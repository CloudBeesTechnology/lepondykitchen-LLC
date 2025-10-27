import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:logger/logger.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_web/constant.dart';
import 'package:user_web/model/history.dart';
import 'package:user_web/model/pickup_address_model.dart';
import 'package:user_web/providers/push_notification.dart';
import '../model/cart_model.dart';
import '../model/order_model.dart';
part 'checkout_provider.g.dart';

var logger = Logger();
final GetStorage _storage = GetStorage();

@riverpod
Stream<num> getWallet(Ref ref) {
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? user = auth.currentUser;
  return FirebaseFirestore.instance
      .collection('users')
      .doc(user!.uid)
      .snapshots()
      .map((e) => e['wallet']);
}

@riverpod
Stream<bool> getCashOnDelivery( Ref ref) {
  return FirebaseFirestore.instance
      .collection('Payment System')
      .doc('Cash on delivery')
      .snapshots()
      .map((event) {
    return event['Cash on delivery'];
  });
}

@riverpod
updateWallet( Ref ref, num total) {
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? user = auth.currentUser;
  FirebaseFirestore.instance
      .collection('users')
      .doc(user!.uid)
      .update({'wallet': FieldValue.increment(-total)}).then((value) {
    // Get the current date and time
    // DateTime now = DateTime.now();

    // // Format the date to '24th January, 2024' format
    // String formattedDate = DateFormat('d MMMM, y').format(now);
    history(HistoryModel(
        message: 'Debit Alert',
        amount: total.toString(),
        paymentSystem: 'Wallet',
        timeCreated: DateTime.now()));
  });
}

history(HistoryModel historyModel) {
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? user = auth.currentUser;
  FirebaseFirestore.instance
      .collection('users')
      .doc(user!.uid)
      .collection('Transaction History')
      .add(historyModel.toMap());
}

@riverpod
Future<List<PickupAddressModel>> getPickUpAddress(Ref ref, String id) async {
  if (id.isEmpty) return [];

  try {
    var doc = await FirebaseFirestore.instance
        .collection('vendors')
        .doc(id)
        .get();

    if (doc.exists) {
      final data = doc.data()!;
      // Return as a list with one item
      return [PickupAddressModel.fromMap(data, doc.id)];
    }
    return [];
  } catch (e) {
    logger.e('Error fetching vendor details: $e');
    return [];
  }
}

@riverpod
// Retrieve all Cart items
List<CartModel> getCheckoutProducts( Ref ref, String cart) {
  // Retrieve cart items from storage
  String? cartString = _storage.read<String>(cart);

  if (cartString != null) {
    List<dynamic> cart = jsonDecode(cartString);
    logger.d('Carts are ${cart.length}');
    // Convert the list of maps back to a list of CartModel objects
    return cart
        .map((item) => CartModel.fromMap(item, item['productID']))
        .toList();
  }

  return [];
}

getPercentageOfCoupon(num couponPercentage, num total) {
  if (couponPercentage != 0) {
    var result = (total * couponPercentage) / 100;
    return result;
  } else {
    return 0;
  }
}

 Future<void> addToOrder(OrderModel orderModel, String uid,bool isFirstOrder ,BuildContext context,) async {
  context.loaderOverlay.show();

  try {
    await FirebaseFirestore.instance
        .collection('Orders')
        .doc(uid)
        .set(orderModel.toMap());

    // Get admin token for notification
    String? adminToken;
    try {
      final adminDoc = await FirebaseFirestore.instance.collection('Admin').doc('Admin').get();
      if (adminDoc.exists && adminDoc.data()!.containsKey('tokenID')) {
        adminToken = adminDoc.data()!['tokenID'];
      }
    } catch (e) {
      logger.e('Error getting admin token: $e');
    }

    // Send push notification to admin
    if (adminToken != null) {
      String notificationTitle = 'New Order Placed';
      String notificationMessage = 'A User placed an order ${orderModel.orderID} for vendor ${orderModel.pickupStorename ?? "Unknown Vendor"}';

      // Send the push notification
      await PushNotificationFunction.sendPushNotification(
          notificationTitle,
          notificationMessage,
          adminToken
      );

      logger.d('Push notification sent to admin for order: ${orderModel.orderID}');
    } else {
      logger.w('Admin token not found, cannot send notification');
    }

    if (context.mounted) {
      context.loaderOverlay.hide();

      if (isFirstOrder) {
        await showAlertsDialog(
            context,
            "Your first order has been placed!🎉\nYou will get 10% coupon for your First order."
        );
      } else {
        await showAlertsDialog(context, "Your new order has been placed.");
      }

      if (context.mounted) {
        context.go('/orders');
      }
    }
  } catch (error) {
    if (context.mounted) {
      context.loaderOverlay.hide();
      await showAlertsDialog(context, "Order placement failed.Try Again");
      // Re-throw the error to be caught by the .catchError() in the calling code
      throw error;
    }
  }
}

Future<void> showAlert2Dialog({
  required BuildContext context,
  required String message,
  // String title = 'Alert',
  String buttonText = 'OK',
}) async {
  return showDialog(
    context: context,
    builder: (_) => AlertDialog(
      // title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(buttonText),
        ),
      ],
    ),
  );
}
