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
import 'package:user_web/model/sub_categories_model.dart';
// import 'package:user_web/widgets/cat_image_widget.dart';
import 'package:user_web/widgets/footer_widget.dart';
// ignore: library_prefixes
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as modalSheet;
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:user_web/constant.dart';
import '../../providers/restuarant_providers/restaurant_categories_page_provider.dart';
import '../../providers/currency_provider.dart';
import '../../providers/restuarant_providers/restaurant_category_providers.dart';
import '../../providers/selected_provider.dart';
import '../../widgets/cat_image_widget.dart';
import '../../widgets/restuarant_module_widget/restaurant_each_product_widget.dart';
import '../../widgets/restuarant_module_widget/restaurant_product_widget_main.dart';

class RestaurantProductsByCategory extends ConsumerStatefulWidget {
  final String category;
  const RestaurantProductsByCategory({super.key, required this.category});

  @override
  ConsumerState<RestaurantProductsByCategory> createState() =>
      _RestaurantProductsByCategoryState();
}

class _RestaurantProductsByCategoryState
    extends ConsumerState<RestaurantProductsByCategory> {
  String? sortBy;
  int? selectedValue;
  int? rateValue;

  @override
  Widget build(BuildContext context) {
    final module = ref.watch(selectedVendorModuleProvider) ?? 'Restaurant';

    var currency = ref.watch(currencySymbolProvider).value;
    var catPageProvider =
        ref.watch(CategoriesPageRestaurantNotifierProvider(widget.category));
    var catPageProviderAction = ref.read(
        CategoriesPageRestaurantNotifierProvider(widget.category).notifier);

    final categoriesAsync = ref.watch(
      getCategoriesByModelRestaurantProvider(module),
    );

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
                  url: catPageProvider.imageUrl,
                  boxFit: 'cover', // since you had BoxFit.cover
                ),
              ),
            ),
            const Gap(10),
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
                          style: TextStyle(fontSize: 12,fontFamily: 'Nunito'),
                        ).tr(),
                      ),
                      Text(
                        '/ ${widget.category}',
                        style: const TextStyle(fontSize: 12,fontFamily: 'Nunito'),
                      ).tr(),
                    ],
                  ),
                ),
              ),
            if (MediaQuery.of(context).size.width >= 1100) const Gap(10),
            MediaQuery.of(context).size.width >= 1100
                ? Padding(
                    padding: MediaQuery.of(context).size.width >= 1100
                        ? const EdgeInsets.only(left: 40, right: 50)
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
                              color:
                                  AdaptiveTheme.of(context).mode.isDark == true
                                      ? Colors.black87
                                      : Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                // child: SingleChildScrollView(
                                //   physics: const ClampingScrollPhysics(),
                                  child: Column(
                                    children: [
                                      ListTile(
                                        title: const Text(
                                          'Collections',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,fontFamily: 'Nunito'),
                                        ).tr(),
                                      ),
                                      catPageProvider.isLoaded == true
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
                                              itemCount: catPageProvider
                                                  .collection.length,
                                              itemBuilder: (context, index) {
                                                SubCategoriesModel
                                                    subCategoriesModel =
                                                    catPageProvider
                                                        .collection[index];
                                                return ListTile(
                                                  onTap: () {
                                                    context.go(
                                                        '/restaurant/collection/${subCategoriesModel.name}');
                                                  },
                                                  title: Text(
                                                    subCategoriesModel.name,
                                                    style: const TextStyle(
                                                        fontSize: 11,fontFamily: 'Nunito'),

                                                    // leading: const Icon(Icons.card_travel),
                                                    // trailing: const Icon(Icons.chevron_right),
                                                  ),
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
                                              fontWeight: FontWeight.bold,fontFamily: 'Nunito'),
                                        ).tr(),
                                        trailing: selectedValue == null
                                            ? null
                                            : TextButton(
                                                child: const Text(
                                                  'Clear',
                                                  style: TextStyle(
                                                      color: Colors.grey,fontFamily: 'Nunito'),
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    selectedValue = null;
                                                    catPageProviderAction
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
                                                  const TextStyle(fontSize: 11,fontFamily: 'Nunito'),
                                            ),
                                            value: 1,
                                            groupValue: selectedValue,
                                            onChanged: (value) {
                                              setState(() {
                                                selectedValue = value;
                                              });
                                              catPageProviderAction
                                                  .resetToInitialList();
                                              catPageProviderAction
                                                  .sortProductsByPriceRange(
                                                      1, 2000);
                                            },
                                          ),
                                          RadioListTile(
                                            title: Text(
                                                '${currency}2,000 - ${currency}5,000',
                                                style: const TextStyle(
                                                    fontSize: 11,fontFamily: 'Nunito')),
                                            value: 2,
                                            groupValue: selectedValue,
                                            onChanged: (value) {
                                              setState(() {
                                                selectedValue = value;
                                              });
                                              catPageProviderAction
                                                  .resetToInitialList();
                                              catPageProviderAction
                                                  .sortProductsByPriceRange(
                                                      2000, 5000);
                                            },
                                          ),
                                          RadioListTile(
                                            title: Text(
                                                '${currency}5,000 - ${currency}10,000',
                                                style: const TextStyle(
                                                    fontSize: 11,fontFamily: 'Nunito')),
                                            value: 3,
                                            groupValue: selectedValue,
                                            onChanged: (value) {
                                              setState(() {
                                                selectedValue = value;
                                              });
                                              catPageProviderAction
                                                  .resetToInitialList();
                                              catPageProviderAction
                                                  .sortProductsByPriceRange(
                                                      5000, 10000);
                                            },
                                          ),
                                          RadioListTile(
                                            title: Text(
                                                '${currency}10,000 - ${currency}20,000',
                                                style: const TextStyle(
                                                    fontSize: 11,fontFamily: 'Nunito')),
                                            value: 4,
                                            groupValue: selectedValue,
                                            onChanged: (value) {
                                              setState(() {
                                                selectedValue = value;
                                              });
                                              catPageProviderAction
                                                  .resetToInitialList();
                                              catPageProviderAction
                                                  .sortProductsByPriceRange(
                                                      10000, 20000);
                                            },
                                          ),
                                          RadioListTile(
                                            title: Text(
                                                '${currency}20,000 - ${currency}40,000',
                                                style: const TextStyle(
                                                    fontSize: 11,fontFamily: 'Nunito')),
                                            value: 5,
                                            groupValue: selectedValue,
                                            onChanged: (value) {
                                              setState(() {
                                                selectedValue = value;
                                              });
                                              catPageProviderAction
                                                  .resetToInitialList();
                                              catPageProviderAction
                                                  .sortProductsByPriceRange(
                                                      20000, 40000);
                                            },
                                          ),
                                          RadioListTile(
                                            title: Text(
                                                'Above ${currency}40,000',
                                                style: const TextStyle(
                                                    fontSize: 11,fontFamily: 'Nunito')),
                                            value: 6,
                                            groupValue: selectedValue,
                                            onChanged: (value) {
                                              setState(() {
                                                selectedValue = value;
                                              });
                                              catPageProviderAction
                                                  .resetToInitialList();
                                              catPageProviderAction
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
                                              fontWeight: FontWeight.bold,fontFamily: 'Nunito'),
                                        ).tr(),
                                        trailing: rateValue == null
                                            ? null
                                            : TextButton(
                                                child: const Text(
                                                  'Clear',
                                                  style: TextStyle(
                                                      color: Colors.grey,fontFamily: 'Nunito'),
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    rateValue = null;
                                                    catPageProviderAction
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
                                                      TextStyle(fontSize: 12,fontFamily: 'Nunito'),
                                                )
                                              ],
                                            ),
                                            value: 1,
                                            groupValue: rateValue,
                                            onChanged: (value) {
                                              setState(() {
                                                rateValue = value;
                                              });
                                              catPageProviderAction
                                                  .resetToInitialList();
                                              catPageProviderAction
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
                                              catPageProviderAction
                                                  .resetToInitialList();
                                              catPageProviderAction
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
                                                      TextStyle(fontSize: 12,fontFamily: 'Nunito'),
                                                )
                                              ],
                                            ),
                                            value: 3,
                                            groupValue: rateValue,
                                            onChanged: (value) {
                                              setState(() {
                                                rateValue = value;
                                              });
                                              catPageProviderAction
                                                  .resetToInitialList();
                                              catPageProviderAction
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
                                                      TextStyle(fontSize: 12,fontFamily: 'Nunito'),
                                                )
                                              ],
                                            ),
                                            value: 4,
                                            groupValue: rateValue,
                                            onChanged: (value) {
                                              setState(() {
                                                rateValue = value;
                                              });
                                              catPageProviderAction
                                                  .resetToInitialList();
                                              catPageProviderAction
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
                                // ),
                              ),
                            )),
                        const Gap(10),
                        Expanded(
                          flex: 7,
                          child: catPageProvider.isLoaded == true
                              ? GridView.builder(
                                physics: const ClampingScrollPhysics(),
                                  shrinkWrap: true,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: MediaQuery.of(context)
                                                      .size
                                                      .width >=
                                                  1100
                                              ? 4
                                              : 2,
                                          crossAxisSpacing: 8.0,
                                          mainAxisSpacing: 8.0,
                                          childAspectRatio: 0.7),
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
                                  // child: SingleChildScrollView(
                                  //   physics: const ClampingScrollPhysics(),
                                    child: Column(
                                      children: [
                                        const Gap(10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${catPageProvider.products.length} Products Found',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,fontFamily: 'Nunito'),
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
                                                              fontFamily: 'Nunito',
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
                                                                      fontFamily: 'Nunito',
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
                                                            catPageProviderAction
                                                                .sortProductsFromLowToHigh();
                                                          } else if (value ==
                                                              'Price:High to Low') {
                                                            catPageProviderAction
                                                                .sortProductsFromHighToLow();
                                                          } else {
                                                            catPageProviderAction
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
                                        catPageProvider.products.isEmpty
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
                                                      'No Product Was Found',style: TextStyle( fontFamily: 'Nunito',),)
                                                ]),
                                              )
                                            : AnimationLimiter(
                                                child: GridView.builder(
                                                  physics:
                                                      const BouncingScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemCount: catPageProvider
                                                      .products.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    ProductsModel
                                                        productsModel =
                                                        catPageProvider
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
                                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                                  // ),
                                ),
                        ),
                        const Gap(8)
                      ],
                    ),
                  )
                ///////////////////////////////////////////// Mobile View ////////////////////////////////////////////////////
                :
              //   SingleChildScrollView(
              // physics: const ClampingScrollPhysics(),
                  Column(
                      children: [
                        catPageProvider.isLoaded == true
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
                                        childAspectRatio: 0.8),
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
                                                        return StatefulBuilder(
                                                            builder: (context,
                                                                setState) {
                                                          return Scaffold(
                                                            body: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              // child:
                                                              //     SingleChildScrollView(
                                                              //       physics: const ClampingScrollPhysics(),
                                                                child: Column(
                                                                  children: [
                                                                    ListTile(
                                                                      title:
                                                                          const Text(
                                                                        'Collections',
                                                                        style: TextStyle(
                                                                          fontFamily: 'Nunito',
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ).tr(),
                                                                      trailing: TextButton(
                                                                          onPressed: () {
                                                                            context.pop();
                                                                          },
                                                                          child: Text(
                                                                            'Close',
                                                                            style:
                                                                                TextStyle(color: AdaptiveTheme.of(context).mode.isDark == true ? Colors.white : Colors.black, fontFamily: 'Nunito',),
                                                                          ).tr()),
                                                                    ),
                                                                    catPageProvider.isLoaded ==
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
                                                                            // itemExtent: 45.0,
                                                                            itemCount: catPageProvider.collection.length,
                                                                            itemBuilder: (context, index) {
                                                                              SubCategoriesModel subCategoriesModel = catPageProvider.collection[index];
                                                                              return ListTile(
                                                                                onTap: () {
                                                                                  context.go('/restaurant/collection/${subCategoriesModel.name}');
                                                                                },
                                                                                // leading: SizedBox(height: 50, width: 50, child: ClipRRect(borderRadius: BorderRadius.circular(5), child: CatImageWidget(url: subCategoriesModel.image, boxFit: 'cover'))),
                                                                                title: Text(
                                                                                  subCategoriesModel.name,
                                                                                  style: const TextStyle( fontFamily: 'Nunito',),

                                                                                  // leading: const Icon(Icons.card_travel),
                                                                                ),
                                                                                trailing: const Icon(Icons.chevron_right),
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
                                                                                FontWeight.bold, fontFamily: 'Nunito',),
                                                                      ).tr(),
                                                                      trailing: selectedValue ==
                                                                              null
                                                                          ? null
                                                                          : TextButton(
                                                                              child: const Text(
                                                                                'Clear',
                                                                                style: TextStyle(color: Colors.grey, fontFamily: 'Nunito',),
                                                                              ),
                                                                              onPressed: () {
                                                                                setState(() {
                                                                                  selectedValueMobile = null;
                                                                                  selectedValue = null;
                                                                                  catPageProviderAction.resetToInitialList();
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
                                                                      // itemExtent:
                                                                      //     35.0,
                                                                      //padding: EdgeInsets.symmetric(vertical:20),
                                                                      children: [
                                                                        RadioListTile(
                                                                          title:
                                                                              Text(
                                                                            'Under ${currency}2,000',
                                                                            style:
                                                                                const TextStyle( fontFamily: 'Nunito',),
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
                                                                            catPageProviderAction.resetToInitialList();
                                                                            catPageProviderAction.sortProductsByPriceRange(1,
                                                                                2000);
                                                                            context.pop();
                                                                          },
                                                                        ),
                                                                        RadioListTile(
                                                                          title: Text(
                                                                              '${currency}2,000 - ${currency}5,000',
                                                                              style: const TextStyle( fontFamily: 'Nunito',)),
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
                                                                            catPageProviderAction.resetToInitialList();
                                                                            catPageProviderAction.sortProductsByPriceRange(2000,
                                                                                5000);
                                                                            context.pop();
                                                                          },
                                                                        ),
                                                                        RadioListTile(
                                                                          title: Text(
                                                                              '${currency}5,000 - ${currency}10,000',
                                                                              style: const TextStyle( fontFamily: 'Nunito',)),
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
                                                                            catPageProviderAction.resetToInitialList();
                                                                            catPageProviderAction.sortProductsByPriceRange(5000,
                                                                                10000);
                                                                            context.pop();
                                                                          },
                                                                        ),
                                                                        RadioListTile(
                                                                          title: Text(
                                                                              '${currency}10,000 - ${currency}20,000',
                                                                              style: const TextStyle( fontFamily: 'Nunito',)),
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
                                                                            catPageProviderAction.resetToInitialList();
                                                                            catPageProviderAction.sortProductsByPriceRange(10000,
                                                                                20000);
                                                                            context.pop();
                                                                          },
                                                                        ),
                                                                        RadioListTile(
                                                                          title: Text(
                                                                              '${currency}20,000 - ${currency}40,000',
                                                                              style: const TextStyle( fontFamily: 'Nunito',)),
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
                                                                            catPageProviderAction.resetToInitialList();
                                                                            catPageProviderAction.sortProductsByPriceRange(20000,
                                                                                40000);
                                                                            context.pop();
                                                                          },
                                                                        ),
                                                                        RadioListTile(
                                                                          title: Text(
                                                                              'Above ${currency}40,000',
                                                                              style: const TextStyle( fontFamily: 'Nunito',)),
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
                                                                            catPageProviderAction.resetToInitialList();
                                                                            catPageProviderAction.sortProductsByPriceRange(40000,
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
                                                                            fontFamily: 'Nunito',
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ).tr(),
                                                                      trailing: rateValue ==
                                                                              null
                                                                          ? null
                                                                          : TextButton(
                                                                              child: const Text(
                                                                                'Clear',
                                                                                style: TextStyle(color: Colors.grey, fontFamily: 'Nunito',),
                                                                              ),
                                                                              onPressed: () {
                                                                                setState(() {
                                                                                  rateValueMobile = null;
                                                                                  rateValue = null;
                                                                                  catPageProviderAction.resetToInitialList();
                                                                                  context.pop();
                                                                                });
                                                                              },
                                                                            ),
                                                                    ),
                                                                    ListView(
                                                                      // itemExtent:
                                                                      //     35.0,
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
                                                                                style: TextStyle( fontFamily: 'Nunito',),
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
                                                                            catPageProviderAction.resetToInitialList();
                                                                            catPageProviderAction.sortAndFilterProductsByRating(4);
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
                                                                                style: TextStyle( fontFamily: 'Nunito',),
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
                                                                            catPageProviderAction.resetToInitialList();
                                                                            catPageProviderAction.sortAndFilterProductsByRating(3);
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
                                                                                style: TextStyle( fontFamily: 'Nunito',),
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
                                                                            catPageProviderAction.resetToInitialList();
                                                                            catPageProviderAction.sortAndFilterProductsByRating(2);
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
                                                                                style: TextStyle( fontFamily: 'Nunito',),
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
                                                                            catPageProviderAction.resetToInitialList();
                                                                            catPageProviderAction.sortAndFilterProductsByRating(1);
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
                                                              // ),
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
                                                  fontFamily: 'Nunito',
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
                                                          fontFamily: 'Nunito',
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
                                                              // color: Colors.black,
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
                                                        catPageProviderAction
                                                            .sortProductsFromLowToHigh();
                                                      } else if (value ==
                                                          'Price:High to Low') {
                                                        catPageProviderAction
                                                            .sortProductsFromHighToLow();
                                                      } else {
                                                        catPageProviderAction
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
                                    catPageProvider.products.isEmpty
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
                                              const Text('No Product Was Found',style: TextStyle( fontFamily: 'Nunito',),)
                                            ]),
                                          )
                                        : AnimationLimiter(
                                            child: GridView.builder(
                                              physics:
                                                  const ClampingScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: catPageProvider
                                                  .products.length,
                                              itemBuilder: (context, index) {
                                                ProductsModel productsModel =
                                                    catPageProvider
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
                                                                .all(8),
                                                        child: InkWell(
                                                            onTap: () {
                                                              context.go(
                                                                  '/restaurant/product-detail/${productsModel.uid}');
                                                            },
                                                            child: RestaurantEachProductWidget(
                                                                index: index,
                                                                productsModel:
                                                                    productsModel)
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                              gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                      childAspectRatio:MediaQuery.of(context).size.width >= 1100 ? 0.8 : 0.7,
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
                                          ),
                                  ],
                                ),
                              ),
                      ],
                    ),
                  // ),
            const Gap(20),
            const FooterWidget()
          ]),
        ));
  }
}
