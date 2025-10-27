import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:logger/logger.dart';
import 'package:user_web/model/cart_model.dart';
import 'package:user_web/constant.dart';

import '../../providers/restuarant_providers/restaurant_cart_storage_provider.dart';

class RestaurantQuantityButton extends ConsumerWidget {
  final String cartID;
  final String productID;
  final num selectedPrice;
  final List<CartModel> products;
  final CartModel cartModel;

  const RestaurantQuantityButton({
    super.key,
    required this.cartID,
    required this.productID,
    required this.selectedPrice,
    required this.cartModel,
    required this.products,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartNotifier = ref.read(cartStorageRestaurantProviderProvider.notifier);

    bool hasExtras = cartModel.selectedExtra1!.isNotEmpty ||
        cartModel.selectedExtra2!.isNotEmpty ||
        cartModel.selectedExtra3!.isNotEmpty ||
        cartModel.selectedExtra4!.isNotEmpty ||
        cartModel.selectedExtra5!.isNotEmpty;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Minus Button
        InkWell(
          onTap: hasExtras
              ? () => _showExtrasToast(context)
              : () => _handleQuantityChange(cartNotifier, context, false),
          child: Container(
            height: MediaQuery.of(context).size.width >= 1100 ? 28 : 24,
            width: MediaQuery.of(context).size.width >= 1100 ? 28 : 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: appColor,
            ),
            child: const Icon(Icons.remove, color: Colors.black87),
          ),
        ),
        const SizedBox(width: 14),
        // Quantity Text
        Text(
          cartModel.quantity.toString(),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 14),
        // Plus Button
        InkWell(
          onTap: hasExtras
              ? () => _showExtrasToast(context)
              : () => _handleQuantityChange(cartNotifier, context, true),
          child: Container(
            height: MediaQuery.of(context).size.width >= 1100 ? 28 : 24,
            width: MediaQuery.of(context).size.width >= 1100 ? 28 : 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: appColor,
            ),
            child: const Icon(Icons.add, color: Colors.black87),
          ),
        ),
      ],
    );
  }

  void _showExtrasToast(BuildContext context) {
    Fluttertoast.showToast(
      msg: "Can't go further because it Contains Extras".tr(),
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 3,
      backgroundColor: const Color(0xFFFFD581),
      textColor: Colors.black,
      webBgColor: "#FFD581",
      webPosition: "center",
      fontSize: 14.0,
    );
  }

  void _handleQuantityChange(cartNotifier , BuildContext context, bool isIncrement) {
    // Immediate validation (no async calls)
    if (!isIncrement && cartModel.quantity <= 1) {
      Fluttertoast.showToast(
        msg: "You can't go below this quantity".tr(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3,
        backgroundColor: const Color(0xFFFFD581),
        textColor: Colors.black,
        webBgColor: "#FFD581",
        webPosition: "center",
        fontSize: 14.0,
      );
      return;
    }

    // Update immediately - stock validation happens in background
    cartNotifier.updateCartItemQuantityRestaurant(
      productID,
      cartModel.selected,
      1,
      selectedPrice,
      context,
      false,
      cartModel.selectedExtraPrice1 ?? 0,
      cartModel.selectedExtraPrice2 ?? 0,
      cartModel.selectedExtraPrice3 ?? 0,
      cartModel.selectedExtraPrice4 ?? 0,
      cartModel.selectedExtraPrice5 ?? 0,
      isIncrement,
    );
  }
}