import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_web/model/products_model.dart';
import 'package:user_web/widgets/footer_widget.dart';
// ignore: library_prefixes
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as modalSheet;
import 'package:user_web/constant.dart';
import '../../model/sub_collections_model.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import '../../providers/currency_provider.dart';
import '../../providers/restuarant_providers/restaurant_collections_page_provider.dart';
import '../../widgets/cat_image_widget.dart';
import '../../widgets/restuarant_module_widget/restaurant_each_product_widget.dart';
import '../../widgets/restuarant_module_widget/restaurant_product_widget_main.dart';

class RestaurantProductsByCollection extends ConsumerStatefulWidget {
  final String category;
  const RestaurantProductsByCollection({super.key, required this.category});

  @override
  ConsumerState<RestaurantProductsByCollection> createState() =>
      _RestaurantProductsByCollectionState();
}

class _RestaurantProductsByCollectionState
    extends ConsumerState<RestaurantProductsByCollection> {
  String? sortBy;
  int? selectedValue;
  int? selectedCollection;
  int? rateValue;

  @override
  Widget build(BuildContext context) {
    var currency = ref.watch(currencySymbolProvider).value;
    var collectionPageProvider =
        ref.watch(CollectionsPageRestaurantNotifierProvider(widget.category));
    var collectionPageProviderAction = ref.read(
        CollectionsPageRestaurantNotifierProvider(widget.category).notifier);
    return Scaffold(
        backgroundColor: AdaptiveTheme.of(context).mode.isDark == true
            ? null
            : const Color(0xFFDF7EB).withOpacity(1.0),
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(children: [
            // const Gap(20),
            AspectRatio(
              aspectRatio: MediaQuery.of(context).size.width >= 1100 ? 16 / 5 : 4 / 3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(0), // or add rounding if you want
                child: CatImageWidget(
                  url: collectionPageProvider.imageUrl,
                  boxFit: 'cover', // since you had BoxFit.cover
                ),
              ),
            ),
            const Gap(20),
            if (MediaQuery.of(context).size.width >= 1100)
              Align(
                alignment: MediaQuery.of(context).size.width >= 1100
                    ? Alignment.centerLeft
                    : Alignment.center,
                child: Padding(
                  padding: MediaQuery.of(context).size.width >= 1100
                      ? const EdgeInsets.only(left: 60, right: 120)
                      : const EdgeInsets.all(0),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          context.go('/restaurant');
                        },
                        child: const Text(
                          'Home',
                          style: TextStyle(fontSize: 12),
                        ).tr(),
                      ),
                      InkWell(
                        onTap: () {
                          context.go(
                              '/restaurant/products/${collectionPageProvider.category}');
                        },
                        child: Text(
                          '/ ${collectionPageProvider.category} ',
                          style: const TextStyle(fontSize: 12),
                        ).tr(),
                      ),
                      Text(
                        '/ ${widget.category}',
                        style: const TextStyle(fontSize: 12),
                      ).tr(),
                    ],
                  ),
                ),
              ),
            if (MediaQuery.of(context).size.width >= 1100) const Gap(10),
            MediaQuery.of(context).size.width >= 1100
                ? Padding(
                    padding: MediaQuery.of(context).size.width >= 1100
                        ? const EdgeInsets.only(left: 50, right: 50)
                        : const EdgeInsets.all(0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            flex: 2,
                            child: Card(
                              shape: const BeveledRectangleBorder(),
                              surfaceTintColor: Colors.white,
                              //r  shadowColor: Colors.white,
                              //  elevation: 1,
                              // color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SingleChildScrollView(
                                  physics: const ClampingScrollPhysics(),
                                  child: Column(
                                    children: [
                                      ListTile(
                                        title: const Text(
                                          'Sub Collections',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 11),
                                        ).tr(),
                                        trailing: selectedCollection == null
                                            ? null
                                            : TextButton(
                                                child: const Text(
                                                  'Clear',
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    selectedCollection = null;
                                                    collectionPageProviderAction
                                                        .resetToInitialList();
                                                  });
                                                },
                                              ),
                                      ),
                                      collectionPageProvider.isLoaded == true
                                          ? ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: 10,
                                              itemBuilder: (context, index) {
                                                return Shimmer.fromColors(
                                                  baseColor: Colors.grey[300]!,
                                                  highlightColor:
                                                      Colors.grey[100]!,
                                                  child: ListTile(
                                                    title: Container(
                                                      height: 16,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                );
                                              },
                                            )
                                          : ListView.builder(
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              shrinkWrap: true,
                                              itemExtent: 35.0,
                                              itemCount: collectionPageProvider
                                                  .collection.length,
                                              itemBuilder: (context, index) {
                                                SubCollectionsModel
                                                    subCategoriesCollectionsModel =
                                                    collectionPageProvider
                                                        .collection[index];
                                                return RadioListTile(
                                                  title: Text(
                                                    subCategoriesCollectionsModel
                                                        .subCollection,
                                                    style: const TextStyle(
                                                        fontSize: 11),
                                                  ),
                                                  value: index,
                                                  groupValue:
                                                      selectedCollection,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      selectedCollection =
                                                          value;
                                                    });
                                                    collectionPageProviderAction
                                                        .resetToInitialList();
                                                    collectionPageProviderAction
                                                        .sortBySubCollections(
                                                            subCategoriesCollectionsModel
                                                                .subCollection);
                                                    // resetToInitialList();
                                                    // sortProductsByPriceRange(1, 2000);
                                                  },
                                                );
                                              }),
                                      const Gap(10),
                                      const Divider(
                                        color: Colors.grey,
                                        thickness: 1,
                                      ),
                                      ListTile(
                                        title: const Text(
                                          'Price',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 11),
                                        ).tr(),
                                        trailing: selectedValue == null
                                            ? null
                                            : TextButton(
                                                child: const Text(
                                                  'Clear',
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    selectedValue = null;
                                                    collectionPageProviderAction
                                                        .resetToInitialList();
                                                  });
                                                },
                                              ),
                                      ),
                                      ListView(
                                        shrinkWrap: true,
                                        itemExtent: 35.0,
                                        //padding: EdgeInsets.symmetric(vertical:20),
                                        children: [
                                          RadioListTile(
                                            title: Text(
                                              'Under ${currency}2,000',
                                              style:
                                                  const TextStyle(fontSize: 11),
                                            ),
                                            value: 1,
                                            groupValue: selectedValue,
                                            onChanged: (value) {
                                              setState(() {
                                                selectedValue = value;
                                              });
                                              collectionPageProviderAction
                                                  .resetToInitialList();
                                              collectionPageProviderAction
                                                  .sortProductsByPriceRange(
                                                      1, 2000);
                                            },
                                          ),
                                          RadioListTile(
                                            title: Text(
                                                '${currency}2,000 - ${currency}5,000',
                                                style: const TextStyle(
                                                    fontSize: 11)),
                                            value: 2,
                                            groupValue: selectedValue,
                                            onChanged: (value) {
                                              setState(() {
                                                selectedValue = value;
                                              });
                                              collectionPageProviderAction
                                                  .resetToInitialList();
                                              collectionPageProviderAction
                                                  .sortProductsByPriceRange(
                                                      2000, 5000);
                                            },
                                          ),
                                          RadioListTile(
                                            title: Text(
                                                '${currency}5,000 - ${currency}10,000',
                                                style: const TextStyle(
                                                    fontSize: 11)),
                                            value: 3,
                                            groupValue: selectedValue,
                                            onChanged: (value) {
                                              setState(() {
                                                selectedValue = value;
                                              });
                                              collectionPageProviderAction
                                                  .resetToInitialList();
                                              collectionPageProviderAction
                                                  .sortProductsByPriceRange(
                                                      5000, 10000);
                                            },
                                          ),
                                          RadioListTile(
                                            title: Text(
                                                '${currency}10,000 - ${currency}20,000',
                                                style: const TextStyle(
                                                    fontSize: 11)),
                                            value: 4,
                                            groupValue: selectedValue,
                                            onChanged: (value) {
                                              setState(() {
                                                selectedValue = value;
                                              });
                                              collectionPageProviderAction
                                                  .resetToInitialList();
                                              collectionPageProviderAction
                                                  .sortProductsByPriceRange(
                                                      10000, 20000);
                                            },
                                          ),
                                          RadioListTile(
                                            title: Text(
                                                '${currency}20,000 - ${currency}40,000',
                                                style: const TextStyle(
                                                    fontSize: 11)),
                                            value: 5,
                                            groupValue: selectedValue,
                                            onChanged: (value) {
                                              setState(() {
                                                selectedValue = value;
                                              });
                                              collectionPageProviderAction
                                                  .resetToInitialList();
                                              collectionPageProviderAction
                                                  .sortProductsByPriceRange(
                                                      20000, 40000);
                                            },
                                          ),
                                          RadioListTile(
                                            title: Text(
                                                'Above ${currency}40,000',
                                                style: const TextStyle(
                                                    fontSize: 11)),
                                            value: 6,
                                            groupValue: selectedValue,
                                            onChanged: (value) {
                                              setState(() {
                                                selectedValue = value;
                                              });
                                              collectionPageProviderAction
                                                  .resetToInitialList();
                                              collectionPageProviderAction
                                                  .sortProductsByPriceRange(
                                                      40000, 100000000000);
                                            },
                                          ),
                                        ],
                                      ),
                                      const Gap(10),
                                      const Divider(
                                        color: Colors.grey,
                                        thickness: 1,
                                      ),
                                      ListTile(
                                        title: const Text(
                                          'Rating',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 11),
                                        ).tr(),
                                        trailing: rateValue == null
                                            ? null
                                            : TextButton(
                                                child: const Text(
                                                  'Clear',
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    rateValue = null;
                                                    collectionPageProviderAction
                                                        .resetToInitialList();
                                                  });
                                                },
                                              ),
                                      ),
                                      ListView(
                                        itemExtent: 35.0,
                                        shrinkWrap: true,
                                        //padding: EdgeInsets.symmetric(vertical:20),
                                        children: [
                                          RadioListTile(
                                            title: Row(
                                              children: [
                                                Icon(
                                                  Icons.star,
                                                  color: appColor,
                                                  size: 14,
                                                ),
                                                Icon(
                                                  Icons.star,
                                                  color: appColor,
                                                  size: 14,
                                                ),
                                                Icon(
                                                  Icons.star,
                                                  color: appColor,
                                                  size: 14,
                                                ),
                                                Icon(
                                                  Icons.star,
                                                  color: appColor,
                                                  size: 14,
                                                ),
                                                const Icon(
                                                  Icons.star,
                                                  color: Colors.grey,
                                                  size: 14,
                                                ),
                                                const Text(
                                                  '& Up',
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                )
                                              ],
                                            ),
                                            value: 1,
                                            groupValue: rateValue,
                                            onChanged: (value) {
                                              setState(() {
                                                rateValue = value;
                                              });
                                              collectionPageProviderAction
                                                  .resetToInitialList();
                                              collectionPageProviderAction
                                                  .sortAndFilterProductsByRating(
                                                      4);
                                            },
                                          ),
                                          RadioListTile(
                                            title: Row(
                                              children: [
                                                Icon(
                                                  Icons.star,
                                                  color: appColor,
                                                  size: 14,
                                                ),
                                                Icon(
                                                  Icons.star,
                                                  color: appColor,
                                                  size: 14,
                                                ),
                                                Icon(
                                                  Icons.star,
                                                  color: appColor,
                                                  size: 14,
                                                ),
                                                const Icon(
                                                  Icons.star,
                                                  color: Colors.grey,
                                                  size: 14,
                                                ),
                                                const Icon(
                                                  Icons.star,
                                                  color: Colors.grey,
                                                  size: 14,
                                                ),
                                                const Text(
                                                  '& Up',
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                )
                                              ],
                                            ),
                                            value: 2,
                                            groupValue: rateValue,
                                            onChanged: (value) {
                                              setState(() {
                                                rateValue = value;
                                              });
                                              collectionPageProviderAction
                                                  .resetToInitialList();
                                              collectionPageProviderAction
                                                  .sortAndFilterProductsByRating(
                                                      3);
                                            },
                                          ),
                                          RadioListTile(
                                            title: Row(
                                              children: [
                                                Icon(
                                                  Icons.star,
                                                  color: appColor,
                                                  size: 14,
                                                ),
                                                Icon(
                                                  Icons.star,
                                                  color: appColor,
                                                  size: 14,
                                                ),
                                                const Icon(
                                                  Icons.star,
                                                  color: Colors.grey,
                                                  size: 14,
                                                ),
                                                const Icon(
                                                  Icons.star,
                                                  color: Colors.grey,
                                                  size: 14,
                                                ),
                                                const Icon(
                                                  Icons.star,
                                                  color: Colors.grey,
                                                  size: 14,
                                                ),
                                                const Text(
                                                  '& Up',
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                )
                                              ],
                                            ),
                                            value: 3,
                                            groupValue: rateValue,
                                            onChanged: (value) {
                                              setState(() {
                                                rateValue = value;
                                              });
                                              collectionPageProviderAction
                                                  .resetToInitialList();
                                              collectionPageProviderAction
                                                  .sortAndFilterProductsByRating(
                                                      2);
                                            },
                                          ),
                                          RadioListTile(
                                            title: Row(
                                              children: [
                                                Icon(
                                                  Icons.star,
                                                  color: appColor,
                                                  size: 14,
                                                ),
                                                const Icon(
                                                  Icons.star,
                                                  color: Colors.grey,
                                                  size: 14,
                                                ),
                                                const Icon(
                                                  Icons.star,
                                                  color: Colors.grey,
                                                  size: 14,
                                                ),
                                                const Icon(
                                                  Icons.star,
                                                  color: Colors.grey,
                                                  size: 14,
                                                ),
                                                const Icon(
                                                  Icons.star,
                                                  color: Colors.grey,
                                                  size: 14,
                                                ),
                                                const Text(
                                                  '& Up',
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                )
                                              ],
                                            ),
                                            value: 4,
                                            groupValue: rateValue,
                                            onChanged: (value) {
                                              setState(() {
                                                rateValue = value;
                                              });
                                              collectionPageProviderAction
                                                  .resetToInitialList();
                                              collectionPageProviderAction
                                                  .sortAndFilterProductsByRating(
                                                      1);
                                            },
                                          ),
                                          const Gap(10)
                                          // Add more RadioListTile widgets as needed
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )),
                        const Gap(10),
                        Expanded(
                          flex: 7,
                          child: collectionPageProvider.isLoaded == true
                              ? GridView.builder(
                                  shrinkWrap: true,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                        MediaQuery.of(context).size.width >=
                                                1100
                                            ? 4
                                            : 2,
                                    crossAxisSpacing: 8.0,
                                    mainAxisSpacing: 8.0,
                                  ),
                                  itemCount: 20,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          AspectRatio(
                                            aspectRatio: 16 / 9,
                                            child: Container(
                                              color: Colors.grey[300],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  height: 16,
                                                  width: 120,
                                                  color: Colors.grey[300],
                                                ),
                                                const SizedBox(height: 8),
                                                Container(
                                                  height: 16,
                                                  width: 80,
                                                  color: Colors.grey[300],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SingleChildScrollView(
                                    physics: const ClampingScrollPhysics(),
                                    child: Column(
                                      children: [
                                        const Gap(10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${collectionPageProvider.products.length} Products Found',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            DropdownButtonHideUnderline(
                                                child: DropdownButton2(
                                                    isExpanded: true,
                                                    dropdownStyleData:
                                                        const DropdownStyleData(
                                                            width: 150),
                                                    customButton: const Row(
                                                      children: [
                                                        Icon(
                                                          Icons.sort,
                                                        ),
                                                        SizedBox(
                                                          width: 7,
                                                        ),
                                                        Text(
                                                          'Sort By',
                                                          style: TextStyle(
                                                              //fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                        SizedBox(
                                                          width: 4,
                                                        ),
                                                        Icon(
                                                          Icons
                                                              .arrow_drop_down_outlined,
                                                          //  color: Color.fromRGBO(48, 30, 2, 1),
                                                        ),
                                                      ],
                                                    ),
                                                    items: [
                                                      'Price:Low to High'.tr(),
                                                      'Price:High to Low'.tr(),
                                                      'Product Rating'.tr(),
                                                      // 'Favorites'.tr(),
                                                      // 'Signup'.tr(),
                                                    ]
                                                        .map((item) =>
                                                            DropdownMenuItem<
                                                                String>(
                                                              value: item,
                                                              child: Text(
                                                                item,
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 11,
                                                                  // fontWeight: FontWeight.bold,
                                                                  // color: Colors
                                                                  //     .black,
                                                                ),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ))
                                                        .toList(),
                                                    value: sortBy,
                                                    onChanged: (value) {
                                                      setState(
                                                        () {
                                                          if (value ==
                                                              'Price:Low to High') {
                                                            collectionPageProviderAction
                                                                .sortProductsFromLowToHigh();
                                                          } else if (value ==
                                                              'Price:High to Low') {
                                                            collectionPageProviderAction
                                                                .sortProductsFromHighToLow();
                                                          } else {
                                                            collectionPageProviderAction
                                                                .sortProductsRatingFromHighToLow();
                                                          }
                                                        },
                                                      );
                                                    })),
                                          ],
                                        ),
                                        const Divider(
                                          color: Colors.grey,
                                          thickness: 1,
                                        ),
                                        collectionPageProvider.products.isEmpty
                                            ? Center(
                                                child: Column(children: [
                                                  Icon(
                                                    Icons.remove_shopping_cart,
                                                    color: appColor,
                                                    size: MediaQuery.of(context)
                                                            .size
                                                            .height /
                                                        3,
                                                  ),
                                                  const Gap(10),
                                                  const Text(
                                                      'No Product Was Found')
                                                ]),
                                              )
                                            : AnimationLimiter(
                                                child: GridView.builder(
                                                  physics:
                                                      const BouncingScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemCount:
                                                      collectionPageProvider
                                                          .products.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    ProductsModel
                                                        productsModel =
                                                        collectionPageProvider
                                                            .products[index];
                                                    return AnimationConfiguration
                                                        .staggeredGrid(
                                                      position: index,
                                                      duration: const Duration(
                                                          milliseconds: 500),
                                                      columnCount:
                                                          MediaQuery.of(context)
                                                                      .size
                                                                      .width >=
                                                                  1100
                                                              ? 4
                                                              : 2,
                                                      child: SlideAnimation(
                                                        verticalOffset: 50.0,
                                                        curve: Curves.easeInOut,
                                                        child: FadeInAnimation(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: RestaurantEachProductWidget(
                                                                index: index,
                                                                productsModel:
                                                                    productsModel),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  gridDelegate:
                                                      SliverGridDelegateWithFixedCrossAxisCount(
                                                          childAspectRatio: 0.7,
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
                                              ),
                                      ],
                                    ),
                                  ),
                                ),
                        ),
                        const Gap(8)
                      ],
                    ),
                  )
                ///////////////////////////////////////////// Mobile View ////////////////////////////////////////////////////
                :
            // SingleChildScrollView(
            //   physics: const ClampingScrollPhysics(),
                   Column(
                      children: [
                        collectionPageProvider.isLoaded == true
                            ? GridView.builder(
                              physics: const ClampingScrollPhysics(),
                                shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      MediaQuery.of(context).size.width >= 1100
                                          ? 4
                                          : 2,
                                  crossAxisSpacing: 8.0,
                                  mainAxisSpacing: 8.0,
                                ),
                                itemCount: 20,
                                itemBuilder: (BuildContext context, int index) {
                                  return Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AspectRatio(
                                          aspectRatio: 16 / 9,
                                          child: Container(
                                            color: Colors.grey[300],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: 16,
                                                width: 120,
                                                color: Colors.grey[300],
                                              ),
                                              const SizedBox(height: 8),
                                              Container(
                                                height: 16,
                                                width: 80,
                                                color: Colors.grey[300],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              )
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    // const Gap(10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        TextButton.icon(
                                            onPressed: () {
                                              modalSheet
                                                  .showBarModalBottomSheet(
                                                      expand: true,
                                                      bounce: true,
                                                      context: context,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      builder: (context) {
                                                        int?
                                                            selectedValueMobile;
                                                        int? rateValueMobile;
                                                        int?
                                                            selectedCollectionMobile;
                                                        return StatefulBuilder(
                                                            builder: (context,
                                                                setState) {
                                                          return Scaffold(
                                                            body: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child:
                                                                  SingleChildScrollView(
                                                                    physics: const ClampingScrollPhysics(),
                                                                child: Column(
                                                                  children: [
                                                                    ListTile(
                                                                      title:
                                                                          const Text(
                                                                        'Sub Collections',
                                                                        style:
                                                                            TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      ).tr(),
                                                                      trailing: selectedCollection ==
                                                                              null
                                                                          ? null
                                                                          : TextButton(
                                                                              child: const Text(
                                                                                'Clear',
                                                                                style: TextStyle(color: Colors.grey),
                                                                              ),
                                                                              onPressed: () {
                                                                                setState(() {
                                                                                  selectedCollectionMobile = null;
                                                                                  selectedCollection = null;
                                                                                  selectedValue = null;
                                                                                  selectedValueMobile = null;
                                                                                  rateValue = null;
                                                                                  rateValueMobile = null;
                                                                                  collectionPageProviderAction.resetToInitialList();
                                                                                  context.pop();
                                                                                });
                                                                              },
                                                                            ),
                                                                    ),
                                                                    collectionPageProvider.isLoaded ==
                                                                            true
                                                                        ? ListView
                                                                            .builder(
                                                                            shrinkWrap:
                                                                                true,
                                                                            itemCount:
                                                                                10,
                                                                            itemBuilder:
                                                                                (context, index) {
                                                                              return Shimmer.fromColors(
                                                                                baseColor: Colors.grey[300]!,
                                                                                highlightColor: Colors.grey[100]!,
                                                                                child: ListTile(
                                                                                  title: Container(
                                                                                    height: 16,
                                                                                    color: Colors.white,
                                                                                  ),
                                                                                ),
                                                                              );
                                                                            },
                                                                          )
                                                                        : ListView.builder(
                                                                            physics: const ClampingScrollPhysics(),
                                                                            shrinkWrap: true,
                                                                            //  itemExtent: 35.0,
                                                                            itemCount: collectionPageProvider.collection.length,
                                                                            itemBuilder: (context, index) {
                                                                              SubCollectionsModel subCategoriesCollectionsModel = collectionPageProvider.collection[index];
                                                                              return RadioListTile(
                                                                                title: Text(
                                                                                  subCategoriesCollectionsModel.subCollection,
                                                                                  style: const TextStyle(),
                                                                                ),
                                                                                value: index,
                                                                                groupValue: selectedCollection ?? selectedCollectionMobile,
                                                                                onChanged: (value) {
                                                                                  setState(() {
                                                                                    selectedCollection = value;
                                                                                    selectedCollectionMobile = value;
                                                                                  });

                                                                                  collectionPageProviderAction.resetToInitialList();
                                                                                  collectionPageProviderAction.sortBySubCollections(subCategoriesCollectionsModel.subCollection);
                                                                                  context.pop();
                                                                                  // resetToInitialList();
                                                                                  // sortProductsByPriceRange(1, 2000);
                                                                                },
                                                                              );
                                                                            }),
                                                                    const Gap(
                                                                        10),
                                                                    const Divider(
                                                                      color: Colors
                                                                          .grey,
                                                                      thickness:
                                                                          1,
                                                                    ),
                                                                    ListTile(
                                                                      title:
                                                                          const Text(
                                                                        'Price',
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ).tr(),
                                                                      trailing: selectedValue ==
                                                                              null
                                                                          ? null
                                                                          : TextButton(
                                                                              child: const Text(
                                                                                'Clear',
                                                                                style: TextStyle(color: Colors.grey),
                                                                              ),
                                                                              onPressed: () {
                                                                                setState(() {
                                                                                  selectedCollectionMobile = null;
                                                                                  selectedCollection = null;
                                                                                  selectedValue = null;
                                                                                  selectedValueMobile = null;
                                                                                  rateValue = null;
                                                                                  rateValueMobile = null;
                                                                                  // selectedValueMobile = null;
                                                                                  // selectedValue = null;
                                                                                  collectionPageProviderAction.resetToInitialList();
                                                                                  context.pop();
                                                                                });
                                                                              },
                                                                            ),
                                                                    ),
                                                                    ListView(
                                                                      physics:
                                                                          const ClampingScrollPhysics(),
                                                                      shrinkWrap:
                                                                          true,

                                                                      //padding: EdgeInsets.symmetric(vertical:20),
                                                                      children: [
                                                                        RadioListTile(
                                                                          title:
                                                                              Text(
                                                                            'Under ${currency}2,000',
                                                                            style:
                                                                                const TextStyle(),
                                                                          ),
                                                                          value:
                                                                              1,
                                                                          groupValue:
                                                                              selectedValueMobile ?? selectedValue,
                                                                          onChanged:
                                                                              (value) {
                                                                            setState(() {
                                                                              selectedValueMobile = value;
                                                                              selectedValue = value;
                                                                            });
                                                                            collectionPageProviderAction.resetToInitialList();
                                                                            collectionPageProviderAction.sortProductsByPriceRange(1,
                                                                                2000);
                                                                            context.pop();
                                                                          },
                                                                        ),
                                                                        RadioListTile(
                                                                          title: Text(
                                                                              '${currency}2,000 - ${currency}5,000',
                                                                              style: const TextStyle()),
                                                                          value:
                                                                              2,
                                                                          groupValue:
                                                                              selectedValueMobile ?? selectedValue,
                                                                          onChanged:
                                                                              (value) {
                                                                            setState(() {
                                                                              selectedValueMobile = value;
                                                                              selectedValue = value;
                                                                            });
                                                                            collectionPageProviderAction.resetToInitialList();
                                                                            collectionPageProviderAction.sortProductsByPriceRange(2000,
                                                                                5000);
                                                                            context.pop();
                                                                          },
                                                                        ),
                                                                        RadioListTile(
                                                                          title: Text(
                                                                              '${currency}5,000 - ${currency}10,000',
                                                                              style: const TextStyle()),
                                                                          value:
                                                                              3,
                                                                          groupValue:
                                                                              selectedValueMobile ?? selectedValue,
                                                                          onChanged:
                                                                              (value) {
                                                                            setState(() {
                                                                              selectedValueMobile = value;
                                                                              selectedValue = value;
                                                                            });
                                                                            collectionPageProviderAction.resetToInitialList();
                                                                            collectionPageProviderAction.sortProductsByPriceRange(5000,
                                                                                10000);
                                                                            context.pop();
                                                                          },
                                                                        ),
                                                                        RadioListTile(
                                                                          title: Text(
                                                                              '${currency}10,000 - ${currency}20,000',
                                                                              style: const TextStyle()),
                                                                          value:
                                                                              4,
                                                                          groupValue:
                                                                              selectedValueMobile ?? selectedValue,
                                                                          onChanged:
                                                                              (value) {
                                                                            setState(() {
                                                                              selectedValueMobile = value;
                                                                              selectedValue = value;
                                                                            });
                                                                            collectionPageProviderAction.resetToInitialList();
                                                                            collectionPageProviderAction.sortProductsByPriceRange(10000,
                                                                                20000);
                                                                            context.pop();
                                                                          },
                                                                        ),
                                                                        RadioListTile(
                                                                          title: Text(
                                                                              '${currency}20,000 - ${currency}40,000',
                                                                              style: const TextStyle()),
                                                                          value:
                                                                              5,
                                                                          groupValue:
                                                                              selectedValueMobile ?? selectedValue,
                                                                          onChanged:
                                                                              (value) {
                                                                            setState(() {
                                                                              selectedValueMobile = value;
                                                                              selectedValue = value;
                                                                            });
                                                                            collectionPageProviderAction.resetToInitialList();
                                                                            collectionPageProviderAction.sortProductsByPriceRange(20000,
                                                                                40000);
                                                                            context.pop();
                                                                          },
                                                                        ),
                                                                        RadioListTile(
                                                                          title: Text(
                                                                              'Above ${currency}40,000',
                                                                              style: const TextStyle()),
                                                                          value:
                                                                              6,
                                                                          groupValue:
                                                                              selectedValueMobile ?? selectedValue,
                                                                          onChanged:
                                                                              (value) {
                                                                            setState(() {
                                                                              selectedValueMobile = value;
                                                                              selectedValue = value;
                                                                            });
                                                                            collectionPageProviderAction.resetToInitialList();
                                                                            collectionPageProviderAction.sortProductsByPriceRange(40000,
                                                                                100000000000);
                                                                            context.pop();
                                                                          },
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    const Gap(
                                                                        10),
                                                                    const Divider(
                                                                      color: Colors
                                                                          .grey,
                                                                      thickness:
                                                                          1,
                                                                    ),
                                                                    ListTile(
                                                                      title:
                                                                          const Text(
                                                                        'Rating',
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ).tr(),
                                                                      trailing: rateValue ==
                                                                              null
                                                                          ? null
                                                                          : TextButton(
                                                                              child: const Text(
                                                                                'Clear',
                                                                                style: TextStyle(color: Colors.grey),
                                                                              ),
                                                                              onPressed: () {
                                                                                setState(() {
                                                                                  selectedCollectionMobile = null;
                                                                                  selectedCollection = null;
                                                                                  selectedValue = null;
                                                                                  selectedValueMobile = null;
                                                                                  rateValue = null;
                                                                                  rateValueMobile = null;
                                                                                  collectionPageProviderAction.resetToInitialList();
                                                                                  context.pop();
                                                                                });
                                                                              },
                                                                            ),
                                                                    ),
                                                                    ListView(
                                                                      shrinkWrap:
                                                                          true,
                                                                      physics:
                                                                          const ClampingScrollPhysics(),
                                                                      //padding: EdgeInsets.symmetric(vertical:20),
                                                                      children: [
                                                                        RadioListTile(
                                                                          title:
                                                                              const Row(
                                                                            children: [
                                                                              Icon(
                                                                                Icons.star,
                                                                                color: Colors.orange,
                                                                              ),
                                                                              Icon(
                                                                                Icons.star,
                                                                                color: Colors.orange,
                                                                              ),
                                                                              Icon(
                                                                                Icons.star,
                                                                                color: Colors.orange,
                                                                              ),
                                                                              Icon(
                                                                                Icons.star,
                                                                                color: Colors.orange,
                                                                              ),
                                                                              Icon(
                                                                                Icons.star,
                                                                                color: Colors.grey,
                                                                              ),
                                                                              Text(
                                                                                '& Up',
                                                                                style: TextStyle(),
                                                                              )
                                                                            ],
                                                                          ),
                                                                          value:
                                                                              1,
                                                                          groupValue:
                                                                              rateValueMobile ?? rateValue,
                                                                          onChanged:
                                                                              (value) {
                                                                            setState(() {
                                                                              rateValueMobile = value;
                                                                              rateValue = value;
                                                                            });
                                                                            collectionPageProviderAction.resetToInitialList();
                                                                            collectionPageProviderAction.sortAndFilterProductsByRating(4);
                                                                            context.pop();
                                                                          },
                                                                        ),
                                                                        RadioListTile(
                                                                          title:
                                                                              const Row(
                                                                            children: [
                                                                              Icon(
                                                                                Icons.star,
                                                                                color: Colors.orange,
                                                                              ),
                                                                              Icon(
                                                                                Icons.star,
                                                                                color: Colors.orange,
                                                                              ),
                                                                              Icon(
                                                                                Icons.star,
                                                                                color: Colors.orange,
                                                                              ),
                                                                              Icon(
                                                                                Icons.star,
                                                                                color: Colors.grey,
                                                                              ),
                                                                              Icon(
                                                                                Icons.star,
                                                                                color: Colors.grey,
                                                                              ),
                                                                              Text(
                                                                                '& Up',
                                                                                style: TextStyle(),
                                                                              )
                                                                            ],
                                                                          ),
                                                                          value:
                                                                              2,
                                                                          groupValue:
                                                                              rateValueMobile ?? rateValue,
                                                                          onChanged:
                                                                              (value) {
                                                                            setState(() {
                                                                              rateValueMobile = value;
                                                                              rateValue = value;
                                                                            });
                                                                            collectionPageProviderAction.resetToInitialList();
                                                                            collectionPageProviderAction.sortAndFilterProductsByRating(3);
                                                                            context.pop();
                                                                          },
                                                                        ),
                                                                        RadioListTile(
                                                                          title:
                                                                              const Row(
                                                                            children: [
                                                                              Icon(
                                                                                Icons.star,
                                                                                color: Colors.orange,
                                                                              ),
                                                                              Icon(
                                                                                Icons.star,
                                                                                color: Colors.orange,
                                                                              ),
                                                                              Icon(
                                                                                Icons.star,
                                                                                color: Colors.grey,
                                                                              ),
                                                                              Icon(
                                                                                Icons.star,
                                                                                color: Colors.grey,
                                                                              ),
                                                                              Icon(
                                                                                Icons.star,
                                                                                color: Colors.grey,
                                                                              ),
                                                                              Text(
                                                                                '& Up',
                                                                                style: TextStyle(),
                                                                              )
                                                                            ],
                                                                          ),
                                                                          value:
                                                                              3,
                                                                          groupValue:
                                                                              rateValueMobile ?? rateValue,
                                                                          onChanged:
                                                                              (value) {
                                                                            setState(() {
                                                                              rateValueMobile = value;
                                                                              rateValue = value;
                                                                            });
                                                                            collectionPageProviderAction.resetToInitialList();
                                                                            collectionPageProviderAction.sortAndFilterProductsByRating(2);
                                                                            context.pop();
                                                                          },
                                                                        ),
                                                                        RadioListTile(
                                                                          title:
                                                                              const Row(
                                                                            children: [
                                                                              Icon(
                                                                                Icons.star,
                                                                                color: Colors.orange,
                                                                              ),
                                                                              Icon(
                                                                                Icons.star,
                                                                                color: Colors.grey,
                                                                              ),
                                                                              Icon(
                                                                                Icons.star,
                                                                                color: Colors.grey,
                                                                              ),
                                                                              Icon(
                                                                                Icons.star,
                                                                                color: Colors.grey,
                                                                              ),
                                                                              Icon(
                                                                                Icons.star,
                                                                                color: Colors.grey,
                                                                              ),
                                                                              Text(
                                                                                '& Up',
                                                                                style: TextStyle(),
                                                                              )
                                                                            ],
                                                                          ),
                                                                          value:
                                                                              4,
                                                                          groupValue:
                                                                              rateValueMobile ?? rateValue,
                                                                          onChanged:
                                                                              (value) {
                                                                            setState(() {
                                                                              rateValueMobile = value;
                                                                              rateValue = value;
                                                                            });
                                                                            collectionPageProviderAction.resetToInitialList();
                                                                            collectionPageProviderAction.sortAndFilterProductsByRating(1);
                                                                            context.pop();
                                                                          },
                                                                        ),
                                                                        const Gap(
                                                                            10)
                                                                        // Add more RadioListTile widgets as needed
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        });
                                                      });
                                            },
                                            icon: Icon(Icons.filter,
                                                color: AdaptiveTheme.of(context)
                                                            .mode
                                                            .isDark ==
                                                        true
                                                    ? Colors.white
                                                    : Colors.black),
                                            label: Text(
                                              'Filter',
                                              style: TextStyle(
                                                  color:
                                                      AdaptiveTheme.of(context)
                                                                  .mode
                                                                  .isDark ==
                                                              true
                                                          ? Colors.white
                                                          : Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ).tr()),
                                        const Gap(10),
                                        const SizedBox(
                                          height: 20,
                                          child: VerticalDivider(
                                            color: Colors.black,
                                            thickness: 1,
                                            width: 1,
                                            endIndent: 2,
                                            indent: 2,
                                          ),
                                        ),
                                        const Gap(10),
                                        DropdownButtonHideUnderline(
                                            child: DropdownButton2(
                                                isExpanded: true,
                                                dropdownStyleData:
                                                    const DropdownStyleData(
                                                        width: 150),
                                                customButton: const Row(
                                                  children: [
                                                    Icon(
                                                      Icons.sort,
                                                    ),
                                                    SizedBox(
                                                      width: 7,
                                                    ),
                                                    Text(
                                                      'Sort By',
                                                      style: TextStyle(
                                                          //fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    SizedBox(
                                                      width: 4,
                                                    ),
                                                    Icon(
                                                      Icons
                                                          .arrow_drop_down_outlined,
                                                      //  color: Color.fromRGBO(48, 30, 2, 1),
                                                    ),
                                                  ],
                                                ),
                                                items: [
                                                  'Price:Low to High'.tr(),
                                                  'Price:High to Low'.tr(),
                                                  'Product Rating'.tr(),
                                                  // 'Favorites'.tr(),
                                                  // 'Signup'.tr(),
                                                ]
                                                    .map((item) =>
                                                        DropdownMenuItem<
                                                            String>(
                                                          value: item,
                                                          child: Text(
                                                            item,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 11,
                                                              // fontWeight: FontWeight.bold,
                                                              // color:
                                                              //     Colors.black,
                                                            ),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ))
                                                    .toList(),
                                                value: sortBy,
                                                onChanged: (value) {
                                                  setState(
                                                    () {
                                                      if (value ==
                                                          'Price:Low to High') {
                                                        collectionPageProviderAction
                                                            .sortProductsFromLowToHigh();
                                                      } else if (value ==
                                                          'Price:High to Low') {
                                                        collectionPageProviderAction
                                                            .sortProductsFromHighToLow();
                                                      } else {
                                                        collectionPageProviderAction
                                                            .sortProductsRatingFromHighToLow();
                                                      }
                                                    },
                                                  );
                                                })),
                                      ],
                                    ),
                                    const Divider(
                                      color: Colors.grey,
                                      thickness: 1,
                                    ),
                                    collectionPageProvider.products.isEmpty
                                        ? Center(
                                            child: Column(children: [
                                              Icon(
                                                Icons.remove_shopping_cart,
                                                color: appColor,
                                                size: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    3,
                                              ),
                                              const Gap(10),
                                              const Text('No Product Was Found')
                                            ]),
                                          )
                                        : GridView.builder(
                                            physics:
                                                const ClampingScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: collectionPageProvider
                                                .products.length,
                                            itemBuilder: (context, index) {
                                              ProductsModel productsModel =
                                                  collectionPageProvider
                                                      .products[index];
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                child: InkWell(
                                                    onTap: () {
                                                      context.go(
                                                          '/restaurant/product-detail/${productsModel.uid}');
                                                    },
                                                    child:
                                                        RestaurantEachProductWidget(
                                                            index: index,
                                                            productsModel:
                                                                productsModel)),
                                              );
                                            },
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                                    childAspectRatio: 0.8,
                                                    crossAxisCount:
                                                        MediaQuery.of(context)
                                                                    .size
                                                                    .width >=
                                                                1100
                                                            ? 4
                                                            : 2,
                                                    mainAxisSpacing: 10,
                                                    crossAxisSpacing: 10),
                                          ),
                                  ],
                                ),
                              ),
                      ],
                    // ),
                  ),
            const Gap(20),
            const FooterWidget()
          ]),
        ));
  }
}
