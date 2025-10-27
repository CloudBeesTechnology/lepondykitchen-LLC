// ignore_for_file: avoid_build_context_in_providers
import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:user_web/constant.dart';
import 'package:user_web/providers/restuarant_providers/restaurant_carts_state_provider.dart';
import '../../model/cart_model.dart';
import '../../model/today_menu_model.dart';
part 'restaurant_cart_storage_provider.g.dart';

var logger = Logger();

@riverpod
class CartStorageRestaurantProvider extends _$CartStorageRestaurantProvider {
  final GetStorage _storage = GetStorage();
  VoidCallback? _removeListener;
  Timer? _clearTimer;

  // TimeOfDay _parseTimeOfDay(String time) {
  //   final format = DateFormat.jm(); // Using package:intl
  //   return TimeOfDay.fromDateTime(format.parse(time));
  // }

  @override
  List<CartModel> build() {
    ref.onDispose(() {
      _removeListener?.call();
      _clearTimer?.cancel();
    });
    _setupExpirationTimer();
    listenToChangesRestaurant();
    // Initialize the state and set up listeners
    return getCartItemsRestaurant();
  }


  Future<void> checkAndRemoveExpiredItems() async {
    final now = DateTime.now();
    List<CartModel> currentCart = getCartItemsRestaurant();
    List<CartModel> validItems = [];

    for (var item in currentCart) {
      try {
        // Skip expiration check for grocery module products
        if (item.module == 'Grocery') {
          validItems.add(item);
          continue;
        }

        // Only restaurant module products need expiration check
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('Today menu')
            .doc(item.productID)
            .get();

        if (!doc.exists) continue;

        final productData = doc.data()! as Map<String, dynamic>;
        final Timestamp startStamp = productData['startDate'] as Timestamp;
        final Timestamp endStamp = productData['endDate'] as Timestamp;
        final DateTime startDate = startStamp.toDate();
        final DateTime endDate = endStamp.toDate();

        final TimeOfDay validFrom = _parseTimeOfDay(productData['validFrom']);
        final TimeOfDay validTo = _parseTimeOfDay(productData['validTo']);

        final DateTime windowStart = DateTime(
          startDate.year,
          startDate.month,
          startDate.day,
          validFrom.hour,
          validFrom.minute,
        );

        final DateTime windowEnd = DateTime(
          endDate.year,
          endDate.month,
          endDate.day,
          validTo.hour,
          validTo.minute,
        );

        if (now.isAfter(windowStart) && now.isBefore(windowEnd)) {
          validItems.add(item);
        }
      } catch (e) {
        logger.e('Error checking expiration: $e');
        // Consider keeping the item if there's an error
        validItems.add(item);
      }
    }

    if (validItems.length != currentCart.length) {
      await _storage.write('Restaurant Cart',
          jsonEncode(validItems.map((e) => e.toMap()).toList()));
      state = validItems;
    }
  }


  TimeOfDay _parseTimeOfDay(String time) {
    try {
      final regExp = RegExp(r'(\d{1,2}):(\d{2})\s*(AM|PM)?', caseSensitive: false);
      final match = regExp.firstMatch(time);

      if (match != null) {
        int hours = int.parse(match.group(1)!);
        final minutes = int.parse(match.group(2)!);
        final period = match.group(3)?.toLowerCase();

        if (period == 'pm' && hours < 12) hours += 12;
        if (period == 'am' && hours == 12) hours = 0;

        return TimeOfDay(hour: hours, minute: minutes);
      }
      return const TimeOfDay(hour: 0, minute: 0);
    } catch (e) {
      logger.e('Error parsing time: $e');
      return const TimeOfDay(hour: 0, minute: 0);
    }
  }

  void _setupExpirationTimer() {
    _clearTimer?.cancel();
    _clearTimer = Timer.periodic(
      const Duration(minutes: 1),
          (_) => checkAndRemoveExpiredItems(),
    );
  }



  String? getCurrentModule() {
    final cartItems = getCartItemsRestaurant();
    if (cartItems.isEmpty) return null;

    // Count modules in cart
    final moduleCount = <String, int>{};
    for (final item in cartItems) {
      moduleCount[item.module] = (moduleCount[item.module] ?? 0) + 1;
    }

    // Return the module with most items
    return moduleCount.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }


  // Save a CartModel to the Cart box without allowing duplicates
  Future<void> saveToCartRestaurant(
      CartModel cartModel, BuildContext context) async {
    // Retrieve existing cart data, decode from JSON if exists
    String? cartString = _storage.read<String>('Restaurant Cart');
    List<dynamic> cart = cartString != null ? jsonDecode(cartString) : [];

    // Extract all vendor IDs from the cart
    Set<String> existingVendorIds =
    cart.map((item) => item['vendorId'] as String).toSet();

    // Check if the product already exists in the cart
    bool productExists = cart.any((item) =>
    item['productID'] == cartModel.productID &&
        item['selected'] == cartModel.selected);

    if (productExists) {
      logger.d('Product already in cart');
      Fluttertoast.showToast(
          msg: "Product already added to cart",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 3,
          backgroundColor: const Color(0xFFFFD581),
          textColor: Colors.black,
          webBgColor: "#FFD581",
          webPosition: "center",
          fontSize: 14.0);
      return;
    }

    // Check if the new product has a different vendorId
    if (existingVendorIds.isNotEmpty &&
        !existingVendorIds.contains(cartModel.vendorId)) {
      // Use AwesomeDialog for vendor mismatch notification
      if (context.mounted) {
        await AwesomeDialog(
          btnOkText: 'Clear Cart',
          context: context,
          dialogType: DialogType.info,
          borderSide: BorderSide(
            color: appColor,
            width: 2,
          ),
          width: MediaQuery.of(context).size.height / 1.2,
          buttonsBorderRadius: const BorderRadius.all(
            Radius.circular(2),
          ),
          dismissOnTouchOutside: true,
          dismissOnBackKeyPress: false,
          headerAnimationLoop: true,
          animType: AnimType.scale,
          title: 'Vendor Mismatch',
          desc:
          'The product you are trying to add belongs to a different vendor. Do you want to clear cart?',
          btnCancelOnPress: () {
            // User cancels, do nothing
            logger.d('User cancelled adding product from different vendor.');
          },
          btnOkOnPress: () async {
            clearCartRestaurant(); // Update the state
          },
        ).show();
      }
    } else {
      // No mismatch or empty cart, proceed with adding the product
      cart.add(cartModel.toMap());
      await _storage.write('Restaurant Cart', jsonEncode(cart));
      if (context.mounted) {
        Fluttertoast.showToast(
            msg: "Product has been added to cart",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 2,
            backgroundColor: const Color(0xFFFFD581),
            textColor: Colors.black,
            webBgColor: "#FFD581",
            webPosition: "center",
            fontSize: 14.0);
      }
      state = getCartItemsRestaurant(); // Update the state
    }
  }

  // Retrieve all Cart items
  List<CartModel> getCartItemsRestaurant() {
    try {
      String? cartString = _storage.read<String>('Restaurant Cart');
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
      state = getCartItemsRestaurant();
    });
  }

  // Clear the cart
  Future<void> clearCartRestaurant() async {
    await _storage.remove('Restaurant Cart');
    // Trigger state update to reflect the removed item
    state = [];
  }

  // Remove a specific item from the cart based on productID
  Future<void> removeFromCartRestaurant(
      String productID, String selected, BuildContext context) async {
    String? cartString = _storage.read<String>('Restaurant Cart');
    if (cartString != null) {
      List<dynamic> cart = jsonDecode(cartString);

      // Filter out the item that matches the given productID
      cart.removeWhere((item) =>
          item['productID'] == productID && item['selected'] == selected);

      // Save the updated cart list
      await _storage.write('Restaurant Cart', jsonEncode(cart));
      if (context.mounted) {
        Fluttertoast.showToast(
            msg: "Product has been removed from cart",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 3,
            backgroundColor:  const Color(0xFFFFD581),
            textColor: Colors.black,
            webBgColor: "#FFD581",
             webPosition: "center",
            fontSize: 14.0);
      }
      // Trigger state update to reflect the removed item
      state = getCartItemsRestaurant();
    }
  }



  Stream<num> getProductQuantityRestaurantStream(String productID) {
    // Stream for product data changes
    final productStream = FirebaseFirestore.instance
        .collection('Today menu')
        .doc(productID)
        .snapshots();

    return productStream.asyncExpand<num>((productSnapshot) async* {
      if (!productSnapshot.exists) {
        yield 0;
        return;
      }

      final productData = productSnapshot.data()!;
      final num totalQty = productData['quantity'];

      // Parse date/time information
      final DateTime startDate = (productData['startDate'] as Timestamp).toDate().toUtc();
      final DateTime endDate = (productData['endDate'] as Timestamp).toDate().toUtc();
      final TimeOfDay validFrom = _parseTimeString(productData['validFrom']);
      final TimeOfDay validTo = _parseTimeString(productData['validTo']);

      final DateTime startUtc = DateTime.utc(
        startDate.year,
        startDate.month,
        startDate.day,
        validFrom.hour,
        validFrom.minute,
      );

      final DateTime endUtc = DateTime.utc(
        endDate.year,
        endDate.month,
        endDate.day,
        validTo.hour,
        validTo.minute,
      );

      // Create a stream for relevant orders
      final ordersStream = FirebaseFirestore.instance
          .collection('Orders')
          .where('timeCreated', isGreaterThanOrEqualTo: startUtc)
          .where('timeCreated', isLessThanOrEqualTo: endUtc)
          .snapshots();

      await for (final ordersSnapshot in ordersStream) {
        num orderedQty = 0;
        for (final doc in ordersSnapshot.docs) {
          final data = doc.data();
          // if (data['status'] != 'Pending' && data['status'] != 'Confirmed') continue;
          if (data['status'] == 'Cancelled') continue;

          for (final item in data['orders'] ?? []) {
            if (item['productID'] == productID) {
              orderedQty += item['quantity'] ?? 0;
            }
          }
        }
        yield (totalQty - orderedQty).clamp(0, totalQty);
      }
    });
  }


  Future<num> getProductQuantityRestaurant(String productID) async {
    final productSnapshot = await FirebaseFirestore.instance
        .collection('Today menu')
        .doc(productID)
        .get();

    if (!productSnapshot.exists) return 0;

    final productData = productSnapshot.data()!;
    final num totalQty = productData['quantity'];

    // 1. Parse dates as UTC
    final DateTime startDate = (productData['startDate'] as Timestamp).toDate().toUtc();
    final DateTime endDate = (productData['endDate'] as Timestamp).toDate().toUtc();

    // 2. Parse times with UTC conversion
    final TimeOfDay validFrom = _parseTimeString(productData['validFrom']);
    final TimeOfDay validTo = _parseTimeString(productData['validTo']);

    // 3. Create UTC date-time objects
    final DateTime startUtc = DateTime.utc(
      startDate.year,
      startDate.month,
      startDate.day,
      validFrom.hour,
      validFrom.minute,
    );

    final DateTime endUtc = DateTime.utc(
      endDate.year,
      endDate.month,
      endDate.day,
      validTo.hour,
      validTo.minute,
    );

    // 4. Query using UTC timestamps
    final ordersSnapshot = await FirebaseFirestore.instance
        .collection('Orders')
        .where('timeCreated', isGreaterThanOrEqualTo: startUtc)
        .where('timeCreated', isLessThanOrEqualTo: endUtc)
        .get();

    num orderedQty = 0;
    for (final doc in ordersSnapshot.docs) {
      final data = doc.data();
      // if (data['status'] != 'Pending' && data['status'] != 'Confirmed') continue;
      if (data['status'] == 'Cancelled') continue;

      for (final item in data['orders'] ?? []) {
        if (item['productID'] == productID) {
          orderedQty += item['quantity'] ?? 0;
        }
      }
    }

    return (totalQty - orderedQty).clamp(0, totalQty);
  }


  TimeOfDay _parseTimeString(String time) {
    final regExp = RegExp(r'(\d{1,2}):(\d{2})\s*(AM|PM)?', caseSensitive: false);
    final match = regExp.firstMatch(time);

    if (match != null) {
      int hours = int.parse(match.group(1)!);
      final minutes = int.parse(match.group(2)!);
      final period = match.group(3)?.toLowerCase();

      if (period == 'pm' && hours < 12) hours += 12;
      if (period == 'am' && hours == 12) hours = 0;

      return TimeOfDay(hour: hours, minute: minutes);
    }
    return const TimeOfDay(hour: 0, minute: 0);
  }


  Future<num> getGroceryProductQuantity(String productID) async {
    final productSnapshot = await FirebaseFirestore.instance
        .collection('Products')
        .doc(productID)
        .get();

    if (!productSnapshot.exists) return 0;

    final productData = productSnapshot.data()!;
    final num totalQty = productData['quantity'];

    // 4. Query using UTC timestamps
    final ordersSnapshot = await FirebaseFirestore.instance
        .collection('Orders')
    // .where('timeCreated', isGreaterThanOrEqualTo: startUtc)
    // .where('timeCreated', isLessThanOrEqualTo: endUtc)
        .get();

    num orderedQty = 0;
    for (final doc in ordersSnapshot.docs) {
      final data = doc.data();
      // if (data['status'] != 'Pending' && data['status'] != 'Confirmed') continue;
      if (data['status'] == 'Cancelled') continue;

      for (final item in data['orders'] ?? []) {
        if (item['productID'] == productID) {
          orderedQty += item['quantity'] ?? 0;
        }
      }
    }

    return (totalQty - orderedQty).clamp(0, totalQty);
  }



  Stream<num> getGroceryProductQuantityStream(String productID) {
    final productStream = FirebaseFirestore.instance
        .collection('Products')
        .doc(productID)
        .snapshots();

    return productStream.asyncExpand<num>((productSnapshot) async* {
      if (!productSnapshot.exists) {
        yield 0;
        return;
      }

      final productData = productSnapshot.data()!;
      final num totalQty = productData['quantity'];

      // Create a stream for relevant orders
      final ordersStream = FirebaseFirestore.instance
          .collection('Orders')
      // .where('timeCreated', isGreaterThanOrEqualTo: startUtc)
      // .where('timeCreated', isLessThanOrEqualTo: endUtc)
          .snapshots();

      await for (final ordersSnapshot in ordersStream) {
        num orderedQty = 0;
        for (final doc in ordersSnapshot.docs) {
          final data = doc.data();
          // if (data['status'] != 'Pending' && data['status'] != 'Confirmed') continue;
          if (data['status'] == 'Cancelled') continue;

          for (final item in data['orders'] ?? []) {
            if (item['productID'] == productID) {
              orderedQty += item['quantity'] ?? 0;
            }
          }
        }
        yield (totalQty - orderedQty).clamp(0, totalQty);
      }
    });
  }


  Future<num> getProductQuantity(String productID, String module) async {
    logger.d('🎯 Getting quantity for product: $productID, module: $module');

    if (module == 'Restaurant') {
      logger.d('🍽️ Using restaurant quantity method');
      return await getProductQuantityRestaurant(productID);
    } else if (module == 'Grocery') {
      logger.d('🛒 Using grocery quantity method');
      return await getGroceryProductQuantity(productID);
    }

    logger.w('⚠️ Unknown module: $module, returning 0');
    return 0;
  }



  Stream<num> getProductQuantityStream(String productID, String module) {
    logger.d('📡 Starting quantity stream for product: $productID, module: $module');

    if (module == 'Restaurant') {
      logger.d('🍽️ Using restaurant quantity stream');
      return getProductQuantityRestaurantStream(productID);
    } else if (module == 'Grocery') {
      logger.d('🛒 Using grocery quantity stream');
      return getGroceryProductQuantityStream(productID);
    }

    logger.w('⚠️ Unknown module: $module, returning empty stream');
    return Stream.value(0);
  }


  // Update the quantity of a cart item
  Future<void> updateCartItemQuantityRestaurant(
      String productID,
      String selected,
      num newQuantity,
      num selectedPrice,
      BuildContext context,
      bool isProductDetailPage,
      num selectedExtraPrice1,
      num selectedExtraPrice2,
      num selectedExtraPrice3,
      num selectedExtraPrice4,
      num selectedExtraPrice5,
      bool isIncrement
      ) async {
    // 1. Update UI immediately (local state)
    final updatedItems = _updateLocalStateImmediately(
        productID,
        selected,
        newQuantity,
        selectedPrice,
        selectedExtraPrice1,
        selectedExtraPrice2,
        selectedExtraPrice3,
        selectedExtraPrice4,
        selectedExtraPrice5,
        isIncrement
    );

    state = updatedItems;

    // 2. Update cart totals provider
    _updateCartTotals(updatedItems);

    // 3. Persist to storage and validate in background
    _persistAndValidateInBackground(
        productID,
        selected,
        newQuantity,
        selectedPrice,
        context,
        isProductDetailPage,
        selectedExtraPrice1,
        selectedExtraPrice2,
        selectedExtraPrice3,
        selectedExtraPrice4,
        selectedExtraPrice5,
        isIncrement,
        updatedItems
    );
  }

  List<CartModel> _updateLocalStateImmediately(
      String productID,
      String selected,
      num newQuantity,
      num selectedPrice,
      num selectedExtraPrice1,
      num selectedExtraPrice2,
      num selectedExtraPrice3,
      num selectedExtraPrice4,
      num selectedExtraPrice5,
      bool isIncrement
      ) {
    return state.map((item) {
      if (item.productID == productID && item.selected == selected) {
        final newQty = isIncrement
            ? item.quantity + newQuantity
            : item.quantity - newQuantity;

        final newPrice = (newQty * selectedPrice) +
            selectedExtraPrice1 +
            selectedExtraPrice2 +
            selectedExtraPrice3 +
            selectedExtraPrice4 +
            selectedExtraPrice5;

        return item.copyWith(quantity: newQty, price: newPrice);
      }
      return item;
    }).toList();
  }

  void _updateCartTotals(List<CartModel> updatedItems) {
    // Calculate total cart price
    num totalPrice = 0;
    int totalQuantity = 0;

    for (final item in updatedItems) {
      totalPrice += item.price;
      totalQuantity += item.quantity.toInt();
    }

    // Update cart state provider
    final cartState = CartStateModel(
      cartQuantity: totalQuantity,
      price: totalPrice,
    );

    // Assuming you have a way to update cartStateRestaurantProvider
    // If using Riverpod, you might need to access the notifier differently
    // This depends on how your cartStateRestaurantProvider is set up
    ref.read(cartStateRestaurantProvider.notifier).state = cartState;
  }

  Future<void> _persistAndValidateInBackground(
      String productID,
      String selected,
      num newQuantity,
      num selectedPrice,
      BuildContext context,
      bool isProductDetailPage,
      num selectedExtraPrice1,
      num selectedExtraPrice2,
      num selectedExtraPrice3,
      num selectedExtraPrice4,
      num selectedExtraPrice5,
      bool isIncrement,
      List<CartModel> updatedItems
      ) async {
    try {
      // Save to storage
      final cartJson = updatedItems.map((item) => item.toMap()).toList();
      await _storage.write('Restaurant Cart', jsonEncode(cartJson));

      // Validate stock in background
      final item = updatedItems.firstWhere(
            (item) => item.productID == productID && item.selected == selected,
      );

      final available = await getProductQuantity(item.productID, item.module);
      if (item.quantity > available) {
        // Revert if over limit
        final revertedItems = _updateLocalStateImmediately(
            productID,
            selected,
            newQuantity,
            selectedPrice,
            selectedExtraPrice1,
            selectedExtraPrice2,
            selectedExtraPrice3,
            selectedExtraPrice4,
            selectedExtraPrice5,
            !isIncrement // Reverse the operation
        );

        state = revertedItems;
        _updateCartTotals(revertedItems);
        await _storage.write('Restaurant Cart', jsonEncode(revertedItems.map((e) => e.toMap()).toList()));

        if (context.mounted) {
          Fluttertoast.showToast(
            msg: "Exceeds available quantity".tr(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 3,
            backgroundColor: const Color(0xFFFFD581),
            textColor: Colors.black,
            webBgColor: "#FFD581",
            webPosition: "center",
            fontSize: 14.0,
          );
        }
      } else if (isProductDetailPage && context.mounted) {
        // Show success toast only for product detail page
        Fluttertoast.showToast(
          msg: "Product quantity has been updated".tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 3,
          backgroundColor: const Color(0xFFFFD581),
          textColor: Colors.black,
          webBgColor: "#FFD581",
          webPosition: "center",
          fontSize: 14.0,
        );
      }
    } catch (e) {
      logger.e('Error in background persistence: $e');
    }
  }
}







// Future<void> _checkAndRemoveExpiredItems() async {
//   final now = DateTime.now();
//   List<CartModel> currentCart = getCartItemsRestaurant();
//   List<CartModel> nonExpiredItems = [];
//
//   for (var item in currentCart) {
//     try {
//       DocumentSnapshot doc = await FirebaseFirestore.instance
//           .collection('Today menu')
//           .doc(item.productID)
//           .get();
//
//       if (!doc.exists) continue; // Remove if product doesn't exist
//
//       TodayMenuModel product = TodayMenuModel.fromMap(doc.data()! as Map<String, dynamic>, doc.id);
//       DateTime endDate = product.endDate;
//       TimeOfDay validTo = _parseTimeOfDay(product.validTo);
//       DateTime endDateTime = DateTime(endDate.year, endDate.month, endDate.day, validTo.hour, validTo.minute);
//
//       if (endDateTime.isAfter(now)) nonExpiredItems.add(item);
//     } catch (e) {
//       logger.e('Error checking expiration: $e');
//     }
//   }
//
//   if (nonExpiredItems.length != currentCart.length) {
//     await _storage.write('Restaurant Cart', jsonEncode(nonExpiredItems.map((e) => e.toMap()).toList()));
//     state = nonExpiredItems;
//   }
// }



// Future<num> getProductQuantityRestaurant(String productID) async {
//   num availableQuantity = 0;
//   var productDoc;
//
//   // Step 1: Check Today Menu dev
//   productDoc = await FirebaseFirestore.instance
//       .collection('Today menu')
//       .doc(productID)
//       .get();
//
//   if (productDoc.exists) {
//     availableQuantity = productDoc['quantity'];
//     logger.d('Today Menu Quantity: $availableQuantity');
//   } else {
//     // Step 2: Check Flash Sales dev
//     productDoc = await FirebaseFirestore.instance
//         .collection('Flash Sales')
//         .doc(productID)
//         .get();
//
//     if (productDoc.exists) {
//       availableQuantity = productDoc['quantity'];
//       logger.d('Flash Sales Quantity: $availableQuantity');
//     } else {
//       // Step 3: Check Hot Deals dev
//       productDoc = await FirebaseFirestore.instance
//           .collection('Hot Deals')
//           .doc(productID)
//           .get();
//
//       if (productDoc.exists) {
//         availableQuantity = productDoc['quantity'];
//         logger.d('Hot Deals Quantity: $availableQuantity');
//       } else {
//         logger.d('Product not found in any menu collections.');
//         return 0;
//       }
//     }
//   }
//
//   // Step 4: Fetch Orders with Pending/Confirmed/Delivered status
//   final ordersQuery = await FirebaseFirestore.instance
//       .collection('Orders')
//       .where('module', isEqualTo: 'Restaurant')
//       .get();
//
//   num reservedQuantity = 0;
//
//   for (var doc in ordersQuery.docs) {
//     final orderData = doc.data();
//     final orderStatus = orderData['status']?.toString().toLowerCase();
//
//     if (!['pending', 'confirmed', 'delivered'].contains(orderStatus)) {
//       continue; // skip cancelled or other statuses
//     }
//
//     final orders = orderData['orders'] as List<dynamic>;
//     for (var item in orders) {
//       if (item['productID'] == productID) {
//         final quantity = item['quantity'];
//         reservedQuantity += quantity;
//       }
//     }
//   }
//
//   logger.d('Reserved Quantity in Orders: $reservedQuantity');
//
//   final finalAvailable = availableQuantity - reservedQuantity;
//   logger.d('Final Available Quantity: $finalAvailable');
//
//   return finalAvailable > 0 ? finalAvailable : 0;
// }