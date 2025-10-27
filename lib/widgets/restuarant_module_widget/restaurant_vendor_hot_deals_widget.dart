import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_web/model/products_model.dart';
import 'package:user_web/constant.dart';
import '../../providers/restuarant_providers/restaurant_hot_deals_provider.dart';
import 'restaurant_product_widget_main.dart';

class RestaurantVendorHotDealsWidget extends ConsumerStatefulWidget {
  final String vendorID;
  const RestaurantVendorHotDealsWidget({
    super.key,
    required this.vendorID,
  });

  @override
  ConsumerState<RestaurantVendorHotDealsWidget> createState() =>
      _RestaurantVendorHotDealsWidgetState();
}

class _RestaurantVendorHotDealsWidgetState
    extends ConsumerState<RestaurantVendorHotDealsWidget> {
  bool reverse = false;
  @override
  void initState() {
    super.initState();
  }

  int current = 0;
  final CarouselSliderController _controller = CarouselSliderController();
  bool isHovered = false;
  bool isLast = true;
  bool stopHovering = false;
  @override
  Widget build(BuildContext context) {
    final hotDeals = widget.vendorID.isEmpty
        ? null
        : ref.watch(hotDealStreamRestaurantByVendorProvider(widget.vendorID));
    return hotDeals == null || hotDeals.value == null
        ? const SizedBox.shrink()
        :  hotDeals.value!.isEmpty
        ? const SizedBox.shrink()
        : widget.vendorID.isEmpty
            ? const SizedBox.shrink()
            : Padding(
                padding: MediaQuery.of(context).size.width >= 1100
                    ? const EdgeInsets.only(left: 50, right: 50)
                    : const EdgeInsets.all(0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Special Offers',
                            style: TextStyle(
                                // color: Colors.white,
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    MediaQuery.of(context).size.width >= 1100
                                        ? 30
                                        : 20),
                          ).tr(),
                        ),

                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: CountdownTimer(
                        //     textStyle: TextStyle(
                        //         fontWeight: FontWeight.bold,
                        //         fontSize: MediaQuery.of(context).size.width >= 1100
                        //             ? 18
                        //             : 15),
                        //     endTime:
                        //         DateTime.parse(flashSales).millisecondsSinceEpoch,
                        //     onEnd: () {
                        //       // FirebaseFirestore.instance
                        //       //     .collection('Flash Sales Products')
                        //       //     .doc(productModel.uid)
                        //       //     .delete();
                        //       deleteAllDocumentsInCollection('Flash Sales');
                        //     },
                        //   ),
                        // ),
                      ],
                    ),
                    hotDeals.when(data: (v) {
                      return MouseRegion(
                        onEnter: (_) {
                          setState(() {
                            isHovered = true;
                          });
                        },
                        onExit: (_) {
                          setState(() {
                            isHovered = false;
                          });
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              height: 250,
                              width: double.infinity,
                              child: CarouselSlider.builder(
                                carouselController: _controller,
                                itemCount: v.length,
                                itemBuilder: (_, index, int pageViewIndex) {
                                  ProductsModel productsModel = v[index];
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                        onHover: (value) {
                                          setState(() {
                                            stopHovering = value;
                                          });
                                        },
                                        onTap: () {
                                          if (MediaQuery.of(context)
                                                  .size
                                                  .width <=
                                              1100) {
                                            context.go(
                                                '/restaurant/product-detail/${productsModel.uid}');
                                          }
                                        },
                                        child: RestaurantProductWidgetMain(
                                            index: index,
                                            productsModel: productsModel)),
                                  );
                                },
                                options: CarouselOptions(
                                    enlargeStrategy:
                                        CenterPageEnlargeStrategy.height,
                                    initialPage: 0,
                                    disableCenter: true,
                                    enableInfiniteScroll: false,
                                    viewportFraction:
                                    MediaQuery.of(context).size.width >=
                                        1100
                                        ? 0.18
                                        : 0.45,
                                    padEnds: false,
                                    aspectRatio:  MediaQuery.of(context).size.width >= 1100 ? 0.8 : 0.10,
                                    reverse: false,
                                    autoPlay: stopHovering == true ||
                                            MediaQuery.of(context).size.width <=
                                                1100
                                        ? false
                                        : true,
                                    autoPlayInterval:
                                        const Duration(seconds: 3),
                                    autoPlayAnimationDuration:
                                        const Duration(milliseconds: 800),
                                    autoPlayCurve: Curves.fastOutSlowIn,
                                    enlargeCenterPage: false,
                                    // onPageChanged: callbackFunction,
                                    scrollDirection: Axis.horizontal,
                                    onPageChanged: (index, reason) {
                                      setState(() {
                                        current = index;
                                        // // ignore: avoid_print
                                        // print('current is $current');
                                      });
                                      if (index == 5) {
                                        setState(() {
                                          isLast = false;
                                        });
                                      } else {
                                        setState(() {
                                          isLast = true;
                                        });
                                      }
                                    }),
                              ),
                            ),
                            if (MediaQuery.of(context).size.width >= 1100)
                              isHovered == false
                                  ? const SizedBox.shrink()
                                  : current == 0
                                      ? const SizedBox.shrink()
                                      : Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: InkWell(
                                              onTap: () {
                                                _controller.previousPage();
                                              },
                                              child: Container(
                                                  height: 30,
                                                  width: 30,
                                                  decoration: BoxDecoration(
                                                    color: appColor,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: const Center(
                                                      child: Icon(
                                                    Icons.chevron_left,
                                                    color: Colors.white,
                                                  ))),
                                            ),
                                          )),
                            if (MediaQuery.of(context).size.width >= 1100)
                              isHovered == false
                                  ? const SizedBox.shrink()
                                  : Align(
                                      alignment: Alignment.centerRight,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: InkWell(
                                          onTap: () {
                                            _controller.nextPage();
                                          },
                                          child: Container(
                                              height: 30,
                                              width: 30,
                                              decoration: BoxDecoration(
                                                color: appColor,
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Center(
                                                  child: Icon(
                                                Icons.chevron_right,
                                                color: Colors.white,
                                              ))),
                                        ),
                                      )),
                            if (MediaQuery.of(context).size.width <= 1100)
                              current == 0
                                  ? const SizedBox.shrink()
                                  : Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: InkWell(
                                          onTap: () {
                                            _controller.previousPage();
                                          },
                                          child: Container(
                                              height: 30,
                                              width: 30,
                                              decoration: BoxDecoration(
                                                color: appColor,
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Center(
                                                  child: Icon(
                                                Icons.chevron_left,
                                                color: Colors.white,
                                              ))),
                                        ),
                                      )),
                            if (MediaQuery.of(context).size.width <= 1100)
                              Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: () {
                                        _controller.nextPage();
                                      },
                                      child: Container(
                                          height: 30,
                                          width: 30,
                                          decoration: BoxDecoration(
                                            color: appColor,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Center(
                                              child: Icon(
                                            Icons.chevron_right,
                                            color: Colors.white,
                                          ))),
                                    ),
                                  )),
                          ],
                        ),
                      );
                    }, error: (r, e) {
                      return Text('$r');
                    }, loading: () {
                      return SizedBox(
                        height: 370,
                        //   width: double.infinity,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            return Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                width: 170.0,
                                height: double.infinity,
                                margin: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    })
                  ],
                ),
              );
  }
}
