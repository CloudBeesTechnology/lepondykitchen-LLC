import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:user_web/model/cart_model.dart';
import 'package:user_web/model/products_model.dart';
import 'package:user_web/widgets/footer_widget.dart';
import 'package:user_web/widgets/web_menu.dart';
import 'package:user_web/constant.dart';

import '../../providers/restuarant_providers/restaurant_favorite_storage_provider.dart';
import '../../widgets/restuarant_module_widget/restaurant_product_widget_main.dart';

class RestaurantFavoritesPage extends ConsumerStatefulWidget {
  const RestaurantFavoritesPage({super.key});

  @override
  ConsumerState<RestaurantFavoritesPage> createState() =>
      _RestaurantFavoritesPageState();
}

class _RestaurantFavoritesPageState
    extends ConsumerState<RestaurantFavoritesPage> {
  @override
  Widget build(BuildContext context) {
    var favoriteModel = ref.watch(favoriteStorageRestaurantProviderProvider);
    // var restaurantFavorite =
    //     favoriteModel.where((e) => e.module == 'Restaurant').toList();
    return Scaffold(
      backgroundColor: AdaptiveTheme.of(context).mode.isDark == true
          ? null
          :  const Color(0xFFDF7EB).withOpacity(1.0),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            if (MediaQuery.of(context).size.width <= 1100) const Gap(20),
            if (MediaQuery.of(context).size.width >= 1100)
              Padding(
                padding: MediaQuery.of(context).size.width >= 1100
                    ? const EdgeInsets.only(left: 60, right: 50)
                    : const EdgeInsets.all(0),
                child: Column(
                  children: [
                    const Gap(20),
                    if (MediaQuery.of(context).size.width >= 1100)
                      Align(
                        alignment: MediaQuery.of(context).size.width >= 1100
                            ? Alignment.centerLeft
                            : Alignment.center,
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                context.go('/restaurant');
                              },
                              child: const Text(
                                'Home',
                                style: TextStyle(fontSize: 10),
                              ).tr(),
                            ),
                            const Text(
                              '/ Favorites',
                              style: TextStyle(fontSize: 10),
                            ).tr(),
                          ],
                        ),
                      ),
                    Align(
                      alignment: MediaQuery.of(context).size.width >= 1100
                          ? Alignment.centerLeft
                          : Alignment.center,
                      child: const Text(
                        'Favorites',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ).tr(),
                    ),
                    const Gap(20),
                  ],
                ),
              ),
            if (MediaQuery.of(context).size.width >= 1100)
              Padding(
                padding: const EdgeInsets.only(left: 50, right: 50),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Expanded(
                    //   flex: 2,
                    //   child: Card(
                    //       shape: const BeveledRectangleBorder(),
                    //       color: AdaptiveTheme.of(context).mode.isDark == true
                    //           ? Colors.black87
                    //           : Colors.white,
                    //       surfaceTintColor: Colors.white,
                    //       child: const WebMenu(path: '/restaurant/favorites')),
                    // ),
                    Expanded(
                        flex: 4,
                          child: Column(
                              children: [
                            // isLoaded == true
                            //     ? GridView.builder(
                            //         shrinkWrap: true,
                            //         gridDelegate:
                            //             SliverGridDelegateWithFixedCrossAxisCount(
                            //           crossAxisCount:
                            //               MediaQuery.of(context).size.width >=
                            //                       1100
                            //                   ? 4
                            //                   : 2,
                            //           crossAxisSpacing: 8.0,
                            //           mainAxisSpacing: 8.0,
                            //         ),
                            //         itemCount: 20,
                            //         itemBuilder:
                            //             (BuildContext context, int index) {
                            //           return Shimmer.fromColors(
                            //             baseColor: Colors.grey[300]!,
                            //             highlightColor: Colors.grey[100]!,
                            //             child: Column(
                            //               crossAxisAlignment:
                            //                   CrossAxisAlignment.start,
                            //               children: [
                            //                 AspectRatio(
                            //                   aspectRatio: 16 / 9,
                            //                   child: Container(
                            //                     color: Colors.grey[300],
                            //                   ),
                            //                 ),
                            //                 Padding(
                            //                   padding:
                            //                       const EdgeInsets.all(8.0),
                            //                   child: Column(
                            //                     crossAxisAlignment:
                            //                         CrossAxisAlignment.start,
                            //                     children: [
                            //                       Container(
                            //                         height: 16,
                            //                         width: 120,
                            //                         color: Colors.grey[300],
                            //                       ),
                            //                       const SizedBox(height: 8),
                            //                       Container(
                            //                         height: 16,
                            //                         width: 80,
                            //                         color: Colors.grey[300],
                            //                       ),
                            //                     ],
                            //                   ),
                            //                 ),
                            //               ],
                            //             ),
                            //           );
                            //         },
                            //       )
                            //     :
                                favoriteModel.isEmpty
                                ? Center(
                                    child: Column(children: [
                                      Icon(
                                        Icons.remove_shopping_cart,
                                        color: appColor,
                                        size:
                                            MediaQuery.of(context).size.height /
                                                3,
                                      ),
                                      const Gap(10),
                                      const Text('No Product Was Found')
                                    ]),
                                  )
                                : GridView.builder(
                                    physics: const ClampingScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: favoriteModel.length,
                                    itemBuilder: (context, index) {
                                      CartModel productsModel =
                                      favoriteModel[index];
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: InkWell(
                                            onTap: () {
                                              context.go(
                                                  '/restaurant/product-detail/${productsModel.uid}');
                                            },
                                            child: RestaurantProductWidgetMain(
                                                index: index,
                                                productsModel: ProductsModel(
                                                    module: 'Restaurant',
                                                    vendorName: productsModel
                                                        .vendorName,
                                                    returnDuration:
                                                        productsModel
                                                            .returnDuration,
                                                    totalRating: productsModel
                                                        .totalRating,
                                                    quantity: 1,
                                                    totalNumberOfUserRating:
                                                        productsModel
                                                            .totalNumberOfUserRating,
                                                    productID:
                                                        productsModel.productID,
                                                    description: productsModel
                                                        .description,
                                                    // marketID:
                                                    //     productsModel.marketID,
                                                    // marketName: productsModel
                                                    //     .marketName,
                                                    uid: productsModel.uid,
                                                    name: productsModel.name,
                                                    category:
                                                        productsModel.category,
                                                    collection: productsModel
                                                        .collection,
                                                    subCollection: productsModel
                                                        .subCollection,
                                                    image1:
                                                        productsModel.image1,
                                                    image2:
                                                        productsModel.image2,
                                                    image3:
                                                        productsModel.image3,
                                                    unitname1:
                                                        productsModel.unitname1,
                                                    unitname2:
                                                        productsModel.unitname2,
                                                    unitname3:
                                                        productsModel.unitname3,
                                                    unitname4:
                                                        productsModel.unitname4,
                                                    unitname5:
                                                        productsModel.unitname5,
                                                    unitname6:
                                                        productsModel.unitname6,
                                                    unitname7:
                                                        productsModel.unitname7,
                                                    unitPrice1: productsModel
                                                        .unitPrice1,
                                                    unitPrice2: productsModel
                                                        .unitPrice2,
                                                    unitPrice3: productsModel
                                                        .unitPrice3,
                                                    unitPrice4: productsModel
                                                        .unitPrice4,
                                                    unitPrice5: productsModel
                                                        .unitPrice5,
                                                    unitPrice6: productsModel
                                                        .unitPrice6,
                                                    unitPrice7: productsModel
                                                        .unitPrice7,
                                                    unitOldPrice1: productsModel
                                                        .unitOldPrice1,
                                                    unitOldPrice2: productsModel
                                                        .unitOldPrice2,
                                                    unitOldPrice3: productsModel
                                                        .unitOldPrice3,
                                                    unitOldPrice4: productsModel
                                                        .unitOldPrice4,
                                                    unitOldPrice5: productsModel
                                                        .unitOldPrice5,
                                                    unitOldPrice6: productsModel
                                                        .unitOldPrice6,
                                                    unitOldPrice7: productsModel
                                                        .unitOldPrice7,
                                                    percantageDiscount:
                                                        productsModel
                                                            .percantageDiscount,
                                                    vendorId:
                                                        productsModel.vendorId,
                                                    brand: productsModel.brand,
                                                    timeCreated:
                                                        DateTime.now()))),
                                      );
                                    },
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            childAspectRatio:
                                                MediaQuery.of(context)
                                                            .size
                                                            .width >=
                                                        1100
                                                    ? 1.4
                                                    : 0.7,
                                            crossAxisCount:
                                                MediaQuery.of(context)
                                                            .size
                                                            .width >=
                                                        1100
                                                    ? 4
                                                    : 2,
                                            mainAxisSpacing: 5,
                                            crossAxisSpacing: 5),
                                  ),
                          ]),
                    )
                  ],
                ),
              ),
            ////////////////////////////////////////////////////// Mobile View /////////////////
            if (MediaQuery.of(context).size.width <= 1100)
              // isLoaded == true
              //     ? GridView.builder(
              //         shrinkWrap: true,
              //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //           crossAxisCount:
              //               MediaQuery.of(context).size.width >= 1100 ? 4 : 2,
              //           crossAxisSpacing: 8.0,
              //           mainAxisSpacing: 8.0,
              //         ),
              //         itemCount: 20,
              //         itemBuilder: (BuildContext context, int index) {
              //           return Shimmer.fromColors(
              //             baseColor: Colors.grey[300]!,
              //             highlightColor: Colors.grey[100]!,
              //             child: Column(
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               children: [
              //                 AspectRatio(
              //                   aspectRatio: 16 / 9,
              //                   child: Container(
              //                     color: Colors.grey[300],
              //                   ),
              //                 ),
              //                 Padding(
              //                   padding: const EdgeInsets.all(8.0),
              //                   child: Column(
              //                     crossAxisAlignment: CrossAxisAlignment.start,
              //                     children: [
              //                       Container(
              //                         height: 16,
              //                         width: 120,
              //                         color: Colors.grey[300],
              //                       ),
              //                       const SizedBox(height: 8),
              //                       Container(
              //                         height: 16,
              //                         width: 80,
              //                         color: Colors.grey[300],
              //                       ),
              //                     ],
              //                   ),
              //                 ),
              //               ],
              //             ),
              //           );
              //         },
              //       )
              //     :
              favoriteModel.isEmpty
                  ? Center(
                      child: Column(children: [
                        Icon(
                          Icons.remove_shopping_cart,
                          color: appColor,
                          size: MediaQuery.of(context).size.height / 3,
                        ),
                        const Gap(10),
                        const Text('No Product Was Found')
                      ]),
                    )
                  : GridView.builder(
                      physics: const ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: favoriteModel.length,
                      itemBuilder: (context, index) {
                        CartModel productsModel = favoriteModel[index];
                        return Padding(
                          padding: const EdgeInsets.all(8),
                          child: InkWell(
                              onTap: () {
                                context
                                    .go('/restaurant/product-detail/${productsModel.uid}');
                              },
                              child: RestaurantProductWidgetMain(
                                  index: index,
                                  productsModel: ProductsModel(
                                      module: 'Restaurant',
                                      vendorName: productsModel.vendorName,
                                      returnDuration:
                                          productsModel.returnDuration,
                                      totalRating: productsModel.totalRating,
                                      quantity: 1,
                                      totalNumberOfUserRating:
                                          productsModel.totalNumberOfUserRating,
                                      productID: productsModel.productID,
                                      description: productsModel.description,
                                      // marketID: productsModel.marketID,
                                      // marketName: productsModel.marketName,
                                      uid: productsModel.uid,
                                      name: productsModel.name,
                                      category: productsModel.category,
                                      collection: productsModel.collection,
                                      subCollection:
                                          productsModel.subCollection,
                                      image1: productsModel.image1,
                                      image2: productsModel.image2,
                                      image3: productsModel.image3,
                                      unitname1: productsModel.unitname1,
                                      unitname2: productsModel.unitname2,
                                      unitname3: productsModel.unitname3,
                                      unitname4: productsModel.unitname4,
                                      unitname5: productsModel.unitname5,
                                      unitname6: productsModel.unitname6,
                                      unitname7: productsModel.unitname7,
                                      unitPrice1: productsModel.unitPrice1,
                                      unitPrice2: productsModel.unitPrice2,
                                      unitPrice3: productsModel.unitPrice3,
                                      unitPrice4: productsModel.unitPrice4,
                                      unitPrice5: productsModel.unitPrice5,
                                      unitPrice6: productsModel.unitPrice6,
                                      unitPrice7: productsModel.unitPrice7,
                                      unitOldPrice1:
                                          productsModel.unitOldPrice1,
                                      unitOldPrice2:
                                          productsModel.unitOldPrice2,
                                      unitOldPrice3:
                                          productsModel.unitOldPrice3,
                                      unitOldPrice4:
                                          productsModel.unitOldPrice4,
                                      unitOldPrice5:
                                          productsModel.unitOldPrice5,
                                      unitOldPrice6:
                                          productsModel.unitOldPrice6,
                                      unitOldPrice7:
                                          productsModel.unitOldPrice7,
                                      percantageDiscount:
                                          productsModel.percantageDiscount,
                                      vendorId: productsModel.vendorId,
                                      brand: productsModel.brand,
                                      timeCreated: DateTime.now()))),
                        );
                      },
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio:
                              MediaQuery.of(context).size.width >= 1100
                                  ? 0.6
                                  : 0.98,
                          crossAxisCount:
                              MediaQuery.of(context).size.width >= 1100 ? 4 : 2,
                          mainAxisSpacing: 5,
                          crossAxisSpacing: 5),
                    ),
            const Gap(20),
            const FooterWidget()
          ],
        ),
      ),
    );
  }
}
