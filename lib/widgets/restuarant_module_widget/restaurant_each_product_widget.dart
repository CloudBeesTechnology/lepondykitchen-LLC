import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:user_web/model/cart_model.dart';
import 'package:user_web/model/formatter.dart';
import 'package:user_web/providers/currency_provider.dart';
import 'package:user_web/providers/vendors_list_home_provider.dart';
import 'package:user_web/widgets/cat_image_widget.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:user_web/constant.dart';
import '../../model/products_model.dart';
// ignore: depend_on_referenced_packages
import 'package:like_button/like_button.dart' as like;
import '../../providers/restuarant_providers/restaurant_cart_storage_provider.dart';
import '../../providers/restuarant_providers/restaurant_favorite_storage_provider.dart';

class RestaurantEachProductWidget extends ConsumerStatefulWidget {
  final ProductsModel productsModel;
  final int index;
  const RestaurantEachProductWidget(
      {super.key, required this.productsModel, required this.index});

  @override
  ConsumerState<RestaurantEachProductWidget> createState() =>
      _RestaurantProductWidgetMainState();
}

class _RestaurantProductWidgetMainState
    extends ConsumerState<RestaurantEachProductWidget> {
  var logger = Logger();
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final currency = ref.watch(currencySymbolProvider).value ?? '';
    final cartStorage =
    ref.read(cartStorageRestaurantProviderProvider.notifier);
    final cartStorageData = ref.watch(cartStorageRestaurantProviderProvider);
    final favoriteStorageData =
    ref.watch(favoriteStorageRestaurantProviderProvider);
    final favoriteStorage =
    ref.read(favoriteStorageRestaurantProviderProvider.notifier);
    final vendorStatus = ref
        .watch(getVendorOpenStatusProvider(widget.productsModel.vendorId))
        .value;

    return InkWell(
      onTap: () {
        if (MediaQuery.of(context).size.width <= 1100) {
          context.go('/restaurant/product-detail/${widget.productsModel.uid}');
        }
      },
      onHover: (value) {
        setState(() {
          isHovered = value;
        });
      },
      child: Transform.scale(
        scale: MediaQuery.of(context).size.width >= 1100
            ? (isHovered == true ? 1.05 : 1.0)
            : (isHovered == true ? 1 : 1.0),
        child:
        Container(
          decoration: BoxDecoration(
            color: AdaptiveTheme.of(context).mode.isDark == true
                ? Colors.black87
                : Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: SizedBox(
            // height: 320,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // const Gap(10),
                Expanded(
                  flex: 4,
                  child: Stack(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                              height: MediaQuery.of(context).size.height,
                              width: double.infinity,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10)),
                                child: MediaQuery.of(context).size.width >= 1100
                                    ? CatImageWidget(
                                  url: widget.productsModel.image1,
                                  boxFit: 'contain',
                                )
                                    : Image.network(
                                  widget.productsModel.image1,
                                  fit: BoxFit.cover,
                                ),
                              )),
                          Align(
                            alignment: Alignment.center,
                            child: FadeIn(
                              duration: const Duration(milliseconds: 100),
                              animate: isHovered,
                              child: Container(
                                height: MediaQuery.of(context).size.height,
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha:0.6),
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10)),
                                ),
                                width: double.infinity,
                                child: InkWell(
                                  onTap: () {
                                    context.go(
                                        '/restaurant/product-detail/${widget.productsModel.uid}');
                                  },
                                  // child: const Icon(
                                  //   Icons.visibility,
                                  //   color: Colors.white,
                                  //   size: 40,
                                  // ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      widget.productsModel.percantageDiscount == 0
                          ? const SizedBox.shrink()
                          : Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Container(
                              height: 24,
                              width: 50,
                              decoration: BoxDecoration(
                                  color: appColor,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10,top: 04),
                                child: Text(
                                  '${widget.productsModel.percantageDiscount}%',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600
                                  ),
                                ),
                              )),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: Icon(
                            favoriteStorageData.any((e) =>
                            e.productID == widget.productsModel.productID)
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: favoriteStorageData.any((e) =>
                            e.productID == widget.productsModel.productID)
                                ? appColor
                                : Colors.grey,
                            size: 25,
                          ),
                          splashColor: Colors.transparent, // Removes click effect
                          highlightColor: Colors.transparent, // Removes hover effect
                          onPressed: () {
                            bool isLiked = favoriteStorageData.any((e) =>
                            e.productID == widget.productsModel.productID);

                            if (isLiked) {
                              favoriteStorage.removeFromFavoriteRestaurant(
                                  widget.productsModel.productID, context);
                            } else {
                              favoriteStorage.saveToFavoriteRestaurant(
                                CartModel(
                                  module: widget.productsModel.module,
                                  vendorName: widget.productsModel.vendorName,
                                  price: widget.productsModel.unitPrice1!,
                                  selectedPrice: widget.productsModel.unitPrice1!,
                                  selected: widget.productsModel.unitname1,
                                  returnDuration: widget.productsModel.returnDuration!,
                                  totalRating: widget.productsModel.totalRating!,
                                  quantity: 1,
                                  totalNumberOfUserRating:
                                  widget.productsModel.totalNumberOfUserRating!,
                                  productID: widget.productsModel.productID,
                                  description: widget.productsModel.description,
                                  uid: widget.productsModel.uid,
                                  name: widget.productsModel.name,
                                  category: widget.productsModel.category,
                                  collection: widget.productsModel.collection,
                                  subCollection: widget.productsModel.subCollection,
                                  image1: widget.productsModel.image1,
                                  image2: widget.productsModel.image2,
                                  image3: widget.productsModel.image3,
                                  unitname1: widget.productsModel.unitname1,
                                  unitname2: widget.productsModel.unitname2,
                                  unitname3: widget.productsModel.unitname3,
                                  unitname4: widget.productsModel.unitname4,
                                  unitname5: widget.productsModel.unitname5,
                                  unitname6: widget.productsModel.unitname6,
                                  unitname7: widget.productsModel.unitname7,
                                  unitPrice1: widget.productsModel.unitPrice1!,
                                  unitPrice2: widget.productsModel.unitPrice2!,
                                  unitPrice3: widget.productsModel.unitPrice3!,
                                  unitPrice4: widget.productsModel.unitPrice4!,
                                  unitPrice5: widget.productsModel.unitPrice5!,
                                  unitPrice6: widget.productsModel.unitPrice6!,
                                  unitPrice7: widget.productsModel.unitPrice7!,
                                  unitOldPrice1: widget.productsModel.unitOldPrice1!,
                                  unitOldPrice2: widget.productsModel.unitOldPrice2!,
                                  unitOldPrice3: widget.productsModel.unitOldPrice3!,
                                  unitOldPrice4: widget.productsModel.unitOldPrice4!,
                                  unitOldPrice5: widget.productsModel.unitOldPrice5!,
                                  unitOldPrice6: widget.productsModel.unitOldPrice6!,
                                  unitOldPrice7: widget.productsModel.unitOldPrice7!,
                                  percantageDiscount:
                                  widget.productsModel.percantageDiscount!,
                                  vendorId: widget.productsModel.vendorId,
                                  brand: widget.productsModel.brand,
                                ),
                                context,
                              );
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
                const Gap(10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Text(
                      widget.productsModel.name,

                      maxLines: 1,
                      // textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: MediaQuery.of(context).size.width <= 1100
                              ? 12
                              : null),
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${widget.productsModel.unitPrice1!.toStringAsFixed(2)}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize:
                              MediaQuery.of(context).size.width <= 1100
                                  ? 12
                                  : null),
                          // maxLines: 1,
                          // textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '\$${widget.productsModel.unitOldPrice1!.toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontSize: 12,
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey),
                          // maxLines: 1,
                          // textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Row(
                      children: [
                        RatingBarIndicator(
                          rating: widget.productsModel.totalRating == 0
                              ? 0
                              : widget.productsModel.totalRating!.toDouble() /
                              widget.productsModel.totalNumberOfUserRating!
                                  .toDouble(),
                          itemBuilder: (context, index) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          itemCount: 5,
                          itemSize: 10.0,
                          direction: Axis.horizontal,
                        ),
                        Text(
                          '(${widget.productsModel.totalNumberOfUserRating})',
                          style: const TextStyle(fontSize: 10),
                        )
                      ],
                    ),
                  ),
                ),
                if (vendorStatus == false) const Gap(10),
                if (vendorStatus == false)
                  const Center(
                      child: Text(
                        'Vendor is closed',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                if (vendorStatus == false) const Gap(10),
                if (vendorStatus == true)
                  Padding(
                    padding: MediaQuery.of(context).size.width >= 1100
                        ? const EdgeInsets.all(8.0)
                        : const EdgeInsets.all(8.0),
                    child:
                    cartStorageData.any((item) =>
                    item.productID ==
                        widget.productsModel.productID &&
                        item.selected ==
                            widget.productsModel.unitname1) ==
                        true
                        ? Align(
                      alignment: Alignment.centerRight,
                      // child: IconButton(
                      //     style: IconButton.styleFrom(
                      //       backgroundColor: appColor,
                      //       shape: const CircleBorder(),
                      //     ),
                      //     onPressed: () {
                      //       // removeStorageCart(
                      //       //     widget.productsModel,
                      //       //     widget.productsModel.productID,
                      //       //     widget.productsModel.unitname1);
                      //       // setState(() {
                      //       //   isMyCart = false;
                      //       // });
                      //       cartStorage.removeFromCartRestaurant(
                      //           widget.productsModel.productID,
                      //           widget.productsModel.unitname1,
                      //           context);
                      //     },
                      //     icon: Icon(
                      //       Icons.add,
                      //       color: AdaptiveTheme.of(context)
                      //           .mode
                      //           .isDark ==
                      //           true
                      //           ? Colors.black
                      //           : Colors.white,
                      //     )),
                    )
                        : Align(
                      alignment: Alignment.centerRight,
                      // child: IconButton.outlined(
                      //     style: IconButton.styleFrom(
                      //         shape: const CircleBorder()),
                      //     onPressed: () {
                      //       cartStorage.saveToCartRestaurant(
                      //           CartModel(
                      //               module:
                      //               widget.productsModel.module,
                      //               selectedExtra1: '',
                      //               selectedExtraPrice1: 0,
                      //               selectedExtra2: '',
                      //               selectedExtraPrice2: 0,
                      //               selectedExtra3: '',
                      //               selectedExtraPrice3: 0,
                      //               selectedExtra4: '',
                      //               selectedExtraPrice4: 0,
                      //               selectedExtra5: '',
                      //               selectedExtraPrice5: 0,
                      //               isPrescription: widget
                      //                   .productsModel.isPrescription,
                      //               vendorName: widget
                      //                   .productsModel.vendorName,
                      //               price: widget
                      //                   .productsModel.unitPrice1!,
                      //               selectedPrice: widget
                      //                   .productsModel.unitPrice1!,
                      //               selected: widget
                      //                   .productsModel.unitname1,
                      //               returnDuration: widget
                      //                   .productsModel
                      //                   .returnDuration!,
                      //               totalRating: widget
                      //                   .productsModel.totalRating!,
                      //               quantity: 1,
                      //               totalNumberOfUserRating: widget
                      //                   .productsModel
                      //                   .totalNumberOfUserRating!,
                      //               productID: widget
                      //                   .productsModel.productID,
                      //               description: widget
                      //                   .productsModel.description,
                      //               // marketID: widget.productsModel.marketID,
                      //               // marketName: widget.productsModel.marketName,
                      //               uid: widget.productsModel.uid,
                      //               name: widget.productsModel.name,
                      //               category:
                      //               widget.productsModel.category,
                      //               collection: widget
                      //                   .productsModel.collection,
                      //               subCollection: widget
                      //                   .productsModel.subCollection,
                      //               image1:
                      //               widget.productsModel.image1,
                      //               image2:
                      //               widget.productsModel.image2,
                      //               image3:
                      //               widget.productsModel.image3,
                      //               unitname1: widget
                      //                   .productsModel.unitname1,
                      //               unitname2: widget
                      //                   .productsModel.unitname2,
                      //               unitname3: widget
                      //                   .productsModel.unitname3,
                      //               unitname4: widget
                      //                   .productsModel.unitname4,
                      //               unitname5: widget
                      //                   .productsModel.unitname5,
                      //               unitname6: widget
                      //                   .productsModel.unitname6,
                      //               unitname7: widget.productsModel.unitname7,
                      //               unitPrice1: widget.productsModel.unitPrice1!,
                      //               unitPrice2: widget.productsModel.unitPrice2!,
                      //               unitPrice3: widget.productsModel.unitPrice3!,
                      //               unitPrice4: widget.productsModel.unitPrice4!,
                      //               unitPrice5: widget.productsModel.unitPrice5!,
                      //               unitPrice6: widget.productsModel.unitPrice6!,
                      //               unitPrice7: widget.productsModel.unitPrice7!,
                      //               unitOldPrice1: widget.productsModel.unitOldPrice1!,
                      //               unitOldPrice2: widget.productsModel.unitOldPrice2!,
                      //               unitOldPrice3: widget.productsModel.unitOldPrice3!,
                      //               unitOldPrice4: widget.productsModel.unitOldPrice4!,
                      //               unitOldPrice5: widget.productsModel.unitOldPrice5!,
                      //               unitOldPrice6: widget.productsModel.unitOldPrice6!,
                      //               unitOldPrice7: widget.productsModel.unitOldPrice7!,
                      //               percantageDiscount: widget.productsModel.percantageDiscount!,
                      //               vendorId: widget.productsModel.vendorId,
                      //               brand: widget.productsModel.brand),
                      //           context);
                      //     },
                      //     icon: Icon(
                      //       Icons.add,
                      //       color: AdaptiveTheme.of(context)
                      //           .mode
                      //           .isDark ==
                      //           true
                      //           ? Colors.white
                      //           : Colors.black,
                      //     )),
                    ),
                  ),
                const Gap(5)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
