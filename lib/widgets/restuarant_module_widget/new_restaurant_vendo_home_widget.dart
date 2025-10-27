import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_web/constant.dart';
import '../../model/user.dart';
import '../vendor_list_home_widget.dart';

class NewRestaurantVendorHomeWidget extends StatefulWidget {
  const   NewRestaurantVendorHomeWidget({super.key});

  @override
  State<NewRestaurantVendorHomeWidget> createState() =>
      _NewRestaurantVendorHomeWidgetState();
}

class _NewRestaurantVendorHomeWidgetState
    extends State<NewRestaurantVendorHomeWidget> {
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
        .orderBy('timeCreated',descending: false)
        // .where('module', isEqualTo: 'Restaurant')
        .limit(7)
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
  bool stopHovering = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width >= 1100 ? 300 : 230,
      decoration: BoxDecoration(
        // color: Color(0xFFDF7EB).withOpacity(1.0),
        color:AdaptiveTheme.of(context).mode.isDark == true
            ? null
            :     Color(0xFFDF7EB).withOpacity(1.0),
        image: DecorationImage(
          image: AssetImage('assets/image/vendor bg.png'), // Change to NetworkImage if needed// Ensures it covers the entire container
          alignment: Alignment.centerRight, // Centers the image
        ),
      ),
      child: Padding(
        padding: MediaQuery.of(context).size.width >= 1100
            ? const EdgeInsets.only(left: 50, right: 50)
            : const EdgeInsets.all(2),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: MediaQuery.of(context).size.width >= 1100 ?
                 const EdgeInsets.all(8.0) :
                    const EdgeInsets.only(top: 10,left: 15) ,
                  child: Text(
                    'Select Vendors',
                    style: TextStyle(
                      // color: Colors.white,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.bold,
                        fontSize:
                        MediaQuery.of(context).size.width >= 1100 ? 30 : 18),
                  ).tr(),
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
                height:MediaQuery.of(context).size.width >= 1100 ? 200 : 170,
                  // width: double.infinity,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Shimmer.fromColors(
                      baseColor: Colors.white38,
                      highlightColor: Colors.white38,
                      child: Container(
                        width: MediaQuery.of(context).size.width >= 1100 ? 170.0 : 120.0,
                        height: double.infinity,
                        margin: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          // borderRadius: BorderRadius.circular(2.0),
                        ),
                      ),
                    );
                  },
                ),
              ),
            )
                : MouseRegion(
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
                    height: MediaQuery.of(context).size.width >= 1100 ? 200 : 170,
                    width: double.infinity,
                    child: CarouselSlider.builder(
                      carouselController: _controller,
                      options: CarouselOptions(
                        enlargeStrategy: CenterPageEnlargeStrategy.height,
                        initialPage: 0,
                        disableCenter: false,
                        enableInfiniteScroll: false, // Disable if only one item
                        padEnds: false,
                        aspectRatio: 1,
                        viewportFraction: MediaQuery.of(context).size.width >= 1100 ? 0.2 : 0.5,
                        reverse: false,
                        autoPlay: stopHovering == true || MediaQuery.of(context).size.width <= 1100
                            ? false
                            : products.length > 1, // AutoPlay only if more than 1 item
                        autoPlayInterval: const Duration(seconds: 3),
                        autoPlayAnimationDuration: const Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: false,
                        scrollDirection: Axis.horizontal,
                        onPageChanged: (index, reason) {
                          setState(() {
                            current = index;
                          });
                        },
                      ),
                      itemCount: products.length, // Prevent duplication
                      itemBuilder: (context, int d, int index) {
                        UserModel productsModel = products[d];
                        return Padding(
                              padding: MediaQuery.of(context).size.width >= 1100
                                  ? const EdgeInsets.only(left: 38,top: 5)
                                  : const EdgeInsets.only(left: 38,top: 5),
                          child: InkWell(
                            // hoverColor: Colors.transparent,
                            // onHover: (value) {
                            //   setState(() {
                            //     stopHovering = value;
                            //   });
                            // },
                            onTap: () {},
                            child: SizedBox(
                              height:MediaQuery.of(context).size.width >= 1100 ? 250 : 220,
                              width:MediaQuery.of(context).size.width >= 1100 ? 260 : 230,
                              child: Card(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero), // Ensure sharp edges
                                child: VendorListHomeWidget(
                                  isNewWidget: true,
                                  showModule: false,
                                  vendor: productsModel,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  if (MediaQuery.of(context).size.width >= 1100)
                    isHovered == false
                        ? const SizedBox.shrink()
                        : Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: InkWell(
                            onTap: () {
                              _controller.previousPage();
                            },
                            child: Container(
                                height: 25,
                                width: 25,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                    child: Icon(
                                      Icons.arrow_back,
                                      color: Colors.grey,
                                    ))),
                          ),
                        )),
                  if (MediaQuery.of(context).size.width >= 1100)
                    isHovered == false
                        ? const SizedBox.shrink()
                        : Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: InkWell(
                            onTap: () {
                              _controller.nextPage();
                            },
                            child: Container(
                                height: 25,
                                width: 25,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                    child: Icon(
                                      Icons.arrow_forward,
                                      color: Colors.grey,
                                    ))),
                          ),
                        )),
                  if (MediaQuery.of(context).size.width <= 1100)
                        isHovered == false
                            ? const SizedBox.shrink()
                          : Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: InkWell(
                            onTap: () {
                              _controller.previousPage();
                            },
                            child: Container(
                                height: 25,
                                width: 25,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                    child: Icon(
                                      Icons.arrow_back,
                                      color: Colors.grey,
                                    ))),
                          ),
                        )),
                  if (MediaQuery.of(context).size.width <= 1100)
                    Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: InkWell(
                            onTap: () {
                              _controller.nextPage();
                            },
                            child: Container(
                                height: 25,
                                width: 25,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                    child: Icon(
                                      Icons.arrow_forward,
                                      color: Colors.grey,
                                    ))),
                          ),
                        )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
