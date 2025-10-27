
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/reward_points_model.dart';

final rewardPointsProvider = StateNotifierProvider<RewardPointsNotifier, RewardPointsState>((ref) {
  return RewardPointsNotifier(ref);
});

class RewardPointsNotifier extends StateNotifier<RewardPointsState> {
  final Ref ref;
  StreamSubscription? _ordersSub;
  StreamSubscription? _redeemedSub;
  StreamSubscription? _cancelledOrdersSub;
  Set<String> _processedCancellations = {};

  RewardPointsNotifier(this.ref)
      : super(RewardPointsState(
    availablePoints: 0,
    redeemableAmount: 0,
    canRedeem: false,
  )) {
    listenRewardPoints();
    listenForCancelledOrders();
  }


  void listenForCancelledOrders() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    _cancelledOrdersSub = FirebaseFirestore.instance
        .collection('Orders')
        .where('userID', isEqualTo: user.uid)
        .snapshots()
        .listen((ordersSnapshot) {
      for (var change in ordersSnapshot.docChanges) {
        if (change.type == DocumentChangeType.added ||
            change.type == DocumentChangeType.modified) {
          final orderData = change.doc.data() as Map<String, dynamic>?;

          // Client-side filtering for cancelled orders with points used
          if (orderData != null &&
              orderData['status'] == 'Cancelled' &&
              orderData['pointsUsed'] != null &&
              (orderData['pointsUsed'] as int) > 0) {

            // Use the orderID field for tracking processed orders
            final orderID = orderData['orderID'] as String;

            if (!_processedCancellations.contains(orderID)) {
              _processedCancellations.add(orderID);

              print('Processing cancelled order: $orderID with points: ${orderData['pointsUsed']}');

              _restorePointsForCancelledOrder(
                  orderID,
                  orderData['pointsUsed'] as int,
                  orderData['pointsRedeemed'] as int
              );
            }
          }
        }
      }
    }, onError: (error) {
      print('Error listening for orders: $error');
    });
  }



  Future<void> _restorePointsForCancelledOrder(
      String orderId,
      int pointsUsed,
      int pointsRedeemed
      ) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      print('Attempting to restore $pointsUsed points for order $orderId');

      // Check if points were already restored for this order
      final redemptionDoc = await FirebaseFirestore.instance
          .collection('RedeemedPoints')
          .where('orderId', isEqualTo: orderId)
          .get();

      if (redemptionDoc.docs.isNotEmpty) {
        print('Found redemption record for order $orderId');

        // Delete the redemption record
        await FirebaseFirestore.instance
            .collection('RedeemedPoints')
            .doc(redemptionDoc.docs.first.id)
            .delete();

        // DON'T update the state here!
        // The listenRewardPoints() listener will automatically recalculate
        // the correct points when the redemption record is deleted

        print('Successfully deleted redemption record for order $orderId');
        print('Points will be automatically recalculated by the listener');
      } else {
        print('No redemption record found for order $orderId');
      }
    } catch (e) {
      print('Error restoring points for order $orderId: $e');
      // Remove from processed set to retry next time
      _processedCancellations.remove(orderId);
    }
  }


  void listenRewardPoints() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    _ordersSub = FirebaseFirestore.instance
        .collection('Orders')
        .where('userID', isEqualTo: user.uid)
        .where('status', whereIn: ['Confirmed', 'Delivered'])
        .snapshots()
        .listen((ordersSnapshot) async {
      _redeemedSub?.cancel();

      _redeemedSub = FirebaseFirestore.instance
          .collection('RedeemedPoints')
          .where('userId', isEqualTo: user.uid)
          .snapshots()
          .listen((redeemedSnapshot) {

        // Use double instead of int to keep decimals
        double totalPoints = ordersSnapshot.docs.fold(0.0, (sum, order) {
          final orderTotal = order.data()['total'] as num? ?? 0;
          return sum + orderTotal.toDouble(); // ✅ keep decimals
        });

        double redeemedPoints = redeemedSnapshot.docs.fold(
            0.0, (sum, doc) => sum + ((doc['points'] as num?)?.toDouble() ?? 0.0));

        double availablePoints = totalPoints - redeemedPoints;

        // Convert to $ value (500 points = $5)
        state = state.copyWith(
          availablePoints: availablePoints.round(), // still store as int if UI expects it
          redeemableAmount: (availablePoints ~/ 500) * 5,
          canRedeem: availablePoints >= 500,
        );

        print('Updated points: total=$totalPoints, redeemed=$redeemedPoints, available=$availablePoints');
      }, onError: (error) {
        print('Error listening for redeemed points: $error');
      });
    }, onError: (error) {
      print('Error listening for orders: $error');
    });
  }



  @override
  void dispose() {
    _ordersSub?.cancel();
    _redeemedSub?.cancel();
    _cancelledOrdersSub?.cancel();
    super.dispose();
  }


  void setPointsToRedeem(int points) {
    if (points > state.availablePoints) return;
    state = state.copyWith(pointsToRedeem: points);
  }



  Future<void> redeemPoints(num orderTotal) async {
    // CHANGE: Minimum redemption threshold is now 500 points instead of 1000
    if (state.pointsToRedeem < 500) return;

    // CHANGE: 500 points = $5 (previously 1000 points = $10)
    final dollarAmount = (state.pointsToRedeem ~/ 500) * 5;

    // Simple check: Only allow redemption if dollarAmount ≤ orderTotal
    if (dollarAmount > orderTotal) {
      // Find the maximum allowed redemption (nearest $5 ≤ orderTotal)
      final maxAllowed = (orderTotal ~/ 5) * 5; // CHANGED: $5 increments
      if (maxAllowed < 5) return; // CHANGED: Minimum redemption is now $5

      // Adjust points to the maximum allowed
      state = state.copyWith(
        pointsToRedeem: maxAllowed * 100, // CHANGED: $5 = 500 points
      );
      return;
    }

    state = state.copyWith(
      isRedeeming: true,
      pendingRedemptionAmount: dollarAmount,
      pendingPointsUsed: state.pointsToRedeem,
      pointsToRedeem: 0,
    );
  }


  void cancelRedemption() {
    state = state.copyWith(
      isRedeeming: false,
      pendingRedemptionAmount: 0,
      pendingPointsUsed: 0,
      pointsToRedeem: 0,
    );
  }


  Future<void> confirmRedemption(String orderId) async {
    if (!state.isRedeeming) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // Permanently deduct points
    final newAvailablePoints = state.availablePoints - state.pendingPointsUsed;
    final newRedeemableAmount = (newAvailablePoints ~/ 1000) * 10;

    // Record redemption in Firestore
    await FirebaseFirestore.instance.collection('RedeemedPoints').add({
      'userId': user.uid,
      'points': state.pendingPointsUsed,
      'dollarAmount': state.pendingRedemptionAmount,
      'orderId': orderId,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Update state
    state = state.copyWith(
      availablePoints: newAvailablePoints,
      redeemableAmount: newRedeemableAmount,
      canRedeem: newAvailablePoints >= 1000,
      isRedeeming: false,
      pendingRedemptionAmount: 0,
      pendingPointsUsed: 0,
    );
  }

  void updatePointsToRedeem(int points) {
    if (points > state.availablePoints) return;
    state = state.copyWith(pointsToRedeem: points);
  }


}