import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:user_web/model/coupon_detail_model.dart';
part 'coupon_detail_provider.g.dart';

  var logger = Logger();
@riverpod
class CouponNotifier extends _$CouponNotifier {

  @override
  Future<CouponDetails?> build(String couponCode) async {
    return getCoupon(couponCode);
  }

  Future<CouponDetails?> getCoupon(String couponCode) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('Coupons')
          .where('coupon', isEqualTo: couponCode)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final couponData = snapshot.docs.first.data();

        // Check for expiry using 'validTo'
        if (couponData.containsKey('validTo') && couponData['validTo'] != null) {
          final DateTime validTo = (couponData['validTo'] as Timestamp).toDate();
          if (validTo.isBefore(DateTime.now())) {
            await Fluttertoast.showToast(
              msg: "Coupon has expired.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 3,
              backgroundColor:  const Color(0xFFFFD581),
              textColor: Colors.black,
              webBgColor: "#FFD581",
              webPosition: "center",
              fontSize: 14.0,
            );
            return null;
          }
        }

        final couponDetails = CouponDetails(
          title: couponData['title'],
          percentage: couponData['percentage'],
          validTo: couponData['validTo'] != null
              ? (couponData['validTo'] as Timestamp).toDate()
              : null,
        );

        await Fluttertoast.showToast(
          msg: "Coupon Applied",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 5,
          backgroundColor: const Color(0xFFFFD581),
          textColor: Colors.black,
          webBgColor: "#FFD581",
          webPosition: "center",
          fontSize: 14.0,
        );

        return couponDetails;
      } else {
        await Fluttertoast.showToast(
          msg: "Wrong coupon number.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 5,
          backgroundColor:  const Color(0xFFFFD581),
          textColor: Colors.black,
          webBgColor: "#FFD581",
          webPosition: "center",
          fontSize: 14.0,
        );
        return null;
      }
    } catch (e) {
      logger.d('Error fetching coupon: $e');
      return null;
    }
  }



  Stream<dynamic> getCouponStatus() {
    return FirebaseFirestore.instance
        .collection('Coupons')
        .snapshots()
        .map((event) {
      if (event.docs.isEmpty) {
        return false;
      } else {
        return true;
      }
    });
  }
}
