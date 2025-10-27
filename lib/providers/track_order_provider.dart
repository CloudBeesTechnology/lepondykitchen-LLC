// ignore_for_file: avoid_build_context_in_providers
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_web/constant.dart';
import 'package:user_web/model/order_model.dart';
part 'track_order_provider.g.dart';

@riverpod
trackOrderProvider(Ref ref, String orderID, BuildContext context) {
  context.loaderOverlay.show();

  FirebaseFirestore.instance
      .collection('Orders')
      .where('orderID', isEqualTo: orderID)
      .get()
      .then((value) {
    if (value.docs.isNotEmpty) {
      for (var item in value.docs) {
        // print(item['uid']);
        if (context.mounted) {
          context.go('/tracking-detail/${item['uid']}');
        }

          if (context.mounted) {
            context.loaderOverlay.hide();
          }
      }
    } else {
      if (context.mounted) {
        context.loaderOverlay.hide();
      }
      // Fluttertoast.showToast(
      //     msg: "Wrong tracking number.".tr(),
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.TOP,
      //     timeInSecForIosWeb: 6,
      //     fontSize: 14.0);
      showAlertDialog(context,"Alert","Wrong tracking number.");
    }
  });
}

@riverpod
trackParcelOrderProvider(Ref ref, String orderID, BuildContext context) {
  context.loaderOverlay.show();

  FirebaseFirestore.instance
      .collection('Orders')
      .where('orderID', isEqualTo: orderID)
      .where('module', isEqualTo: 'Parcel Delivery')
      .get()
      .then((value) {
    if (value.docs.isNotEmpty) {
      for (var item in value.docs) {
        // print(item['uid']);
        if (context.mounted) {
          context.go('/tracking-detail/${item['uid']}');
        }
        // Fluttertoast.showToast(
        //         msg: "Package found.".tr(),
        //         toastLength: Toast.LENGTH_SHORT,
        //         gravity: ToastGravity.TOP,
        //         timeInSecForIosWeb: 6,
        //         fontSize: 14.0)
        //     .then((value) {
          if (context.mounted) {
            context.loaderOverlay.hide();
          }
        // }
        // );
      }
    } else {
      if (context.mounted) {
        context.loaderOverlay.hide();
      }
      // Fluttertoast.showToast(
      //     msg: "Wrong tracking number.".tr(),
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.TOP,
      //     timeInSecForIosWeb: 6,
      //     fontSize: 14.0);
      showAlertDialog(context,"Alert","Wrong tracking number.");
    }
  });
}

@riverpod
Future<OrderModel2> fetchTrackingOrderDetail(Ref ref, String orderID) async {
  var doc =
      await FirebaseFirestore.instance.collection('Orders').doc(orderID).get();
  return OrderModel2(
    scheduleDate: doc.data()!['scheduleDate'],
    scheduleTime: doc.data()!['scheduleTime'],
    vendorId: doc.data()!['vendorId'],
    senderName: doc.data()!['senderName'],
    receiverName: doc.data()!['receiverName'],
    parcelCategory: doc.data()!['parcelCategory'],
    senderEmail: doc.data()!['senderEmail'],
    senderPhone: doc.data()!['senderPhone'],
    senderAddress: doc.data()!['senderAddress'],
    senderHouseNumber: doc.data()!['senderHouseNumber'],
    senderStreetNumber: doc.data()!['senderStreetNumber'],
    senderFloorNumber: doc.data()!['senderFloorNumber'],
    receiverPhone: doc.data()!['receiverPhone'],
    receiverEmail: doc.data()!['receiverEmail'],
    receiverAddress: doc.data()!['receiverAddress'],
    receiverHouseNumber: doc.data()!['receiverHouseNumber'],
    receiverStreetNumber: doc.data()!['receiverStreetNumber'],
    receiverFloorNumber: doc.data()!['receiverFloorNumber'],
    parcelAdminCommission: doc.data()!['parcelAdminCommission'],
    parcelPayer: doc.data()!['parcelPayer'],
    prescription: doc.data()!['prescription'],
    prescriptionPic: doc.data()!['prescriptionPic'],
    module: doc.data()!['module'],
    orders: [
      ...(doc.data()!['orders']).map((items) {
        return OrdersList.fromMap(items);
      })
    ],
    pickupStorename: doc.data()!['pickupStorename'],
    pickupPhone: doc.data()!['pickupPhone'],
    pickupAddress: doc.data()!['pickupAddress'],
    instruction: doc.data()!['instruction'],
    couponPercentage: doc.data()!['couponPercentage'],
    couponTitle: doc.data()!['couponTitle'],
    useCoupon: doc.data()!['useCoupon'],
    confirmationStatus: doc.data()!['confirmationStatus'],
    uid: doc.data()!['uid'],
    // marketID: doc.data()!['marketID'],
    vendorIDs: [
      ...(doc.data()!['vendorIDs']).map((items) {
        return items;
      })
    ],
    userID: doc.data()!['userID'],
    deliveryAddress: doc.data()!['deliveryAddress'],
    houseNumber: doc.data()!['houseNumber'],
    closesBusStop: doc.data()!['closesBusStop'],
    deliveryBoyID: doc.data()!['deliveryBoyID'],
    status: doc.data()!['status'],
    accept: doc.data()!['accept'],
    orderID: doc.data()!['orderID'],
    timeCreated: doc.data()!['timeCreated'].toDate(),
    total: doc.data()!['total'],
    deliveryFee: doc.data()!['deliveryFee'],
    acceptDelivery: doc.data()!['acceptDelivery'],
    paymentType: doc.data()!['paymentType'],
  );
  //  for (var element in orderDetail!.orders) {

  //  }
}
