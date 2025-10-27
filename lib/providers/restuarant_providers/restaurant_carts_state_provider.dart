import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../model/cart_model.dart';
// import 'profile_provider.dart';
part 'restaurant_carts_state_provider.g.dart';

var logger = Logger();
final cartBox = GetStorage();

@riverpod
class CartStateRestaurant extends _$CartStateRestaurant {
  VoidCallback? _removeListener;

  @override
  CartStateModel build() {
    ref.onDispose(() {
      _removeListener?.call();
    });
    readStorageCartRestaurant();
    listenToChangesRestaurant();
    // var authAsyncValue = ref.watch(getAuthListenerProvider);
    // authAsyncValue.whenData((auth) {
    //   if (auth == false) {
    //     state = state.copyWith(cartQuantity: 0, price: 0);
    //   } else {
    //     readStorageCart();
    //     listenToChanges();
    //   }
    // });

    return CartStateModel(cartQuantity: 0, price: 0);
  }

  void readStorageCartRestaurant() {
    Future.delayed(const Duration(seconds: 2), () {
      var result = cartBox.read('Restaurant Cart');
      if (result != null) {
        var testing = jsonDecode(result);
        num tempTotal = testing.fold(0, (tot, doc) => tot + doc['quantity']);
        num totalPrice = testing.fold(0, (tot, doc) => tot + doc['price']);
        state =
            state.copyWith(cartQuantity: tempTotal.toInt(), price: totalPrice);
      } else {
        state = state.copyWith(cartQuantity: 0, price: 0);
      }
    });
  }

  void listenToChangesRestaurant() {
    _removeListener = cartBox.listen(() {
      readStorageCartRestaurant();
    });
  }
}

@riverpod
Future<dynamic> getDeliveryFee(Ref ref) async {
  var event =
      await FirebaseFirestore.instance.collection('Admin').doc('Admin').get();
  return event['Delivery Fee'];
}

@riverpod
Future<bool> getCouponStatus(Ref ref) async {
  var event = await FirebaseFirestore.instance.collection('Coupons').get();
  var logger = Logger();
  logger.d('Coupons are $event');
  if (event.docs.isEmpty) {
    return false;
  } else {
    return true;
  }
}
