import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coupon_uikit/coupon_uikit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_web/model/coupon.dart';

import 'package:user_web/constant.dart';

class AvailableCouponsWidget extends StatefulWidget {
  final Function(String) onCouponSelected;
  const AvailableCouponsWidget({super.key, required this.onCouponSelected});

  @override
  State<AvailableCouponsWidget> createState() => _VoucherWidgetState();
}

class _VoucherWidgetState extends State<AvailableCouponsWidget> {
  List<CouponModel> products = [];
  List<CouponModel> availableCoupons = [];
  List<CouponModel> expiredCoupons = [];
  List<CouponModel> usedCoupons = [];
  bool isLoaded = false;
  int userOrderCount = 0;



  getProducts() async {
    setState(() {
      isLoaded = true;
    });

    final userID = FirebaseAuth.instance.currentUser?.uid;
    if (userID == null) return;

    try {
      // First get all user orders
      final ordersSnapshot = await FirebaseFirestore.instance
          .collection('Orders')
          .where('userID', isEqualTo: userID)
          .get();

      // Then filter out cancelled orders locally
      final validOrders = ordersSnapshot.docs.where((doc) {
        final orderStatus = doc['status']?.toString().toLowerCase() ?? '';
        return orderStatus != 'cancelled';
      }).toList();

      final orderCount = validOrders.length;
      print("User has $orderCount orders"); // Debug print

      // Set to store coupons used in valid (non-cancelled) orders
      final Set<String> actuallyUsedCoupons = {};

      for (var doc in validOrders) {
        final couponTitle = doc['couponTitle']?.toString() ?? '';
        if (couponTitle.isNotEmpty) {
          actuallyUsedCoupons.add(couponTitle);
        }
      }

      print("Used coupons: ${actuallyUsedCoupons.join(', ')}"); // Debug print

      FirebaseFirestore.instance.collection('Coupons').snapshots().listen((event) {
        print("Found ${event.docs.length} coupons in database"); // Debug print

        setState(() {
          isLoaded = false;
          userOrderCount = orderCount;
        });

        products.clear();
        availableCoupons.clear();
        expiredCoupons.clear();
        usedCoupons.clear();

        final now = DateTime.now();

        for (var element in event.docs) {
          var prods = CouponModel.fromMap(element.data(), element.id);

          final title = prods.title ?? '';
          if (title != "New User" && title != "First Order") {
            continue; // Skip all other coupons
          }

          products.add(prods);

          print("Processing coupon: ${prods.title}"); // Debug print


          if (prods.validTo != null && prods.validTo!.isBefore(now)) {
            print("Coupon ${prods.title} is expired"); // Debug print
            expiredCoupons.add(prods);
          } else if (actuallyUsedCoupons.contains(title)) {
            print("Coupon ${prods.title} is already used"); // Debug print
            usedCoupons.add(prods);
          } else {
            // Special handling for "First Order" coupon
            if (title == "First Order") {
              if (orderCount >= 1) {
                availableCoupons.add(prods);
              }
            }
            // "New User" coupon
            else if (title == "New User") {
              availableCoupons.add(prods);
            }
          }
        }

        print("Available coupons: ${availableCoupons.length}"); // Debug print
        print("Expired coupons: ${expiredCoupons.length}"); // Debug print
        print("Used coupons: ${usedCoupons.length}"); // Debug print

        setState(() {});
      });
    } catch (e) {
      print("Error loading coupons: $e");
      setState(() {
        isLoaded = false;
      });
    }
  }



  @override
  void initState() {
    getProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Colors.white;
    Color secondaryColor = appColor;

    return DefaultTabController(
      length: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TabBar(
            // labelColor: Colors.black,
            // unselectedLabelColor: Colors.grey,
            // indicatorColor: Colors.black,
            labelStyle: TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
            unselectedLabelStyle: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16
            ),
            tabs: [
              Tab(text: 'Available',),
            ],
          ),
          SizedBox(
            height: 350,
            child: isLoaded
                ? ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Card(
                    elevation: 2.0,
                    margin: MediaQuery.of(context).size.width >= 1100
                        ? const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0)
                        : const EdgeInsets.all(10),
                    child: Container(
                      height: 150.0,
                      // color: Colors.white,
                    ),
                  ),
                );
              },
            )
                : products.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.card_giftcard_rounded,
                    color: appColor,
                    size: MediaQuery.of(context).size.width >= 1100
                        ? MediaQuery.of(context).size.width / 5.5
                        : MediaQuery.of(context).size.width / 2,
                  ),
                  const Gap(20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const BeveledRectangleBorder(),
                      backgroundColor: appColor,
                    ),
                    onPressed: () {
                      context.go('/restaurant');
                    },
                    child: const Text(
                      'Continue Shopping',
                      style: TextStyle(
                          // color: Colors.white
                      ),
                    ).tr(),
                  ),
                ],
              ),
            )
                : TabBarView(
              children: [
                // Available
                ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: availableCoupons.length,
                  itemBuilder: (context, index) {
                    final cartModel = availableCoupons[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CouponCard(
                        height: MediaQuery.of(context).size.width >= 1100
                            ? 130
                            : 110,
                        // backgroundColor: primaryColor,
                        clockwise: true,
                        curvePosition: 135,
                        curveRadius: 30,
                        curveAxis: Axis.vertical,
                        borderRadius: 10,
                        firstChild: Container(
                          decoration:  BoxDecoration(
                              border: Border.all(
                                  color: appColor,
                                  width: 1.0
                              ),
                              color: secondaryColor),
                          child: Column(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '${cartModel.percentage}%',
                                        style: const TextStyle(
                                          color: Colors.black87,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Text(
                                        'OFF',
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ).tr(),
                                    ],
                                  ),
                                ),
                              ),
                              const Divider(
                                  color: Colors.grey, height: 0),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    cartModel.title!,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        secondChild: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: appColor,
                                width: 1.0,
                              )
                          ),
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Coupon Code',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  // color: Colors.black54,
                                ),
                              ).tr(),
                              const SizedBox(height: 4),
                              InkWell(
                                onTap: () {
                                  widget.onCouponSelected(cartModel.coupon); // Send code back to Checkout
                                  Navigator.of(context).pop(); // Close endDrawer
                                },
                                child: Text(
                                  cartModel.coupon,
                                  style:  TextStyle(
                                    fontSize: 20,
                                    // color: secondaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const Spacer(),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),

                // Used
                // usedCoupons.isEmpty
                //     ? const Center(child: Text("No Used Coupons"))
                //     : ListView.builder(
                //   physics: const BouncingScrollPhysics(),
                //   itemCount: usedCoupons.length,
                //   itemBuilder: (context, index) {
                //     final cartModel = usedCoupons[index];
                //     return Padding(
                //       padding: const EdgeInsets.all(8.0),
                //       child: CouponCard(
                //         height: MediaQuery.of(context).size.width >= 1100 ? 200 : 150,
                //         backgroundColor: primaryColor,
                //         clockwise: true,
                //         curvePosition: 135,
                //         curveRadius: 30,
                //         curveAxis: Axis.vertical,
                //         borderRadius: 10,
                //         firstChild: Container(
                //           decoration:  BoxDecoration(
                //               color: secondaryColor,
                //               border: Border.all(color: appColor,width: 1)
                //           ),
                //           child: Column(
                //             mainAxisAlignment: MainAxisAlignment.center,
                //             children: [
                //               Expanded(
                //                 child: Center(
                //                   child: Column(
                //                     mainAxisSize: MainAxisSize.min,
                //                     children: [
                //                       Text(
                //                         '${cartModel.percentage}%',
                //                         style: const TextStyle(
                //                           color: Colors.white,
                //                           fontSize: 24,
                //                           fontWeight: FontWeight.bold,
                //                         ),
                //                       ),
                //                       const Text(
                //                         'OFF',
                //                         style: TextStyle(
                //                           color: Colors.white,
                //                           fontSize: 16,
                //                           fontWeight: FontWeight.bold,
                //                         ),
                //                       ).tr(),
                //                     ],
                //                   ),
                //                 ),
                //               ),
                //               const Divider(color: Colors.white54, height: 0),
                //               Expanded(
                //                 child: Center(
                //                   child: Text(
                //                     cartModel.title!,
                //                     textAlign: TextAlign.center,
                //                     style: const TextStyle(
                //                       color: Colors.white,
                //                       fontSize: 12,
                //                       fontWeight: FontWeight.bold,
                //                     ),
                //                   ),
                //                 ),
                //               ),
                //             ],
                //           ),
                //         ),
                //         secondChild: Container(
                //           width: double.infinity,
                //           decoration: BoxDecoration(
                //               border: Border.all(
                //                   color: appColor,
                //                   width: 1
                //               )
                //           ),
                //           padding: const EdgeInsets.all(18),
                //           child: Column(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [
                //               const Text(
                //                 'Coupon Code',
                //                 style: TextStyle(
                //                   fontSize: 13,
                //                   fontWeight: FontWeight.bold,
                //                   color: Colors.black54,
                //                 ),
                //               ).tr(),
                //               const SizedBox(height: 4),
                //               InkWell(
                //                 onTap: () {
                //                   FlutterClipboard.copy(cartModel.coupon)
                //                       .then((value) => print('copied'));
                //                   Fluttertoast.showToast(
                //                     msg: "Coupon code has been copied".tr(),
                //                     gravity: ToastGravity.TOP,
                //                     fontSize: 14.0,
                //                   );
                //                 },
                //                 child: Text(
                //                   cartModel.coupon,
                //                   style:  TextStyle(
                //                     fontSize: 24,
                //                     color: secondaryColor,
                //                     fontWeight: FontWeight.bold,
                //                   ),
                //                 ),
                //               ),
                //               const Spacer(),
                //             ],
                //           ),
                //         ),
                //       ),
                //     );
                //   },
                // ),
                // Expired
                // expiredCoupons.isEmpty
                //     ? const Center(child: Text("No Expired Coupons"))
                //     : ListView.builder(
                //   physics: const BouncingScrollPhysics(),
                //   itemCount: expiredCoupons.length,
                //   itemBuilder: (context, index) {
                //     final cartModel = expiredCoupons[index];
                //     return Padding(
                //       padding: const EdgeInsets.all(8.0),
                //       child: CouponCard(
                //         height:
                //         MediaQuery.of(context).size.width >=
                //             1100
                //             ? 200
                //             : 150,
                //         backgroundColor: primaryColor,
                //         clockwise: true,
                //         curvePosition: 135,
                //         curveRadius: 30,
                //         curveAxis: Axis.vertical,
                //         borderRadius: 10,
                //         firstChild: Container(
                //           decoration:  BoxDecoration(
                //               color: secondaryColor,
                //               border: Border.all(color: appColor,width: 1)
                //           ),
                //           child: Column(
                //             mainAxisAlignment:
                //             MainAxisAlignment.center,
                //             children: [
                //               Expanded(
                //                 child: Center(
                //                   child: Column(
                //                     mainAxisSize:
                //                     MainAxisSize.min,
                //                     children: [
                //                       Text(
                //                         '${cartModel.percentage}%',
                //                         style: const TextStyle(
                //                           color: Colors.white,
                //                           fontSize: 24,
                //                           fontWeight:
                //                           FontWeight.bold,
                //                         ),
                //                       ),
                //                       const Text(
                //                         'OFF',
                //                         style: TextStyle(
                //                           color: Colors.white,
                //                           fontSize: 16,
                //                           fontWeight:
                //                           FontWeight.bold,
                //                         ),
                //                       ).tr(),
                //                     ],
                //                   ),
                //                 ),
                //               ),
                //               const Divider(
                //                   color: Colors.white54,
                //                   height: 0),
                //               Expanded(
                //                 child: Center(
                //                   child: Text(
                //                     cartModel.title!,
                //                     textAlign: TextAlign.center,
                //                     style: const TextStyle(
                //                       color: Colors.white,
                //                       fontSize: 12,
                //                       fontWeight:
                //                       FontWeight.bold,
                //                     ),
                //                   ),
                //                 ),
                //               ),
                //             ],
                //           ),
                //         ),
                //         secondChild: Container(
                //           width: double.infinity,
                //           decoration: BoxDecoration(
                //               border: Border.all(color: appColor,width: 1)
                //           ),
                //           padding: const EdgeInsets.all(18),
                //           child: Column(
                //             crossAxisAlignment:
                //             CrossAxisAlignment.start,
                //             children: [
                //               const Text(
                //                 'Coupon Code',
                //                 style: TextStyle(
                //                   fontSize: 13,
                //                   fontWeight: FontWeight.bold,
                //                   color: Colors.black54,
                //                 ),
                //               ).tr(),
                //               const SizedBox(height: 4),
                //               InkWell(
                //                 onTap: () {
                //                   FlutterClipboard.copy(
                //                       cartModel.coupon)
                //                       .then((value) =>
                //                       print('copied'));
                //                   Fluttertoast.showToast(
                //                     msg:
                //                     "Coupon code has been copied"
                //                         .tr(),
                //                     gravity: ToastGravity.TOP,
                //                     fontSize: 14.0,
                //                   );
                //                 },
                //                 child: Text(
                //                   cartModel.coupon,
                //                   style:  TextStyle(
                //                     fontSize: 24,
                //                     color: secondaryColor,
                //                     fontWeight: FontWeight.bold,
                //                   ),
                //                 ),
                //               ),
                //               const Spacer(),
                //             ],
                //           ),
                //         ),
                //       ),
                //     );
                //   },
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

