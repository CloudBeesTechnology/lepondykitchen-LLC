// ignore_for_file: avoid_print
import 'dart:convert';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_web/model/cart_model.dart';
import 'package:user_web/model/formatter.dart';
import 'package:user_web/widgets/cat_image_widget.dart';
import 'package:user_web/widgets/footer_widget.dart';
import 'package:user_web/widgets/review_widget.dart';
import 'package:user_web/widgets/share_to_social_media_widget.dart';
import 'package:user_web/constant.dart';
import '../providers/currency_provider.dart';
import '../providers/product_detail_provider.dart';
import '../providers/restuarant_providers/restaurant_cart_storage_provider.dart';
import '../providers/restuarant_providers/restaurant_favorite_storage_provider.dart';
import '../providers/vendors_list_home_provider.dart';
import 'restuarant_module_widget/restaurant_similar_items_widget.dart';

class ProductDetailMobileViewWidget extends ConsumerStatefulWidget {
  final String productID;
  const ProductDetailMobileViewWidget({super.key, required this.productID});

  @override
  ConsumerState<ProductDetailMobileViewWidget> createState() =>
      _ProductDetailMobileViewWidgetState();
}

class _ProductDetailMobileViewWidgetState
    extends ConsumerState<ProductDetailMobileViewWidget> {
  final QuillController _controllerDetail = QuillController.basic();
  int current = 0;
  num quantity = 1;
  List<String> images = [];
  int selectedValue = 1;
  num selectedPrice = 0;
  num price = 0;
  int selectedTab = 1;
  String selectedProduct = '';
  final CarouselSliderController _controller = CarouselSliderController();
  String collection = '';
  String selectedExtra1 = '';
  num? selectedExtraPrice1;
  String selectedExtra2 = '';
  num? selectedExtraPrice2;
  String selectedExtra3 = '';
  num? selectedExtraPrice3;
  String selectedExtra4 = '';
  num? selectedExtraPrice4;
  String selectedExtra5 = '';
  num? selectedExtraPrice5;
  bool isSelectedExtra1 = false;
  bool isSelectedExtra2 = false;
  bool isSelectedExtra3 = false;
  bool isSelectedExtra4 = false;
  bool isSelectedExtra5 = false;

  getSelectedExtra1(num price1) {
    if (isSelectedExtra1 == true) {
      return price1 * quantity;
    } else {
      return 0;
    }
  }

  getSelectedExtra2(num price2) {
    if (isSelectedExtra2 == true) {
      return price2 * quantity;
    } else {
      return 0;
    }
  }

  getSelectedExtra3(num price3) {
    if (isSelectedExtra3 == true) {
      return price3 * quantity;
    } else {
      return 0;
    }
  }

  getSelectedExtra4(num price4) {
    if (isSelectedExtra4 == true) {
      return price4 * quantity;
    } else {
      return 0;
    }
  }

  getSelectedExtra5(num price5) {
    if (isSelectedExtra5 == true) {
      return price5 * quantity;
    } else {
      return 0;
    }
  }

  getCollection() {
    FirebaseFirestore.instance
        .collection('Products')
        .doc(widget.productID)
        .get()
        .then((v) {
      if (v.exists) {
        setState(() {
          collection = 'Products';
        });
      } else {
        FirebaseFirestore.instance
            .collection('Flash Sales')
            .doc(widget.productID)
            .get()
            .then((v) {
          if (v.exists) {
            setState(() {
              collection = 'Flash Sales';
            });
          } else {
            setState(() {
              collection = 'Hot Deals';
            });
          }
        });
      }
    });
  }

  @override
  void initState() {
    getCollection();
    super.initState();
  }

  //newly added
  @override
  void dispose() {
    _controllerDetail.dispose();
    _scrollController.dispose();
  // If needed
    super.dispose();
  }


    //new changes
  @override
  void didUpdateWidget(covariant ProductDetailMobileViewWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) return;

      try {
        _scrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      } catch (e) {
        debugPrint("Scroll failed: $e");
      }
    });

  }


  final ScrollController _scrollController = ScrollController();


  @override
  Widget build(BuildContext context) {
    final productsModel =
        ref.watch(productDetailProviderProvider(widget.productID)).valueOrNull;
    if (selectedProduct.isEmpty && productsModel != null) {
      selectedProduct = productsModel.unitname1;
    }

    final currency = ref.watch(currencySymbolProvider).value;

    //////////////// Restaurant Providers ////////////////////////////
    final cartStorageRestaurant =
        ref.read(cartStorageRestaurantProviderProvider.notifier);
    final cartStorageDataRestaurant =
        ref.watch(cartStorageRestaurantProviderProvider);
    final favoriteStorageDataRestaurant =
        ref.watch(favoriteStorageRestaurantProviderProvider);
    final favoriteStorageRestaurant =
        ref.read(favoriteStorageRestaurantProviderProvider.notifier);

    if (productsModel != null) {
      _controllerDetail.document =
          Document.fromJson(jsonDecode(productsModel.description));
      _controllerDetail.readOnly = true;
    }

    if (productsModel != null) {
      List<String> imagesValue = [
        productsModel.image1,
        productsModel.image2 == ''
            ? productsModel.image1
            : productsModel.image2,
        productsModel.image3 == ''
            ? productsModel.image1
            : productsModel.image3,
      ];
      images = imagesValue;
    }
    final vendorStatus = productsModel == null
        ? false
        : ref.watch(getVendorOpenStatusProvider(productsModel.vendorId)).value;

    return Scaffold(
      backgroundColor: const Color(0xFFDF7EB).withOpacity(1.0),
      body: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              // if (productsModel == null) const Gap(10),
              productsModel == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: double.infinity, // Set the width as needed
                              height: MediaQuery.of(context).size.height /
                                  2.5, // Set the height as needed
                              color: Colors.grey, // Set the color as needed
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: 200, // Set the width as needed
                              height: 15, // Set the height as needed
                              color: Colors.grey, // Set the color as needed
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: 300, // Set the width as needed
                              height: 14, // Set the height as needed
                              color: Colors.grey, // Set the color as needed
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: 400, // Set the width as needed
                              height: 15, // Set the height as needed
                              color: Colors.grey, // Set the color as needed
                            ),
                          ),
                        ),
                      ],
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // const Gap(30),
                          SizedBox(
                            width: double.infinity,
                            //  height: 500,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Gap(10),
                                Column(
                                  children: [
                                    const Gap(10),
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: CarouselSlider.builder(
                                              carouselController: _controller,
                                              itemCount: images.length,
                                              itemBuilder: (_, index,
                                                  int pageViewIndex) {
                                                return CatImageWidget(
                                                    url: images[index],
                                                    boxFit: 'cover');
                                              },
                                              options: CarouselOptions(
                                                  onPageChanged:
                                                      (index, reason) {
                                                    setState(() {
                                                      current = index;
                                                    });
                                                  },
                                                  enlargeCenterPage: true,
                                                  aspectRatio: 0.8,
                                                  autoPlay: true,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      2.5)),
                                        ),
                                        Align(
                                            alignment: Alignment.centerLeft,
                                            child: IconButton(
                                              iconSize: 40,
                                              onPressed: () {
                                                _controller.previousPage();
                                              },
                                              icon: Container(
                                                  height: 50,
                                                  width: 50,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey
                                                        .withValues(alpha: 0.4),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: const Center(
                                                      child: Icon(
                                                          Icons.chevron_left))),
                                              color: Colors.white,
                                            )),
                                        Align(
                                            alignment: Alignment.centerRight,
                                            child: IconButton(
                                              iconSize: 40,
                                              onPressed: () {
                                                _controller.nextPage();
                                              },
                                              icon: Container(
                                                  height: 50,
                                                  width: 50,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey
                                                        .withValues(alpha: 0.4),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: const Center(
                                                      child: Icon(Icons
                                                          .chevron_right))),
                                              color: Colors.white,
                                            )),
                                      ],
                                    ),
                                  ],
                                ),
                                const Gap(20),
                                SizedBox(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Gap(20),
                                      Text(
                                        productsModel.name,
                                        style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      if (productsModel.module == 'Pharmacy')
                                        if (productsModel.isPrescription ==
                                            true)
                                          Text(
                                            'Prescription is required',
                                            style: TextStyle(
                                              fontSize: 12.r,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                      // const Gap(20),
                                      const Gap(10),
                                      const Divider(
                                          color: Color.fromARGB(
                                              255, 243, 236, 236)),
                                      const Gap(10),
                                      Row(
                                        children: [
                                          Text(
                                            '$currency${Formatter().converter(productsModel.unitPrice1!.toDouble())}',
                                            style: const TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const Gap(5),
                                          Text(
                                            '$currency${Formatter().converter(productsModel.unitOldPrice1!.toDouble())}',
                                            style: const TextStyle(
                                                fontSize: 18,
                                                color: Colors.grey,
                                                decoration:
                                                    TextDecoration.lineThrough),
                                          ),
                                          const Gap(5),
                                          productsModel.percantageDiscount == 0
                                              ? const SizedBox.shrink()
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 8),
                                                  child: Container(
                                                      color: appColor,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(3.0),
                                                        child: Text(
                                                          '-${productsModel.percantageDiscount}%',
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 10,
                                                          ),
                                                        ),
                                                      )),
                                                )
                                        ],
                                      ),
                                      const Gap(5),
                                      Text(
                                        'Unit: ${productsModel.unitname1}',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      const Gap(5),
                                      Row(
                                        children: [
                                          RatingBarIndicator(
                                            rating: productsModel.totalRating ==
                                                    0
                                                ? 0
                                                : productsModel.totalRating!
                                                        .toDouble() /
                                                    productsModel
                                                        .totalNumberOfUserRating!
                                                        .toDouble(),
                                            itemBuilder: (context, index) =>
                                                const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            itemCount: 5,
                                            itemSize: 12.0,
                                            direction: Axis.horizontal,
                                          ),
                                          Text(
                                            '(${productsModel.totalNumberOfUserRating})',
                                            style:
                                                const TextStyle(fontSize: 12),
                                          )
                                        ],
                                      ),
                                      const Gap(10),
                                      const Divider(
                                          color: Color.fromARGB(
                                              255, 243, 236, 236)),
                                      const Gap(10),
                                      const Text(
                                        'Variants:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ).tr(),
                                      const Gap(10),
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border: Border.all(
                                                color: const Color.fromARGB(
                                                    255, 214, 214, 214),
                                                width: 0.5)),
                                        child: RadioListTile(
                                            title:
                                                Text(productsModel.unitname1),
                                            secondary: RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        '$currency${Formatter().converter(productsModel.unitPrice1!.toDouble())} ',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: AdaptiveTheme.of(
                                                                        context)
                                                                    .mode
                                                                    .isDark ==
                                                                true
                                                            ? Colors.white
                                                            : Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  TextSpan(
                                                      text:
                                                          '$currency${Formatter().converter(productsModel.unitOldPrice1!.toDouble())}',
                                                      style: TextStyle(
                                                          color: AdaptiveTheme.of(
                                                                          context)
                                                                      .mode
                                                                      .isDark ==
                                                                  true
                                                              ? Colors.white
                                                              : Colors.black,
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough))
                                                ],
                                              ),
                                            ),
                                            value: 1,
                                            groupValue: selectedValue,
                                            onChanged: (v) {
                                              setState(() {
                                                selectedValue = v!;
                                                selectedPrice =
                                                    productsModel.unitPrice1!;
                                                selectedProduct =
                                                    productsModel.unitname1;
                                              });
                                            }),
                                      ),
                                      if (productsModel.unitname2.isNotEmpty)
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              border: Border.all(
                                                  color: const Color.fromARGB(
                                                      255, 214, 214, 214),
                                                  width: 0.5)),
                                          child: RadioListTile(
                                              title:
                                                  Text(productsModel.unitname2),
                                              secondary: RichText(
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          '$currency${Formatter().converter(productsModel.unitPrice2!.toDouble())} ',
                                                      style: TextStyle(
                                                          color: AdaptiveTheme.of(
                                                                          context)
                                                                      .mode
                                                                      .isDark ==
                                                                  true
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    TextSpan(
                                                        text:
                                                            '$currency${Formatter().converter(productsModel.unitOldPrice2!.toDouble())}',
                                                        style: TextStyle(
                                                            color: AdaptiveTheme.of(
                                                                            context)
                                                                        .mode
                                                                        .isDark ==
                                                                    true
                                                                ? Colors.white
                                                                : Colors.black,
                                                            decoration:
                                                                TextDecoration
                                                                    .lineThrough))
                                                  ],
                                                ),
                                              ),
                                              value: 2,
                                              groupValue: selectedValue,
                                              onChanged: (v) {
                                                setState(() {
                                                  selectedValue = v!;
                                                  selectedPrice =
                                                      productsModel.unitPrice2!;
                                                  selectedProduct =
                                                      productsModel.unitname2;
                                                });
                                              }),
                                        ),
                                      if (productsModel.unitname3.isNotEmpty)
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              border: Border.all(
                                                  color: const Color.fromARGB(
                                                      255, 214, 214, 214),
                                                  width: 0.5)),
                                          child: RadioListTile(
                                              title:
                                                  Text(productsModel.unitname3),
                                              secondary: RichText(
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          '$currency${Formatter().converter(productsModel.unitPrice3!.toDouble())} ',
                                                      style: TextStyle(
                                                          color: AdaptiveTheme.of(
                                                                          context)
                                                                      .mode
                                                                      .isDark ==
                                                                  true
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    TextSpan(
                                                        text:
                                                            '$currency${Formatter().converter(productsModel.unitOldPrice3!.toDouble())}',
                                                        style: TextStyle(
                                                            color: AdaptiveTheme.of(
                                                                            context)
                                                                        .mode
                                                                        .isDark ==
                                                                    true
                                                                ? Colors.white
                                                                : Colors.black,
                                                            decoration:
                                                                TextDecoration
                                                                    .lineThrough))
                                                  ],
                                                ),
                                              ),
                                              value: 3,
                                              groupValue: selectedValue,
                                              onChanged: (v) {
                                                setState(() {
                                                  selectedValue = v!;
                                                  selectedPrice =
                                                      productsModel.unitPrice3!;
                                                  selectedProduct =
                                                      productsModel.unitname3;
                                                });
                                              }),
                                        ),
                                      if (productsModel.unitname4.isNotEmpty)
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              border: Border.all(
                                                  color: const Color.fromARGB(
                                                      255, 214, 214, 214),
                                                  width: 0.5)),
                                          child: RadioListTile(
                                              title:
                                                  Text(productsModel.unitname4),
                                              secondary: RichText(
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          '$currency${Formatter().converter(productsModel.unitPrice4!.toDouble())} ',
                                                      style: TextStyle(
                                                          color: AdaptiveTheme.of(
                                                                          context)
                                                                      .mode
                                                                      .isDark ==
                                                                  true
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    TextSpan(
                                                        text:
                                                            '$currency${Formatter().converter(productsModel.unitOldPrice4!.toDouble())}',
                                                        style: TextStyle(
                                                            color: AdaptiveTheme.of(
                                                                            context)
                                                                        .mode
                                                                        .isDark ==
                                                                    true
                                                                ? Colors.white
                                                                : Colors.black,
                                                            decoration:
                                                                TextDecoration
                                                                    .lineThrough))
                                                  ],
                                                ),
                                              ),
                                              value: 4,
                                              groupValue: selectedValue,
                                              onChanged: (v) {
                                                setState(() {
                                                  selectedValue = v!;
                                                  selectedPrice =
                                                      productsModel.unitPrice4!;
                                                  selectedProduct =
                                                      productsModel.unitname4;
                                                });
                                              }),
                                        ),
                                      if (productsModel.unitname5.isNotEmpty)
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              border: Border.all(
                                                  color: const Color.fromARGB(
                                                      255, 214, 214, 214),
                                                  width: 0.5)),
                                          child: RadioListTile(
                                              title:
                                                  Text(productsModel.unitname5),
                                              secondary: RichText(
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          '$currency${Formatter().converter(productsModel.unitPrice5!.toDouble())} ',
                                                      style: TextStyle(
                                                          color: AdaptiveTheme.of(
                                                                          context)
                                                                      .mode
                                                                      .isDark ==
                                                                  true
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    TextSpan(
                                                        text:
                                                            '$currency${Formatter().converter(productsModel.unitOldPrice5!.toDouble())}',
                                                        style: TextStyle(
                                                            color: AdaptiveTheme.of(
                                                                            context)
                                                                        .mode
                                                                        .isDark ==
                                                                    true
                                                                ? Colors.white
                                                                : Colors.black,
                                                            decoration:
                                                                TextDecoration
                                                                    .lineThrough))
                                                  ],
                                                ),
                                              ),
                                              value: 5,
                                              groupValue: selectedValue,
                                              onChanged: (v) {
                                                setState(() {
                                                  selectedValue = v!;
                                                  selectedPrice =
                                                      productsModel.unitPrice5!;
                                                  selectedProduct =
                                                      productsModel.unitname5;
                                                });
                                              }),
                                        ),
                                      if (productsModel.unitname6.isNotEmpty)
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              border: Border.all(
                                                  color: const Color.fromARGB(
                                                      255, 214, 214, 214),
                                                  width: 0.5)),
                                          child: RadioListTile(
                                              title:
                                                  Text(productsModel.unitname6),
                                              secondary: RichText(
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          '$currency${Formatter().converter(productsModel.unitPrice6!.toDouble())} ',
                                                      style: TextStyle(
                                                          color: AdaptiveTheme.of(
                                                                          context)
                                                                      .mode
                                                                      .isDark ==
                                                                  true
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    TextSpan(
                                                        text:
                                                            '$currency${Formatter().converter(productsModel.unitOldPrice6!.toDouble())}',
                                                        style: TextStyle(
                                                            color: AdaptiveTheme.of(
                                                                            context)
                                                                        .mode
                                                                        .isDark ==
                                                                    true
                                                                ? Colors.white
                                                                : Colors.black,
                                                            decoration:
                                                                TextDecoration
                                                                    .lineThrough))
                                                  ],
                                                ),
                                              ),
                                              value: 6,
                                              groupValue: selectedValue,
                                              onChanged: (v) {
                                                setState(() {
                                                  selectedValue = v!;
                                                  selectedPrice =
                                                      productsModel.unitPrice6!;
                                                  selectedProduct =
                                                      productsModel.unitname6;
                                                });
                                              }),
                                        ),
                                      if (productsModel.unitname7.isNotEmpty)
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              border: Border.all(
                                                  color: const Color.fromARGB(
                                                      255, 214, 214, 214),
                                                  width: 0.5)),
                                          child: RadioListTile(
                                              title:
                                                  Text(productsModel.unitname7),
                                              secondary: RichText(
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          '$currency${Formatter().converter(productsModel.unitPrice7!.toDouble())} ',
                                                      style: TextStyle(
                                                          color: AdaptiveTheme.of(
                                                                          context)
                                                                      .mode
                                                                      .isDark ==
                                                                  true
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    TextSpan(
                                                        text:
                                                            '$currency${Formatter().converter(productsModel.unitOldPrice7!.toDouble())}',
                                                        style: TextStyle(
                                                            color: AdaptiveTheme.of(
                                                                            context)
                                                                        .mode
                                                                        .isDark ==
                                                                    true
                                                                ? Colors.white
                                                                : Colors.black,
                                                            decoration:
                                                                TextDecoration
                                                                    .lineThrough))
                                                  ],
                                                ),
                                              ),
                                              value: 7,
                                              groupValue: selectedValue,
                                              onChanged: (v) {
                                                setState(() {
                                                  selectedValue = v!;
                                                  selectedPrice =
                                                      productsModel.unitPrice7!;
                                                  selectedProduct =
                                                      productsModel.unitname7;
                                                });
                                              }),
                                        ),
                                      if (productsModel.extraTitle!.isNotEmpty)
                                        const Gap(20),
                                      if (productsModel.extraTitle!.isNotEmpty)
                                        const Divider(
                                            color: Color.fromARGB(
                                                255, 243, 236, 236)),
                                      if (productsModel.extraTitle!.isNotEmpty)
                                        const Gap(10),
                                      // const Gap(10),
                                      if (productsModel.extraTitle!.isNotEmpty)
                                        const Text(
                                          'Extras:',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ).tr(),
                                      const Gap(10),
                                      productsModel.extraTitle == ''
                                          ? const SizedBox()
                                          : Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: SizedBox(
                                                    width: double.infinity,
                                                    child: Text(
                                                            productsModel
                                                                .extraTitle!,
                                                            style: TextStyle(
                                                                fontSize: 13.r,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold))
                                                        .tr(),
                                                  ),
                                                ),
                                                productsModel.extraname1 == ''
                                                    ? Container()
                                                    : InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            isSelectedExtra1 =
                                                                !isSelectedExtra1;
                                                            if (isSelectedExtra1 ==
                                                                false) {
                                                              selectedExtra1 =
                                                                  '';
                                                              selectedExtraPrice1 =
                                                                  0;
                                                            } else {
                                                              selectedExtra1 =
                                                                  productsModel
                                                                      .extraname1!;
                                                              selectedExtraPrice1 =
                                                                  productsModel
                                                                      .extraPrice1!;
                                                            }
                                                          });
                                                        },
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                              border: Border.all(
                                                                  color: const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      214,
                                                                      214,
                                                                      214),
                                                                  width: 0.5)),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 10,
                                                                    right: 10),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        isSelectedExtra1 ==
                                                                                true
                                                                            ? Row(
                                                                                children: [
                                                                                  Icon(
                                                                                    Icons.check_outlined,
                                                                                    color: appColor,
                                                                                  ),
                                                                                  const SizedBox(
                                                                                    width: 10,
                                                                                  ),
                                                                                ],
                                                                              )
                                                                            : Container(),
                                                                        Text(
                                                                            productsModel
                                                                                .extraname1!,
                                                                            style:
                                                                                TextStyle(
                                                                              color: appColor,
                                                                              fontSize: 13.r,
                                                                            )),
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                              '+$currency${Formatter().converter(productsModel.extraPrice1!.toDouble())}',
                                                                              style: TextStyle(fontSize: 12.r, fontWeight: FontWeight.bold)),
                                                                          const SizedBox(
                                                                              width: 5),
                                                                        ])
                                                                  ]),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                const Gap(10),
                                                productsModel.extraname2 == ''
                                                    ? Container()
                                                    : InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            isSelectedExtra2 =
                                                                !isSelectedExtra2;
                                                            if (isSelectedExtra2 ==
                                                                false) {
                                                              selectedExtra2 =
                                                                  '';
                                                              selectedExtraPrice2 =
                                                                  0;
                                                            } else {
                                                              selectedExtra2 =
                                                                  productsModel
                                                                      .extraname2!;
                                                              selectedExtraPrice2 =
                                                                  productsModel
                                                                      .extraPrice2!;
                                                            }
                                                          });
                                                        },
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                              border: Border.all(
                                                                  color: const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      214,
                                                                      214,
                                                                      214),
                                                                  width: 0.5)),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 10,
                                                                    right: 10),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        isSelectedExtra2 ==
                                                                                true
                                                                            ? Row(
                                                                                children: [
                                                                                  Icon(Icons.check_outlined, color: appColor),
                                                                                  const SizedBox(
                                                                                    width: 10,
                                                                                  ),
                                                                                ],
                                                                              )
                                                                            : Container(),
                                                                        Text(
                                                                            productsModel
                                                                                .extraname2!,
                                                                            style:
                                                                                TextStyle(
                                                                              color: appColor,
                                                                              fontSize: 13.r,
                                                                            )),
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                              '+$currency${Formatter().converter(productsModel.extraPrice2!.toDouble())}',
                                                                              style: TextStyle(fontSize: 12.r, fontWeight: FontWeight.bold)),
                                                                          const SizedBox(
                                                                              width: 5),
                                                                        ])
                                                                  ]),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                const Gap(10),
                                                productsModel.extraname3 == ''
                                                    ? Container()
                                                    : InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            isSelectedExtra3 =
                                                                !isSelectedExtra3;
                                                            if (isSelectedExtra3 ==
                                                                false) {
                                                              selectedExtra3 =
                                                                  '';
                                                              selectedExtraPrice3 =
                                                                  0;
                                                            } else {
                                                              selectedExtra3 =
                                                                  productsModel
                                                                      .extraname3!;
                                                              selectedExtraPrice3 =
                                                                  productsModel
                                                                      .extraPrice3!;
                                                            }
                                                          });
                                                        },
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                              border: Border.all(
                                                                  color: const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      214,
                                                                      214,
                                                                      214),
                                                                  width: 0.5)),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 10,
                                                                    right: 10),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        isSelectedExtra3 ==
                                                                                true
                                                                            ? Row(
                                                                                children: [
                                                                                  Icon(Icons.check_outlined, color: appColor),
                                                                                  const SizedBox(
                                                                                    width: 10,
                                                                                  ),
                                                                                ],
                                                                              )
                                                                            : Container(),
                                                                        Text(
                                                                            productsModel
                                                                                .extraname3!,
                                                                            style:
                                                                                TextStyle(
                                                                              color: appColor,
                                                                              fontSize: 13.r,
                                                                            )),
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                              '+$currency${Formatter().converter(productsModel.extraPrice3!.toDouble())}',
                                                                              style: TextStyle(fontSize: 12.r, fontWeight: FontWeight.bold)),
                                                                          const SizedBox(
                                                                              width: 5),
                                                                        ])
                                                                  ]),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                const Gap(10),
                                                productsModel.extraname4 == ''
                                                    ? Container()
                                                    : InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            isSelectedExtra4 =
                                                                !isSelectedExtra4;
                                                            if (isSelectedExtra4 ==
                                                                false) {
                                                              selectedExtra4 =
                                                                  '';
                                                              selectedExtraPrice4 =
                                                                  0;
                                                            } else {
                                                              selectedExtra4 =
                                                                  productsModel
                                                                      .extraname4!;
                                                              selectedExtraPrice4 =
                                                                  productsModel
                                                                      .extraPrice4!;
                                                            }
                                                          });
                                                        },
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                              border: Border.all(
                                                                  color: const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      214,
                                                                      214,
                                                                      214),
                                                                  width: 0.5)),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 10,
                                                                    right: 10),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        isSelectedExtra4 ==
                                                                                true
                                                                            ? Row(
                                                                                children: [
                                                                                  Icon(Icons.check_outlined, color: appColor),
                                                                                  const SizedBox(
                                                                                    width: 10,
                                                                                  ),
                                                                                ],
                                                                              )
                                                                            : Container(),
                                                                        Text(
                                                                            productsModel
                                                                                .extraname4!,
                                                                            style:
                                                                                TextStyle(
                                                                              color: appColor,
                                                                              fontSize: 13.r,
                                                                            )),
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                              '+$currency${Formatter().converter(productsModel.extraPrice4!.toDouble())}',
                                                                              style: TextStyle(fontSize: 12.r, fontWeight: FontWeight.bold)),
                                                                          const SizedBox(
                                                                              width: 5),
                                                                        ])
                                                                  ]),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                const Gap(10),
                                                productsModel.extraname5 == ''
                                                    ? Container()
                                                    : InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            isSelectedExtra5 =
                                                                !isSelectedExtra5;
                                                            if (isSelectedExtra5 ==
                                                                false) {
                                                              selectedExtra5 =
                                                                  '';
                                                              selectedExtraPrice5 =
                                                                  0;
                                                            } else {
                                                              selectedExtra5 =
                                                                  productsModel
                                                                      .extraname5!;
                                                              selectedExtraPrice5 =
                                                                  productsModel
                                                                      .extraPrice5!;
                                                            }
                                                          });
                                                        },
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                              border: Border.all(
                                                                  color: const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      214,
                                                                      214,
                                                                      214),
                                                                  width: 0.5)),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 10,
                                                                    right: 10),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        isSelectedExtra5 ==
                                                                                true
                                                                            ? Row(
                                                                                children: [
                                                                                  Icon(Icons.check_outlined, color: appColor),
                                                                                  const SizedBox(
                                                                                    width: 10,
                                                                                  ),
                                                                                ],
                                                                              )
                                                                            : Container(),
                                                                        Text(
                                                                            productsModel
                                                                                .extraname5!,
                                                                            style:
                                                                                TextStyle(
                                                                              color: appColor,
                                                                              fontSize: 13.r,
                                                                            )),
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                              '+$currency${Formatter().converter(productsModel.extraPrice5!.toDouble())}',
                                                                              style: TextStyle(fontSize: 12.r, fontWeight: FontWeight.bold)),
                                                                          const SizedBox(
                                                                              width: 5),
                                                                        ])
                                                                  ]),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                              ],
                                            ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      // const Gap(10),
                                      const Divider(
                                          color: Color.fromARGB(
                                              255, 243, 236, 236)),
                                      const Gap(10),
                                      Row(
                                        children: [
                                          const Text(
                                            'Quantity:',
                                            style: TextStyle(fontSize: 12),
                                          ).tr(),
                                          const Gap(10),
                                          SizedBox(
                                              width: 120,
                                              height: 30,
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    flex: 2,
                                                    child: InkWell(
                                                      onTap: () {
                                                        if (quantity <= 1) {
                                                          // Fluttertoast.showToast(
                                                          //     msg:
                                                          //         "You can't go below this quantity"
                                                          //             .tr(),
                                                          //     toastLength: Toast
                                                          //         .LENGTH_SHORT,
                                                          //     gravity:
                                                          //         ToastGravity
                                                          //             .CENTER,
                                                          //     timeInSecForIosWeb:
                                                          //         6,
                                                          //     backgroundColor: Theme
                                                          //             .of(
                                                          //                 context)
                                                          //         .primaryColor,
                                                          //     textColor:
                                                          //         Colors.white,
                                                          //     fontSize: 14.0);
                                                          showAlertDialog(context,"Note","You can't go below this quantity" );
                                                        } else {
                                                          setState(() {
                                                            quantity =
                                                                quantity - 1;
                                                          });
                                                        }
                                                      },
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            borderRadius: const BorderRadius
                                                                .only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        5),
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        5)),
                                                            border: Border.all(
                                                                color: Colors
                                                                    .grey)),
                                                        child: const Center(
                                                            child: Icon(
                                                          Icons.remove,
                                                          size: 14,
                                                        )),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 3,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color:
                                                                  Colors.grey)
                                                          // border: Border(
                                                          //     top: BorderSide(
                                                          //         color: Colors
                                                          //             .grey),
                                                          //     bottom: BorderSide(
                                                          //         color: Colors
                                                          //             .grey),
                                                          //     right:
                                                          //         BorderSide
                                                          //             .none,
                                                          //     left: BorderSide
                                                          //         .none)
                                                          ),
                                                      child: Center(
                                                          child: Text(quantity
                                                              .toString())),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: InkWell(
                                                      onTap: () {
                                                        if (quantity >=
                                                            productsModel
                                                                .quantity!) {
                                                          // Fluttertoast.showToast(
                                                          //     msg:
                                                          //         'This is the available quantity'
                                                          //             .tr(),
                                                          //     toastLength: Toast
                                                          //         .LENGTH_SHORT,
                                                          //     gravity:
                                                          //         ToastGravity
                                                          //             .CENTER,
                                                          //     timeInSecForIosWeb:
                                                          //         6,
                                                          //     backgroundColor: Theme
                                                          //             .of(
                                                          //                 context)
                                                          //         .primaryColor,
                                                          //     textColor:
                                                          //         Colors.white,
                                                          //     fontSize: 14.0);
                                                          showAlertDialog(context,'Note','This is the available quantity');
                                                        } else {
                                                          setState(() {
                                                            quantity =
                                                                quantity + 1;
                                                          });
                                                        }
                                                      },
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            borderRadius: const BorderRadius
                                                                .only(
                                                                topRight: Radius
                                                                    .circular(
                                                                        5),
                                                                bottomRight:
                                                                    Radius
                                                                        .circular(
                                                                            5)),
                                                            border: Border.all(
                                                                color: Colors
                                                                    .grey)),
                                                        child: const Center(
                                                            child: Icon(
                                                          Icons.add,
                                                          size: 14,
                                                        )),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              )),
                                        ],
                                      ),
                                      const Gap(20),
                                      ////////////////// Restaurant Button ////////////////////

                                      if (productsModel.module == 'Restaurant')
                                        if (vendorStatus == false &&
                                            productsModel.module ==
                                                'Restaurant')
                                          const Gap(10),
                                      if (vendorStatus == false &&
                                          productsModel.module == 'Restaurant')
                                        const Center(
                                            child: Text(
                                          'Vendor is closed',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )),
                                      if (vendorStatus == false &&
                                          productsModel.module == 'Restaurant')
                                        const Gap(10),
                                      if (vendorStatus == true &&
                                          productsModel.module == 'Restaurant')
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              flex: 5,
                                              child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                      shape:
                                                          const BeveledRectangleBorder(),
                                                      backgroundColor:
                                                          appColor),
                                                  onPressed: () {
                                                    if (cartStorageDataRestaurant
                                                            .any((e) =>
                                                                e.productID ==
                                                                    productsModel
                                                                        .productID &&
                                                                e.selected ==
                                                                    selectedProduct) ==
                                                        true) {
                                                      cartStorageRestaurant.updateCartItemQuantityRestaurant(
                                                          productsModel
                                                              .productID,
                                                          selectedProduct,
                                                          quantity,
                                                          selectedPrice == 0
                                                              ? productsModel
                                                                  .unitPrice1!
                                                              : selectedPrice,
                                                          context,
                                                          true,
                                                          getSelectedExtra1(
                                                              productsModel
                                                                  .extraPrice1!),
                                                          getSelectedExtra2(
                                                              productsModel
                                                                  .extraPrice2!),
                                                          getSelectedExtra3(
                                                              productsModel
                                                                  .extraPrice3!),
                                                          getSelectedExtra4(
                                                              productsModel
                                                                  .extraPrice4!),
                                                          getSelectedExtra5(
                                                              productsModel
                                                                  .extraPrice5!),
                                                        false,
                                                      );
                                                    } else {
                                                      cartStorageRestaurant
                                                          .saveToCartRestaurant(
                                                              CartModel(
                                                                  module:
                                                                      productsModel
                                                                          .module,
                                                                  isPrescription:
                                                                      productsModel
                                                                          .isPrescription,
                                                                  selectedExtra1:
                                                                      selectedExtra1,
                                                                  selectedExtraPrice1:
                                                                      selectedExtraPrice1,
                                                                  selectedExtra2:
                                                                      selectedExtra2,
                                                                  selectedExtraPrice2:
                                                                      selectedExtraPrice2,
                                                                  selectedExtra3:
                                                                      selectedExtra3,
                                                                  selectedExtraPrice3:
                                                                      selectedExtraPrice3,
                                                                  selectedExtra4:
                                                                      selectedExtra4,
                                                                  selectedExtraPrice4:
                                                                      selectedExtraPrice4,
                                                                  selectedExtra5:
                                                                      selectedExtra5,
                                                                  selectedExtraPrice5:
                                                                      selectedExtraPrice5,
                                                                  vendorName:
                                                                      productsModel
                                                                          .vendorName,
                                                                  returnDuration:
                                                                      productsModel
                                                                          .returnDuration!,
                                                                  totalNumberOfUserRating:
                                                                      productsModel
                                                                          .totalNumberOfUserRating!,
                                                                  totalRating:
                                                                      productsModel
                                                                          .totalRating!,
                                                                  productID:
                                                                      productsModel
                                                                          .productID,
                                                                  price: selectedPrice ==
                                                                          0
                                                                      ? (productsModel.unitPrice1! *
                                                                              quantity) +
                                                                          getSelectedExtra1(productsModel
                                                                              .extraPrice1!) +
                                                                          getSelectedExtra2(productsModel
                                                                              .extraPrice2!) +
                                                                          getSelectedExtra3(productsModel
                                                                              .extraPrice3!) +
                                                                          getSelectedExtra4(
                                                                              productsModel.extraPrice4!) +
                                                                          getSelectedExtra5(productsModel.extraPrice5!)
                                                                      : (selectedPrice * quantity) + getSelectedExtra1(productsModel.extraPrice1!) + getSelectedExtra2(productsModel.extraPrice2!) + getSelectedExtra3(productsModel.extraPrice3!) + getSelectedExtra4(productsModel.extraPrice4!) + getSelectedExtra5(productsModel.extraPrice5!),
                                                                  selectedPrice: selectedPrice == 0 ? productsModel.unitPrice1! : selectedPrice,
                                                                  quantity: quantity.toInt(),
                                                                  selected: selectedProduct == '' ? productsModel.unitname1 : selectedProduct,
                                                                  description: productsModel.description,
                                                                  // marketID: '',
                                                                  // marketName:
                                                                  //     productsModel
                                                                  //         .marketName,
                                                                  uid: productsModel.uid,
                                                                  name: productsModel.name,
                                                                  category: productsModel.category,
                                                                  subCollection: productsModel.subCollection,
                                                                  collection: productsModel.collection,
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
                                                                  unitPrice1: productsModel.unitPrice1!,
                                                                  unitPrice2: productsModel.unitPrice2!,
                                                                  unitPrice3: productsModel.unitPrice3!,
                                                                  unitPrice4: productsModel.unitPrice4!,
                                                                  unitPrice5: productsModel.unitPrice5!,
                                                                  unitPrice6: productsModel.unitPrice6!,
                                                                  unitPrice7: productsModel.unitPrice7!,
                                                                  unitOldPrice1: productsModel.unitOldPrice1!,
                                                                  unitOldPrice2: productsModel.unitOldPrice2!,
                                                                  unitOldPrice3: productsModel.unitOldPrice3!,
                                                                  unitOldPrice4: productsModel.unitOldPrice4!,
                                                                  unitOldPrice5: productsModel.unitOldPrice5!,
                                                                  unitOldPrice6: productsModel.unitOldPrice6!,
                                                                  unitOldPrice7: productsModel.unitOldPrice7!,
                                                                  percantageDiscount: productsModel.percantageDiscount!,
                                                                  vendorId: productsModel.vendorId,
                                                                  brand: productsModel.brand),
                                                              context);
                                                    }
                                                  },
                                                  child: const Text(
                                                    'Add To Cart',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  )),
                                            ),
                                            const Gap(20),
                                            Expanded(
                                              flex: 3,
                                              child: Row(
                                                children: [
                                                  favoriteStorageDataRestaurant
                                                              .any((e) =>
                                                                  e.productID ==
                                                                  productsModel
                                                                      .productID) ==
                                                          false
                                                      ? InkWell(
                                                          onTap: () {
                                                            favoriteStorageRestaurant
                                                                .saveToFavoriteRestaurant(
                                                                    CartModel(
                                                                        module: productsModel
                                                                            .module,
                                                                        vendorName: productsModel
                                                                            .vendorName,
                                                                        price: productsModel
                                                                            .unitPrice1!,
                                                                        selectedPrice: productsModel
                                                                            .unitPrice1!,
                                                                        selected: productsModel
                                                                            .unitname1,
                                                                        returnDuration: productsModel
                                                                            .returnDuration!,
                                                                        totalRating: productsModel
                                                                            .totalRating!,
                                                                        quantity:
                                                                            1,
                                                                        totalNumberOfUserRating: productsModel
                                                                            .totalNumberOfUserRating!,
                                                                        productID: productsModel
                                                                            .productID,
                                                                        description: productsModel
                                                                            .description,
                                                                        // marketID: productsModel
                                                                        //     .marketID,
                                                                        // marketName:
                                                                        //     productsModel
                                                                        //         .marketName,
                                                                        uid: productsModel
                                                                            .uid,
                                                                        name: productsModel
                                                                            .name,
                                                                        category:
                                                                            productsModel
                                                                                .category,
                                                                        collection:
                                                                            productsModel
                                                                                .collection,
                                                                        subCollection:
                                                                            productsModel
                                                                                .subCollection,
                                                                        image1:
                                                                            productsModel
                                                                                .image1,
                                                                        image2:
                                                                            productsModel
                                                                                .image2,
                                                                        image3:
                                                                            productsModel
                                                                                .image3,
                                                                        unitname1:
                                                                            productsModel
                                                                                .unitname1,
                                                                        unitname2:
                                                                            productsModel
                                                                                .unitname2,
                                                                        unitname3:
                                                                            productsModel
                                                                                .unitname3,
                                                                        unitname4:
                                                                            productsModel
                                                                                .unitname4,
                                                                        unitname5:
                                                                            productsModel
                                                                                .unitname5,
                                                                        unitname6:
                                                                            productsModel
                                                                                .unitname6,
                                                                        unitname7:
                                                                            productsModel
                                                                                .unitname7,
                                                                        unitPrice1:
                                                                            productsModel
                                                                                .unitPrice1!,
                                                                        unitPrice2:
                                                                            productsModel
                                                                                .unitPrice2!,
                                                                        unitPrice3:
                                                                            productsModel
                                                                                .unitPrice3!,
                                                                        unitPrice4:
                                                                            productsModel
                                                                                .unitPrice4!,
                                                                        unitPrice5:
                                                                            productsModel
                                                                                .unitPrice5!,
                                                                        unitPrice6:
                                                                            productsModel
                                                                                .unitPrice6!,
                                                                        unitPrice7:
                                                                            productsModel
                                                                                .unitPrice7!,
                                                                        unitOldPrice1:
                                                                            productsModel
                                                                                .unitOldPrice1!,
                                                                        unitOldPrice2:
                                                                            productsModel
                                                                                .unitOldPrice2!,
                                                                        unitOldPrice3:
                                                                            productsModel
                                                                                .unitOldPrice3!,
                                                                        unitOldPrice4:
                                                                            productsModel
                                                                                .unitOldPrice4!,
                                                                        unitOldPrice5:
                                                                            productsModel
                                                                                .unitOldPrice5!,
                                                                        unitOldPrice6:
                                                                            productsModel
                                                                                .unitOldPrice6!,
                                                                        unitOldPrice7:
                                                                            productsModel
                                                                                .unitOldPrice7!,
                                                                        percantageDiscount:
                                                                            productsModel
                                                                                .percantageDiscount!,
                                                                        vendorId:
                                                                            productsModel
                                                                                .vendorId,
                                                                        brand: productsModel
                                                                            .brand),
                                                                    context);
                                                          },
                                                          child: Container(
                                                            height: 35,
                                                            width: 35,
                                                            decoration:
                                                                const BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: Colors
                                                                        .grey),
                                                            child: const Center(
                                                              child: Icon(
                                                                Icons.favorite,
                                                                color: Colors
                                                                    .white,
                                                                size: 20,
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      : InkWell(
                                                          onTap: () {
                                                            favoriteStorageRestaurant
                                                                .removeFromFavoriteRestaurant(
                                                                    productsModel
                                                                        .productID,
                                                                    context);
                                                          },
                                                          child: Container(
                                                            height: 35,
                                                            width: 35,
                                                            decoration:
                                                                const BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: Colors
                                                                        .orange),
                                                            child: const Center(
                                                              child: Icon(
                                                                Icons.favorite,
                                                                color: Colors
                                                                    .white,
                                                                size: 20,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                  const Gap(10),
                                                  const Text(
                                                    'Save for later',
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  ).tr()
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      const Gap(10),
                                      const Divider(
                                          color: Color.fromARGB(
                                              255, 243, 236, 236)),
                                      const Gap(10),
                                      ShareToSocials(
                                          module: productsModel.module,
                                          productID: productsModel.productID),
                                      const Gap(15),
                                      RichText(
                                        text: TextSpan(
                                            text: 'Seller:',
                                            style: TextStyle(
                                              color: AdaptiveTheme.of(context)
                                                          .mode
                                                          .isDark ==
                                                      true
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                            children: <TextSpan>[
                                              const TextSpan(text: ' '),
                                              TextSpan(
                                                  text: productsModel
                                                          .vendorName.isEmpty
                                                      ? appName
                                                      : productsModel
                                                          .vendorName,
                                                  style: const TextStyle(
                                                    decoration: TextDecoration
                                                        .underline,
                                                    color: Colors.blue,
                                                  ),
                                                  recognizer:
                                                      TapGestureRecognizer()
                                                        ..onTap = () {
                                                          if (productsModel
                                                              .vendorName
                                                              .isNotEmpty) {
                                                            context.go(
                                                                '/${productsModel.module.toLowerCase()}/vendor-detail/${productsModel.vendorId}');
                                                          }
                                                        })
                                            ]),
                                      ),
                                      const Gap(30),
                                    ],
                                  ),
                                ),
                                const Gap(10),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
              //  const Gap(20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Text(
                      'Product Detail',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        fontFamily: 'Helvetica',
                      ),
                    ).tr(),
                  ],
                ),
              ),
              if (productsModel == null) const Gap(10),
              if (productsModel == null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 200, // Set the width as needed
                            height: 15, // Set the height as needed
                            color: Colors.grey, // Set the color as needed
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 300, // Set the width as needed
                            height: 14, // Set the height as needed
                            color: Colors.grey, // Set the color as needed
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 400, // Set the width as needed
                            height: 15, // Set the height as needed
                            color: Colors.grey, // Set the color as needed
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (productsModel != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        width: double.infinity,
                        child: QuillEditor.basic(
                          controller: _controllerDetail,
                          configurations: const QuillEditorConfigurations(),
                        ),
                      )),
                ),
              const Gap(20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Text(
                      'Return Policy',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        fontFamily: 'Helvetica',
                      ),
                    ).tr(),
                  ],
                ),
              ),
              if (productsModel == null) const Gap(10),
              if (productsModel == null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 200, // Set the width as needed
                            height: 15, // Set the height as needed
                            color: Colors.grey, // Set the color as needed
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 300, // Set the width as needed
                            height: 14, // Set the height as needed
                            color: Colors.grey, // Set the color as needed
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 400, // Set the width as needed
                            height: 15, // Set the height as needed
                            color: Colors.grey, // Set the color as needed
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (productsModel != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        width: double.infinity,
                        child: Text(productsModel.returnDuration == 0
                            ? 'No return policy'
                            : '${productsModel.returnDuration} Day Return Guarantee'),
                      )),
                ),
              const Gap(20),
              // const Gap(20),
              Padding(
                padding: MediaQuery.of(context).size.width >= 1100
                    ? const EdgeInsets.only(left: 120, right: 100)
                    : const EdgeInsets.all(8),
                child: Row(
                  children: [
                    const Text(
                      'Reviews & Ratings',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        fontFamily: 'Helvetica',
                      ),
                    ).tr(),
                  ],
                ),
              ),
              if (productsModel == null) const Gap(10),
              if (productsModel == null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 200, // Set the width as needed
                            height: 15, // Set the height as needed
                            color: Colors.grey, // Set the color as needed
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 300, // Set the width as needed
                            height: 14, // Set the height as needed
                            color: Colors.grey, // Set the color as needed
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 400, // Set the width as needed
                            height: 15, // Set the height as needed
                            color: Colors.grey, // Set the color as needed
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (productsModel != null)
                ReviewWidget(
                  collection: collection,
                  totalNumberOfUserRating:
                      productsModel.totalNumberOfUserRating!,
                  totalRating: productsModel.totalRating!,
                  productUID: productsModel.productID,
                ),
              const Gap(20),
              Padding(
                padding: MediaQuery.of(context).size.width >= 1100
                    ? const EdgeInsets.only(left: 120, right: 100)
                    : const EdgeInsets.all(8),
                child: Row(
                  children: [
                    const Text(
                      'Similar items you may like',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    ).tr(),
                  ],
                ),
              ),
              const Gap(10),
              if (productsModel != null)
               RestaurantSimilarItemsWidget(
                  productID: productsModel.productID,
                  category: productsModel.category,
                ),
              const Gap(50),
              const FooterWidget()
            ],
          )
      ),
    );
  }
}
