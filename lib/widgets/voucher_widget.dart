import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coupon_uikit/coupon_uikit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_web/model/coupon.dart';

import 'package:user_web/constant.dart';

import '../model/reward_points_model.dart';
import '../providers/reward_points_provider.dart';

class VoucherWidget extends ConsumerStatefulWidget {
  const VoucherWidget({super.key});

  @override
  ConsumerState<VoucherWidget> createState() => _VoucherWidgetState();
}

class _VoucherWidgetState extends ConsumerState<VoucherWidget> {

  List<CouponModel> products = [];
  List<CouponModel> availableCoupons = [];
  List<CouponModel> expiredCoupons = [];
  List<CouponModel> usedCoupons = [];
  bool isLoaded = false;
  List<QueryDocumentSnapshot> redeemedPointsHistory = [];
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




  void loadRedeemedPointsHistory() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final redeemedSnapshot = await FirebaseFirestore.instance
          .collection('RedeemedPoints')
          .where('userId', isEqualTo: user.uid)
          .orderBy('timestamp', descending: true)
          .get();

      setState(() {
        redeemedPointsHistory = redeemedSnapshot.docs;
      });
    } catch (e) {
      debugPrint('Error loading redeemed points history: $e');
    }
  }

  @override
  void initState() {
    getProducts();
    loadRedeemedPointsHistory();

    // Load reward points when widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = ref.read(rewardPointsProvider.notifier);
      notifier.listenRewardPoints();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
     Color primaryColor = Colors.white;
     Color secondaryColor = appColor;

     final rewardState = ref.watch(rewardPointsProvider);

    return DefaultTabController(
      length: 3,
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
                Tab(text: 'Used'),
                Tab(text: 'Expired'),
              ],
            ),
          SizedBox(
            height: 600,
            child: isLoaded
                ? ListView.builder(
              physics: const ClampingScrollPhysics(),
              itemCount: 10,
              itemBuilder: (context, index) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Card(
                    elevation: 2.0,
                    color: AdaptiveTheme.of(context).mode.isDark == true
                        ? Colors.black87
                        : Colors.white,
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
                : products.isEmpty && rewardState.availablePoints == 0
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.card_giftcard_rounded,
                    color: appColor,
                    size: MediaQuery.of(context).size.width >= 1100
                        ? MediaQuery.of(context).size.width / 5
                        : MediaQuery.of(context).size.width / 1.5,
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
                      style: TextStyle(color: Colors.white),
                    ).tr(),
                  ),
                ],
              ),
            )
                : TabBarView(
              children: [
                // Available Tab - Now includes Reward Points
                _buildAvailableTab(rewardState),

                // Used Tab - Now includes Redeemed Points
                _buildUsedTab(),

                // Expired
                expiredCoupons.isEmpty
                    ? const Center(child: Text("No Expired Coupons"))
                    : ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  itemCount: expiredCoupons.length,
                  itemBuilder: (context, index) {
                    final cartModel = expiredCoupons[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CouponCard(
                        height:
                        MediaQuery.of(context).size.width >=
                            1100
                            ? 200
                            : 150,
                        // backgroundColor: primaryColor,
                        clockwise: true,
                        curvePosition: 135,
                        curveRadius: 30,
                        curveAxis: Axis.vertical,
                        borderRadius: 10,
                        firstChild: Container(
                          decoration:  BoxDecoration(
                              color: appColor,
                            border: Border.all(color: appColor,width: 1)
                          ),
                          child: Column(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Center(
                                  child: Column(
                                    mainAxisSize:
                                    MainAxisSize.min,
                                    children: [
                                      Text(
                                        '${cartModel.percentage}%',
                                        style: const TextStyle(
                                          color: Colors.black87,
                                          fontSize: 24,
                                          fontWeight:
                                          FontWeight.bold,
                                        ),
                                      ),
                                      const Text(
                                        'OFF',
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 16,
                                          fontWeight:
                                          FontWeight.bold,
                                        ),
                                      ).tr(),
                                    ],
                                  ),
                                ),
                              ),
                              const Divider(
                                  color: Colors.white54,
                                  height: 0),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    cartModel.title!,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 12,
                                      fontWeight:
                                      FontWeight.bold,
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
                            border: Border.all(color: appColor,width: 1)
                          ),
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Coupon Code',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  // color: Colors.black54,
                                ),
                              ).tr(),
                              const SizedBox(height: 4),
                              InkWell(
                                onTap: () {
                                  // FlutterClipboard.copy(
                                  //     cartModel.coupon)
                                  //     .then((value) =>
                                  //     print('copied'));
                                  // Fluttertoast.showToast(
                                  //   msg:
                                  //   "Coupon code has been copied"
                                  //       .tr(),
                                  //   gravity: ToastGravity.TOP,
                                  //   fontSize: 14.0,
                                  //   timeInSecForIosWeb: 5,
                                  //   backgroundColor: Colors.grey.shade300,
                                  //   textColor: Colors.black,
                                  //   webBgColor: "#D3D3D3",
                                  //   webPosition: "center",
                                  // );
                                },
                                child: Text(
                                  cartModel.coupon,
                                  style:  TextStyle(
                                    fontSize: 24,
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
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildAvailableTab(RewardPointsState rewardState) {
    return ListView(
      physics: const ClampingScrollPhysics(),
      children: [
        // Reward Points Card (displayed first in Available tab)
        if (rewardState.availablePoints > 0)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4,
              // color: Colors.white,
              color: AdaptiveTheme.of(context).mode.isDark == true
                  ? Colors.black87
                  : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: appColor.withOpacity(0.3), width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.stars, color: Colors.amber, size: 24),
                        SizedBox(width: 8),
                        Text(
                          'Reward Points',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            // color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Available Points',
                              style: TextStyle(
                                fontSize: 14,
                                // color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              '${rewardState.availablePoints}',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: appColor,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Redeemable Amount',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              '\$${rewardState.redeemableAmount}',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (rewardState.availablePoints >= 1000)
                      Text(
                        'You can redeem \$${rewardState.redeemableAmount} on your next purchase!',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.green[700],
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    else
                      Text(
                        'You need ${1000 - rewardState.availablePoints} more points to redeem (\$10 minimum)',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

        // Available Coupons
        if (availableCoupons.isNotEmpty)
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
          //   child: Text(
          //     'Available Coupons',
          //     style: TextStyle(
          //       fontSize: 18,
          //       fontWeight: FontWeight.bold,
          //     ),
          //   ),
          // ),

        // List of available coupons
        ...availableCoupons.map((cartModel) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: CouponCard(
              height: MediaQuery.of(context).size.width >= 1100 ? 200 : 150,
              // backgroundColor: Colors.white,
              clockwise: true,
              curvePosition: 135,
              curveRadius: 30,
              curveAxis: Axis.vertical,
              borderRadius: 10,
              firstChild: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        color: appColor,
                        width: 1.0
                    ),
                    color: appColor),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                                fontSize: 24,
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
                    const Divider(color: Colors.grey, height: 0),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Coupon Code',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        // color: Colors.black54,
                      ),
                    ).tr(),
                    const SizedBox(height: 4),
                    InkWell(
                      onTap: () {
                        FlutterClipboard.copy(cartModel.coupon).then(
                                (value) => print('copied'));
                        Fluttertoast.showToast(
                          msg: "Coupon code has been copied".tr(),
                          gravity: ToastGravity.TOP,
                          fontSize: 14.0,
                          backgroundColor: Colors.grey.shade300,
                          textColor: Colors.black,
                          timeInSecForIosWeb: 5,
                          webBgColor: "#D3D3D3",
                          webPosition: "center",
                        );
                      },
                      child: Text(
                        cartModel.coupon,
                        style: TextStyle(
                          fontSize: 24,
                          // color: appColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    if (cartModel.validTo != null)
                      Text(
                        'Valid until ${DateFormat('MMM dd, yyyy').format(cartModel.validTo!)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),

        // Message if no coupons available
        if (availableCoupons.isEmpty && rewardState.availablePoints == 0)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.card_giftcard, size: 64,
                    // color: Colors.grey
                ),
                SizedBox(height: 16),
                Text(
                  'No available coupons or reward points',
                  style: TextStyle(),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildUsedTab() {
    return ListView(
      physics: const ClampingScrollPhysics(),
      children: [
        // Redeemed Points Section
        if (redeemedPointsHistory.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4,
              color: AdaptiveTheme.of(context).mode.isDark == true
                  ? Colors.black87
                  : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.green.withOpacity(0.3), width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.history, color: Colors.green, size: 24),
                        SizedBox(width: 8),
                        Text(
                          'Redeemed Points History',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ...redeemedPointsHistory.map((doc) {
                      final points = doc['points'] as int;
                      final dollarAmount = doc['dollarAmount'] as int;
                      final timestamp = doc['timestamp'] as Timestamp;
                      final orderId = doc['orderId'] as String?;

                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(Icons.currency_exchange, color: Colors.green),
                        title: Text('Redeemed \$$dollarAmount'),
                        subtitle: Text(
                          '${points} points • ${DateFormat.yMMMd().format(timestamp.toDate())}',
                        ),
                        trailing: orderId != null
                            ? Text('Order #${orderId.substring(0, 8)}')
                            : null,
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
          ),

        // Used Coupons Section
        if (usedCoupons.isNotEmpty)
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
          //   child: Text(
          //     'Used Coupons',
          //     style: TextStyle(
          //       fontSize: 18,
          //       fontWeight: FontWeight.bold,
          //     ),
          //   ),
          // ),

        // List of used coupons
        ...usedCoupons.map((cartModel) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: CouponCard(
              height: MediaQuery.of(context).size.width >= 1100 ? 200 : 150,
              // backgroundColor: Colors.white,
              clockwise: true,
              curvePosition: 135,
              curveRadius: 30,
              curveAxis: Axis.vertical,
              borderRadius: 10,
              firstChild: Container(
                decoration: BoxDecoration(
                    color: appColor, // Different color for used
                    border: Border.all(color:appColor, width: 1)
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                                fontSize: 24,
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
                    const Divider(color: Colors.white54, height: 0),
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
                        width: 1
                    )
                ),
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Used Coupon',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ).tr(),
                    const SizedBox(height: 4),
                    Text(
                      cartModel.coupon,
                      style: TextStyle(
                        fontSize: 24,
                        // color: appColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          );
        }).toList(),

        // Message if nothing is used
        if (usedCoupons.isEmpty && redeemedPointsHistory.isEmpty)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.history, size: 64,
                    // color: Colors.grey
                ),
                SizedBox(height: 16),
                Text(
                  'No used coupons or redeemed points',
                  style: TextStyle(),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

