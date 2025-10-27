import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shimmer/shimmer.dart';
import '../../model/user.dart';
import '../vendor_list_home_widget.dart';


class RestaurantVendorMobileHomeWidget extends StatefulWidget {
  const RestaurantVendorMobileHomeWidget({super.key});

  @override
  State<RestaurantVendorMobileHomeWidget> createState() =>
      _RestaurantVendorMobileHomeWidgetState();
}

class _RestaurantVendorMobileHomeWidgetState
    extends State<RestaurantVendorMobileHomeWidget> {
  List<UserModel> products = [];
  // List<ProductsModel> productsFilter = [];
  bool isLoaded = true;

  getProducts() async {
    setState(() {
      isLoaded = true;
    });
    context.loaderOverlay.show();
    FirebaseFirestore.instance
        .collection('vendors')
        .where('approval', isEqualTo: true)
        .where('module', isEqualTo: 'Restaurant')
        .limit(5)
        .snapshots()
        .listen((event) {
      setState(() {
        isLoaded = false;
      });
      if (mounted) {
        context.loaderOverlay.hide();
      }
      products.clear();
      for (var element in event.docs) {
        var prods = UserModel.fromMap(element.data(), element.id);
        setState(() {
          products.add(prods);
        });
      }
    });
  }

  @override
  void initState() {
    getProducts();
    super.initState();
  }

  int current = 0;
  final CarouselSliderController _controller = CarouselSliderController();
  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).size.width >= 1100
          ? const EdgeInsets.only(left: 50, right: 50)
          : const EdgeInsets.all(0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Vendors',
                  style: TextStyle(
                      // color: Colors.white,
                      fontFamily: 'LilitaOne',
                      // fontWeight: FontWeight.bold,
                      fontSize:
                          MediaQuery.of(context).size.width >= 1100 ? 30 : 20),
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
              Padding(
                padding: MediaQuery.of(context).size.width >= 1100
                    ? const EdgeInsets.all(0)
                    : const EdgeInsets.all(8.0),
                child: Center(
                  child: OutlinedButton(
                    onPressed: () {
                      context.go('/restaurant/vendors');
                    },
                    child: Text(
                      'See All',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AdaptiveTheme.of(context).mode.isDark == true
                              ? Colors.white
                              : Colors.black,
                          fontSize: MediaQuery.of(context).size.width >= 1100
                              ? 15
                              : 12),
                    ).tr(),
                  ),
                ),
              ),
            ],
          ),
          isLoaded == true
              ? Card(
                  semanticContainer: false,
                  shape: const Border.fromBorderSide(BorderSide.none),
                  color: MediaQuery.of(context).size.width >= 1100
                      ? Colors.white
                      : null,
                  elevation:
                      MediaQuery.of(context).size.width >= 1100 ? 0.5 : null,
                  child: SizedBox(
                    height: 200,
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
                  ),
                )
              : SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: CarouselSlider.builder(
                    carouselController: _controller,
                    options: CarouselOptions(
                        enlargeStrategy: CenterPageEnlargeStrategy.height,
                        initialPage: 0,
                        disableCenter: true,
                        enableInfiniteScroll: false,
                        padEnds: false,
                        aspectRatio: 1,
                        viewportFraction:
                            MediaQuery.of(context).size.width >= 1100
                                ? 0.2
                                : 0.7,
                        reverse: false,
                        autoPlay: isHovered == true ||
                                        MediaQuery.of(context).size.width <=
                                            1100
                                    ? false
                                    : true,
                        autoPlayInterval: const Duration(seconds: 3),
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
                        }),
                    // scrollDirection: Axis.horizontal,
                    // physics: const BouncingScrollPhysics(),
                    // shrinkWrap: true,
                    itemCount: products.length,
                    itemBuilder: (context, int d, int index) {
                      UserModel productsModel = products[d];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                            height: 200,
                            // width: 200,
                            child: VendorListHomeWidget(
                              isNewWidget: false,
                                showModule: false, vendor: productsModel)),
                      );
                    },
                  ))
        ],
      ),
    );
  }
}
