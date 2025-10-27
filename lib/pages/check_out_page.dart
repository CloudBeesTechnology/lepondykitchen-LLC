import 'dart:math';
import 'dart:typed_data';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:isoweek/isoweek.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_web/model/cart_model.dart';
import 'package:user_web/model/formatter.dart';
import 'package:user_web/model/order_model.dart';
import 'package:user_web/model/pickup_address_model.dart';
import 'package:user_web/providers/delivery_detail_provider.dart';
import 'package:user_web/widgets/cat_image_widget.dart';
import 'package:user_web/constant.dart';
import 'package:user_web/providers/checkout_provider.dart';
import 'package:user_web/providers/currency_provider.dart';
import 'package:user_web/widgets/schedule_time_picker.dart';
import 'package:uuid/uuid.dart';
import '../providers/coupon_detail_provider.dart';
import '../providers/restuarant_providers/restaurant_cart_storage_provider.dart';
import '../providers/restuarant_providers/restaurant_carts_state_provider.dart';
import '../providers/reward_points_provider.dart';
import '../widgets/available_coupons_widget.dart';
import '../widgets/voucher_widget.dart';
import 'delivery_address_page2.dart';

class CheckoutPage extends ConsumerStatefulWidget {
  final String module;
  const CheckoutPage({super.key, required this.module});

  @override
  ConsumerState<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends ConsumerState<CheckoutPage> {
  String selectedDelivery = 'Pickup';
  String pickupAddress = '';
  String pickupPhone = '';
  String pickupStorename = '';
  String vendorModule='';
  num total = 0;
  String? selectedPayment = 'Cash On Delivery';
  num couponPercentage = 0;
  String couponTitle = '';
  String userID = '';
  List<Map<String, dynamic>> orders = [];
  String uid = '';
  String couponCode = '';
  String scheduleDate = '';
  String scheduleTime = '';
  bool isSchedule = false;
  bool isPrescription = false;
  String prescriptionImage = '';
  bool isCouponApplied = false;
  Uint8List? imageFile;
  bool isRedeemingPoints = false;
  int pointsToRedeem = 0;
  final TextEditingController couponController = TextEditingController();



  @override
  void initState() {
    var uuid = const Uuid();
    uid = uuid.v1();
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user != null) {
      userID = user.uid;
    } else {
      // Handle unauthenticated user case
    }

    // getCashOnDelivery();
    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldHome = GlobalKey<ScaffoldState>();
  List<PickupAddressModel> pickupAddresses = [];
  @override
  Widget build(BuildContext context) {
    var clearRestaurantCart =
    ref.read(cartStorageRestaurantProviderProvider.notifier);
    final cartPriceQuantity = ref.watch(cartStateRestaurantProvider);
    // var checkOutProducts =
    // ref.watch(getCheckoutProductsProvider(widget.module == 'Ecommerce'
    //     ? 'Cart'
    //     : widget.module == 'Restaurant'
    //     ? 'Restaurant Cart'
    //     : widget.module == 'Pharmacy'
    //     ? 'Pharmacy Cart'
    //     : 'Grocery Cart'));

    final cartItems = ref.watch(cartStorageRestaurantProviderProvider);
    final checkOutProducts = cartItems.where((item) => item.module == widget.module).toList();


    if (checkOutProducts.isNotEmpty) {
      isPrescription = checkOutProducts.any((p) => p.isPrescription!);
    }

    var currencySymbol = ref.watch(currencySymbolProvider).value;
    final deliveryFee = ref.watch(getDeliveryFeeProvider).value ?? 0;
    final deliveryDetails = ref.watch(deliveryDetailsNotifierProvider).value;
    // final cashOnDelivery = ref.watch(getCashOnDeliveryProvider).value;
    final isCouponActive = ref.watch(getCouponStatusProvider).value;
    final wallet = ref.watch(getWalletProvider).value;

    final rewardState = ref.watch(rewardPointsProvider);

    // pickupAddresses = ref.watch(getPickUpAddressProvider(checkOutProducts.isNotEmpty ? checkOutProducts[0].vendorId : '')).valueOrNull ?? [];
    // debugPrint('Pickup Addresses: $pickupAddresses');

    final vendorId = checkOutProducts.isNotEmpty ? checkOutProducts.first.vendorId : '';

// This returns a List<PickupAddressModel>
    final vendorDetailsList = ref.watch(getPickUpAddressProvider(vendorId)).valueOrNull ?? [];

// Get the first item from the list
    final vendorDetails = vendorDetailsList.isNotEmpty ? vendorDetailsList.first : null;


    // ✅ CORRECT: Use the SINGLE vendorDetails object
    if (vendorDetails != null && pickupAddress.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            pickupAddress = vendorDetails.address;
            pickupPhone = vendorDetails.phonenumber; // Use phonenumber (model field name)
            pickupStorename = vendorDetails.storename; // Use storename (model field name)
            vendorModule = vendorDetails.module;
            debugPrint('$vendorModule');
          });
        }
      });
    }




    // if (wallet != null) {
    //   total = cartPriceQuantity.price +
    //       (selectedDelivery == 'Delivery' ? deliveryFee : 0) -
    //       getPercentageOfCoupon(couponPercentage, total);
    // }


    // if (wallet != null) {
      // total = cartPriceQuantity.price +
      //     (selectedDelivery == 'Delivery' ? deliveryFee : 0) -
      //     getPercentageOfCoupon(couponPercentage, total) -
      //     rewardState.pendingRedemptionAmount;
    // }

      final subtotal = cartPriceQuantity.price;

    final discount = isCouponApplied ? (subtotal * (couponPercentage / 100)) : 0.0;
    final redeemed = rewardState.pendingRedemptionAmount;

    total = (subtotal - discount - redeemed);

    bool  isCouponCodeEmpty = couponCode.isEmpty;



    return Scaffold(
      key: _scaffoldHome,
      drawerEnableOpenDragGesture: false,
      endDrawerEnableOpenDragGesture: false,

      // LEFT SIDE DRAWER - Pickup Address
      // drawer: selectedDelivery != 'Pickup'
      //     ? null
      //     : Drawer(
      //   shape: const ContinuousRectangleBorder(
      //       borderRadius: BorderRadius.all(Radius.zero)),
      //   width: MediaQuery.of(context).size.width >= 1100
      //       ? MediaQuery.of(context).size.width / 3
      //       : double.infinity,
      //   child: SingleChildScrollView(
      //     child: Column(
      //       children: [
      //         const Gap(10),
      //         Padding(
      //           padding: const EdgeInsets.all(8.0),
      //           child: Row(
      //             children: [
      //               const Text(
      //                 "Pickup Addresses",
      //                 style: TextStyle(
      //                     fontFamily: 'Nunito',
      //                     fontSize: 18,
      //                     fontWeight: FontWeight.bold),
      //               ).tr(),
      //             ],
      //           ),
      //         ),
      //         ListView.builder(
      //             itemCount: pickupAddresses.length,
      //             shrinkWrap: true,
      //             itemBuilder: (context, index) {
      //               PickupAddressModel pickupAddressModel =
      //               pickupAddresses[index];
      //               return Padding(
      //                 padding: const EdgeInsets.all(8.0),
      //                 child: InkWell(
      //                   onTap: () {
      //                     setState(() {
      //                       pickupAddress = pickupAddressModel.address;
      //                       pickupPhone = pickupAddressModel.phonenumber;
      //                       pickupStorename =
      //                           pickupAddressModel.storename;
      //                     });
      //                     Navigator.pop(context); // closes drawer
      //                   },
      //                   child: Container(
      //                     decoration: BoxDecoration(
      //                         border: Border.all(),
      //                         borderRadius:
      //                         const BorderRadius.all(Radius.circular(5))),
      //                     child: Column(
      //                       children: [
      //                         const Divider(
      //                             color: Color.fromARGB(255, 236, 227, 227)),
      //                         const Gap(10),
      //                         ListTile(
      //                           visualDensity:
      //                           const VisualDensity(vertical: -4),
      //                           title: Text(pickupAddressModel.storename),
      //                           leading: const Icon(Icons.home),
      //                         ),
      //                         ListTile(
      //                           visualDensity:
      //                           const VisualDensity(vertical: -4),
      //                           title: Text(pickupAddressModel.address),
      //                           leading: const Icon(Icons.room),
      //                         ),
      //                         ListTile(
      //                           visualDensity:
      //                           const VisualDensity(vertical: -4),
      //                           title: Text(pickupAddressModel.phonenumber),
      //                           leading: const Icon(Icons.phone),
      //                         )
      //                       ],
      //                     ),
      //                   ),
      //                 ),
      //               );
      //             })
      //       ],
      //     ),
      //   ),
      // ),
      // RIGHT SIDE DRAWER - Coupon
      endDrawer: Drawer(
        // backgroundColor: const Color(0xFFDF7EB).withOpacity(1.0),
        backgroundColor: AdaptiveTheme.of(context).mode.isDark == true
            ? null
            :  Color(0xFFDF7EB).withOpacity(1.0),
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(Radius.zero),
        ),
        width: MediaQuery.of(context).size.width >= 1100
            ? MediaQuery.of(context).size.width / 3
            : double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              // Close button aligned to the end
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon:  Icon(Icons.close,color: appColor,),
                      onPressed: () {
                        Navigator.of(context).pop(); // closes the drawer
                      },
                    ),
                  ],
                ),
              ),
              AvailableCouponsWidget(
                onCouponSelected: (selectedCode) async {

                  if (isCouponApplied) {
                    // Fluttertoast.showToast(
                    //   msg: "Please remove current coupon first",
                    //   toastLength: Toast.LENGTH_SHORT,
                    //   gravity: ToastGravity.TOP,
                    //   backgroundColor: const Color(0xFFFFD581),
                    //   textColor: Colors.black,
                    //   webBgColor: "#FFD581",
                    //   webPosition: "center",
                    //   timeInSecForIosWeb: 3,
                    //   fontSize: 14.0,
                    // );
                    return;
                  }

                  couponController.text = selectedCode;
                  setState(() {
                    couponCode = selectedCode;
                  });

                  final couponDetails = await ref.read(couponNotifierProvider(selectedCode).future);

                  if (couponDetails != null) {
                    setState(() {
                      couponPercentage = couponDetails.percentage;
                      couponTitle = couponDetails.title;
                      isCouponApplied = true;
                    });
                  } else {
                    // If invalid
                    couponController.clear();
                    setState(() {
                      couponCode = '';
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        actions: [Container()],
        // backgroundColor: Color(0xCCCCCC).withOpacity(1.0),
        backgroundColor: AdaptiveTheme.of(context).mode.isDark == true
            ? null : Color(0xCCCCCC).withOpacity(1.0),
        automaticallyImplyLeading: false,
        elevation: 5,
        leadingWidth: MediaQuery.of(context).size.width >= 1100 ? 150 : 100,
        leading: IconButton(
            onPressed: (){
              context.go('/restaurant');
            },
            icon: Icon(Icons.arrow_back)
        ),
        title: const Text(
          'Checkout',
          style:
          TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Nunito'),
        ),
        centerTitle: true,
      ),
      // backgroundColor: Color(0xFFDF7EB).withOpacity(1.0),
      backgroundColor: AdaptiveTheme.of(context).mode.isDark == true
          ? null :     Color(0xFFDF7EB).withOpacity(1.0),
      body: wallet == null
          ? MediaQuery.of(context).size.width >= 1100
          ? Padding(
        padding: const EdgeInsets.only(left: 100),
        child: Column(
          children: [
            const Gap(50),
            Row(
              children: [
                Expanded(
                  flex: 4,
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
                            color: Colors
                                .grey, // Set the color as needed
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
                            color: Colors
                                .grey, // Set the color as needed
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
                            color: Colors
                                .grey, // Set the color as needed
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 250, // Set the width as needed
                            height: 15, // Set the height as needed
                            color: Colors
                                .grey, // Set the color as needed
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 290, // Set the width as needed
                            height: 15, // Set the height as needed
                            color: Colors
                                .grey, // Set the color as needed
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(20),
                Expanded(
                  flex: 6,
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
                            width: 400, // Set the width as needed
                            height: 15, // Set the height as needed
                            color: Colors
                                .grey, // Set the color as needed
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 600, // Set the width as needed
                            height: 14, // Set the height as needed
                            color: Colors
                                .grey, // Set the color as needed
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 700, // Set the width as needed
                            height: 15, // Set the height as needed
                            color: Colors
                                .grey, // Set the color as needed
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 500, // Set the width as needed
                            height: 15, // Set the height as needed
                            color: Colors
                                .grey, // Set the color as needed
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 290, // Set the width as needed
                            height: 15, // Set the height as needed
                            color: Colors
                                .grey, // Set the color as needed
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      )
          : Padding(
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
                  width: 400, // Set the width as needed
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
                  width: 600, // Set the width as needed
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
                  width: 700, // Set the width as needed
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
                  width: 500, // Set the width as needed
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
                  width: 290, // Set the width as needed
                  height: 15, // Set the height as needed
                  color: Colors.grey, // Set the color as needed
                ),
              ),
            ),
          ],
        ),
      )
          : MediaQuery.of(context).size.width >= 1100
          ? checkOutProducts.isEmpty
          ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Icon(
              Icons.remove_shopping_cart_outlined,
              color: appColor,
              size: MediaQuery.of(context).size.width >= 1100
                  ? MediaQuery.of(context).size.width / 5
                  : MediaQuery.of(context).size.width / 1.5,
            ),
          ),
          const Gap(20),
          const Text('Cart is empty',style: TextStyle(fontFamily: 'Nunito',fontSize: 16),),
          const Gap(20),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: const BeveledRectangleBorder(),
                  backgroundColor: appColor),
              onPressed: () {
                context.go('/restaurant');
              },
              child: const Text(
                'Continue Shopping',
                style: TextStyle(
                    // color: Colors.white,
                    fontFamily: 'Nunito'),
              ).tr())
        ],
      )
          : Padding(
        padding: const EdgeInsets.only(left: 100),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // const Gap(10),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: appColor, // Your yellow color
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Main free shipping message
                            const Text(
                              'Free Delivery for All in/Around Columbus,ohio',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            // Additional charges note
                            Text(
                              '(Thanks for your valuable Orders ...) ',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Gap(15),
                    Card(
                      shape: const BeveledRectangleBorder(),
                      color:
                      AdaptiveTheme.of(context).mode.isDark ==
                          true
                          ? Colors.black
                          : Colors.white,
                      surfaceTintColor: Colors.white,
                      child: Column(
                        children: [
                          ListTile(
                            leading: Container(
                              height: 25,
                              width: 25,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: appColor),
                              child: const Center(
                                child: Icon(
                                  Icons.done,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                            title: const Text(
                              '1. CHOOSE DELIVERY OPTION',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,fontFamily: 'Nunito'),
                            ).tr(),
                          ),
                          if (vendorModule == 'Grocery') ...[
                          Container(
                            // height: 255,
                            color: selectedDelivery == 'Delivery'
                                ?  AdaptiveTheme.of(context)
                                    .mode
                                    .isDark ==
                                    true
                                ? Colors.grey.shade900
                                : const Color(0xF6F6F6).withOpacity(1.0) :  AdaptiveTheme.of(context)
                                .mode
                                .isDark ==
                                true ? Colors.black38 :Colors.white,
                            child: Padding(
                              padding:
                              const EdgeInsets.only(left: 30,top: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RadioListTile(
                                      secondary: InkWell(
                                        onTap: () {
                                          // context.go('/delivery-addresses');
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=> DeliveryAddressPages2()));
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                          decoration: BoxDecoration(
                                            color:  appColor, // Button yellow like your image
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: const [
                                              Icon(Icons.add,
                                                  color: Colors.black,
                                                  size: 16),
                                              SizedBox(width: 6),
                                              Text(
                                                'Change Delivery Address',
                                                style: TextStyle(
                                                  fontFamily: 'Nunito',
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      value: 'Delivery',
                                      groupValue:
                                      selectedDelivery,
                                      title: Text(
                                        'Deliver to me',
                                        style: TextStyle(
                                            fontFamily:
                                            'Nunito',
                                            // color: selectedDelivery ==
                                            //     'Delivery' &&
                                            //     AdaptiveTheme.of(
                                            //         context)
                                            //         .mode
                                            //         .isDark ==
                                            //         true
                                            //     ? Colors.black
                                            //     : null,
                                            fontWeight: FontWeight.bold),

                                      ).tr(),
                                      onChanged: (v) {
                                        setState(() {
                                          selectedDelivery = v!;
                                          if (selectedPayment == null) {
                                            selectedPayment = 'Cash On Delivery';
                                          }
                                        });
                                      }),
                                  const Gap(20),
                                  if (deliveryDetails!
                                      .deliveryAddress !=
                                      '')
                                    Padding(
                                      padding:
                                      const EdgeInsets.only(
                                          left: 50),
                                      child: Container(
                                        width:
                                        MediaQuery.of(context)
                                            .size
                                            .width /
                                            3,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            const BorderRadius.all(Radius .circular(   5)),
                                            border: Border.all(color: Colors.grey.shade500)),
                                        child: Column(
                                          crossAxisAlignment:  CrossAxisAlignment.start,
                                          children: [
                                            ListTile(
                                              visualDensity:
                                              const VisualDensity(
                                                  vertical:
                                                  -4),
                                              leading:  Icon(
                                                  Icons.room, color: selectedDelivery ==
                                                  'Delivery'
                                                  ? appColor
                                                  : null,),
                                              title: Text(
                                                deliveryDetails
                                                    .deliveryAddress,
                                                style: TextStyle(
                                                    // color: selectedDelivery ==
                                                    //     'Delivery' &&
                                                    //     AdaptiveTheme.of(context).mode.isDark ==
                                                    //         true
                                                    //     ? Colors
                                                    //     .black
                                                    //     : null,
                                                    fontSize: 16,fontFamily: 'Nunito',fontWeight: FontWeight.w500),
                                              ),
                                            ),
                                            ListTile(
                                              visualDensity:
                                              const VisualDensity(
                                                  vertical:
                                                  -4),
                                              leading:  Icon(
                                                  Icons.home, color: selectedDelivery ==
                                                  'Delivery'
                                                  ? appColor
                                                  : null,),
                                              title: Text(
                                                deliveryDetails
                                                    .houseNumber,
                                                style: TextStyle(
                                                    // color: selectedDelivery ==
                                                    //     'Delivery' &&
                                                    //     AdaptiveTheme.of(context).mode.isDark ==
                                                    //         true
                                                    //     ? Colors
                                                    //     .black
                                                    //     : null,
                                                    fontSize: 16,fontFamily: 'Nunito',fontWeight: FontWeight.w500),
                                              ),
                                            ),
                                            ListTile(
                                              visualDensity:
                                              const VisualDensity(
                                                  vertical:
                                                  -4),
                                              leading:  Icon(
                                                  Icons
                                                      .bus_alert, color: selectedDelivery ==
                                                  'Delivery'
                                                  ? appColor
                                                  : null,),
                                              title: Text(
                                                deliveryDetails
                                                    .closestBusStop,
                                                style: TextStyle(
                                                    // color: selectedDelivery ==
                                                    //     'Delivery' &&
                                                    //     AdaptiveTheme.of(context).mode.isDark ==
                                                    //         true
                                                    //     ? Colors
                                                    //     .black
                                                    //     : null,
                                                    fontSize: 16,fontFamily: 'Nunito',fontWeight: FontWeight.w500),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  if (deliveryDetails
                                      .deliveryAddress ==
                                      '')
                                    Padding(
                                      padding:
                                      const EdgeInsets.only(
                                          left: 50),
                                      child: Container(
                                        width:  MediaQuery.of(context).size.width / 3,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            const BorderRadius
                                                .all(Radius
                                                .circular(
                                                5)),
                                            border: Border.all()),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,
                                          children: [
                                            ListTile(
                                              visualDensity:
                                              const VisualDensity(
                                                  vertical:
                                                  -4),
                                              leading:  Icon(
                                                  Icons.room,color: appColor,),
                                              title: Text(
                                                "Tap button to add a delivery address",
                                                style: TextStyle(
                                                    color: selectedDelivery ==
                                                        'Delivery' &&
                                                        AdaptiveTheme.of(context).mode.isDark ==
                                                            true
                                                        ? Colors
                                                        .black
                                                        : null,
                                                    fontSize: 14,fontFamily: 'Nunito'),
                                              ),
                                            ),
                                            const Gap(20),
                                            Padding(
                                              padding:
                                              const EdgeInsets .only( left: 25),
                                              child:
                                              ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                      shape:
                                                      const BeveledRectangleBorder(),
                                                      backgroundColor:appColor),
                                                  onPressed:
                                                      () {
                                                    context.go(
                                                        '/delivery-addresses');
                                                  },
                                                  child:
                                                  const Text(
                                                    "Add a delivery address",
                                                    style: TextStyle(
                                                        color:
                                                        Colors.black,fontFamily: 'Nunito'),
                                                  ).tr()),
                                            ),
                                            const Gap(20),
                                          ],
                                        ),
                                      ),
                                    ),
                                  const Gap(20),
                                  // Padding(
                                  //   padding:
                                  //   const EdgeInsets.only(
                                  //       left: 50),
                                  //   child: Text(
                                  //     // 'Delivery Fee is $currencySymbol${Formatter().converter(deliveryFee.toDouble())}',
                                  //     'Delivery Fee $currencySymbol${deliveryFee.toDouble().toStringAsFixed(2)}',
                                  //     style: TextStyle(
                                  //       // color: selectedDelivery ==
                                  //       //     'Delivery' &&
                                  //       //     AdaptiveTheme.of(
                                  //       //         context)
                                  //       //         .mode
                                  //       //         .isDark ==
                                  //       //         true
                                  //       //     ? Colors.black
                                  //       //     : null,
                                  //       fontWeight: FontWeight.w500,
                                  //       fontSize: 16,
                                  //       fontFamily: 'Nunito',
                                  //     ),
                                  //   ),
                                  // ), //  const Gap(20),
                                ],
                              ),
                            ),
                          ),
                          const Gap(20),
                          ],
                          Container(
                            height: 150,
                            color: selectedDelivery == 'Pickup'
                                ?  AdaptiveTheme.of(context)
                                    .mode
                                    .isDark ==
                                    true
                                ? Colors.grey.shade900
                                : const Color(0xF6F6F6).withOpacity(1.0) :  AdaptiveTheme.of(context)
                                .mode
                                .isDark ==
                                true ?Colors.black :Colors.white,
                            child: Padding(
                              padding:
                              const EdgeInsets.only(left: 50),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  RadioListTile(
                                    value: 'Pickup',
                                    groupValue: selectedDelivery,
                                    title: Text(
                                      'Pickup',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Nunito',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ).tr(),
                                    onChanged: (v) {
                                      setState(() {
                                        selectedDelivery = v!;
                                        if (selectedPayment == null) {
                                          selectedPayment = 'Cash On Delivery';
                                        }
                                      });
                                    },
                                  ),
                                  const Gap(20),
                                  // if (pickupAddress != '')
                                    // Padding(
                                    //   padding:
                                    //   const EdgeInsets.only(
                                    //       left: 50),
                                    //   child: Container(
                                    //     width:
                                    //     MediaQuery.of(context)
                                    //         .size
                                    //         .width /
                                    //         3,
                                    //     decoration: BoxDecoration(
                                    //         borderRadius:
                                    //         const BorderRadius
                                    //             .all(Radius
                                    //             .circular(
                                    //             5)),
                                    //         border: Border.all()),
                                    //     child: Column(
                                    //       crossAxisAlignment:
                                    //       CrossAxisAlignment
                                    //           .start,
                                    //       children: [
                                    //         ListTile(
                                    //           visualDensity:
                                    //           const VisualDensity(
                                    //               vertical:
                                    //               -4),
                                    //           leading: const Icon(
                                    //               Icons.home),
                                    //           title: Text(
                                    //             pickupStorename,
                                    //             style: TextStyle(
                                    //                 color: selectedDelivery ==
                                    //                     'Pickup' &&
                                    //                     AdaptiveTheme.of(context).mode.isDark ==
                                    //                         true
                                    //                     ? Colors
                                    //                     .black
                                    //                     : null,
                                    //                 fontSize: 12,fontFamily: 'Nunito'),
                                    //           ),
                                    //         ),
                                    //         ListTile(
                                    //           visualDensity:
                                    //           const VisualDensity(
                                    //               vertical:
                                    //               -4),
                                    //           leading:  Icon(
                                    //               Icons.room,color: appColor,),
                                    //           title: Text(
                                    //             pickupAddress,
                                    //             style: TextStyle(
                                    //                 color: selectedDelivery ==
                                    //                     'Pickup' &&
                                    //                     AdaptiveTheme.of(context).mode.isDark ==
                                    //                         true
                                    //                     ? Colors
                                    //                     .black
                                    //                     : null,
                                    //                 fontSize: 12,fontFamily: 'Nunito'),
                                    //           ),
                                    //         ),
                                    //         ListTile(
                                    //           visualDensity:
                                    //           const VisualDensity(
                                    //               vertical:
                                    //               -4),
                                    //           leading: const Icon(
                                    //               Icons.phone),
                                    //           title: Text(
                                    //             pickupPhone,
                                    //             style: TextStyle(
                                    //                 color: selectedDelivery ==
                                    //                     'Pickup' &&
                                    //                     AdaptiveTheme.of(context).mode.isDark ==
                                    //                         true
                                    //                     ? Colors
                                    //                     .black
                                    //                     : null,
                                    //                 fontSize: 12,fontFamily: 'Nunito'),
                                    //           ),
                                    //         ),
                                    //       ],
                                    //     ),
                                    //   ),
                                    // ),


                                  // if (pickupAddress == '')
                                  //   Padding(
                                  //     padding:
                                  //     const EdgeInsets.only(
                                  //         left: 50),
                                  //     child: Container(
                                  //       width:
                                  //       MediaQuery.of(context)
                                  //           .size
                                  //           .width /
                                  //           3,
                                  //       decoration: BoxDecoration(
                                  //           borderRadius:
                                  //           const BorderRadius
                                  //               .all(Radius
                                  //               .circular(
                                  //               5)),
                                  //           border: Border.all()),
                                  //       child: Column(
                                  //         crossAxisAlignment:
                                  //         CrossAxisAlignment
                                  //             .start,
                                  //         children: [
                                  //           ListTile(
                                  //             visualDensity:
                                  //             const VisualDensity(
                                  //                 vertical:
                                  //                 -4),
                                  //             leading:  Icon(
                                  //                 Icons.room,color : selectedDelivery ==
                                  //                 'Pickup'
                                  //                 ? appColor
                                  //                 : null,),
                                  //             title: Text(
                                  //               "Tap button to select pickup address",
                                  //               style: TextStyle(
                                  //                   color: selectedDelivery ==
                                  //                       'Pickup' &&
                                  //                       AdaptiveTheme.of(context).mode.isDark ==
                                  //                           true
                                  //                       ? Colors
                                  //                       .black
                                  //                       : null,
                                  //                   fontSize: 16,fontFamily: 'Nunito',fontWeight: FontWeight.w500),
                                  //             ),
                                  //           ),
                                  //           const Gap(20),
                                  //           Padding(
                                  //             padding:
                                  //             const EdgeInsets
                                  //                 .only(
                                  //                 left: 25),
                                  //             child:
                                  //             ElevatedButton(
                                  //                 style: ElevatedButton.styleFrom(
                                  //                     shape:
                                  //                     const BeveledRectangleBorder(),
                                  //                     backgroundColor: appColor ),
                                  //                 onPressed:
                                  //                     () {
                                  //                       _scaffoldHome.currentState?.openDrawer();
                                  //                   _scaffoldHome
                                  //                       .currentState!
                                  //                       .openDrawer();
                                  //                 },
                                  //                 child:
                                  //                 const Text(
                                  //                   "Select pickup address",
                                  //                   style: TextStyle(
                                  //                       color:
                                  //                       Colors.black,fontFamily: 'Nunito',fontSize: 14,fontWeight: FontWeight.w600),
                                  //                 ).tr()),
                                  //           ),
                                  //           const Gap(20),
                                  //         ],
                                  //       ),
                                  //     ),
                                  //   ),

                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const Gap(20),
                    Card(
                      shape: const BeveledRectangleBorder(),
                      color:
                      AdaptiveTheme.of(context).mode.isDark ==
                          true
                          ? Colors.black
                          : Colors.white,
                      surfaceTintColor: Colors.white,
                      child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              leading: Container(
                                height: 25,
                                width: 25,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: appColor),
                                child: const Center(
                                  child: Icon(
                                    Icons.done,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                              title: const Text(
                                '2. CHOOSE A PAYMENT OPTION',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,fontFamily: 'Nunito'),
                              ).tr(),
                            ),
                            // Container(
                            //   height: selectedPayment == 'Pay Now'
                            //       ? 250
                            //       : null,
                            //   color: selectedPayment == 'Pay Now'
                            //       ? const Color(0xF6F6F6).withOpacity(1.0)
                            //       : null,
                            //   child: Padding(
                            //     padding: const EdgeInsets.only(
                            //         left: 50),
                            //     child: Column(
                            //       crossAxisAlignment:
                            //       CrossAxisAlignment.start,
                            //       children: [
                            //         RadioListTile(
                            //           // secondary: Text(
                            //           //     'Wallet Balance is $currency${Formatter().converter(wallet.toDouble())}'),
                            //             value: 'Pay Now',
                            //             groupValue:
                            //             selectedPayment,
                            //             title: const Text(
                            //               'Pay Now',
                            //               style: TextStyle(
                            //                   fontFamily:
                            //                   'Nunito',
                            //                   fontWeight:
                            //                   FontWeight
                            //                       .bold),
                            //             ).tr(),
                            //             onChanged: (v) {
                            //               if (selectedDelivery ==
                            //                   'Delivery') {
                            //                 setState(() {
                            //                   selectedPayment =
                            //                   v!;
                            //                 });
                            //               } else {
                            //                 if (pickupAddress
                            //                     .isEmpty) {
                            //                   Fluttertoast.showToast(
                            //                       msg:
                            //                       "Please select a pickup address."
                            //                           .tr(),
                            //                       toastLength: Toast
                            //                           .LENGTH_SHORT,
                            //                       gravity:
                            //                       ToastGravity
                            //                           .TOP,
                            //                       timeInSecForIosWeb:
                            //                       6,
                            //                       fontSize: 14.0);
                            //                 } else {
                            //                   setState(() {
                            //                     selectedPayment =
                            //                     v!;
                            //                   });
                            //                 }
                            //               }
                            //             }),
                            //         const Gap(20),
                            //         if (selectedPayment ==
                            //             'Pay Now')
                            //           Padding(
                            //             padding:
                            //             const EdgeInsets.only(
                            //                 left: 50),
                            //             child: Container(
                            //               width: MediaQuery.of(
                            //                   context)
                            //                   .size
                            //                   .width /
                            //                   3,
                            //               decoration: BoxDecoration(
                            //                   borderRadius:
                            //                   const BorderRadius
                            //                       .all(Radius
                            //                       .circular(
                            //                       5)),
                            //                   border:
                            //                   Border.all()),
                            //               child: Column(
                            //                 crossAxisAlignment:
                            //                 CrossAxisAlignment
                            //                     .start,
                            //                 children: [
                            //                   ListTile(
                            //                     visualDensity:
                            //                     const VisualDensity(
                            //                         vertical:
                            //                         -4),
                            //                     leading:  Icon(
                            //                         Icons.wallet,color: appColor,),
                            //                     title: total <=
                            //                         wallet
                            //                         ? const Text(
                            //                         'Continue to process payment')
                            //                         .tr()
                            //                         : const Text(
                            //                       "Tap button to upload money to wallet",
                            //                       style: TextStyle(
                            //                           fontWeight: FontWeight.w500,
                            //                           fontFamily: 'Nunito',
                            //                           fontSize:  16),
                            //
                            //                     ).tr(),
                            //                   ),
                            //                   const Gap(20),
                            //                   if (total <= wallet)
                            //                     Padding(
                            //                       padding:
                            //                       const EdgeInsets
                            //                           .only(
                            //                           left:
                            //                           25),
                            //                       child: Text(
                            //                           'Wallet balance will be $currencySymbol${Formatter().converter(wallet.toDouble())}- $currencySymbol${Formatter().converter(total.toDouble())} = $currencySymbol${Formatter().converter((wallet - total).toDouble())}',style: TextStyle(fontWeight: FontWeight.w500,fontFamily: 'Nunito',fontSize: 16),),
                            //                     ),
                            //                   if (total > wallet)
                            //                     Padding(
                            //                       padding:
                            //                       const EdgeInsets
                            //                           .only(
                            //                           left:
                            //                           25),
                            //                       child:
                            //                       ElevatedButton(
                            //                           style: ElevatedButton.styleFrom(
                            //                               shape:
                            //                               const BeveledRectangleBorder(),
                            //                               backgroundColor: appColor),
                            //                           onPressed:
                            //                               () {
                            //                             context
                            //                                 .go('/wallet');
                            //                           },
                            //                           child:
                            //                           const Text(
                            //                             "Upload Money To Wallet",
                            //                             style:
                            //                             TextStyle(color: Colors.black,fontFamily: 'Nunito',fontSize: 14,fontWeight: FontWeight.w600),
                            //                           ).tr()),
                            //                     ),
                            //                   const Gap(20),
                            //                 ],
                            //               ),
                            //             ),
                            //           ),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                            const Gap(10),
                            // if (cashOnDelivery == true)
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: RadioListTile(
                                value: 'Cash On Delivery',
                                groupValue: selectedPayment,
                                title: const Text(
                                  'Cash On Delivery',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Nunito',
                                      fontWeight: FontWeight.bold),
                                ).tr(),
                                onChanged: (v) {
                                  // if (selectedDelivery == 'Delivery') {
                                    setState(() {
                                      selectedPayment = v!;
                                    });
                                  // } else {
                                  //   if (pickupAddress.isNotEmpty) {
                                  //     Fluttertoast.showToast(
                                  //         msg: "Please select a pickup address.".tr(),
                                  //         toastLength: Toast.LENGTH_SHORT,
                                  //         gravity: ToastGravity.TOP,
                                  //         timeInSecForIosWeb: 3,
                                  //         fontSize: 14.0);
                                  //   } else {
                                  //     setState(() {
                                  //       selectedPayment = v!;
                                  //     });
                                  //   }
                                  // }
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: RadioListTile(
                                value: 'Zelle Payment',
                                groupValue: selectedPayment,
                                title: const Text(
                                  'Zelle Payment : (614)559-3885',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Nunito',
                                      fontWeight: FontWeight.bold),
                                ).tr(),
                                onChanged: (v) {
                                  // if (selectedDelivery == 'Delivery') {
                                    setState(() {
                                      selectedPayment = v!;
                                    });
                                  // } else {
                                  //   if (pickupAddress.isNotEmpty) {
                                  //     Fluttertoast.showToast(
                                  //         msg: "Please select a pickup address.".tr(),
                                  //         toastLength: Toast.LENGTH_SHORT,
                                  //         gravity: ToastGravity.TOP,
                                  //         timeInSecForIosWeb: 3,
                                  //         fontSize: 14.0);
                                  //   } else {
                                  //     setState(() {
                                  //       selectedPayment = v!;
                                  //     });
                                  //   }
                                  // }
                                },
                              ),
                            ),

                            // Cash On Delivery Option


                            const Gap(10),
                            // if (isCouponActive == true)
                            //   Center(
                            //     child: Container(
                            //       width: 350,
                            //       height: 50,
                            //       padding: EdgeInsets.symmetric(horizontal: 12,),
                            //       decoration: BoxDecoration(
                            //         color: Colors.grey.shade50,
                            //         borderRadius: BorderRadius.circular(8),
                            //         border: Border.all(color: Colors.grey.shade300),
                            //       ),
                            //       child: InkWell(
                            //         onTap: (){
                            //           context.go('/voucher');
                            //         },
                            //         child: Row(
                            //           children: [
                            //             Icon(Icons.confirmation_num_outlined, color: Colors.black87),
                            //             SizedBox(width: 10),
                            //             Expanded(
                            //               child: Text(
                            //                 'Add a coupon',
                            //                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                            //               ),
                            //             ),
                            //             Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black87),
                            //           ],
                            //         ),
                            //       )
                            //     ),
                            //   ),

                            // Padding(
                              //   padding: const EdgeInsets.only(
                              //       left: 50),
                              //   child: const Text(
                              //     'Add Voucher Code',
                              //     style: TextStyle(
                              //         fontWeight:
                              //         FontWeight.bold),
                              //   ).tr(),
                              // ),
                            if (isCouponActive == true)
                              // const Gap(5),
                            // if (isCouponActive == true)
                            //   Padding(
                            //     padding: const EdgeInsets.only(
                            //         left: 50),
                            //     child: const Text(
                            //       'Do you have a voucher? Enter the voucher code below',
                            //       style: TextStyle(),
                            //     ).tr(),
                            //   ),
                            if (isCouponActive == true)
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 50,
                                    right: 50,
                                    top: 20,
                                    bottom: 20),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 6,
                                      child: TextField(
                                        controller: couponController,
                                        enabled: !isCouponApplied,
                                        onChanged: (v) {
                                          setState(() {
                                            couponCode = v;
                                          });
                                        },
                                        decoration: InputDecoration(
                                            border:
                                            const OutlineInputBorder(
                                                borderRadius:
                                                BorderRadius
                                                    .zero),
                                            hintText:
                                            'Add Coupon code'
                                                .tr(),
                                          hintStyle: TextStyle(fontFamily: 'Nunito'),
                                        ),
                                      ),
                                    ),
                                    const Gap(12),
                                    Expanded(
                                      flex: 1,
                                      child: SizedBox(
                                        height: 45,
                                        // width: 36,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: isCouponApplied
                                                ? Colors.grey.shade300
                                                : isCouponCodeEmpty
                                                ? Colors.grey.shade200 // Disabled color
                                                : appColor, // Enabled color
                                            shape: const BeveledRectangleBorder(),
                                            // Optional: Change text color for disabled state
                                            foregroundColor: isCouponApplied
                                                ? Colors.black
                                                : isCouponCodeEmpty
                                                ? Colors.grey.shade400
                                                : Colors.black,
                                          ),
                                          onPressed: isCouponApplied
                                              ? () async {
                                            // 🟡 Remove coupon
                                            couponController.clear();
                                            setState(() {
                                              couponCode = '';
                                              couponPercentage = 0;
                                              couponTitle = '';
                                              isCouponApplied = false;
                                            });
                                            Fluttertoast.showToast(
                                              msg: "Coupon removed",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.TOP,
                                              backgroundColor: const Color(0xFFFFD581),
                                              textColor: Colors.black,
                                              webBgColor: "#FFD581",
                                              webPosition: "center",
                                              timeInSecForIosWeb: 3,
                                              fontSize: 12.0,
                                            );
                                          }
                                              : isCouponCodeEmpty
                                              ? null // Disable button when empty
                                              : () async {
                                            // 🟢 Apply coupon
                                            final couponDetails = await ref.read(
                                              couponNotifierProvider(couponCode).future,
                                            );

                                            if (couponDetails != null) {
                                              setState(() {
                                                couponPercentage = couponDetails.percentage;
                                                couponTitle = couponDetails.title;
                                                isCouponApplied = true;
                                              });
                                            } else {
                                              couponController.clear();
                                              setState(() {
                                                couponCode = '';
                                              });
                                            }
                                          },
                                          child: Text(
                                            isCouponApplied ? 'Remove' : 'Apply',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                              fontFamily: 'Nunito',
                                              color: isCouponApplied
                                                  ? Colors.black
                                                  : isCouponCodeEmpty
                                                  ? Colors.grey.shade500
                                                  : Colors.black,
                                            ),
                                          ).tr(),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            // CheckboxListTile(
                            //   value: isSchedule,
                            //   onChanged: (v) {
                            //     setState(() {
                            //       isSchedule = !isSchedule;
                            //       scheduleTime = '';
                            //       scheduleDate = '';
                            //     });
                            //   },
                            //   title: const Text(
                            //     'Schedule Order',
                            //     style: TextStyle(
                            //         fontWeight: FontWeight.bold,fontFamily: 'Nunito'),
                            //   ),
                            // ),
                            // if (isSchedule == true)
                            //   ScheduleTimePicker(
                            //     onDateSelected: (DateTime? date) {
                            //       if (date != null) {
                            //         // ignore: avoid_print
                            //         print('Selected date: $date');
                            //         setState(() {
                            //           scheduleDate =
                            //               DateFormat('yyyy-MM-dd')
                            //                   .format(date);
                            //         });
                            //         // Do something with the date
                            //       }
                            //     },
                            //     onTimeSelected:
                            //         (TimeOfDay? time) {
                            //       if (time != null) {
                            //         // ignore: avoid_print
                            //         print(
                            //             'Selected time: ${time.format(context)}');
                            //         setState(() {
                            //           scheduleTime =
                            //               time.format(context);
                            //         });
                            //         // Do something with the time
                            //       }
                            //     },
                            //   ),
                            if (isPrescription == true)
                              const Gap(30),
                            if (isPrescription == true)
                              imageFile == null
                                  ? const Align(
                                alignment: Alignment.center,
                                child: Icon(Icons.image,
                                    color: Colors.grey,
                                    size: 120),
                              )
                                  : Align(
                                alignment: Alignment.center,
                                child: Image.memory(
                                    imageFile!,
                                    width: 120,
                                    height: 120),
                              ),
                            if (isPrescription == true)
                              Align(
                                alignment: Alignment.center,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: appColor,
                                        shape:
                                        const BeveledRectangleBorder()),
                                    onPressed: () {
                                      // uploadImage(context);
                                    },
                                    child: const Text(
                                      'Upload Prescription',
                                      style: TextStyle(
                                          color: Colors.white),
                                    )),
                              ),
                            const Gap(30),
                            Center(
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width / 2,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: appColor,
                                    shape: const BeveledRectangleBorder(),
                                  ),
                                  onPressed: selectedPayment == null ||
                                      (selectedPayment == 'Pay Now' && total > wallet)
                                      ? null
                                      : isPrescription == true && prescriptionImage == ''
                                      ? null
                                      : () async {
                                    // ✅ Check for "First Order 10%" coupon usage
                                    if (selectedDelivery == 'Delivery' &&
                                        (deliveryDetails == null || deliveryDetails.deliveryAddress.trim().isEmpty)) {
                                      showAlertDialog(context, "Note", "Please add a delivery address");
                                      return;
                                    }

                                    if (couponTitle.isNotEmpty) {
                                      final usedCoupons = await FirebaseFirestore.instance
                                          .collection('Orders')
                                          .where('userID', isEqualTo: userID)
                                          .where('couponTitle', isEqualTo: couponTitle)
                                          .get();

                                      if (usedCoupons.docs.isNotEmpty) {
                                        showAlertDialog(context, "Note", "You have already used this coupon.");
                                        setState(() {
                                          couponTitle = '';
                                          couponPercentage = 0;
                                          isCouponApplied = false;
                                          couponController.clear();
                                        });
                                        return;
                                      }
                                    }

                                    final userOrdersSnapshot = await FirebaseFirestore.instance
                                        .collection('Orders')
                                        .where('userID', isEqualTo: userID)
                                        .get();

                                    final validOrders = userOrdersSnapshot.docs.where((doc) {
                                      final orderStatus = doc['status']?.toString().toLowerCase() ?? '';
                                      return orderStatus != 'cancelled';
                                    }).toList();

                                    final bool isFirstOrder = validOrders.isEmpty;

                                    Random random = Random();
                                    var result = '';
                                    for (int i = 0; i < 9; i++) {
                                      result += random.nextInt(10).toString();
                                    }

                                    Week currentWeek = Week.current();
                                    var day = DateTime.now();
                                    var dateDay = DateTime.now().day;
                                    var month = DateTime.now();
                                    String formattedDate = DateFormat('MMMM').format(month);
                                    String dayFormatter = DateFormat('EEEE').format(day);

                                    if (selectedDelivery == 'Delivery' && selectedPayment == 'Pay Now') {
                                      ref.read(updateWalletProvider(total));
                                    }

                                    for (var element in checkOutProducts) {
                                      orders.add({
                                        'receivedDate': null,
                                        'name': element.name,
                                        'status': 'Received',
                                        'id': element.productID,
                                        'returnDuration': element.returnDuration,
                                        'selected': element.selected,
                                        'productID': element.productID,
                                        'image': element.image1,
                                        'totalRating': element.totalRating,
                                        'totalNumberOfUserRating': element.totalNumberOfUserRating,
                                        'selectedPrice': element.selectedPrice,
                                        'category': element.category,
                                        'quantity': element.quantity,
                                        'vendorId': element.vendorId,
                                        'vendorName': element.vendorName,
                                        'selectedExtra1': element.selectedExtra1,
                                        'selectedExtraPrice1': element.selectedExtraPrice1,
                                        'selectedExtra2': element.selectedExtra2,
                                        'selectedExtraPrice2': element.selectedExtraPrice2,
                                        'selectedExtra3': element.selectedExtra3,
                                        'selectedExtraPrice3': element.selectedExtraPrice3,
                                        'selectedExtra4': element.selectedExtra4,
                                        'selectedExtraPrice4': element.selectedExtraPrice4,
                                        'selectedExtra5': element.selectedExtra5,
                                        'selectedExtraPrice5': element.selectedExtraPrice5,
                                        'isPrescription': element.isPrescription,
                                      });
                                    }

                                    List<String> vendorIDs = [];
                                    for (var element in orders) {
                                      vendorIDs.add(element['vendorId']);
                                    }

                                    final orderModel = OrderModel(
                                      prescription: isPrescription == true ? true : null,
                                      prescriptionPic: isPrescription == true ? prescriptionImage : null,
                                      scheduleDate: scheduleDate,
                                      scheduleTime: scheduleTime,
                                      vendorId: vendorIDs[0],
                                      vendorIDs: vendorIDs,
                                      confirmationStatus: false,
                                      module: widget.module,
                                      isPos: false,
                                      couponTitle: couponTitle,
                                      couponPercentage: couponPercentage,
                                      useCoupon: couponTitle.isEmpty ? false : true,
                                      day: dayFormatter,
                                      instruction: '',
                                      pickupAddress: selectedDelivery == 'Pickup' ? pickupAddress : '',
                                      pickupPhone: selectedDelivery == 'Pickup' ? pickupPhone : '',
                                      pickupStorename: selectedDelivery == 'Pickup' ? pickupStorename : '',
                                      weekNumber: currentWeek.weekNumber,
                                      date: '$dayFormatter, $formattedDate $dateDay',
                                      orderID: result,
                                      orders: orders,
                                      uid: uid,
                                      acceptDelivery: false,
                                      deliveryFee: selectedDelivery == 'Pickup' ? 0 : deliveryFee,
                                      total: total,
                                      paymentType:selectedPayment == 'Zelle Payment' ? 'Zelle Payment' : 'Cash On Delivery',
                                      userID: userID,
                                      timeCreated: DateTime.now(),
                                      deliveryAddress: selectedDelivery == 'Pickup'
                                          ? ''
                                          : deliveryDetails?.deliveryAddress ?? '',
                                      houseNumber: selectedDelivery == 'Pickup'
                                          ? ''
                                          : deliveryDetails?.houseNumber ?? '',
                                      closesBusStop: selectedDelivery == 'Pickup'
                                          ? ''
                                          : deliveryDetails?.closestBusStop ?? '',
                                      deliveryBoyID: '',
                                      status: 'Pending',
                                      accept: false,
                                      pointsRedeemed: rewardState.pendingRedemptionAmount,
                                      pointsUsed: rewardState.pendingPointsUsed,
                                    );

                                    // Use .then() to ensure these happen AFTER order is placed
                                    addToOrder(orderModel, uid, isFirstOrder,context).then((_) async {
                                      // This will execute after addToOrder completes successfully
                                      if (rewardState.isRedeeming) {
                                        try {
                                          await ref.read(rewardPointsProvider.notifier)
                                              .confirmRedemption(result); // result is your orderId
                                          // Cart clearing happens only after successful order creation
                                          await clearRestaurantCart.clearCartRestaurant();
                                        } catch (e) {
                                          // If order creation fails, cancel the redemption
                                          ref.read(rewardPointsProvider.notifier).cancelRedemption();
                                          throw e; // Re-throw to show error to user
                                        }
                                      } else {
                                        await clearRestaurantCart.clearCartRestaurant();
                                      }
                                    }).catchError((error) {
                                      // Handle any errors that occurred during addToOrder
                                      debugPrint('Order placement failed: $error');

                                      }
                                    );
                                  },
                                  child: const Text(
                                    'Place Order',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Nunito',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ).tr(),
                                ),
                              ),
                            ),

                            const Gap(30)
                          ]),
                    ),
                    const Gap(20),
                  ],
                ),
              ),
            ),
            const Gap(20),
            Expanded(
              flex: 2,
              child: Padding(padding: EdgeInsets.only(top: 18),
                child:  Card(
                  shape: const BeveledRectangleBorder(),
                  color:
                  AdaptiveTheme.of(context).mode.isDark == true
                      ? Colors.black
                      : Colors.white,
                  surfaceTintColor: Colors.white,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const Gap(10),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const Text(
                                "Order Detail",
                                style: TextStyle(
                                    fontFamily: 'Nunito',
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ).tr(),
                            ],
                          ),
                        ),
                        const Divider(
                            color:
                            Color.fromARGB(255, 236, 227, 227)),
                        const Gap(10),
                        ListView.separated(
                          shrinkWrap: true,
                          itemCount: checkOutProducts.length,
                          itemBuilder: (context, index) {
                            CartModel cartModel =
                            checkOutProducts[index];

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                height: MediaQuery.of(context)
                                    .size
                                    .width >=
                                    1100
                                    ? 90
                                    : 110,
                                child: Row(
                                  children: [
                                    Expanded(
                                        flex: 2,
                                        child: CatImageWidget(
                                          url: cartModel.image1,
                                          boxFit: 'cover',
                                        )),
                                    const Gap(20),
                                    Expanded(
                                        flex: 5,
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,
                                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              cartModel.name,
                                              maxLines: 2,
                                              overflow: TextOverflow
                                                  .ellipsis,
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  fontFamily: 'Nunito',
                                                  fontWeight:
                                                  FontWeight
                                                      .w400),
                                            ),
                                            const Gap(10),
                                            Text(
                                              '$currencySymbol${cartModel.selectedPrice.toDouble().toStringAsFixed(2)}',
                                              // '$currencySymbol${Formatter().converter(cartModel.selectedPrice.toDouble())}',
                                              maxLines: 1,
                                              overflow: TextOverflow
                                                  .ellipsis,
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'Nunito',
                                                  fontWeight:
                                                  FontWeight
                                                      .bold),
                                            ),
                                            const Gap(10),
                                            Text(
                                              'Quantity: ${cartModel.quantity}',
                                              maxLines: 2,
                                              overflow: TextOverflow
                                                  .ellipsis,
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'Nunito',
                                                  fontWeight:
                                                  FontWeight
                                                      .w400),
                                            )
                                          ],
                                        ))
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder:
                              (BuildContext context, int index) {
                            return const Divider(
                                color: Color.fromARGB(
                                    255, 236, 227, 227));
                          },
                        ),
                        const Gap(15),
                        if (isCouponActive == true)
                          Center(
                            child: Container(
                                width: 320,
                                height: 40,
                                padding: EdgeInsets.symmetric(horizontal: 12,),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey.shade300),
                                ),
                                child: InkWell(
                                  onTap: (){
                                    _scaffoldHome
                                        .currentState!
                                        .openEndDrawer();
                                  },
                                  child: Row(
                                    children: [
                                      Icon(Icons.confirmation_num_outlined,
                                          // color: Colors.black87
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          'Add a coupon',
                                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,color: Colors.black87),
                                        ),
                                      ),
                                      Icon(Icons.arrow_forward_ios, size: 14,
                                          color: Colors.black87
                                      ),
                                    ],
                                  ),
                                )
                            ),
                          ),
                        const Gap(15),
                        Builder(
                          builder: (context) {
                            final rewardState = ref.watch(rewardPointsProvider);
                            final currentTotal = cartPriceQuantity.price +
                                (selectedDelivery == 'Delivery' ? deliveryFee : 0) -
                                getPercentageOfCoupon(couponPercentage, cartPriceQuantity.price);

                            return Column(
                              children: [
                                // Points Display - Updated text
                                Text(
                                  'You have ${rewardState.availablePoints} points (\$${rewardState.redeemableAmount} redeemable)',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),

                                if (rewardState.availablePoints >= 500) ...[ // CHANGED: 500 points threshold
                                  if (!rewardState.isRedeeming)
                                    Slider(
                                      value: rewardState.pointsToRedeem.toDouble(),
                                      min: 0,
                                      max: rewardState.availablePoints.toDouble(),
                                      divisions: rewardState.availablePoints ~/ 500, // CHANGED: 500 point increments
                                      label: '\$${(rewardState.pointsToRedeem ~/ 500) * 5}', // CHANGED: $5 per 500 points
                                      onChanged: (value) {
                                        ref.read(rewardPointsProvider.notifier)
                                            .updatePointsToRedeem((value ~/ 500) * 500); // CHANGED: 500 point increments
                                      },
                                    ),

                                  if (!rewardState.isRedeeming) ...[
                                    if (currentTotal >= 5) // CHANGED: Minimum order total $5 instead of $10
                                      if (rewardState.pointsToRedeem >= 500) // CHANGED: 500 points minimum
                                        SizedBox(
                                          height: 40,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              final redemptionAmount = (rewardState.pointsToRedeem ~/ 500) * 5; // CHANGED
                                              if (redemptionAmount > currentTotal) {
                                                final maxAllowed = (currentTotal ~/ 5) * 5; // CHANGED: $5 increments
                                                ref.read(rewardPointsProvider.notifier)
                                                    .updatePointsToRedeem(maxAllowed * 100); // CHANGED: $5 = 500 points
                                                return;
                                              }
                                              ref.read(rewardPointsProvider.notifier).redeemPoints(currentTotal);
                                            },
                                            child: Text(
                                              'Redeem \$${(rewardState.pointsToRedeem ~/ 500) * 5}', // CHANGED
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16,
                                                  fontFamily: 'Nunito',
                                                  color: Colors.black
                                              ),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: appColor,
                                                shape: const BeveledRectangleBorder()
                                            ),
                                          ),
                                        )
                                      else
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                                          child: Text(
                                            "Slide to select points to redeem", // Text remains the same
                                            style: TextStyle(
                                              color: Colors.grey.shade900,
                                              fontStyle: FontStyle.italic,
                                              fontSize: 14,
                                            ),
                                          ),
                                        )
                                    else
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                                        child: Text(
                                          "Order total must be at least \$5 to redeem points", // CHANGED: $5 minimum
                                          style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                  ] else ...[
                                    // Redemption status (when isRedeeming = true)
                                    SizedBox(height: 10),
                                    Text(
                                      'Redeemed: \$${rewardState.pendingRedemptionAmount}',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 10),
                                    SizedBox(
                                      height: 40,
                                      child: ElevatedButton(
                                        onPressed: () => ref.read(rewardPointsProvider.notifier).cancelRedemption(),
                                        child: const Text(
                                          'Remove',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                              fontFamily: 'Nunito',
                                              color: Colors.black
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red[400],
                                            shape: const BeveledRectangleBorder()
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ],
                            );
                          },
                        ),
                        const Gap(15),
                        if (selectedDelivery == 'Delivery')
                          Padding(
                            padding:
                            MediaQuery.of(context).size.width >=
                                1100
                                ? const EdgeInsets.all(8)
                                : const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Delivery Fee',
                                  style: TextStyle(
                                      fontFamily: 'Nunito',
                                      fontWeight: FontWeight.bold),
                                ).tr(),
                                Text(
                                  // '$currencySymbol${Formatter().converter(deliveryFee.toDouble())}',
                                  '$currencySymbol${deliveryFee.toDouble().toStringAsFixed(2)}',
                                  style: const TextStyle(
                                      fontFamily: 'Nunito',
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        if (selectedDelivery == 'Delivery')
                        Padding(
                          padding:
                          MediaQuery.of(context).size.width >=
                              1100
                              ? const EdgeInsets.all(8)
                              : const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Free Delivery',
                                style: TextStyle(
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.bold),
                              ).tr(),
                              Text(
                                '-$currencySymbol${deliveryFee.toDouble().toStringAsFixed(2)}',
                                style: const TextStyle(
                                    fontFamily: 'Nunito',
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                          MediaQuery.of(context).size.width >=
                              1100
                              ? const EdgeInsets.all(8)
                              : const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Sub Total',
                                style: TextStyle(
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.bold),
                              ).tr(),
                              Text(
                                '$currencySymbol${cartPriceQuantity.price.toDouble().toStringAsFixed(2)}',
                                // '$currencySymbol${Formatter().converter(cartPriceQuantity.price.toDouble())}',
                                style: const TextStyle(
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                        if (isCouponApplied)
                          Padding(
                            padding: MediaQuery.of(context).size.width >= 1100
                                ? const EdgeInsets.all(8)
                                : const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Coupon ($couponPercentage%)',
                                  style: const TextStyle(
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ).tr(),
                                Text(
                                  '-$currencySymbol${discount.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        Padding(
                          padding:
                          MediaQuery.of(context).size.width >=
                              1100
                              ? const EdgeInsets.all(8)
                              : const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total',
                                style: TextStyle(
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.bold),
                              ).tr(),
                              Text(
                                '$currencySymbol${total.toDouble().toStringAsFixed(2)}',
                                // '$currencySymbol${Formatter().converter(total.toDouble())}',
                                // '$currency${Formatter().converter((totalPrice + (selectedDelivery == 'Delivery' ? deliveryFee : 0)).toDouble())}',
                                style: const TextStyle(
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            )
          ],
        ),
      )
      //////////////////////////////// Mobile View /////////////////////////////////////////////
          : checkOutProducts.isEmpty
          ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Icon(
              Icons.remove_shopping_cart_outlined,
              color: appColor,
              size: MediaQuery.of(context).size.width >= 1100
                  ? MediaQuery.of(context).size.width / 5
                  : MediaQuery.of(context).size.width / 1.5,
            ),
          ),
          const Gap(20),
          const Text('Cart is empty',style: TextStyle(fontFamily: 'Nunito'),),
          const Gap(20),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: const BeveledRectangleBorder(),
                  backgroundColor: appColor),
              onPressed: () {
                context.go('/restaurant');
              },
              child: const Text(
                'Continue Shopping',
                style: TextStyle(
                    // color: Colors.white,
                    fontFamily: 'Nunito'),
              ).tr())
        ],
      )
          : SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            // const Gap(10),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: appColor, // Your yellow color
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Main free shipping message
                        const Text(
                          'Free Delivery for all in/Around Columbus,ohio.',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        // Additional charges note
                        Text(
                          '(Thanks for your valuable Orders) ',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
                const Gap(15),
                Card(
                  shape: const BeveledRectangleBorder(),
                  color: AdaptiveTheme.of(context).mode.isDark ==
                      true
                      ? Colors.black
                      : Colors.white,
                  surfaceTintColor: Colors.white,
                  child: Column(
                    children: [
                      ListTile(
                        leading: Container(
                          height: 25,
                          width: 25,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: appColor),
                          child: const Center(
                            child: Icon(
                              Icons.done,
                              // color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                        title: const Text(
                          '1. CHOOSE DELIVERY OPTION',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ).tr(),
                      ),
                      if (vendorModule == 'Grocery') ...[
                      Container(
                        height: 270,
                          color: selectedDelivery == 'Delivery'
                              ?  AdaptiveTheme.of(context)
                              .mode
                              .isDark ==
                              true
                              ? Colors.grey.shade900
                              : const Color(0xF6F6F6).withOpacity(1.0) :  AdaptiveTheme.of(context)
                              .mode
                              .isDark ==
                              true ? Colors.black38 :Colors.white,
                             // Adaptive color for selected
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Radio<String>(
                                    value: 'Delivery',
                                    groupValue: selectedDelivery,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedDelivery = value!;
                                        if (selectedPayment == null) {
                                          selectedPayment = 'Cash On Delivery';
                                        }
                                      });
                                    },
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      'Deliver to me',
                                      style: const TextStyle(
                                        fontFamily: 'Nunito',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 2),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=> DeliveryAddressPages2()));
                                      // context.go('/delivery-addresses');
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: appColor, // your yellow color
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.add, color: Colors.black, size: 12),
                                          SizedBox(width: 6),
                                          Text(
                                            'Change Delivery Address',
                                            style: TextStyle(
                                              fontFamily: 'Nunito',
                                              color: Colors.black,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Gap(20),
                              if (deliveryDetails!
                                  .deliveryAddress !=
                                  '')
                                Padding(
                                  padding:
                                  const EdgeInsets.all(8),
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                        const BorderRadius.all(Radius.circular( 5)),
                                        border: Border.all(color: Colors.grey.shade500)),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                      children: [
                                        ListTile(
                                          visualDensity:
                                          const VisualDensity(
                                              vertical: -4),
                                          leading: Icon(
                                            Icons.room,
                                            color: selectedDelivery ==
                                                'Delivery'
                                                ? appColor
                                                : null,
                                          ),
                                          title: Text(
                                            deliveryDetails
                                                .deliveryAddress,
                                            maxLines: 2,
                                            style:
                                            const TextStyle(
                                                fontFamily: 'Nunito',
                                                fontSize: 14),
                                          ),
                                        ),
                                        ListTile(
                                          visualDensity:
                                          const VisualDensity(
                                              vertical: -4),
                                          leading: Icon(
                                            Icons.home,
                                            color: selectedDelivery ==
                                                'Delivery'
                                                ? appColor
                                                : null,
                                          ),
                                          title: Text(
                                            deliveryDetails
                                                .houseNumber,
                                            maxLines: 2,
                                            style: TextStyle(
                                                // color: selectedDelivery ==
                                                //     'Delivery'
                                                //     ? Colors.black
                                                //     : null,
                                                fontFamily: 'Nunito',
                                                fontSize: 14),
                                          ),
                                        ),
                                        ListTile(
                                          visualDensity:
                                          const VisualDensity(
                                              vertical: -4),
                                          leading: Icon(
                                            Icons.bus_alert,
                                            color: selectedDelivery ==
                                                'Delivery'
                                                ? appColor
                                                : null,
                                          ),
                                          title: Text(
                                            deliveryDetails
                                                .closestBusStop,
                                            maxLines: 2,
                                            style: TextStyle(
                                                // color: selectedDelivery ==
                                                //     'Delivery' &&
                                                //     AdaptiveTheme.of(context)
                                                //         .mode
                                                //         .isDark ==
                                                //         true
                                                //     ? Colors.black
                                                //     : null,
                                                fontFamily: 'Nunito',
                                                fontSize: 14),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              if (deliveryDetails
                                  .deliveryAddress ==
                                  '')
                                Padding(
                                  padding:
                                  const EdgeInsets.all(8),
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                        const BorderRadius
                                            .all(
                                            Radius.circular(
                                                5)),
                                        border: Border.all()),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                      children: [
                                        ListTile(
                                          visualDensity:
                                          const VisualDensity(
                                              vertical: -4),
                                          leading: const Icon(
                                              Icons.room),
                                          title: Text(
                                            "Tap button to add a delivery address",
                                            style: TextStyle(
                                                color: selectedDelivery ==
                                                    'Delivery' &&
                                                    AdaptiveTheme.of(context)
                                                        .mode
                                                        .isDark ==
                                                        true
                                                    ? Colors.black
                                                    : null,
                                                fontSize: 12),
                                          ),
                                        ),
                                        const Gap(20),
                                        Padding(
                                          padding:
                                          const EdgeInsets
                                              .only(left: 25),
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  shape:
                                                  const BeveledRectangleBorder(),
                                                  backgroundColor:
                                                  appColor),
                                              onPressed: () {
                                                context.go(
                                                    '/delivery-addresses');
                                              },
                                              child: const Text(
                                                "Add a delivery address",
                                                style: TextStyle(
                                                    // color: Colors
                                                    //     .white
                                                ),
                                              ).tr()),
                                        ),
                                        const Gap(20),
                                      ],
                                    ),
                                  ),
                                ),
                              // const Gap(20),
                              // Padding(
                              //   padding: const EdgeInsets.all(8),
                              //   child: Text(
                              //       // 'Delivery Fee is $currencySymbol${Formatter().converter(deliveryFee.toDouble())}',
                              //       'Delivery Fee $currencySymbol${deliveryFee.toDouble().toStringAsFixed(2)}',
                              //       style: TextStyle(
                              //         // color: selectedDelivery ==
                              //         //     'Delivery' &&
                              //         //     AdaptiveTheme.of(
                              //         //         context)
                              //         //         .mode
                              //         //         .isDark ==
                              //         //         true
                              //         //     ? Colors.black
                              //         //     : null,
                              //         fontFamily: 'Nunito',
                              //         fontSize: 16
                              //       )),
                              // ),
                              //  const Gap(20),
                            ],
                          ),
                        ),
                      ),
                      // const Gap(20),
                      ],
                      Container(
                        height: 110,
                        color: selectedDelivery == 'Pickup'
                            ?  AdaptiveTheme.of(context)
                            .mode
                            .isDark ==
                            true
                            ? Colors.grey.shade900
                            : const Color(0xF6F6F6).withOpacity(1.0) :  AdaptiveTheme.of(context)
                            .mode
                            .isDark ==
                            true ? Colors.black38 :Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              RadioListTile(
                                value: 'Pickup',
                                groupValue: selectedDelivery,
                                title: Text(
                                  'Pickup',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ).tr(),
                                onChanged: (v) {
                                  setState(() {
                                    selectedDelivery = v!;
                                    if (selectedPayment == null) {
                                      selectedPayment = 'Cash On Delivery';
                                    }
                                  });
                                },
                              ),
                              const Gap(20),
                              // if (pickupAddress != '')
                                // Padding(
                                //   padding:
                                //   const EdgeInsets.all(8),
                                //   child: Container(
                                //     width: double.infinity,
                                //     decoration: BoxDecoration(
                                //         borderRadius:
                                //         const BorderRadius
                                //             .all(
                                //             Radius.circular(
                                //                 5)),
                                //         border: Border.all(color: Colors.grey.shade500)),
                                //     child: Column(
                                //       crossAxisAlignment:
                                //       CrossAxisAlignment
                                //           .start,
                                //       children: [
                                //         ListTile(
                                //           visualDensity:
                                //           const VisualDensity(
                                //               vertical: -4),
                                //           leading: Icon(
                                //             Icons.home,
                                //             color: selectedDelivery ==
                                //                 'Pickup' &&
                                //                 AdaptiveTheme.of(
                                //                     context)
                                //                     .mode
                                //                     .isDark ==
                                //                     true
                                //                 ? Colors.black
                                //                 : null,
                                //           ),
                                //           title: Text(
                                //             pickupStorename,
                                //             maxLines: 2,
                                //             style: TextStyle(
                                //                 color: selectedDelivery ==
                                //                     'Pickup' &&
                                //                     AdaptiveTheme.of(context)
                                //                         .mode
                                //                         .isDark ==
                                //                         true
                                //                     ? Colors.black
                                //                     : null,
                                //                 fontSize: 12),
                                //           ),
                                //         ),
                                //         ListTile(
                                //           visualDensity:
                                //           const VisualDensity(
                                //               vertical: -4),
                                //           leading: Icon(
                                //             Icons.room,
                                //             color: selectedDelivery ==
                                //                 'Pickup' &&
                                //                 AdaptiveTheme.of(
                                //                     context)
                                //                     .mode
                                //                     .isDark ==
                                //                     true
                                //                 ? Colors.black
                                //                 : null,
                                //           ),
                                //           title: Text(
                                //             pickupAddress,
                                //             maxLines: 2,
                                //             style: TextStyle(
                                //                 color: selectedDelivery ==
                                //                     'Pickup' &&
                                //                     AdaptiveTheme.of(context)
                                //                         .mode
                                //                         .isDark ==
                                //                         true
                                //                     ? Colors.black
                                //                     : null,
                                //                 fontSize: 12),
                                //           ),
                                //         ),
                                //         ListTile(
                                //           visualDensity:
                                //           const VisualDensity(
                                //               vertical: -4),
                                //           leading: Icon(
                                //             Icons.phone,
                                //             color: selectedDelivery ==
                                //                 'Pickup' &&
                                //                 AdaptiveTheme.of(
                                //                     context)
                                //                     .mode
                                //                     .isDark ==
                                //                     true
                                //                 ? Colors.black
                                //                 : null,
                                //           ),
                                //           title: Text(
                                //             pickupPhone,
                                //             maxLines: 2,
                                //             style: TextStyle(
                                //                 color: selectedDelivery ==
                                //                     'Pickup' &&
                                //                     AdaptiveTheme.of(context)
                                //                         .mode
                                //                         .isDark ==
                                //                         true
                                //                     ? Colors.black
                                //                     : null,
                                //                 fontSize: 12),
                                //           ),
                                //         ),
                                //       ],
                                //     ),
                                //   ),
                                // ),

                              // if (pickupAddress == '')
                              //   Padding(
                              //     padding:
                              //     const EdgeInsets.all(8),
                              //     child: Container(
                              //       width: double.infinity,
                              //       decoration: BoxDecoration(
                              //           borderRadius:
                              //           const BorderRadius
                              //               .all(
                              //               Radius.circular(
                              //                   5)),
                              //           border: Border.all(color: Colors.grey.shade500)),
                              //       child: Column(
                              //         crossAxisAlignment:CrossAxisAlignment .start,
                              //         children: [
                              //           ListTile(
                              //             visualDensity:
                              //             const VisualDensity(
                              //                 vertical: -4),
                              //             leading: Icon(
                              //               Icons.room,
                              //               color: selectedDelivery ==
                              //                   'Pickup'
                              //                   ? appColor
                              //                   : null,
                              //             ),
                              //             title: Text(
                              //               "Tap button to select pickup address",
                              //               style: TextStyle(
                              //                   color: selectedDelivery ==
                              //                       'Pickup' &&
                              //                       AdaptiveTheme.of(context)
                              //                           .mode
                              //                           .isDark ==
                              //                           true
                              //                       ? Colors.black
                              //                       : null,
                              //                   fontFamily: 'Nunito',
                              //                   fontSize: 14),
                              //             ),
                              //           ),
                              //           const Gap(20),
                              //           Padding(
                              //             padding:
                              //             const EdgeInsets
                              //                 .only(left: 25),
                              //             child: ElevatedButton(
                              //                 style: ElevatedButton.styleFrom(
                              //                     shape:
                              //                     const BeveledRectangleBorder(),
                              //                     backgroundColor:appColor,),
                              //                 onPressed: () {
                              //                   _scaffoldHome.currentState?.openDrawer();
                              //                   // _scaffoldHome
                              //                   //     .currentState!
                              //                   //     .openEndDrawer();
                              //                 },
                              //                 child: const Text(
                              //                   "Select pickup address",
                              //                   style: TextStyle(
                              //                     fontSize: 14,
                              //                     fontWeight: FontWeight.w600,
                              //                     fontFamily: 'Nunito',
                              //                       color: Colors
                              //                           .black),
                              //                 ).tr()),
                              //           ),
                              //           const Gap(20),
                              //         ],
                              //       ),
                              //     ),
                              //   ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const Gap(20),
                Card(
                  shape: const BeveledRectangleBorder(),
                  color: AdaptiveTheme.of(context).mode.isDark ==
                      true
                      ? Colors.black
                      : Colors.white,
                  surfaceTintColor: Colors.white,
                  child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: Container(
                            height: 25,
                            width: 25,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: appColor),
                            child: const Center(
                              child: Icon(
                                Icons.done,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                          title: const Text(
                            '2. CHOOSE A PAYMENT OPTION',
                            style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ).tr(),
                        ),
                        // Container(
                        //   height: selectedPayment == 'Pay Now'
                        //       ? 250
                        //       : null,
                        //   color: selectedPayment == 'Pay Now'
                        //       ? const Color(0xF6F6F6).withOpacity(1.0)
                        //       : null,
                        //   child: Padding(
                        //     padding: const EdgeInsets.all(8),
                        //     child: Column(
                        //       crossAxisAlignment:
                        //       CrossAxisAlignment.start,
                        //       children: [
                        //         RadioListTile(
                        //           // secondary: Text(
                        //           //     'Wallet Balance is $currency${Formatter().converter(wallet.toDouble())}'),
                        //             value: 'Pay Now',
                        //             groupValue: selectedPayment,
                        //             title: const Text(
                        //               'Pay Now',
                        //               style: TextStyle(
                        //                   fontSize: 16,
                        //                   fontFamily: 'Nunito',
                        //                   fontWeight:
                        //                   FontWeight.bold),
                        //             ).tr(),
                        //             onChanged: (v) {
                        //               if (selectedDelivery ==
                        //                   'Delivery') {
                        //                 setState(() {
                        //                   selectedPayment = v!;
                        //                 });
                        //               } else {
                        //                 if (pickupAddress
                        //                     .isNotEmpty) {
                        //                   Fluttertoast.showToast(
                        //                       msg: "Please select a pickup address."
                        //                           .tr(),
                        //                       toastLength: Toast
                        //                           .LENGTH_SHORT,
                        //                       gravity:
                        //                       ToastGravity
                        //                           .TOP,
                        //                       timeInSecForIosWeb:
                        //                       6,
                        //                       fontSize: 14.0);
                        //                 } else {
                        //                   setState(() {
                        //                     selectedPayment = v!;
                        //                   });
                        //                 }
                        //               }
                        //             }),
                        //         const Gap(20),
                        //         if (selectedPayment == 'Pay Now')
                        //           Padding(
                        //             padding:
                        //             const EdgeInsets.all(8),
                        //             child: Container(
                        //               width: double.infinity,
                        //               decoration: BoxDecoration(
                        //                   borderRadius:
                        //                   const BorderRadius
                        //                       .all(
                        //                       Radius.circular(
                        //                           5)),
                        //                   border: Border.all()),
                        //               child: Column(
                        //                 crossAxisAlignment:
                        //                 CrossAxisAlignment
                        //                     .start,
                        //                 children: [
                        //                   ListTile(
                        //                     visualDensity:
                        //                     const VisualDensity(
                        //                         vertical: -4),
                        //                     leading:  Icon(
                        //                         Icons.wallet,color: appColor,),
                        //                     title: total <= wallet
                        //                         ? const Text(
                        //                       'Continue to process payment',
                        //                       style: TextStyle(
                        //                           fontSize:
                        //                           12),
                        //                     ).tr()
                        //                         : const Text(
                        //                       "Tap button to upload money to wallet",
                        //                       style: TextStyle(
                        //                           fontFamily: 'Nunito',
                        //                           fontSize:
                        //                           14),
                        //                     ).tr(),
                        //                   ),
                        //                   const Gap(20),
                        //                   if (total <= wallet)
                        //                     Padding(
                        //                       padding:
                        //                       const EdgeInsets
                        //                           .only(
                        //                           left: 25),
                        //                       child: Text(
                        //                         'Wallet balance will be $currencySymbol${Formatter().converter(wallet.toDouble())}- $currencySymbol${Formatter().converter(total.toDouble())} = $currencySymbol${Formatter().converter((wallet - total).toDouble())}',
                        //                         style:
                        //                         const TextStyle(
                        //                             fontSize:
                        //                             13),
                        //                       ),
                        //                     ),
                        //                   if (total > wallet)
                        //                     Padding(
                        //                       padding:
                        //                       const EdgeInsets
                        //                           .only(
                        //                           left: 25),
                        //                       child:
                        //                       ElevatedButton(
                        //                           style: ElevatedButton.styleFrom(
                        //                               shape:
                        //                               const BeveledRectangleBorder(),
                        //                               backgroundColor:appColor),
                        //                           onPressed:
                        //                               () {
                        //                             context.go(
                        //                                 '/wallet');
                        //                           },
                        //                           child:
                        //                           const Text(
                        //                             "Upload Money To Wallet",
                        //                             style: TextStyle(
                        //                                 fontFamily: 'Nunito',
                        //                                 fontSize: 14,
                        //                                 fontWeight: FontWeight.w600,
                        //                                 color:
                        //                                 Colors.black),
                        //                           ).tr()),
                        //                     ),
                        //                   const Gap(20),
                        //                 ],
                        //               ),
                        //             ),
                        //           ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        //  const Gap(20),
                        // if (cashOnDelivery == true)
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: RadioListTile(
                            value: 'Cash On Delivery',
                            groupValue: selectedPayment,
                            title: const Text(
                              'Cash On Delivery',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.bold),
                            ).tr(),
                            onChanged: (v) {
                              // if (selectedDelivery == 'Delivery') {
                                setState(() {
                                  selectedPayment = v!;
                                });
                              // } else {
                              //   if (pickupAddress.isNotEmpty) {
                              //     Fluttertoast.showToast(
                              //         msg: "Please select a pickup address.".tr(),
                              //         toastLength: Toast.LENGTH_SHORT,
                              //         gravity: ToastGravity.TOP,
                              //         timeInSecForIosWeb: 3,
                              //         fontSize: 14.0);
                              //   } else {
                              //     setState(() {
                              //       selectedPayment = v!;
                              //     });
                              //   }
                              // }
                            },
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: RadioListTile(
                            value: 'Zelle Payment',
                            groupValue: selectedPayment,
                            title: const Text(
                              'Zelle Payment : (614)559-3885',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.bold),
                            ).tr(),
                            onChanged: (v) {
                              // if (selectedDelivery == 'Delivery' || selectedDelivery =='Pickup') {
                                setState(() {
                                  selectedPayment = v!;
                                });
                              // } else {
                              //   if (pickupAddress.isNotEmpty) {
                              //     Fluttertoast.showToast(
                              //         msg: "Please select a pickup address.".tr(),
                              //         toastLength: Toast.LENGTH_SHORT,
                              //         gravity: ToastGravity.TOP,
                              //         timeInSecForIosWeb: 3,
                              //         fontSize: 14.0);
                              //   } else {
                              //     setState(() {
                              //       selectedPayment = v!;
                              //     });
                              //   }
                              // }
                            },
                          ),
                        ),
                        // Cash On Delivery Option
                        const Gap(12),
                        if (isCouponActive == true)
                          Center(
                            child: Container(
                                width: 300,
                                height: 40,
                                padding: EdgeInsets.symmetric(horizontal: 10,),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey.shade300),
                                ),
                                child: InkWell(
                                  onTap: (){
                                    _scaffoldHome
                                        .currentState!
                                        .openEndDrawer();
                                  },
                                  child: Row(
                                    children: [
                                      Icon(Icons.confirmation_num_outlined, color: Colors.black87),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          'Add a coupon',
                                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,color: Colors.black87),
                                        ),
                                      ),
                                      Icon(Icons.arrow_forward_ios, size: 14,
                                          color: Colors.black87
                                      ),
                                    ],
                                  ),
                                )
                            ),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.all(8),
                          //   child: const Text(
                          //     'Add Voucher Code',
                          //     style: TextStyle(
                          //         fontWeight: FontWeight.bold),
                          //   ).tr(),
                          // ),
                        if (isCouponActive == true) const Gap(5),
                        // if (isCouponActive == true)
                        //   Padding(
                        //     padding: const EdgeInsets.all(8),
                        //     child: const Text(
                        //       'Do you have a voucher? Enter the voucher code below',
                        //       style: TextStyle(),
                        //     ).tr(),
                        //   ),
                        if (isCouponActive == true)
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8,
                                right: 8,
                                top: 12,
                                bottom: 8),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: SizedBox(
                                    height: 40,
                                    child: TextField(
                                      controller: couponController,
                                      enabled: !isCouponApplied,
                                      onChanged: (v) {
                                        setState(() {
                                          couponCode = v;
                                        });
                                      },
                                      decoration: InputDecoration(
                                          hintStyle:
                                          const TextStyle(
                                              fontSize: 13),
                                          border:
                                          const OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius
                                                  .zero),
                                          hintText:
                                          'Add Coupon Code'
                                              .tr(),
                                      ),

                                    ),
                                  ),
                                ),
                                const Gap(5),
                                Expanded(
                                  flex: 2,
                                  child: SizedBox(
                                    height: 38,
                                    width: 36,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: isCouponApplied
                                            ? Colors.grey.shade300
                                            : isCouponCodeEmpty
                                            ? Colors.grey.shade200 // Disabled color
                                            : appColor, // Enabled color
                                        shape: const BeveledRectangleBorder(),
                                        // Optional: Change text color for disabled state
                                        foregroundColor: isCouponApplied
                                            ? Colors.black
                                            : isCouponCodeEmpty
                                            ? Colors.grey.shade400
                                            : Colors.black,
                                      ),
                                      onPressed: isCouponApplied
                                          ? () async {
                                        // 🟡 Remove coupon
                                        couponController.clear();
                                        setState(() {
                                          couponCode = '';
                                          couponPercentage = 0;
                                          couponTitle = '';
                                          isCouponApplied = false;
                                        });
                                        Fluttertoast.showToast(
                                          msg: "Coupon removed",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.TOP,
                                          backgroundColor: const Color(0xFFFFD581),
                                          textColor: Colors.black,
                                          webBgColor: "#FFD581",
                                          webPosition: "center",
                                          timeInSecForIosWeb: 3,
                                          fontSize: 12.0,
                                        );
                                      }
                                          : isCouponCodeEmpty
                                          ? null // Disable button when empty
                                          : () async {
                                        // 🟢 Apply coupon
                                        final couponDetails = await ref.read(
                                          couponNotifierProvider(couponCode).future,
                                        );

                                        if (couponDetails != null) {
                                          setState(() {
                                            couponPercentage = couponDetails.percentage;
                                            couponTitle = couponDetails.title;
                                            isCouponApplied = true;
                                          });
                                        } else {
                                          couponController.clear();
                                          setState(() {
                                            couponCode = '';
                                          });
                                        }
                                      },
                                      child: Text(
                                        isCouponApplied ? 'Remove' : 'Apply',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          fontFamily: 'Nunito',
                                          color: isCouponApplied
                                              ? Colors.black
                                              : isCouponCodeEmpty
                                              ? Colors.grey.shade500
                                              : Colors.black,
                                        ),
                                      ).tr(),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        const Gap(30),
                      ]),
                ),
                // const Gap(20),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Text(
                    "Order Detail",
                    style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ).tr(),
                ],
              ),
            ),
            const Divider(
                color: Color.fromARGB(255, 236, 227, 227)),
            const Gap(10),
            ListView.separated(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: checkOutProducts.length,
              itemBuilder: (context, index) {
                CartModel cartModel = checkOutProducts[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height:
                    MediaQuery.of(context).size.width >= 1100
                        ? 90
                        : 90,
                    child: Row(
                      children: [
                        Expanded(
                            flex: 2,
                            child: CatImageWidget(
                              url: cartModel.image1,
                              boxFit: 'cover',
                            )),
                        const Gap(20),
                        Expanded(
                            flex: 5,
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  cartModel.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontFamily: 'Nunito',
                                      fontSize: 14,
                                      fontWeight:
                                      FontWeight.w400),
                                ),
                                const Gap(10),
                                Text(
                                  '$currencySymbol${cartModel.selectedPrice.toDouble().toStringAsFixed(2)}',
                                  // '$currencySymbol${Formatter().converter(cartModel.selectedPrice.toDouble())}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontFamily: 'Nunito',
                                      fontSize: 14,
                                      fontWeight:
                                      FontWeight.bold),
                                ),
                                const Gap(10),
                                Text(
                                  'Quantity: ${cartModel.quantity}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontFamily: 'Nunito',
                                      fontSize: 14,
                                      fontWeight:
                                      FontWeight.w400),
                                )
                              ],
                            ))
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder:
                  (BuildContext context, int index) {
                return const Divider(
                    color: Color.fromARGB(255, 236, 227, 227));
              },
            ),
            const Gap(15),
            Builder(
              builder: (context) {
                final rewardState = ref.watch(rewardPointsProvider);
                final currentTotal = cartPriceQuantity.price +
                    (selectedDelivery == 'Delivery' ? deliveryFee : 0) -
                    getPercentageOfCoupon(couponPercentage, cartPriceQuantity.price);

                return Column(
                  children: [
                    // Points Display - Updated text
                    Text(
                      'You have ${rewardState.availablePoints} points (\$${rewardState.redeemableAmount} redeemable)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),

                    if (rewardState.availablePoints >= 500) ...[ // CHANGED: 500 points threshold
                      if (!rewardState.isRedeeming)
                        Slider(
                          value: rewardState.pointsToRedeem.toDouble(),
                          min: 0,
                          max: rewardState.availablePoints.toDouble(),
                          divisions: rewardState.availablePoints ~/ 500, // CHANGED: 500 point increments
                          label: '\$${(rewardState.pointsToRedeem ~/ 500) * 5}', // CHANGED: $5 per 500 points
                          onChanged: (value) {
                            ref.read(rewardPointsProvider.notifier)
                                .updatePointsToRedeem((value ~/ 500) * 500); // CHANGED: 500 point increments
                          },
                        ),

                      if (!rewardState.isRedeeming) ...[
                        if (currentTotal >= 5) // CHANGED: Minimum order total $5 instead of $10
                          if (rewardState.pointsToRedeem >= 500) // CHANGED: 500 points minimum
                            SizedBox(
                              height: 35,
                              child: ElevatedButton(
                                onPressed: () {
                                  final redemptionAmount = (rewardState.pointsToRedeem ~/ 500) * 5; // CHANGED
                                  if (redemptionAmount > currentTotal) {
                                    final maxAllowed = (currentTotal ~/ 5) * 5; // CHANGED: $5 increments
                                    ref.read(rewardPointsProvider.notifier)
                                        .updatePointsToRedeem(maxAllowed * 100); // CHANGED: $5 = 500 points
                                    return;
                                  }
                                  ref.read(rewardPointsProvider.notifier).redeemPoints(currentTotal);
                                },
                                child: Text(
                                  'Redeem \$${(rewardState.pointsToRedeem ~/ 500) * 5}', // CHANGED
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      fontFamily: 'Nunito',
                                      color: Colors.black
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: appColor,
                                    shape: const BeveledRectangleBorder()
                                ),
                              ),
                            )
                          else
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                "Slide to select points to redeem", // Text remains the same
                                style: TextStyle(
                                  color: Colors.grey.shade900,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 14,
                                ),
                              ),
                            )
                        else
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              "Order total must be at least \$5 to redeem points", // CHANGED: $5 minimum
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 14,
                              ),
                            ),
                          ),
                      ] else ...[
                        // Redemption status (when isRedeeming = true)
                        SizedBox(height: 10),
                        Text(
                          'Redeemed: \$${rewardState.pendingRedemptionAmount}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          height: 35,
                          child: ElevatedButton(
                            onPressed: () => ref.read(rewardPointsProvider.notifier).cancelRedemption(),
                            child: const Text(
                              'Remove',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  fontFamily: 'Nunito',
                                  color: Colors.black
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red[400],
                                shape: const BeveledRectangleBorder()
                            ),
                          ),
                        ),
                      ],
                    ],
                  ],
                );
              },
            ),
            const Gap(20),
            if (selectedDelivery == 'Delivery')
              Padding(
                padding: MediaQuery.of(context).size.width >= 1100
                    ? const EdgeInsets.all(8)
                    : const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Delivery Fee',
                      style:
                      TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Nunito',),
                    ).tr(),
                    Text(
                      '$currencySymbol${deliveryFee.toDouble().toStringAsFixed(2)}',
                      // '$currencySymbol${Formatter().converter(deliveryFee.toDouble())}',
                      style: const TextStyle(
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            if (selectedDelivery == 'Delivery')
              Padding(
                padding: MediaQuery.of(context).size.width >= 1100
                    ? const EdgeInsets.all(8)
                    : const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Free Delivery',
                      style:
                      TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Nunito',),
                    ).tr(),
                    Text(
                      '-$currencySymbol${deliveryFee.toDouble().toStringAsFixed(2)}',
                      // '$currencySymbol${Formatter().converter(deliveryFee.toDouble())}',
                      style: const TextStyle(
                          fontFamily: 'Nunito',
                          color : Colors.green,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            Padding(
              padding: MediaQuery.of(context).size.width >= 1100
                  ? const EdgeInsets.all(8)
                  : const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Sub Total',
                    style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Nunito',),
                  ).tr(),
                  Text(
                    // '$currencySymbol${Formatter().converter(cartPriceQuantity.price.toDouble())}',
                    '$currencySymbol${cartPriceQuantity.price.toDouble().toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,fontFamily: 'Nunito',),
                  )
                ],
              ),
            ),
            if (isCouponApplied)
              Padding(
                padding: MediaQuery.of(context).size.width >= 1100
                    ? const EdgeInsets.all(8)
                    : const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Coupon ($couponPercentage%)',
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.bold,
                      ),
                    ).tr(),
                    Text(
                      '-$currencySymbol${discount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            Padding(
              padding: MediaQuery.of(context).size.width >= 1100
                  ? const EdgeInsets.all(8)
                  : const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(fontFamily: 'Nunito',fontWeight: FontWeight.bold),
                  ).tr(),
                  Text(
                    '$currencySymbol${total.toDouble().toStringAsFixed(2)}',
                    // '$currencySymbol${Formatter().converter(total.toDouble())}',
                    // '$currency${Formatter().converter((totalPrice + (selectedDelivery == 'Delivery' ? deliveryFee : 0)).toDouble())}',
                    style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            const Gap(30),
            // CheckboxListTile(
            //   value: isSchedule,
            //   onChanged: (v) {
            //     setState(() {
            //       isSchedule = !isSchedule;
            //       scheduleTime = '';
            //       scheduleDate = '';
            //     });
            //   },
            //   title: const Text(
            //     'Schedule Order',
            //     style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Nunito'),
            //   ),
            // ),
            // if (isSchedule == true)
            //   ScheduleTimePicker(
            //     onDateSelected: (DateTime? date) {
            //       if (date != null) {
            //         // ignore: avoid_print
            //         print('Selected date: $date');
            //         setState(() {
            //           scheduleDate =
            //               DateFormat('yyyy-MM-dd').format(date);
            //         });
            //         // Do something with the date
            //       }
            //     },
            //     onTimeSelected: (TimeOfDay? time) {
            //       if (time != null) {
            //         // ignore: avoid_print
            //         print(
            //             'Selected time: ${time.format(context)}');
            //         setState(() {
            //           scheduleTime = time.format(context);
            //         });
            //         // Do something with the time
            //       }
            //     },
            //   ),
            if (isPrescription == true) const Gap(30),
            if (isPrescription == true)
              imageFile == null
                  ? const Icon(Icons.image,
                  color: Colors.grey, size: 120)
                  : Image.memory(imageFile!,
                  width: 120, height: 120),
            if (isPrescription == true)
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: appColor,
                      shape: const BeveledRectangleBorder()),
                  onPressed: () {
                    // uploadImage(context);
                  },
                  child: const Text(
                    'Upload Prescription',
                    style: TextStyle(color: Colors.white,fontFamily: 'Nunito'),
                  )),
            const Gap(30),
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appColor,
                    shape: const BeveledRectangleBorder(),
                  ),
                  onPressed: selectedPayment == null ||
                      (selectedPayment == 'Pay Now' && total > wallet)
                      ? null
                      : isPrescription == true && prescriptionImage == ''
                      ? null
                      : () async {
                    // ✅ Check for "First Order 10%" coupon usage
                    if (selectedDelivery == 'Delivery' &&
                        (deliveryDetails == null || deliveryDetails.deliveryAddress.trim().isEmpty)) {
                      showAlertDialog(context, "Note", "Please add a delivery address");
                      return;
                    }

                    if (couponTitle.isNotEmpty) {
                      final usedCoupons = await FirebaseFirestore.instance
                          .collection('Orders')
                          .where('userID', isEqualTo: userID)
                          .where('couponTitle', isEqualTo: couponTitle)
                          .get();

                      if (usedCoupons.docs.isNotEmpty) {
                        showAlertDialog(context, "Note", "You have already used this coupon.");
                        setState(() {
                          couponTitle = '';
                          couponPercentage = 0;
                          isCouponApplied = false;
                          couponController.clear();
                        });
                        return;
                      }
                    }

                    final userOrdersSnapshot = await FirebaseFirestore.instance
                        .collection('Orders')
                        .where('userID', isEqualTo: userID)
                        .get();


                    final validOrders = userOrdersSnapshot.docs.where((doc) {
                      final orderStatus = doc['status']?.toString().toLowerCase() ?? '';
                      return orderStatus != 'cancelled';
                    }).toList();

                    final bool isFirstOrder = validOrders.isEmpty;

                    Random random = Random();
                    var result = '';
                    for (int i = 0; i < 9; i++) {
                      result += random.nextInt(10).toString();
                    }

                    Week currentWeek = Week.current();
                    var day = DateTime.now();
                    var dateDay = DateTime.now().day;
                    var month = DateTime.now();
                    String formattedDate = DateFormat('MMMM').format(month);
                    String dayFormatter = DateFormat('EEEE').format(day);

                    if (selectedDelivery == 'Delivery' && selectedPayment == 'Pay Now') {
                      ref.read(updateWalletProvider(total));
                    }

                    for (var element in checkOutProducts) {
                      orders.add({
                        'receivedDate': null,
                        'name': element.name,
                        'status': 'Received',
                        'id': element.productID,
                        'returnDuration': element.returnDuration,
                        'selected': element.selected,
                        'productID': element.productID,
                        'image': element.image1,
                        'totalRating': element.totalRating,
                        'totalNumberOfUserRating': element.totalNumberOfUserRating,
                        'selectedPrice': element.selectedPrice,
                        'category': element.category,
                        'quantity': element.quantity,
                        'vendorId': element.vendorId,
                        'vendorName': element.vendorName,
                        'selectedExtra1': element.selectedExtra1,
                        'selectedExtraPrice1': element.selectedExtraPrice1,
                        'selectedExtra2': element.selectedExtra2,
                        'selectedExtraPrice2': element.selectedExtraPrice2,
                        'selectedExtra3': element.selectedExtra3,
                        'selectedExtraPrice3': element.selectedExtraPrice3,
                        'selectedExtra4': element.selectedExtra4,
                        'selectedExtraPrice4': element.selectedExtraPrice4,
                        'selectedExtra5': element.selectedExtra5,
                        'selectedExtraPrice5': element.selectedExtraPrice5,
                        'isPrescription': element.isPrescription,
                      });
                    }

                    List<String> vendorIDs = [];
                    for (var element in orders) {
                      vendorIDs.add(element['vendorId']);
                    }

                    final orderModel = OrderModel(
                      prescription: isPrescription == true ? true : null,
                      prescriptionPic: isPrescription == true ? prescriptionImage : null,
                      scheduleDate: scheduleDate,
                      scheduleTime: scheduleTime,
                      vendorId: vendorIDs[0],
                      vendorIDs: vendorIDs,
                      confirmationStatus: false,
                      module: widget.module,
                      isPos: false,
                      couponTitle: couponTitle,
                      couponPercentage: couponPercentage,
                      useCoupon: couponTitle.isEmpty ? false : true,
                      day: dayFormatter,
                      instruction: '',
                      pickupAddress: selectedDelivery == 'Pickup' ? pickupAddress : '',
                      pickupPhone: selectedDelivery == 'Pickup' ? pickupPhone : '',
                      pickupStorename: selectedDelivery == 'Pickup' ? pickupStorename : '',
                      weekNumber: currentWeek.weekNumber,
                      date: '$dayFormatter, $formattedDate $dateDay',
                      orderID: result,
                      orders: orders,
                      uid: uid,
                      acceptDelivery: false,
                      deliveryFee: selectedDelivery == 'Pickup' ? 0 : deliveryFee,
                      total: total,
                      // paymentType: selectedPayment == 'Pay Now' ? 'Wallet' : 'Cash On Delivery',
                      paymentType:selectedPayment == 'Zelle Payment' ? 'Zelle Payment' : 'Cash On Delivery',
                      userID: userID,
                      timeCreated: DateTime.now(),
                      deliveryAddress: selectedDelivery == 'Pickup'
                          ? ''
                          : deliveryDetails?.deliveryAddress ?? '',
                      houseNumber: selectedDelivery == 'Pickup'
                          ? ''
                          : deliveryDetails?.houseNumber ?? '',
                      closesBusStop: selectedDelivery == 'Pickup'
                          ? ''
                          : deliveryDetails?.closestBusStop ?? '',
                      deliveryBoyID: '',
                      status: 'Pending',
                      accept: false,
                      pointsRedeemed: rewardState.pendingRedemptionAmount,
                      pointsUsed: rewardState.pendingPointsUsed,
                    );

                    // Use .then() to ensure these happen AFTER order is placed
                    addToOrder(orderModel, uid,isFirstOrder, context).then((_) async {
                      // This will execute after addToOrder completes successfully
                      if (rewardState.isRedeeming) {
                        try {
                          await ref.read(rewardPointsProvider.notifier)
                              .confirmRedemption(result); // result is your orderId
                          // Cart clearing happens only after successful order creation
                          await clearRestaurantCart.clearCartRestaurant();
                        } catch (e) {
                          // If order creation fails, cancel the redemption
                          ref.read(rewardPointsProvider.notifier).cancelRedemption();
                          throw e; // Re-throw to show error to user
                        }
                      } else {
                        await clearRestaurantCart.clearCartRestaurant();
                      }
                    }).catchError((error) {
                      // Handle any errors that occurred during addToOrder
                      debugPrint('Order placement failed: $error');

                    }
                    );
                  },
                  child: const Text(
                    'Place Order',
                    style: TextStyle(color: Colors.black,fontFamily: 'Nunito',fontWeight: FontWeight.w600,fontSize: 16),
                  ).tr(),
                ),
              ),
            ),
            const Gap(30)
          ],
        ),
      ),
    );
  }
}
