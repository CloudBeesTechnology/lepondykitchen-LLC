// ignore_for_file: avoid_build_context_in_providers
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_web/model/cart_model.dart';
part 'restaurant_favorite_storage_provider.g.dart';

var logger = Logger();

@riverpod
class FavoriteStorageRestaurantProvider
    extends _$FavoriteStorageRestaurantProvider {
  final GetStorage _storage = GetStorage();
  VoidCallback? _removeListener;

  @override
  List<CartModel> build() {
    ref.onDispose(() {
      _removeListener?.call();
    });
    listenToChangesRestaurant();
    // Initialize the state and set up listeners
    return getFavoriteItemsRestaurant();
  }

  // Save a ProductsModel to the Cart box without allowing duplicates
  Future<void> saveToFavoriteRestaurant(
      CartModel productsModel, BuildContext context) async {
    // Retrieve existing cart data, decode from JSON if exists
    String? cartString = _storage.read<String>('Get favorites');
    List<dynamic> cart = cartString != null ? jsonDecode(cartString) : [];

    // Check if the product already exists in the cart by comparing productID
    bool productExists =
        cart.any((item) => item['productID'] == productsModel.productID);

    if (!productExists) {
      // Convert ProductsModel to a map and add to the cart
      cart.add(productsModel.toMap());
      logger.d(cart);
      // Save the updated cart list back to the storage as JSON
      await _storage.write('Get favorites', jsonEncode(cart));
      if (context.mounted) {
        Fluttertoast.showToast(
            msg: "Product has been added to favorites",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 3,
            backgroundColor:  const Color(0xFFFFD581),
            textColor: Colors.black,
            webBgColor: "#FFD581",
            webPosition: "center",
            fontSize: 14.r);
      }
      // Trigger state update to reflect the new cart item
      state = getFavoriteItemsRestaurant();
    } else {
      logger.d('Product already in cart');
    }
  }

  // Retrieve all Cart items
  List<CartModel> getFavoriteItemsRestaurant() {
    try {
      String? cartString = _storage.read<String>('Get favorites');
      if (cartString == null) {
        logger.w('No cart data found');
        return [];
      }

      List<dynamic> cart = jsonDecode(cartString);
      return cart
          .map((item) {
            try {
              return CartModel.fromMap(item, item['productID']);
            } catch (e) {
              logger.e('Failed to parse cart item: $e');
              return null; // Return null for invalid items
            }
          })
          .whereType<CartModel>()
          .toList(); // Filter out nulls
    } catch (e) {
      logger.e('Error retrieving cart items: $e');
      return [];
    }
  }

  void listenToChangesRestaurant() {
    _removeListener = _storage.listen(() {
      logger.d('it is listening for changes');
      // Update state when there are changes in the storage
      state = getFavoriteItemsRestaurant();
    });
  }

  // Clear the cart
  Future<void> clearFavoriteRestaurant() async {
    await _storage.remove('Get favorites');
    // Trigger state update to reflect the removed item
    state = [];
  }

  // Remove a specific item from the cart based on productID
  Future<void> removeFromFavoriteRestaurant(
      String productID, BuildContext context) async {
    String? cartString = _storage.read<String>('Get favorites');
    if (cartString != null) {
      List<dynamic> cart = jsonDecode(cartString);

      // Filter out the item that matches the given productID
      cart.removeWhere((item) => item['productID'] == productID);

      // Save the updated cart list
      await _storage.write('Get favorites', jsonEncode(cart));
      if (context.mounted) {
        Fluttertoast.showToast(
            msg: "Product has been removed from favorites",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 3,
            backgroundColor:  const Color(0xFFFFD581),
            textColor: Colors.black,
            webBgColor: "#FFD581",
             webPosition: "center",
            fontSize: 14.r);
      }
      // Trigger state update to reflect the removed item
      state = getFavoriteItemsRestaurant();
    }
  }
}
