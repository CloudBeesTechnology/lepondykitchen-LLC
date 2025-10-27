import 'dart:async';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:animations/animations.dart';
import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_web/model/formatter.dart';
import 'package:user_web/model/history.dart';
import 'package:user_web/model/order_model.dart';
import 'package:user_web/model/user.dart';
import 'package:user_web/pages/chat_page.dart';
import 'package:user_web/pages/return_product_page.dart';
import 'package:user_web/widgets/cat_image_widget.dart';

import 'package:user_web/constant.dart';

import '../pages/chat_vendor_page.dart';
import '../providers/push_notification.dart';

class OrderDetailWidget extends StatefulWidget {
  final String uid;
  const OrderDetailWidget({super.key, required this.uid});

  @override
  State<OrderDetailWidget> createState() => _OrderDetailWidgetState();
}

class _OrderDetailWidgetState extends State<OrderDetailWidget> {
  OrderModel2? orderDetail;
  num quantity = 0;
  num selectedPrice = 0;

  String currency = '';
  bool isLoading = true;
  StreamSubscription<DocumentSnapshot>? _subscription;

  Future<void> fetchOrderDetail() async {
    setState(() {
      isLoading = true;
      orderDetail = null;
    });
    context.loaderOverlay.show();

    FirebaseFirestore.instance
        .collection('Orders')
        .doc(widget.uid)
        .snapshots(includeMetadataChanges: true)
        .listen((doc) {
      if (mounted) {
        context.loaderOverlay.hide();
      }
      setState(() {
        isLoading = false;
        orderDetail = OrderModel2(
          scheduleDate: doc.data()!['scheduleDate'],
          scheduleTime: doc.data()!['scheduleTime'],
          vendorId: doc.data()!['vendorId'],
          senderName: doc.data()!['senderName'],
          receiverName: doc.data()!['receiverName'],
          parcelCategory: doc.data()!['parcelCategory'],
          senderEmail: doc.data()!['senderEmail'],
          senderPhone: doc.data()!['senderPhone'],
          senderAddress: doc.data()!['senderAddress'],
          senderHouseNumber: doc.data()!['senderHouseNumber'],
          senderStreetNumber: doc.data()!['senderStreetNumber'],
          senderFloorNumber: doc.data()!['senderFloorNumber'],
          receiverPhone: doc.data()!['receiverPhone'],
          receiverEmail: doc.data()!['receiverEmail'],
          receiverAddress: doc.data()!['receiverAddress'],
          receiverHouseNumber: doc.data()!['receiverHouseNumber'],
          receiverStreetNumber: doc.data()!['receiverStreetNumber'],
          receiverFloorNumber: doc.data()!['receiverFloorNumber'],
          parcelAdminCommission: doc.data()!['parcelAdminCommission'],
          parcelPayer: doc.data()!['parcelPayer'],
          prescription: doc.data()!['prescription'],
          prescriptionPic: doc.data()!['prescriptionPic'],
          module: doc.data()!['module'],
          orders: [
            ...(doc.data()!['orders']).map((items) {
              return OrdersList.fromMap(items);
            })
          ],
          pickupStorename: doc.data()!['pickupStorename'],
          pickupPhone: doc.data()!['pickupPhone'],
          pickupAddress: doc.data()!['pickupAddress'],
          instruction: doc.data()!['instruction'],
          couponPercentage: doc.data()!['couponPercentage'],
          couponTitle: doc.data()!['couponTitle'],
          useCoupon: doc.data()!['useCoupon'],
          confirmationStatus: doc.data()!['confirmationStatus'],
          uid: doc.data()!['uid'],
          // marketID: doc.data()!['marketID'],
          vendorIDs: [
            ...(doc.data()!['vendorIDs']).map((items) {
              return items;
            })
          ],
          userID: doc.data()!['userID'],
          deliveryAddress: doc.data()!['deliveryAddress'],
          houseNumber: doc.data()!['houseNumber'],
          closesBusStop: doc.data()!['closesBusStop'],
          deliveryBoyID: doc.data()!['deliveryBoyID'],
          status: doc.data()!['status'],
          accept: doc.data()!['accept'],
          orderID: doc.data()!['orderID'],
          timeCreated: doc.data()!['timeCreated'].toDate(),
          total: doc.data()!['total'],
          deliveryFee: doc.data()!['deliveryFee'],
          acceptDelivery: doc.data()!['acceptDelivery'],
          paymentType: doc.data()!['paymentType'],
          pointsRedeemed: doc.data()!['pointsRedeemed'],
          pointsUsed: doc.data()!['pointsUsed'],
        );
      });
      setState(() {
        // carts.remove(id);
        quantity =
            orderDetail!.orders!.fold(0, (m, product) => m + product.quantity);
        selectedPrice = orderDetail!.orders!.fold(
            0, (s, product) => s + product.selectedPrice * product.quantity);
      });
    });
    //  for (var element in orderDetail!.orders) {

    //  }
  }

  @override
  initState() {
    super.initState();
    getCurrency();
    fetchOrderDetail();
  }


  @override
  void didUpdateWidget(OrderDetailWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.uid != oldWidget.uid) {
      // Cancel old subscription if UID changes
      _subscription?.cancel();
      fetchOrderDetail(); // Fetch new data
    }
  }

  @override
  void dispose() {
    _subscription?.cancel(); // Clean up subscription
    super.dispose();
  }

  getCurrency() {
    FirebaseFirestore.instance
        .collection('Currency Settings')
        .doc('Currency Settings')
        .get()
        .then((value) {
      setState(() {
        currency = value['Currency symbol'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (MediaQuery.of(context).size.width >= 1100) const Gap(10),
          //  if (MediaQuery.of(context).size.width >= 1100)
          if (MediaQuery.of(context).size.width >= 1100)
            Align(
              alignment: MediaQuery.of(context).size.width >= 1100
                  ? Alignment.bottomLeft
                  : Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width >= 1100 ? 20 : 0),
                child: Row(
                  children: [
                    InkWell(
                        onTap: () {
                          context.go('/orders');
                        },
                        child: const Icon(Icons.arrow_back)),
                    const Gap(20),
                    Text(
                      'Order Details',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.width >= 1100
                              ? 15
                              : 15),
                    ).tr(),
                  ],
                ),
              ),
            ),
          if (MediaQuery.of(context).size.width >= 1100)
            const Divider(
              color: Color.fromARGB(255, 237, 235, 235),
              thickness: 1,
            ),
          if (MediaQuery.of(context).size.width >= 1100) const Gap(20),
          if (isLoading == true)
            MediaQuery.of(context).size.width >= 1100
                ? Padding(
                    padding: const EdgeInsets.only(left: 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Gap(20),
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
                        const Gap(20),
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
                  ),
          if (isLoading == false)
            Padding(
              padding: MediaQuery.of(context).size.width >= 1100
                  ? const EdgeInsets.only(left: 25, right: 25)
                  : const EdgeInsets.all(8.0),
              child: Result(
                selectedPrice: selectedPrice,
                orderModel2: orderDetail!,
                quantity: quantity,
                currency: currency,
              ),
            )
        ],
      ),
    );
  }
}




class Result extends StatefulWidget {
  final OrderModel2 orderModel2;
  final num quantity;
  final num selectedPrice;
  final String currency;
  const Result(
      {super.key,
      required this.orderModel2,
      required this.quantity,
      required this.currency,
      required this.selectedPrice});

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  bool isLoading = false;
  num wallet = 0;
  DateTime? completedTimeCreated;
  String userID = '';
  String reviewProduct = '';
  num ratingValProduct = 0;
  String name = '';
  String phoneNo='';

  getCompletedTimeCreated() {
    FirebaseFirestore.instance
        .collection('Orders')
        .doc(widget.orderModel2.uid)
        .snapshots()
        .listen((event) {
      if (event.exists && event.data()!.containsKey('completedTimeCreated')) {
        final timestamp = event['completedTimeCreated'];
        if (timestamp != null) {
          setState(() {
            completedTimeCreated = timestamp.toDate();
          });
          print(completedTimeCreated);
        }
      } else {
        print("Field 'completedTimeCreated' does not exist in document.");
      }
    });
  }


  getWallet() {
    setState(() {
      isLoading = true;
    });
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .snapshots()
        .listen((event) {
      setState(() {
        userID = user.uid;
        //  userID = user.uid;

        isLoading = false;
        wallet = event['wallet'];
        name = event['fullname'];
        phoneNo=event['phone'];
      });
      //  print('Fullname is $fullName');
    });
  }

  getExpiryForReturnPolicy(int returnPolicy) {
    if (completedTimeCreated != null) {}
    DateTime fixedDate = DateTime(completedTimeCreated!.year,
        completedTimeCreated!.month, completedTimeCreated!.day);
    var result = fixedDate.add(Duration(days: returnPolicy));
    // ignore: avoid_print
    print('Result is $result');
    // Get the current date
    DateTime currentDate = DateTime.now();

    // Check if the current date is greater than the new date
    bool dateExceeded = currentDate.isAfter(result);
    if (dateExceeded) {
      // ignore: avoid_print
      print('Date has been exceeded');
      // ignore: avoid_print
      print('Date bool is $dateExceeded');
    } else {
      // ignore: avoid_print
      print('Date has not been exceeded');
      // ignore: avoid_print
      print('Date bool is $dateExceeded');
    }
    return result;
  }

  getExpiry(int returnPolicy) {
    if (completedTimeCreated != null) {
      DateTime fixedDate = DateTime(completedTimeCreated!.year,
          completedTimeCreated!.month, completedTimeCreated!.day);
      var result = fixedDate.add(Duration(days: returnPolicy));
      // Parse the string into a DateTime object
      DateTime dateTime = DateTime.parse(result.toString());

      // Format the DateTime object to the desired format
      String formattedDate = DateFormat('MMMM d, y').format(dateTime);

      return formattedDate;
    } else {
      return '';
    }
  }

  getExpiryBool(int returnPolicy) {
    if (completedTimeCreated != null) {}
    DateTime fixedDate = DateTime(completedTimeCreated!.year,
        completedTimeCreated!.month, completedTimeCreated!.day);
    var result = fixedDate.add(Duration(days: returnPolicy));
    // ignore: avoid_print
    print('Result is $result');
    // Get the current date
    DateTime currentDate = DateTime.now();

    // Check if the current date is greater than the new date
    bool dateExceeded = currentDate.isAfter(result);
    if (dateExceeded) {
      // ignore: avoid_print
      print('Date has been exceeded');
      // ignore: avoid_print
      print('Date bool is $dateExceeded');
      return true;
    } else {
      // ignore: avoid_print
      print('Date has not been exceeded');
      // ignore: avoid_print
      print('Date bool is $dateExceeded');
      return false;
    }
    //return result;
  }

  UserModel vendorDetail = UserModel(
      displayName: '',
      phonenumber: '',
      email: '',
      token: '',
      uid: '',
      referralCode: '',
      photoUrl: '');

  getVendorDetails(String vendorUID) async {
    var doc = await FirebaseFirestore.instance
        .collection('vendors')
        .doc(vendorUID)
        .get();
    setState(() {
      vendorDetail = UserModel.fromMap(doc.data()!, doc.id);
    });
  }

  @override
  void initState() {
    getCompletedTimeCreated();
    getVendorDetails(widget.orderModel2.vendorId);
    getWallet();
    getRiderDetail();
    super.initState();
  }

  String riderName = '';
  String riderPhone = '';
  String riderToken = '';
  getRiderDetail() {
    if (widget.orderModel2.acceptDelivery == true) {
      FirebaseFirestore.instance
          .collection('riders')
          .doc(widget.orderModel2.deliveryBoyID)
          .get()
          .then((value) {
        setState(() {
          riderName = value['fullname'];
          riderPhone = value['phone'];
          riderToken = value['tokenID'];
        });
      });
    }
  }

  cancelOrder() {
    showModal(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: const Text('Are you sure you want to cancel this order?').tr(),
          actions: [
            TextButton(
              onPressed: () async {
                if (widget.orderModel2.paymentType == 'Wallet') {
                  updateWallet(); // optional: refund logic if needed
                }

                await FirebaseFirestore.instance
                    .collection('Orders')
                    .doc(widget.orderModel2.uid)
                    .update({'status': 'Cancelled'}).then((value) {
                  if (context.mounted) {
                    context.go('/orders'); // navigate back to orders page
                    context.pop(); // close the dialog
                  }

                  Fluttertoast.showToast(
                    msg: "Your order has been cancelled".tr(),
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.TOP,
                    backgroundColor:  const Color(0xFFFFD581),
                    textColor: Colors.black,
                    webBgColor: "#FFD581",
                    webPosition: "center",
                    timeInSecForIosWeb: 3,
                    fontSize: 14.0,
                  );
                });
              },
              child: const Text('Yes').tr(),
            ),
            TextButton(
              onPressed: () {
                context.pop();
              },
              child: const Text('No').tr(),
            ),
          ],
        );
      },
    );
  }

  getPercentageOfCoupon() {
    if (widget.orderModel2.couponPercentage != 0) {
      var result =
          (widget.orderModel2.total * widget.orderModel2.couponPercentage!) /
              100;
      return result;
    } else {
      return 0;
    }
  }

  updateWallet() {
    var total = widget.orderModel2.total + getPercentageOfCoupon();
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .update({'wallet': wallet + total}).then((value) {
      // Get the current date and time
      // DateTime now = DateTime.now();

      // // Format the date to '24th January, 2024' format
      // String formattedDate = DateFormat('d MMMM, y').format(now);
      history(HistoryModel(
          message: 'Debit Alert',
          amount: total.toString(),
          paymentSystem: 'Wallet',
          timeCreated: DateTime.now()));
    });
  }

  history(HistoryModel historyModel) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('Transaction History')
        .add(historyModel.toMap());
  }

  ratingAndReviewProduct(
    String productID,
  ) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Review Product').tr(),
            content: SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              width: double.infinity,
              child: Column(children: [
                RatingBar.builder(
                  initialRating: 1,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    setState(() {
                      ratingValProduct = rating;
                    });
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                  maxLines: 5,
                  decoration: InputDecoration(
                    filled: true,

                    border: InputBorder.none,
                    fillColor: const Color.fromARGB(255, 236, 234, 234),
                    hintText: 'Review Product'.tr(),
                    //border: OutlineInputBorder()
                  ),
                  onChanged: (val) {
                    setState(() {
                      reviewProduct = val;
                    });
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: appColor),
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection('Products')
                          .doc(productID)
                          .get()
                          .then((v) {
                        if (v.exists) {
                          if (context.mounted) {
                            context.loaderOverlay.show();
                          }
                          FirebaseFirestore.instance
                              .collection('Products')
                              .doc(productID)
                              .get()
                              .then((value) {
                            if (context.mounted) {
                              context.loaderOverlay.hide();
                            }
                            FirebaseFirestore.instance
                                .collection('Products')
                                .doc(productID)
                                .update({
                              'totalRating':
                                  value['totalRating'] + ratingValProduct,
                              'totalNumberOfUserRating':
                                  value['totalNumberOfUserRating'] + 1
                            });
                          });

                          FirebaseFirestore.instance
                              .collection('Products')
                              .doc(productID)
                              .collection('Ratings')
                              .add({
                            'rating': ratingValProduct,
                            'review': reviewProduct,
                            'fullname': name,
                            'profilePicture': '',
                            'timeCreated': DateFormat.yMMMMEEEEd()
                                .format(DateTime.now())
                                .toString()
                          }).then((value) {
                            if (context.mounted) {
                              Navigator.of(context).pop();
                            }
                          });
                        } else {
                          FirebaseFirestore.instance
                              .collection('Flash Sales')
                              .doc(productID)
                              .get()
                              .then((v) {
                            if (v.exists) {
                              if (context.mounted) {
                                context.loaderOverlay.show();
                              }
                              FirebaseFirestore.instance
                                  .collection('Flash Sales')
                                  .doc(productID)
                                  .get()
                                  .then((value) {
                                if (context.mounted) {
                                  context.loaderOverlay.hide();
                                }
                                FirebaseFirestore.instance
                                    .collection('Flash Sales')
                                    .doc(productID)
                                    .update({
                                  'totalRating':
                                      value['totalRating'] + ratingValProduct,
                                  'totalNumberOfUserRating':
                                      value['totalNumberOfUserRating'] + 1
                                });
                              });

                              FirebaseFirestore.instance
                                  .collection('Flash Sales')
                                  .doc(productID)
                                  .collection('Ratings')
                                  .add({
                                'rating': ratingValProduct,
                                'review': reviewProduct,
                                'fullname': name,
                                'profilePicture': '',
                                'timeCreated': DateFormat.yMMMMEEEEd()
                                    .format(DateTime.now())
                                    .toString()
                              }).then((value) {
                                if (context.mounted) {
                                  Navigator.of(context).pop();
                                }
                              });
                            } else {
                              FirebaseFirestore.instance
                                  .collection('Hot Deals')
                                  .doc(productID)
                                  .get()
                                  .then((v) {
                                if (context.mounted) {
                                  context.loaderOverlay.show();
                                }
                                FirebaseFirestore.instance
                                    .collection('Hot Deals')
                                    .doc(productID)
                                    .get()
                                    .then((value) {
                                  if (context.mounted) {
                                    context.loaderOverlay.hide();
                                  }
                                  FirebaseFirestore.instance
                                      .collection('Hot Deals')
                                      .doc(productID)
                                      .update({
                                    'totalRating':
                                        value['totalRating'] + ratingValProduct,
                                    'totalNumberOfUserRating':
                                        value['totalNumberOfUserRating'] + 1
                                  });
                                });

                                FirebaseFirestore.instance
                                    .collection('Hot Deals')
                                    .doc(productID)
                                    .collection('Ratings')
                                    .add({
                                  'rating': ratingValProduct,
                                  'review': reviewProduct,
                                  'fullname': name,
                                  'profilePicture': '',
                                  'timeCreated': DateFormat.yMMMMEEEEd()
                                      .format(DateTime.now())
                                      .toString()
                                }).then((value) {
                                  if (context.mounted) {
                                    Navigator.of(context).pop();
                                  }
                                });
                              });
                            }
                          });
                        }
                      });
                    },
                    child: const Text(
                      'Submit',
                      style: TextStyle(color: Colors.white),
                    ).tr())
              ]),
            ),
          );
        });
  }

  ratingAndReviewVendor(
    String productID,
  ) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Rate Vendor').tr(),
            content: SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              width: double.infinity,
              child: Column(children: [
                RatingBar.builder(
                  initialRating: 1,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    setState(() {
                      ratingValProduct = rating;
                    });
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: appColor),
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection('vendors')
                          .doc(productID)
                          .update({
                        'totalRating': FieldValue.increment(ratingValProduct),
                        'totalNumberOfUserRating': FieldValue.increment(1)
                      }).then((v) {
                        if (context.mounted) {
                          Navigator.of(context).pop();
                        }
                      });
                    },
                    child: const Text(
                      'Submit',
                      style: TextStyle(color: Colors.white),
                    ).tr())
              ]),
            ),
          );
        });
  }

  num tipAmmount = 0;

  Future<void> tipRider({
    required String userId,
    required String riderId,
  }) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Tip Rider').tr(),
            content: SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              width: double.infinity,
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter
                          .digitsOnly, // Allows only digits
                    ],
                    keyboardType: TextInputType.number,
                    onChanged: (v) {
                      setState(() {
                        tipAmmount = int.parse(v);
                      });
                    },
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: appColor),
                    onPressed: () async {
                      final FirebaseFirestore firestore =
                          FirebaseFirestore.instance;

                      try {
                        // Start a Firestore transaction
                        await firestore.runTransaction((transaction) async {
                          // References to the user and rider documents
                          DocumentReference userRef =
                              firestore.collection('users').doc(userId);
                          DocumentReference riderRef =
                              firestore.collection('riders').doc(riderId);

                          // Fetch the user document
                          DocumentSnapshot userSnapshot =
                              await transaction.get(userRef);
                          if (!userSnapshot.exists) {
                            throw Exception("User not found");
                          }

                          // Fetch the rider document
                          DocumentSnapshot riderSnapshot =
                              await transaction.get(riderRef);
                          if (!riderSnapshot.exists) {
                            throw Exception("Rider not found");
                          }

                          // Get the current wallet balances
                          double userWallet = userSnapshot['wallet'] ?? 0.0;
                          double riderWallet = riderSnapshot['wallet'] ?? 0.0;

                          // Validate the amount
                          if (tipAmmount <= 0) {
                            // Fluttertoast.showToast(
                            //     msg: "Amount must be greater than zero".tr(),
                            //     toastLength: Toast.LENGTH_SHORT,
                            //     gravity: ToastGravity.TOP,
                            //     timeInSecForIosWeb: 6,
                            //     fontSize: 14.0);
                            showAlertDialog(context,'Note',"Amount must be greater than zero" );
                            throw Exception("Amount must be greater than zero");
                          }
                          if (userWallet < tipAmmount) {
                            // Fluttertoast.showToast(
                            //     msg: "Insufficient funds in user's wallet".tr(),
                            //     toastLength: Toast.LENGTH_SHORT,
                            //     gravity: ToastGravity.TOP,
                            //     timeInSecForIosWeb: 6,
                            //     fontSize: 14.0);
                            showAlertDialog(context,"Alert","Insufficient funds in user's wallet");
                            throw Exception(
                                "Insufficient funds in user's wallet");
                          }

                          // Deduct from user's wallet and add to rider's wallet
                          transaction.update(
                              userRef, {'wallet': userWallet - tipAmmount});
                          transaction.update(
                              riderRef, {'wallet': riderWallet + tipAmmount});
                        });
                        // Fluttertoast.showToast(
                        //     msg:
                        //         "Transaction successful: \$${tipAmmount} tipped to rider $riderId"
                        //             .tr(),
                        //     toastLength: Toast.LENGTH_SHORT,
                        //     gravity: ToastGravity.TOP,
                        //     timeInSecForIosWeb: 6,
                        //     fontSize: 14.0);
                        showAlertsDialog(context,"Transaction successful: \$${tipAmmount} tipped to rider $riderId");
                        PushNotificationFunction.sendPushNotification(
                          'tip received',
                          '${widget.orderModel2.orderID} tipped you',
                          riderToken,
                        );
                        Navigator.pop(context);
                        print(
                            "Transaction successful: \$${tipAmmount} tipped to rider $riderId");
                      } catch (e) {
                        print("Transaction failed: $e");
                        rethrow; // Re-throw the exception after logging it
                      }
                    },
                    child: const Text(
                      'Tip',
                      style: TextStyle(color: Colors.white),
                    ).tr())
              ]),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // Parse the string into a DateTime object
    DateTime dateTime =
        DateTime.parse(widget.orderModel2.timeCreated.toString());

    // Format the DateTime object to the desired format
    String formattedDate = DateFormat('MMMM d, y').format(dateTime);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Order no ${widget.orderModel2.orderID}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const Gap(5),
            IconButton(
                onPressed: () {
                  FlutterClipboard.copy(widget.orderModel2.orderID)
                      // ignore: avoid_print
                      .then((value) => print('copied'));
                  Fluttertoast.showToast(
                      msg: "Order id has been copied".tr(),
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.TOP,
                      timeInSecForIosWeb: 3,
                      backgroundColor:  const Color(0xFFFFD581),
                      textColor: Colors.black,
                      webBgColor: "#FFD581",
                       webPosition: "center",

                      fontSize: 14.0);
                },
                icon: const Icon(
                  Icons.copy,
                  size: 14,
                ))
          ],
        ),
        const Gap(5),
        Text('Order Status: ${widget.orderModel2.status}'),
        const Gap(5),
        Text('${widget.quantity} items'),
        const Gap(5),
        Text('Placed on $formattedDate'),
        if (widget.orderModel2.scheduleDate!.isNotEmpty) const Gap(5),
        if (widget.orderModel2.scheduleDate!.isNotEmpty)
          Text('Scheduled Date ${widget.orderModel2.scheduleDate}'),
        if (widget.orderModel2.scheduleDate!.isNotEmpty) const Gap(5),
        if (widget.orderModel2.scheduleDate!.isNotEmpty)
          Text('Scheduled Time ${widget.orderModel2.scheduleTime}'),
        const Gap(5),
        Text(
            'Total ${widget.currency}${widget.orderModel2.total.toDouble().toStringAsFixed(2)}'),
            // 'Total ${widget.currency}${Formatter().converter(widget.orderModel2.total.toDouble())}'),
        const Gap(10),
        const Divider(
          color: Color.fromARGB(255, 237, 235, 235),
          thickness: 1,
        ),
        const Gap(10),
        const Text(
          'ITEMS IN YOUR ORDER',
          style: TextStyle(fontWeight: FontWeight.bold),
        ).tr(),
        const Gap(10),
        // const Divider(
        //   color: Color.fromARGB(255, 237, 235, 235),
        //   thickness: 1,
        // ),
        // const Gap(10),
        ListView.builder(
          physics: const ClampingScrollPhysics(),
          shrinkWrap: true,
          itemCount: widget.orderModel2.orders!.length,
          itemBuilder: (context, index) {
            OrdersList cartModel = widget.orderModel2.orders![index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(2)),
                    border: Border.all(
                        color: const Color.fromARGB(255, 237, 235, 235))),
                // height: MediaQuery.of(context).size.width >= 1100
                //     ? widget.orderModel2.status == 'Delivered'
                //         ? 220
                //         : 200
                //     : widget.orderModel2.status == 'Delivered'
                //         ? 250
                //         : 220,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 3,
                          child: SizedBox(
                            height: MediaQuery.of(context).size.width >= 1100
                                ? 200
                                : 100,
                            width: 100,
                            child: CatImageWidget(
                              url: cartModel.image,
                              boxFit: 'cover',
                            ),
                          )),
                      const Gap(20),
                      Expanded(
                          flex: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                cartModel.productName,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w200),
                              ),
                              const Gap(10),
                              Text(
                                '${widget.currency}${cartModel.selectedPrice.toDouble().toStringAsFixed(2)}',
                                // '${widget.currency}${Formatter().converter(cartModel.selectedPrice.toDouble())}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                              const Gap(10),
                              Text(
                                'Selected Product: ${cartModel.selected}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w200),
                              ).tr(),
                              const Gap(10),
                              Text(
                                'Quantity: ${cartModel.quantity}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w200),
                              ).tr(),
                              if (cartModel.selectedExtra1!.isNotEmpty ||
                                  cartModel.selectedExtra2!.isNotEmpty ||
                                  cartModel.selectedExtra3!.isNotEmpty ||
                                  cartModel.selectedExtra4!.isNotEmpty ||
                                  cartModel.selectedExtra5!.isNotEmpty)
                                const Text(
                                  'Extras:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              if (cartModel.selectedExtra1 != null)
                                if (cartModel.selectedExtra1 != '')
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('${cartModel.selectedExtra1}',
                                            style:
                                                const TextStyle(fontSize: 12)),
                                        Text(
                                            '${cartModel.quantity} x ${widget.currency}${Formatter().converter(cartModel.selectedExtraPrice1!.toDouble())}',
                                            style:
                                                const TextStyle(fontSize: 12))
                                      ],
                                    ),
                                  ),
                              if (cartModel.selectedExtra2 != null)
                                if (cartModel.selectedExtra2 != '')
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('${cartModel.selectedExtra2}',
                                            style:
                                                const TextStyle(fontSize: 12)),
                                        Text(
                                            '${cartModel.quantity} x ${widget.currency}${Formatter().converter(cartModel.selectedExtraPrice2!.toDouble())}',
                                            style:
                                                const TextStyle(fontSize: 12))
                                      ],
                                    ),
                                  ),
                              if (cartModel.selectedExtra3 != null)
                                if (cartModel.selectedExtra3 != '')
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('${cartModel.selectedExtra3}',
                                            style:
                                                const TextStyle(fontSize: 12)),
                                        Text(
                                            '${cartModel.quantity} x ${widget.currency}${Formatter().converter(cartModel.selectedExtraPrice3!.toDouble())}',
                                            style:
                                                const TextStyle(fontSize: 12))
                                      ],
                                    ),
                                  ),
                              if (cartModel.selectedExtra4 != null)
                                if (cartModel.selectedExtra4 != '')
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('${cartModel.selectedExtra4}',
                                            style:
                                                const TextStyle(fontSize: 12)),
                                        Text(
                                            '${cartModel.quantity} x ${widget.currency}${Formatter().converter(cartModel.selectedExtraPrice4!.toDouble())}',
                                            style:
                                                const TextStyle(fontSize: 12))
                                      ],
                                    ),
                                  ),
                              if (cartModel.selectedExtra5 != null)
                                if (cartModel.selectedExtra5 != '')
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(cartModel.selectedExtra5!,
                                            style:
                                                const TextStyle(fontSize: 12)),
                                        Text(
                                            '${cartModel.quantity} x ${widget.currency}${Formatter().converter(cartModel.selectedExtraPrice5!.toDouble())}',
                                            style:
                                                const TextStyle(fontSize: 12))
                                      ],
                                    ),
                                  ),
                              // const Gap(10),
                              const Gap(10),
                              if (cartModel.returnDuration == 0)
                                const Text(
                                  'No return policy on this product',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w200),
                                ).tr(),
                              if (cartModel.returnDuration != 0 &&
                                  completedTimeCreated != null &&
                                  getExpiryBool(cartModel.returnDuration) ==
                                      false)
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(12))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return ReturnProductPage(
                                            userID: userID,
                                            orderID: widget.orderModel2.orderID,
                                            ordersList: cartModel,
                                          );
                                        }));
                                      },
                                      child: Text(
                                        'Return policy expires on  ${getExpiry(cartModel.returnDuration)}, Tap to request for a return',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: appColor,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w200),
                                      ).tr(),
                                    ),
                                  ),
                                ),
                              if (cartModel.returnDuration != 0 &&
                                  completedTimeCreated != null &&
                                  getExpiryBool(cartModel.returnDuration) ==
                                      true)
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(12))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      'Return policy on this product has expired',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: appColor,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w200),
                                    ).tr(),
                                  ),
                                ),
                              if (cartModel.returnDuration != 0 &&
                                  completedTimeCreated == null)
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(12))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      'Return policy of ${cartModel.returnDuration} days',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: appColor,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w200),
                                    ).tr(),
                                  ),
                                ),
                              const Gap(10),
                              RichText(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                text: TextSpan(
                                    text: 'Seller: ',
                                    style: TextStyle(
                                      // color: Colors.black,
                                      color: AdaptiveTheme.of(context)
                                                  .mode
                                                  .isDark ==
                                              true
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: cartModel.vendorName.isEmpty
                                            ? appName
                                            : cartModel.vendorName,
                                        style: TextStyle(
                                            color: Colors.blue, fontSize: 10.r),
                                      )
                                    ]),
                              ),
                              if (widget.orderModel2.status == 'Confirmed')
                                const Gap(10),
                              if (widget.orderModel2.status == 'Confirmed')
                                Center(
                                  child: TextButton(
                                      onPressed: () {
                                        ratingAndReviewProduct(
                                          cartModel.productID,
                                        );
                                      },
                                      child: const Text('Review & Rate Product')
                                          .tr()),
                                )
                            ],
                          ))
                    ],
                  ),
                ),
              ),
            );
          },
          // separatorBuilder:
          //     (BuildContext context, int index) {
          //   return const Divider(
          //       color:
          //           Color.fromARGB(255, 236, 227, 227));
          // },
        ),
        const Gap(20),
        const Text(
          'VENDOR INFORMATION',
          style: TextStyle(fontWeight: FontWeight.bold),
        ).tr(),
        const Gap(5),
        const Divider(
          color: Color.fromARGB(255, 237, 235, 235),
          thickness: 1,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(10),
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: 'Vendor Name: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: vendorDetail.displayName),
                ],
              ),
            ),
            const Gap(10),
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: 'Vendor Email: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: vendorDetail.email),
                ],
              ),
            ),
            const Gap(10),
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: 'Vendor Phone: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: vendorDetail.phonenumber),
                ],
              ),
            ),
            const Gap(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton.icon(
                  style: TextButton.styleFrom(backgroundColor: appColor),
                  onPressed: () {
                    if (MediaQuery.of(context).size.width >= 1100) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 1.5,
                                  child: ChatVendorPage(
                                      vendorID: widget.orderModel2.vendorId)),
                            );
                          });
                    } else {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return ChatVendorPage(
                            vendorID: widget.orderModel2.vendorId);
                      }));
                    }
                  },
                  label: const Text(
                    "Chat Vendor",
                    style: TextStyle(color: Colors.white),
                  ),
                  icon: const Icon(
                    Icons.chat,
                    color: Colors.white,
                  ),
                ),
                const Gap(20),
                TextButton.icon(
                  style: TextButton.styleFrom(backgroundColor: appColor),
                  onPressed: () {
                    makePhoneCall(vendorDetail.phonenumber);
                  },
                  label: const Text(
                    "Call Vendor",
                    style: TextStyle(color: Colors.white),
                  ),
                  icon: const Icon(
                    Icons.chat,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            if (widget.orderModel2.status == 'Delivered') const Gap(20),
            if (widget.orderModel2.status == 'Delivered')
              Center(
                child: TextButton(
                    style: TextButton.styleFrom(backgroundColor: appColor),
                    onPressed: () {
                      ratingAndReviewVendor(
                        widget.orderModel2.vendorId,
                      );
                    },
                    child: const Text(
                      'Rate vendor',
                      style: TextStyle(color: Colors.white),
                    ).tr()),
              ),
            if (widget.orderModel2.status == 'Delivered' &&
                widget.orderModel2.deliveryAddress!.isNotEmpty)
              const Gap(20),
            if (widget.orderModel2.status == 'Delivered' &&
                widget.orderModel2.deliveryAddress!.isNotEmpty)
              Center(
                child: TextButton(
                    style: TextButton.styleFrom(backgroundColor: appColor),
                    onPressed: () {
                      tipRider(
                          userId: widget.orderModel2.userID,
                          riderId: widget.orderModel2.deliveryBoyID);
                    },
                    child: const Text(
                      'Tip Rider',
                      style: TextStyle(color: Colors.white),
                    ).tr()),
              ),
            const Gap(20),
          ],
        ),

        const Gap(20),
        const Text(
          'Customer INFORMATION',
          style: TextStyle(fontWeight: FontWeight.bold),
        ).tr(),
        const Gap(5),
        const Divider(
          color: Color.fromARGB(255, 237, 235, 235),
          thickness: 1,
        ),
        const Gap(10),
        Text('Customer Name: ${name}'),
        Text('Customer Phone no: ${phoneNo}'),
        const Gap(20),
        const Text(
          'PAYMENT INFORMATION',
          style: TextStyle(fontWeight: FontWeight.bold),
        ).tr(),
        const Gap(5),
        const Divider(
          color: Color.fromARGB(255, 237, 235, 235),
          thickness: 1,
        ),
        const Gap(10),

        Text('Payment Method: ${widget.orderModel2.paymentType}'),

        const Gap(5),
        Text(
            'Items Total: ${widget.currency}${widget.selectedPrice.toDouble().toStringAsFixed(2)}'),
            // 'Items Total: ${widget.currency}${Formatter().converter(widget.selectedPrice.toDouble())}'),
        if (widget.orderModel2.deliveryFee != 0) const Gap(2),
        if (widget.orderModel2.deliveryFee != 0)
          // Text(
          //     // 'Delivery Fee: ${widget.currency}${Formatter().converter(widget.orderModel2.deliveryFee!.toDouble())}'
          //   'Delivery Fee: ${widget.currency}${widget.orderModel2.deliveryFee!.toDouble().toStringAsFixed(2)}',
          // ),
        if (widget.orderModel2.useCoupon == true) const Gap(5),
        if (widget.orderModel2.useCoupon == true)
          Text(
            'Discount: ${widget.currency}${(((widget.selectedPrice + widget.orderModel2.deliveryFee!) * widget.orderModel2.couponPercentage! / 100).toDouble()).toStringAsFixed(2)} at ${widget.orderModel2.couponPercentage}% Discount',
              // 'Discount: ${widget.currency}${Formatter().converter(((widget.selectedPrice + widget.orderModel2.deliveryFee!) * widget.orderModel2.couponPercentage! / 100).toDouble())} at ${widget.orderModel2.couponPercentage}% Discount',
          ),
        const Gap(5),
        if (widget.orderModel2.pointsRedeemed != null && widget.orderModel2.pointsRedeemed! > 0) const Gap(5),
        if (widget.orderModel2.pointsRedeemed != null && widget.orderModel2.pointsRedeemed! > 0)
          Text(
            'Redeemed Amount: ${widget.currency}${widget.orderModel2.pointsRedeemed!.toDouble().toStringAsFixed(2)}',
          ),
        const Gap(5),
        Text(
            'Total: ${widget.currency}${widget.orderModel2.total.toDouble().toStringAsFixed(2)}'),
            // 'Total: ${widget.currency}${Formatter().converter(widget.orderModel2.total.toDouble())}'),
        const Gap(20),
        if (widget.orderModel2.deliveryAddress!.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'DELIVERY INFORMATION',
                style: TextStyle(fontWeight: FontWeight.bold),
              ).tr(),
              const Gap(5),
              const Divider(
                color: Color.fromARGB(255, 237, 235, 235),
                thickness: 1,
              ),
              const Gap(10),
              Text('House Number: ${widget.orderModel2.houseNumber}'),
              const Gap(5),
              Text('Address: ${widget.orderModel2.deliveryAddress}'),
              const Gap(5),
              Text('Closest Bus Stop: ${widget.orderModel2.closesBusStop}'),
              if (riderName.isNotEmpty)
                if (widget.orderModel2.acceptDelivery == true) const Gap(5),
              if (riderName.isNotEmpty)
                if (widget.orderModel2.acceptDelivery == true)
                  Text('Rider name: $riderName'),
              if (riderName.isNotEmpty)
                if (widget.orderModel2.acceptDelivery == true) const Gap(5),
              if (riderName.isNotEmpty)
                if (widget.orderModel2.acceptDelivery == true)
                  Text('Rider name: $riderPhone'),
              if (riderName.isNotEmpty) const Gap(20),
              if (widget.orderModel2.acceptDelivery == true &&
                  widget.orderModel2.status == 'On the way')
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton.icon(
                      style: TextButton.styleFrom(backgroundColor: appColor),
                      onPressed: () {
                        if (MediaQuery.of(context).size.width >= 1100) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          1.5,
                                      child: ChatPage(
                                          orderModel2: widget.orderModel2)),
                                );
                              });
                        } else {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ChatPage(orderModel2: widget.orderModel2);
                          }));
                        }
                      },
                      label: const Text(
                        "Chat Rider",
                        style: TextStyle(color: Colors.white),
                      ),
                      icon: const Icon(
                        Icons.chat,
                        color: Colors.white,
                      ),
                    ),
                    const Gap(20),
                    TextButton.icon(
                      style: TextButton.styleFrom(backgroundColor: appColor),
                      onPressed: () {
                        makePhoneCall(riderPhone);
                      },
                      label: const Text(
                        "Call Rider",
                        style: TextStyle(color: Colors.white),
                      ),
                      icon: const Icon(
                        Icons.chat,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        if (widget.orderModel2.deliveryAddress!.isEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'PICKUP INFORMATION',
                style: TextStyle(fontWeight: FontWeight.bold),
              ).tr(),
              const Gap(5),
              const Divider(
                color: Color.fromARGB(255, 237, 235, 235),
                thickness: 1,
              ),
              const Gap(10),
              Text('Pickup Store: ${widget.orderModel2.pickupStorename}'),
              const Gap(5),
              Text('Pickup Address: ${widget.orderModel2.pickupAddress}'),
              // Text('Pickup Address:  ${vendorDetail.address}'),
              const Gap(5),
              Text('Pickup Phone: ${widget.orderModel2.pickupPhone}'),
              // Text('Pickup Phone: ${vendorDetail.phonenumber}'),
            ],
          ),
        if (widget.orderModel2.status == 'Pending') const Gap(20),
        if (widget.orderModel2.status == 'Pending')
          Center(
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: appColor),
                onPressed: () {
                  cancelOrder();
                },
                child: const Text(
                  'Cancel Order',
                  style: TextStyle(color: Colors.white),
                ).tr()),
          ),
        const Gap(20)
      ],
    );
  }
}
