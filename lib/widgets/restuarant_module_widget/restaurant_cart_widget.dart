import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:user_web/model/cart_model.dart';
import 'package:user_web/constant.dart';
import 'package:user_web/model/formatter.dart';
import 'package:user_web/providers/currency_provider.dart';
import 'package:user_web/providers/profile_provider.dart';
import 'package:user_web/widgets/cat_image_widget.dart';
import '../../providers/restuarant_providers/restaurant_cart_storage_provider.dart';
import '../../providers/restuarant_providers/restaurant_carts_state_provider.dart';
import 'restaurant_quantity_button.dart';

class RestaurantCartWidget extends ConsumerStatefulWidget {
  const RestaurantCartWidget({super.key});

  @override
  ConsumerState<RestaurantCartWidget> createState() => _RestaurantCartWidgetState();
}

class _RestaurantCartWidgetState extends ConsumerState<RestaurantCartWidget> {
  String coupon = '';

  @override
  void initState() {
    super.initState();
    // Trigger expiration check when cart screen opens
    Future.microtask(() {
      ref.read(cartStorageRestaurantProviderProvider.notifier)
          .checkAndRemoveExpiredItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    final currencySymbol = ref.watch(currencySymbolProvider).value ?? '';
    final isCouponActive = ref.watch(getCouponStatusProvider).value ?? false;
    final deliveryFee = ref.watch(getDeliveryFeeProvider).value ?? 0;
    final isLogged = ref.watch(getAuthListenerProvider).value ?? false;
    final products = ref.watch(cartStorageRestaurantProviderProvider);
    final cartPriceQuantity = ref.watch(cartStateRestaurantProvider);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: products.isEmpty
            ? null
            : Row(
          children: [
            Icon(Icons.shopping_bag, size: 20, color: appColor),
            const SizedBox(width: 8),
            Text(
              '${cartPriceQuantity.cartQuantity} items',
              style: TextStyle(
                fontSize: 15,
                color: appColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Use spacer to push the cart text to center
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Your',
                      style: TextStyle(
                        // color: Colors.black,
                        fontSize: MediaQuery.of(context).size.width >= 1100 ? 20 : 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Nunito',
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Cart',
                      style: TextStyle(
                        color: appColor,
                        fontSize: MediaQuery.of(context).size.width >= 1100 ? 20 : 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Nunito',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.go('/restaurant');

            },
            icon: Icon(Icons.close, color: appColor),
          )
        ],
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            products.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Icon(
                          Icons.remove_shopping_cart_outlined,
                          color: appColor,
                          size: MediaQuery.of(context).size.width >= 1100
                              ? MediaQuery.of(context).size.width / 5
                              : MediaQuery.of(context).size.width / 1.5,
                        ),
                      ),
                      const Gap(20),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: const BeveledRectangleBorder(),
                              backgroundColor: appColor),
                          onPressed: () {
                            if (products.isEmpty) {
                              context.go('/restaurant');
                              context.pop();
                            } else {
                              context.go('/login');
                            }
                          },
                          child: Text(
                            products.isEmpty
                                ? 'Continue Shopping'
                                : 'Login to continue',
                            style: const TextStyle(color: Colors.white),
                          ).tr())
                    ],
                  )
                : Padding(
                padding: MediaQuery.of(context).size.width >= 1100
                  ? const EdgeInsets.all(10.0)
                  : const EdgeInsets.all(8),
                child:  Card(
                  elevation: 1,
                    color: AdaptiveTheme.of(context).mode.isDark ? Colors.black38 : null,
                  child:  Column(
                    children: [
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          CartModel cartModel = products[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.width >= 1100 ? 160 : 150,
                              width: double.infinity,
                              child: InkWell(
                                onTap: () {
                                  context.go('/restaurant/product-detail/${cartModel.productID}');
                                  context.pop();
                                },
                                child: Card(
                                  elevation: 0,
                                  surfaceTintColor: Colors.white,
                                  color: AdaptiveTheme.of(context).mode.isDark ? Colors.black : Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        /// 🖼️ Product Image
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: SizedBox(
                                            height: 100,
                                            width: 100,
                                            child: CatImageWidget(
                                              url: cartModel.image1,
                                              boxFit: 'cover',
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),

                                        /// 📝 Info Column
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              /// 👨‍🍳 Vendor Name & Location
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      cartModel.name,
                                                      style:  TextStyle(
                                                        fontSize: MediaQuery.of(context).size.width >= 1100 ? 16 : 14,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  IconButton(
                                                    onPressed: () {
                                                      ref.read(cartStorageRestaurantProviderProvider.notifier)
                                                          .removeFromCartRestaurant(
                                                        cartModel.productID,
                                                        cartModel.selected,
                                                        context,
                                                      );
                                                    },
                                                    icon: const Icon(Icons.delete_forever_rounded),
                                                    iconSize: 20,
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 6),
                                              /// ⭐ Rating
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: Colors.green,
                                                  borderRadius: BorderRadius.circular(4),
                                                ),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      cartModel.totalNumberOfUserRating.toStringAsFixed(1),
                                                      style: const TextStyle(
                                                          // color: Colors.white,
                                                          fontSize: 12),
                                                    ),
                                                    const SizedBox(width: 4),
                                                    const Icon(Icons.star,
                                                        // color: Colors.white,
                                                        size: 14),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 18),
                                              Row(
                                                children: [
                                                 // Expanded(
                                                 //   flex : 2,
                                                 //   child:  Text(
                                                 //   cartModel.name,
                                                 //   style:  TextStyle(
                                                 //     fontSize:   MediaQuery.of(context).size.width >= 1100? 15 : 13,
                                                 //     fontWeight: FontWeight.w500,
                                                 //   ),
                                                 // ),),
                                                 //  MediaQuery.of(context).size.width >= 1100?   const Gap(50) : const Gap(40) ,
                                                 Expanded(
                                                   flex: 2,
                                                   child:  RestaurantQuantityButton(
                                                   products: products,
                                                   cartModel: cartModel,
                                                   selectedPrice: cartModel.selectedPrice,
                                                   productID: cartModel.productID,
                                                   cartID: '${cartModel.name}${cartModel.selected}',
                                                 ),),
                                                  MediaQuery.of(context).size.width >= 1100?  const Gap(20) : const Gap(30) ,
                                                 Expanded(
                                                   flex: 1,
                                                     child:  Text(
                                                       // '$currencySymbol${Formatter().converter(cartModel.selectedPrice.toDouble())}',
                                                       // '$currencySymbol${cartModel.selectedPrice.toDouble().toStringAsFixed(2)}',
                                                       // '${cartModel.quantity} x $currencySymbol${cartModel.selectedPrice.toDouble().toStringAsFixed(2)} = ${currencySymbol}${(cartModel.quantity * cartModel.selectedPrice).toDouble().toStringAsFixed(2)}',
                                                       '${currencySymbol}${(cartModel.quantity * cartModel.selectedPrice).toDouble().toStringAsFixed(2)}',
                                                    style:  TextStyle(  fontSize:  MediaQuery.of(context).size.width >= 1100? 16 :14,  color: Colors.grey, ),))
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const Divider(
                            color: Color.fromARGB(255, 225, 224, 224),
                            indent: 20,
                            endIndent: 20,
                          );
                        },
                      ),
                      MediaQuery.of(context).size.width >= 1100? const Gap(50) :const Gap(30),
                    // const Divider(
                    //   color: Color.fromARGB(255, 225, 224, 224),
                    //   indent: 20,
                    //   endIndent: 20,
                    // ),
                    //   const Gap(10),
                      Container(
                        height: (MediaQuery.of(context).size.width >= 1100 ? 160 : 180),
                        //  +
                        //     (isCouponActive == true ? 50 : 0),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: AdaptiveTheme.of(context).mode.isDark == true
                                ? Colors.black
                                : Colors.white),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            MediaQuery.of(context).size.width >= 1100? const Gap(10) : const Gap(5),
                            // Padding(
                            //   padding: MediaQuery.of(context).size.width >= 1100
                            //       ? const EdgeInsets.only(left: 20, right: 20)
                            //       : const EdgeInsets.all(6.0),
                            //   child: Row(
                            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //     children: [
                            //       const Text(
                            //         'Delivery Fee',
                            //         style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Nunito'),
                            //       ).tr(),
                            //       Text(
                            //         '$currencySymbol${Formatter().converter(deliveryFee.toDouble())}',
                            //         style: const TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Nunito'),
                            //       )
                            //     ],
                            //   ),
                            // ),
                            MediaQuery.of(context).size.width >= 1100? const Gap(10) : const Gap(5),
                            Padding(
                              padding: MediaQuery.of(context).size.width >= 1100
                                  ? const EdgeInsets.only(left: 20, right: 20)
                                  : const EdgeInsets.all(6.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Sub Total',
                                    style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Nunito'),
                                  ).tr(),
                                  Text(
                                      '$currencySymbol${cartPriceQuantity.price.toDouble().toStringAsFixed(2)}',
                                    style: const TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Nunito'),
                                  )
                                ],
                              ),
                            ),
                            MediaQuery.of(context).size.width >= 1100? const Gap(10) : const Gap(5),
                            Padding(
                              padding: MediaQuery.of(context).size.width >= 1100
                                  ? const EdgeInsets.only(left: 20, right: 20)
                                  : const EdgeInsets.all(6.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Total',
                                    style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Nunito'),
                                  ).tr(),
                                  Text(
                                    '$currencySymbol${cartPriceQuantity.price.toDouble().toStringAsFixed(2)}',
                                    style: const TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Nunito'),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: MediaQuery.of(context).size.width >= 1100
                                  ? const EdgeInsets.only(left: 20, right: 20,top: 15)
                                  : const EdgeInsets.all(8.0),
                              child: SizedBox(
                                height: 30,
                                width: 250,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: appColor,
                                    shape: const BeveledRectangleBorder(),
                                  ),
                                  onPressed: () async {
                                    if (!isLogged) {
                                      context.go('/login');
                                      Fluttertoast.showToast(
                                        msg: "Login to continue.".tr(),
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.TOP,
                                          timeInSecForIosWeb: 3,
                                          backgroundColor: const Color(0xFFFFD581),
                                          textColor: Colors.black,
                                          webBgColor: "#FFD581",
                                          webPosition: "center",
                                          fontSize: 14.0);
                                    } else {
                                      if (coupon.isEmpty) {
                                        final cartNotifier = ref.read(cartStorageRestaurantProviderProvider.notifier);
                                        final cartItems = ref.read(cartStorageRestaurantProviderProvider);
                                        final List<String> errorMessages = [];

                                        final dominantModule = cartNotifier.getCurrentModule();

                                        if (dominantModule == null) {
                                          Fluttertoast.showToast(msg: "Your cart is empty".tr());
                                          return;
                                        }

                                        for (final item in cartItems) {
                                          // Use module-specific validation
                                          final available = await cartNotifier.getProductQuantity(item.productID, item.module);

                                          if (available <= 0) {
                                            cartNotifier.removeFromCartRestaurant(item.productID, item.selected, context);
                                            errorMessages.add('⚠️ ${item.name} is sold out and removed from cart.');
                                          } else if (item.quantity > available) {
                                            cartNotifier.updateCartItemQuantityRestaurant(
                                              item.productID,
                                              item.selected,
                                              available,
                                              item.selectedPrice,
                                              context,
                                              false,
                                              item.selectedExtraPrice1 ?? 0,
                                              item.selectedExtraPrice2 ?? 0,
                                              item.selectedExtraPrice3 ?? 0,
                                              item.selectedExtraPrice4 ?? 0,
                                              item.selectedExtraPrice5 ?? 0,
                                              false,
                                            );
                                            errorMessages.add('⚠️ ${item.name} is only $available available. Quantity adjusted to $available.');
                                          }
                                        }

                                        if (errorMessages.isNotEmpty) {
                                          String errorMsg = errorMessages.join('\n');
                                          if (context.mounted) {
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: const Text('Cart Updated'),
                                                backgroundColor: AdaptiveTheme.of(context).mode.isDark
                                                    ? Colors.grey[900]
                                                    : Colors.white,
                                                content: SingleChildScrollView(child: Text(errorMsg)),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () => Navigator.pop(context),
                                                    child: const Text('OK'),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
                                        } else {
                                          if (context.mounted) {
                                            context.go('/checkout/$dominantModule');
                                            context.pop();
                                          }
                                        }
                                      }
                                    }
                                  },
                                  child: Text(
                                    'Check Out',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Nunito',
                                      fontWeight: FontWeight.bold,
                                      fontSize: MediaQuery.of(context).size.width >= 1100 ? 18 : 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            MediaQuery.of(context).size.width >= 1100 ?
                            const Gap(15) :  const Gap(8)
                          ],
                        ),
                      ),
                    ],
                  )
              ),
            ),

            // if (MediaQuery.of(context).size.width >= 1100) const Gap(150),
            // if (MediaQuery.of(context).size.width <= 1100) const Gap(200),
            if (isCouponActive == true) const Gap(50),
          ],
        ),
      ),
      // bottomSheet: products.isEmpty
      //     ? null
      //     : Container(
      //         height: (MediaQuery.of(context).size.width >= 1100 ? 150 : 200),
      //         //  +
      //         //     (isCouponActive == true ? 50 : 0),
      //         width: double.infinity,
      //         decoration: BoxDecoration(
      //             shape: BoxShape.rectangle,
      //             color: AdaptiveTheme.of(context).mode.isDark == true
      //                 ? Colors.black
      //                 : Colors.white),
      //         child: Column(
      //           mainAxisAlignment: MainAxisAlignment.spaceAround,
      //           children: [
      //             const Gap(10),
      //             Padding(
      //               padding: MediaQuery.of(context).size.width >= 1100
      //                   ? const EdgeInsets.only(left: 20, right: 20)
      //                   : const EdgeInsets.all(8.0),
      //               child: Row(
      //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                 children: [
      //                   const Text(
      //                     'Delivery Fee',
      //                     style: TextStyle(fontWeight: FontWeight.bold),
      //                   ).tr(),
      //                   Text(
      //                     '$currencySymbol${Formatter().converter(deliveryFee.toDouble())}',
      //                     style: const TextStyle(fontWeight: FontWeight.bold),
      //                   )
      //                 ],
      //               ),
      //             ),
      //             Padding(
      //               padding: MediaQuery.of(context).size.width >= 1100
      //                   ? const EdgeInsets.only(left: 20, right: 20)
      //                   : const EdgeInsets.all(8.0),
      //               child: Row(
      //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                 children: [
      //                   const Text(
      //                     'Sub Total',
      //                     style: TextStyle(fontWeight: FontWeight.bold),
      //                   ).tr(),
      //                   Text(
      //                     '$currencySymbol${Formatter().converter(cartPriceQuantity.price.toDouble())}',
      //                     style: const TextStyle(fontWeight: FontWeight.bold),
      //                   )
      //                 ],
      //               ),
      //             ),
      //             Padding(
      //               padding: MediaQuery.of(context).size.width >= 1100
      //                   ? const EdgeInsets.only(left: 20, right: 20)
      //                   : const EdgeInsets.all(8.0),
      //               child: Row(
      //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                 children: [
      //                   const Text(
      //                     'Total',
      //                     style: TextStyle(fontWeight: FontWeight.bold),
      //                   ).tr(),
      //                   Text(
      //                     '$currencySymbol${Formatter().converter((cartPriceQuantity.price + deliveryFee).toDouble())}',
      //                     style: const TextStyle(fontWeight: FontWeight.bold),
      //                   )
      //                 ],
      //               ),
      //             ),
      //             Padding(
      //               padding: MediaQuery.of(context).size.width >= 1100
      //                   ? const EdgeInsets.only(left: 20, right: 20)
      //                   : const EdgeInsets.all(8.0),
      //               child: SizedBox(
      //                 width: double.infinity,
      //                 child: ElevatedButton(
      //                     style: ElevatedButton.styleFrom(
      //                         backgroundColor: appColor,
      //                         shape: const BeveledRectangleBorder()),
      //                     onPressed: () {
      //                       if (isLogged == false) {
      //                         context.go('/login');
      //                         Fluttertoast.showToast(
      //                             msg: "Login to continue.".tr(),
      //                             toastLength: Toast.LENGTH_SHORT,
      //                             gravity: ToastGravity.TOP,
      //                             timeInSecForIosWeb: 1,
      //                             fontSize: 14.0);
      //                       } else {
      //                         if (coupon.isEmpty) {
      //                           context.go('/checkout/Restaurant');
      //                           context.pop();
      //                         } else {
      //                           // ref.read(getCouponProvider(context, coupon));
      //                         }
      //                       }
      //                     },
      //                     child: const Text(
      //                       'Check Out',
      //                       style: TextStyle(color: Colors.white),
      //                     )),
      //               ),
      //             ),
      //             if (MediaQuery.of(context).size.width <= 1100) const Gap(10)
      //           ],
      //         ),
      //       ),
    );
  }
}
