import 'dart:async';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:logger/logger.dart';
import 'package:shimmer/shimmer.dart';

// ignore: library_prefixes
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as modalSheet;
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:user_web/model/products_model.dart';
import 'package:user_web/model/user.dart';
import 'package:user_web/providers/profile_provider.dart';
import 'package:user_web/widgets/cat_image_widget.dart';
import 'package:user_web/widgets/footer_widget.dart';
import 'package:user_web/widgets/map_view_widget.dart';
import 'package:user_web/widgets/restuarant_module_widget/restaurant_each_product_widget.dart';
import 'package:user_web/widgets/restuarant_module_widget/restaurant_vendor_hot_deals_widget.dart';
import '../../constant.dart';
import '../../model/categories.dart';
import '../../widgets/restuarant_module_widget/restaurant_product_widget_main.dart';
import '../../widgets/restuarant_module_widget/restaurant_vendor_flash_sales_widget.dart';
import '../../widgets/vendor_favorite_button.dart';
import '../chat_vendor_page.dart';

class RestaurantProductsByVendor extends ConsumerStatefulWidget {
  final String category;
  final String module;
  const RestaurantProductsByVendor({super.key, required this.category,required this.module,});

  @override
  ConsumerState<RestaurantProductsByVendor> createState() =>
      _RestaurantProductsByVendorState();
}

class _RestaurantProductsByVendorState
    extends ConsumerState<RestaurantProductsByVendor> {
  List<ProductsModel> products = [];
  List<ProductsModel> initProducts = [];
  // List<ProductsModel> productsFilter = [];
  bool isLoaded = true;
  Timer? _timer;

  getProducts() async {
    setState(() {
      isLoaded = true;
    });
    context.loaderOverlay.show();
    FirebaseFirestore.instance
        .collection('Products')
        // .limit(10)
        .where('vendorId', isEqualTo: widget.category)
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
        var prods = ProductsModel.fromMap(element, element.id);
        setState(() {
          products.add(prods);
          initProducts = products;
        });
      }
    });
  }

  List<CategoriesModel> retails = [];
  getSubCollections(String module) {
    return FirebaseFirestore.instance
        .collection('Categories')
        // .orderBy('index')
        .where('module', isEqualTo: module)
        .snapshots()
        .listen((value) {
      retails.clear();
      for (var element in value.docs) {
        setState(() {
          var fetchServices =
              CategoriesModel.fromMap(element.data(), element.id);
          retails.add(fetchServices);
        });
      }
    });
  }


  @override
  void initState() {
    super.initState();

    getProducts();
    getVendorDetail();
    getCurrency();

    // Start a timer to toggle the widget visibility after 3 seconds
    _timer = Timer(const Duration(seconds: 3), () {
      if (mounted) { // Check if the widget is still in the tree
        setState(() {
          showWidget = true;
        });
      }
    });
  }


  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void resetToInitialList() {
    setState(() {
      products = List.from(initProducts);
    });
  }

  @override
  void didUpdateWidget(covariant RestaurantProductsByVendor oldWidget) {
    //  getSubCollections();
    getVendorDetail();
    getProducts();
    getCurrency();

    super.didUpdateWidget(oldWidget);
  }

  String? sortBy;
  int? selectedValue;
  int? rateValue;
  String currency = '';
  UserModel? userModel;
  String address = '';
  String? openingTimeString;
  String? closingTimeString;
  // String city = '';
  double lat = 0;
  double long = 0;

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

  void sortProductsFromLowToHigh() {
    setState(() {
      products.sort((a, b) => a.unitPrice1!.compareTo(b.unitPrice1!));
    });
  }

  void sortProductsFromHighToLow() {
    setState(() {
      products.sort((a, b) => b.unitPrice1!.compareTo(a.unitPrice1!));
    });
  }

  void sortProductsRatingFromHighToLow() {
    setState(() {
      products.sort((a, b) =>
          b.totalNumberOfUserRating!.compareTo(a.totalNumberOfUserRating!));
    });
  }

  void sortProductsByPriceRange(int minPrice, int maxPrice) {
    setState(() {
      products = products
          .where((user) =>
              user.unitPrice1! >= minPrice && user.unitPrice1! <= maxPrice)
          .toList();
      products.sort((a, b) => a.unitPrice1!.compareTo(b.unitPrice1!));
    });
  }

  void sortAndFilterProductsByRating4() {
    setState(() {
      // Sort the products based on the ratio of totalRating to totalUserRating
      products.sort((a, b) {
        double ratioA = a.totalRating! / a.totalNumberOfUserRating!;
        double ratioB = b.totalRating! / b.totalNumberOfUserRating!;
        return ratioB.compareTo(ratioA); // Sort in descending order
      });

      // Filter products with a ratio of 4 and above
      products = products.where((product) {
        double ratio = product.totalRating! / product.totalNumberOfUserRating!;
        return ratio >= 4.0;
      }).toList();
    });
  }

  void sortAndFilterProductsByRating3() {
    setState(() {
      // Sort the products based on the ratio of totalRating to totalUserRating
      products.sort((a, b) {
        double ratioA = a.totalRating! / a.totalNumberOfUserRating!;
        double ratioB = b.totalRating! / b.totalNumberOfUserRating!;
        return ratioB.compareTo(ratioA); // Sort in descending order
      });

      // Filter products with a ratio of 4 and above
      products = products.where((product) {
        double ratio = product.totalRating! / product.totalNumberOfUserRating!;
        return ratio >= 3.0;
      }).toList();
    });
  }

  void sortAndFilterProductsByRating2() {
    setState(() {
      // Sort the products based on the ratio of totalRating to totalUserRating
      products.sort((a, b) {
        double ratioA = a.totalRating! / a.totalNumberOfUserRating!;
        double ratioB = b.totalRating! / b.totalNumberOfUserRating!;
        return ratioB.compareTo(ratioA); // Sort in descending order
      });

      // Filter products with a ratio of 4 and above
      products = products.where((product) {
        double ratio = product.totalRating! / product.totalNumberOfUserRating!;
        return ratio >= 2.0;
      }).toList();
    });
  }

  void sortAndFilterProductsByRating1() {
    setState(() {
      // Sort the products based on the ratio of totalRating to totalUserRating
      products.sort((a, b) {
        double ratioA = a.totalRating! / a.totalNumberOfUserRating!;
        double ratioB = b.totalRating! / b.totalNumberOfUserRating!;
        return ratioB.compareTo(ratioA); // Sort in descending order
      });

      // Filter products with a ratio of 4 and above
      products = products.where((product) {
        double ratio = product.totalRating! / product.totalNumberOfUserRating!;
        return ratio >= 1.0;
      }).toList();
    });
  }

  getVendorDetail() {
    FirebaseFirestore.instance
        .collection('vendors')
        .doc(widget.category)
        .get()
        .then((value) {
      getSubCollections(value['module']);
      setState(() {
        userModel = UserModel.fromMap(value.data()!, value.id);
        address = value['address'];
        openingTimeString = value['opening Time'];
        closingTimeString = value['closing Time'];
        // city = value['city'];
        // lat = value?['lat'];
        // long = value?['long'];
        final data = value.data();
        lat = data != null && data.containsKey('lat') ? data['lat'] as double : 0.0;
        long = data != null && data.containsKey('long') ? data['long'] as double : 0.0;

      });
    });
  }

  filterByCategory(String cat) {
    setState(() {
      products = products.where((e) => e.category == cat).toList();
    });
  }

  searchProduct(String productName) {
    setState(() {
      products = products
          .where(
              (e) => e.name.toLowerCase().contains(productName.toLowerCase()))
          .toList();
    });
  }

  String selectedCategory = '';
  bool showWidget = false;
  var logger = Logger();

  @override
  Widget build(BuildContext context) {
    final isLogged = ref.watch(getAuthListenerProvider).value ?? false;
    return Scaffold(
        backgroundColor: AdaptiveTheme.of(context).mode.isDark == true
            ? null
            : const Color(0xFFDF7EB).withOpacity(1.0),
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
              children: [
            // const Gap(20),
            if (userModel != null)
              MediaQuery.of(context).size.width >= 1100 ?
                Stack(
                  children: [
                    Container(
                      height: 200,
                      width: double.infinity,
                      // color: Colors.grey[200],
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // LEFT SIDE — Name, Address, Phone
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Gap(30),
                                Text(
                                  userModel!.displayName,
                                  style:  TextStyle(
                                    color: appColor,
                                    fontSize: 30,
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.bold,
                                    overflow: TextOverflow.ellipsis
                                  ),
                                ),
                                const SizedBox(height: 14),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on, size: 16),
                                    const SizedBox(width: 6),
                                    SizedBox(
                                      width: 220,
                                      child: Text(
                                        address,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 14,fontFamily: 'Nunito'),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    const Icon(Icons.phone, size: 16),
                                    const SizedBox(width: 6),
                                    Text(
                                      userModel!.phonenumber,
                                      style: const TextStyle(fontSize: 14,fontFamily: 'Nunito'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Image.network(
                              userModel!.photoUrl, // Your image URL from Firebase or other storage
                              height: double.infinity, // Adjust height as needed
                              fit: BoxFit.contain, // Ensures image is properly scaled
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(), // Shows loader while image loads
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.image_not_supported, size: 90,
                                    // color: Colors.grey
                                ); // Fallback if image fails
                              },
                            ),
                            // RIGHT SIDE — Icons + Time + Chat Button
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                // Favorite + Map
                                const Gap(30),
                                Row(
                                  children: [
                                    VendorFavoriteButton(
                                      isWhite: false,
                                      vendorId: widget.category,
                                    ),
                                    const SizedBox(width: 15),
                                    if (lat != 0)
                                      Container(
                                        height: 30,
                                        width: 30,
                                        decoration: const BoxDecoration(
                                          // color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                        child: IconButton(
                                          padding: EdgeInsets.zero,
                                          iconSize: 20,
                                          icon: const Icon(Icons.map),
                                          onPressed: () {
                                            if (MediaQuery.of(context).size.width >= 1100) {
                                              showDialog(
                                                context: context,
                                                builder: (context) => AlertDialog(
                                                  content: SizedBox(
                                                    width: MediaQuery.of(context).size.width / 1.5,
                                                    child: MapViewWidget(lat: lat, long: long),
                                                  ),
                                                ),
                                              );
                                            } else {
                                              Navigator.push(context,
                                                  MaterialPageRoute(builder: (_) {
                                                    return MapViewWidget(lat: lat, long: long);
                                                  }));
                                            }
                                          },
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                // Opening Time
                                Row(
                                  children: [
                                    const Icon(Icons.access_time, size: 16,
                                      // color: Colors.black,
                                    ),
                                    const SizedBox(width: 6),
                                    Text('Opening Time: $openingTimeString', style: const TextStyle(fontSize: 13, fontFamily: 'Nunito')),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                // Closing Time
                                Row(
                                  children: [
                                    const Icon(Icons.access_time, size: 16,
                                      // color: Colors.black,
                                    ),
                                    const SizedBox(width: 6),
                                    Text('Closing Time: $closingTimeString', style: const TextStyle(fontSize: 13, fontFamily: 'Nunito',)),
                                  ],
                                ),

                                const SizedBox(height: 15),

                                // Chat Vendor Button
                                TextButton.icon(
                                  style: TextButton.styleFrom(
                                    backgroundColor: appColor,
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  ),
                                  onPressed: () {
                                    if (isLogged == true) {
                                      if (MediaQuery.of(context).size.width >= 1100) {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            content: SizedBox(
                                              width: MediaQuery.of(context).size.width / 1.5,
                                              child: ChatVendorPage(vendorID: widget.category),
                                            ),
                                          ),
                                        );
                                      } else {
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (_) {
                                              return ChatVendorPage(vendorID: widget.category);
                                            }));
                                      }
                                    } else {
                                      // Fluttertoast.showToast(
                                      //   msg: "Please login to enable chat feature",
                                      //   toastLength: Toast.LENGTH_SHORT,
                                      //   gravity: ToastGravity.TOP,
                                      //   timeInSecForIosWeb: 6,
                                      //   backgroundColor: Theme.of(context).primaryColor,
                                      //   textColor: Colors.white,
                                      //   fontSize: 14,
                                      // );
                                      showAlertDialog(context,"Note","Please login to enable chat feature");
                                      context.go('/login');
                                    }
                                  },
                                  icon: const Icon(Icons.chat, color: Colors.white, size: 16),
                                  label: const Text("Chat Vendor", style: TextStyle(color: Colors.white, fontSize: 13, fontFamily: 'Nunito',)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ) :
              Stack(
                children: [
                  Container(
                    height: 340,
                    width: double.infinity,
                    // color: Colors.grey[200],
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Gap(10),
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Stack(
                                  children: [
                                    // Centered displayName
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        userModel!.displayName,
                                        style: TextStyle(
                                          color: appColor,
                                          fontSize: 22,
                                          fontFamily: 'Nunito',
                                          fontWeight: FontWeight.bold,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          VendorFavoriteButton(
                                            isWhite: false,
                                            vendorId: widget.category,
                                          ),
                                          const SizedBox(width: 10),
                                          if (lat != 0)
                                            Container(
                                              height: 26,
                                              width: 26,
                                              decoration: const BoxDecoration(
                                                // color: Colors.white,
                                                shape: BoxShape.circle,
                                              ),
                                              child: IconButton(
                                                padding: EdgeInsets.zero,
                                                iconSize: 20,
                                                icon: const Icon(Icons.map),
                                                onPressed: () {
                                                  if (MediaQuery.of(context).size.width >= 1100) {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) => AlertDialog(
                                                        content: SizedBox(
                                                          width: MediaQuery.of(context).size.width / 1.5,
                                                          child: MapViewWidget(lat: lat, long: long),
                                                        ),
                                                      ),
                                                    );
                                                  } else {
                                                    Navigator.push(context,
                                                        MaterialPageRoute(builder: (_) {
                                                          return MapViewWidget(lat: lat, long: long);
                                                        }));
                                                  }
                                                },
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.location_on, size: 16),
                                    const SizedBox(width: 10),
                                    SizedBox(
                                      width: 120,
                                      child: Text(
                                        address,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 12, fontFamily: 'Nunito'),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(padding: EdgeInsets.only(right: 20),
                                      child: const Icon(Icons.phone, size: 16),
                                    ),
                                    // const SizedBox(width: 2),
                                    Text(
                                      userModel!.phonenumber,
                                      style: const TextStyle(fontSize: 12, fontFamily: 'Nunito'),
                                    ),
                                  ],
                                ),

                              ],
                            ),
                          ),
                          const Gap(6),
                          Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // const Spacer(flex: 3), // Push image to center
                                Image.network(
                                  userModel!.photoUrl,
                                  height: 110,
                                  width: 180,
                                  fit: BoxFit.contain,
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.image_not_supported, size: 90, color: Colors.grey);
                                  },
                                ),
                                // const Spacer(flex: 1), // Adjusts space between image and button
                                // Align(
                                //   alignment: Alignment.centerRight,
                                //   child: TextButton.icon(
                                //     style: TextButton.styleFrom(
                                //       backgroundColor: appColor,
                                //       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                //     ),
                                //     onPressed: () {
                                //       if (isLogged == true) {
                                //         if (MediaQuery.of(context).size.width >= 1100) {
                                //           showDialog(
                                //             context: context,
                                //             builder: (context) => AlertDialog(
                                //               content: SizedBox(
                                //                 width: MediaQuery.of(context).size.width / 2.2,
                                //                 child: ChatVendorPage(vendorID: widget.category),
                                //               ),
                                //             ),
                                //           );
                                //         } else {
                                //           Navigator.push(context,
                                //               MaterialPageRoute(builder: (_) {
                                //                 return ChatVendorPage(vendorID: widget.category);
                                //               }));
                                //         }
                                //       } else {
                                //         Fluttertoast.showToast(
                                //           msg: "Please login to enable chat feature",
                                //           toastLength: Toast.LENGTH_SHORT,
                                //           gravity: ToastGravity.TOP,
                                //           backgroundColor: Theme.of(context).primaryColor,
                                //           textColor: Colors.white,
                                //           fontSize: 14,
                                //         );
                                //         context.go('/login');
                                //       }
                                //     },
                                //     icon: const Icon(Icons.chat, color: Colors.white, size: 14),
                                //     label: const Text("Chat Vendor", style: TextStyle(color: Colors.white, fontSize: 12)),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                          const Gap(10),
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                        // const SizedBox(height: 12),
                        // Opening Time
                          Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.access_time, size: 16,
                              // color: Colors.black,
                            ),
                            const SizedBox(width: 6),
                            Text('Opening Time: $openingTimeString', style: const TextStyle(fontSize: 13, fontFamily: 'Nunito',)),
                          ],
                        ),
                         const SizedBox(height: 5),
                          Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.access_time, size: 16,
                              // color: Colors.black,
                            ),
                            const SizedBox(width: 6),
                            Text('Closing Time: $closingTimeString', style: const TextStyle(fontSize: 13, fontFamily: 'Nunito',)),
                            ],
                              ),
                                const SizedBox(height: 10),
                                TextButton.icon(
                                  style: TextButton.styleFrom(
                                    backgroundColor: appColor,
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  ),
                                  onPressed: () {
                                    if (isLogged == true) {
                                      if (MediaQuery.of(context).size.width >= 1100) {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            content: SizedBox(
                                              width: MediaQuery.of(context).size.width / 2.2,
                                              child: ChatVendorPage(vendorID: widget.category),
                                            ),
                                          ),
                                        );
                                      } else {
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (_) {
                                              return ChatVendorPage(vendorID: widget.category);
                                            }));
                                      }
                                    } else {
                                      // Fluttertoast.showToast(
                                      //   msg: "Please login to enable chat feature",
                                      //   toastLength: Toast.LENGTH_SHORT,
                                      //   gravity: ToastGravity.TOP,
                                      //   timeInSecForIosWeb: 6,
                                      //   backgroundColor: Theme.of(context).primaryColor,
                                      //   textColor: Colors.white,
                                      //   fontSize: 14,
                                      // );

                                      showAlertDialog(context,"Note","Please login to enable chat feature");
                                      context.go('/login');
                                    }
                                  },
                                  icon: const Icon(Icons.chat, color: Colors.white, size: 14),
                                  label: const Text("Chat Vendor", style: TextStyle(color: Colors.white, fontSize: 12, fontFamily: 'Nunito',)),
                                ),
                            const SizedBox(height: 8),
                              ],
                            )
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            const Gap(10),
            // if (MediaQuery.of(context).size.width >= 1100)
            //   Align(
            //     alignment: MediaQuery.of(context).size.width >= 1100
            //         ? Alignment.centerLeft
            //         : Alignment.center,
            //     child: Padding(
            //       padding: MediaQuery.of(context).size.width >= 1100
            //           ? const EdgeInsets.only(left: 120, right: 120)
            //           : const EdgeInsets.all(0),
            //       child: Row(
            //         children: [
            //           InkWell(
            //             onTap: () {
            //               context.go('/restaurant');
            //             },
            //             child: const Text(
            //               'Home',
            //               style: TextStyle(fontSize: 12),
            //             ).tr(),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // if (showWidget == true)
            RestaurantVendorFlashSalesWidget(
              vendorID: widget.category,
            ),
            // if (showWidget == true)
            const Gap(5),
            RestaurantVendorHotDealsWidget(
              vendorID: widget.category,
            ),
            if (MediaQuery.of(context).size.width >= 1100) const Gap(10),
            const Gap(20),
            Padding(
              padding: MediaQuery.of(context).size.width >= 1100
                  ? const EdgeInsets.only(left: 50, right: 50)
                  : const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                      flex: MediaQuery.of(context).size.width >= 1100 ? 5 : 3,
                      child: const SizedBox()),
                  Expanded(
                    flex: MediaQuery.of(context).size.width >= 1100 ? 2 : 5,
                    child: TextField(
                      decoration: InputDecoration(
                        filled: true,
                        // border: InputBorder.none,
                        fillColor: Colors.white,
                        isDense: true, // This reduces the overall height
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        prefixIcon: const Icon(Icons.search),
                        hintText: 'Search A Product'.tr(),
                        // fillColor: Colors.white10,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          // borderSide:
                          //     const BorderSide(color: Colors.grey, width: 2),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          // borderSide:
                          //     const BorderSide(color: Colors.grey, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          // borderSide:
                          //     const BorderSide(color: Colors.grey, width: 2),
                        ),
                      ),
                      onChanged: (v) {
                        setState(() {
                          if (v.isNotEmpty) {
                            searchProduct(v);
                          } else {
                            resetToInitialList();
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
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
                                          'Categories',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold, fontFamily: 'Nunito',),
                                        ).tr(),
                                        trailing: selectedCategory == ''
                                            ? null
                                            : TextButton(
                                                child: const Text(
                                                  'Clear',
                                                  style: TextStyle(
                                                      color: Colors.grey, fontFamily: 'Nunito',),
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    selectedCategory = '';
                                                    resetToInitialList();
                                                  });
                                                },
                                              ),
                                      ),
                                      isLoaded == true
                                          ? ListView.builder(
                                              physics: const ClampingScrollPhysics(),
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
                                              physics:  const ClampingScrollPhysics(),
                                              shrinkWrap: true,
                                              // itemExtent: 35.0,
                                              itemCount: retails.length,
                                              itemBuilder: (context, index) {
                                                CategoriesModel
                                                    subCategoriesModel =
                                                    retails[index];
                                                return ListTile(
                                                  selected: selectedCategory ==
                                                          subCategoriesModel
                                                              .category
                                                      ? true
                                                      : false,
                                                  selectedColor:
                                                      selectedCategory ==
                                                              subCategoriesModel
                                                                  .category
                                                          ? appColor
                                                          : null,
                                                  leading: SizedBox(
                                                    height: 65,
                                                    width: 65,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              3.0),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        child: CatImageWidget(
                                                          url:
                                                              subCategoriesModel
                                                                  .image,
                                                          boxFit: 'cover',
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    resetToInitialList();
                                                    filterByCategory(
                                                        subCategoriesModel
                                                            .category);
                                                    setState(() {
                                                      selectedCategory =
                                                          subCategoriesModel
                                                              .category;
                                                    });
                                                    // context.go(
                                                    //     '/restaurant/collection/${subCategoriesModel.name}');
                                                  },
                                                  title: Text(
                                                    subCategoriesModel.category,
                                                    style: const TextStyle(
                                                        fontFamily: 'Nunito',
                                                        fontSize: 11),

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
                                              fontFamily: 'Nunito',
                                              fontWeight: FontWeight.bold),
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
                                                    resetToInitialList();
                                                  });
                                                },
                                              ),
                                      ),
                                      ListView(
                                        physics: const ClampingScrollPhysics(),
                                        shrinkWrap: true,
                                        itemExtent: 35.0,
                                        //padding: EdgeInsets.symmetric(vertical:20),
                                        children: [
                                          RadioListTile(
                                            title: Text(
                                              'Under ${currency}2,000',
                                              style:
                                                  const TextStyle(fontSize: 11, fontFamily: 'Nunito',),
                                            ),
                                            value: 1,
                                            groupValue: selectedValue,
                                            onChanged: (value) {
                                              setState(() {
                                                selectedValue = value;
                                              });
                                              resetToInitialList();
                                              sortProductsByPriceRange(1, 2000);
                                            },
                                          ),
                                          RadioListTile(
                                            title: Text(
                                                '${currency}2,000 - ${currency}5,000',
                                                style: const TextStyle(
                                                    fontSize: 11, fontFamily: 'Nunito',)),
                                            value: 2,
                                            groupValue: selectedValue,
                                            onChanged: (value) {
                                              setState(() {
                                                selectedValue = value;
                                              });
                                              resetToInitialList();
                                              sortProductsByPriceRange(
                                                  2000, 5000);
                                            },
                                          ),
                                          RadioListTile(
                                            title: Text(
                                                '${currency}5,000 - ${currency}10,000',
                                                style: const TextStyle(
                                                    fontSize: 11, fontFamily: 'Nunito',)),
                                            value: 3,
                                            groupValue: selectedValue,
                                            onChanged: (value) {
                                              setState(() {
                                                selectedValue = value;
                                              });
                                              resetToInitialList();
                                              sortProductsByPriceRange(
                                                  5000, 10000);
                                            },
                                          ),
                                          RadioListTile(
                                            title: Text(
                                                '${currency}10,000 - ${currency}20,000',
                                                style: const TextStyle(
                                                    fontSize: 11, fontFamily: 'Nunito',)),
                                            value: 4,
                                            groupValue: selectedValue,
                                            onChanged: (value) {
                                              setState(() {
                                                selectedValue = value;
                                              });
                                              resetToInitialList();
                                              sortProductsByPriceRange(
                                                  10000, 20000);
                                            },
                                          ),
                                          RadioListTile(
                                            title: Text(
                                                '${currency}20,000 - ${currency}40,000',
                                                style: const TextStyle(
                                                    fontSize: 11, fontFamily: 'Nunito',)),
                                            value: 5,
                                            groupValue: selectedValue,
                                            onChanged: (value) {
                                              setState(() {
                                                selectedValue = value;
                                              });
                                              resetToInitialList();
                                              sortProductsByPriceRange(
                                                  20000, 40000);
                                            },
                                          ),
                                          RadioListTile(
                                            title: Text(
                                                'Above ${currency}40,000',
                                                style: const TextStyle(
                                                    fontSize: 11, fontFamily: 'Nunito',)),
                                            value: 6,
                                            groupValue: selectedValue,
                                            onChanged: (value) {
                                              setState(() {
                                                selectedValue = value;
                                              });
                                              resetToInitialList();
                                              sortProductsByPriceRange(
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
                                              fontWeight: FontWeight.bold, fontFamily: 'Nunito',),
                                        ).tr(),
                                        trailing: rateValue == null
                                            ? null
                                            : TextButton(
                                                child: const Text(
                                                  'Clear',
                                                  style: TextStyle(
                                                      color: Colors.grey, fontFamily: 'Nunito',),
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    rateValue = null;
                                                    resetToInitialList();
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
                                              resetToInitialList();
                                              sortAndFilterProductsByRating4();
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
                                                      TextStyle(fontSize: 12, fontFamily: 'Nunito',),
                                                )
                                              ],
                                            ),
                                            value: 2,
                                            groupValue: rateValue,
                                            onChanged: (value) {
                                              setState(() {
                                                rateValue = value;
                                              });
                                              resetToInitialList();
                                              sortAndFilterProductsByRating3();
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
                                                      TextStyle(fontSize: 12, fontFamily: 'Nunito',),
                                                )
                                              ],
                                            ),
                                            value: 3,
                                            groupValue: rateValue,
                                            onChanged: (value) {
                                              setState(() {
                                                rateValue = value;
                                              });
                                              resetToInitialList();
                                              sortAndFilterProductsByRating2();
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
                                                      TextStyle(fontSize: 12, fontFamily: 'Nunito',),
                                                )
                                              ],
                                            ),
                                            value: 4,
                                            groupValue: rateValue,
                                            onChanged: (value) {
                                              setState(() {
                                                rateValue = value;
                                              });
                                              resetToInitialList();
                                              sortAndFilterProductsByRating1();
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
                          child: isLoaded == true
                              ? GridView.builder(
                                  shrinkWrap: true,
                                  physics: const ClampingScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: MediaQuery.of(context).size.width >=1100 ? 4  : 2,
                                          crossAxisSpacing: 8.0,
                                          mainAxisSpacing: 8.0,
                                          childAspectRatio: 0.7
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
                                              '${products.length} Products Found',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold, fontFamily: 'Nunito',),
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
                                                            sortProductsFromLowToHigh();
                                                          } else if (value ==
                                                              'Price:High to Low') {
                                                            sortProductsFromHighToLow();
                                                          } else {
                                                            sortProductsRatingFromHighToLow();
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
                                        products.isEmpty
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
                                                      'Coming Soon..',style: TextStyle( fontFamily: 'Nunito',),)
                                                ]),
                                              )
                                            : GridView.builder(
                                                physics:  const ClampingScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount: products.length,
                                                itemBuilder: (context, index) {
                                                  ProductsModel productsModel =
                                                      products[index];
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child:
                                                        RestaurantEachProductWidget(
                                                      productsModel:
                                                          productsModel,
                                                      index: index,
                                                    ),
                                                  );
                                                },
                                                gridDelegate:
                                                    SliverGridDelegateWithFixedCrossAxisCount(
                                                        childAspectRatio:
                                                            MediaQuery.of(context)
                                                                        .size
                                                                        .width >=
                                                                    1100
                                                                ? 0.7
                                                                : 0.57,
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
                        isLoaded == true
                            ? GridView.builder(
                                physics: const ClampingScrollPhysics(),
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
                                                                        'Categories',
                                                                        style: TextStyle(
                                                                            fontFamily: 'Nunito',
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ).tr(),
                                                                      trailing: selectedCategory ==
                                                                              ''
                                                                          ? TextButton(
                                                                              onPressed: () {
                                                                                context.pop();
                                                                              },
                                                                              child: Text(
                                                                                'Close',
                                                                                style: TextStyle(color: AdaptiveTheme.of(context).mode.isDark == true ? Colors.white : Colors.black, fontFamily: 'Nunito',),
                                                                              ).tr())
                                                                          : TextButton(
                                                                              child: const Text(
                                                                                'Clear',
                                                                                style: TextStyle(color: Colors.grey, fontFamily: 'Nunito',),
                                                                              ),
                                                                              onPressed: () {
                                                                                setState(() {
                                                                                  selectedCategory = '';
                                                                                  resetToInitialList();
                                                                                });
                                                                              },
                                                                            ),
                                                                      // trailing: TextButton(
                                                                      //     onPressed: () {
                                                                      //       context.pop();
                                                                      //     },
                                                                      //     child: Text(
                                                                      //       'Close',
                                                                      //       style:
                                                                      //           TextStyle(color: AdaptiveTheme.of(context).mode.isDark == true ? Colors.white : Colors.black),
                                                                      //     ).tr()),
                                                                    ),
                                                                    isLoaded ==
                                                                            true
                                                                        ? ListView
                                                                            .builder(
                                                                      physics: const ClampingScrollPhysics(),
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
                                                                            itemCount: retails.length,
                                                                            itemBuilder: (context, index) {
                                                                              CategoriesModel subCategoriesModel = retails[index];
                                                                              return ListTile(
                                                                                selected: selectedCategory == subCategoriesModel.category ? true : false,
                                                                                selectedColor: selectedCategory == subCategoriesModel.category ? appColor : null,
                                                                                onTap: () {
                                                                                  resetToInitialList();
                                                                                  filterByCategory(subCategoriesModel.category);
                                                                                  setState(() {
                                                                                    selectedCategory = subCategoriesModel.category;
                                                                                  });
                                                                                  context.pop();
                                                                                  // context.go('/restaurant/collection/${subCategoriesModel.name}');
                                                                                },
                                                                                leading: SizedBox(
                                                                                  height: 50,
                                                                                  width: 50,
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.all(5.0),
                                                                                    child: ClipRRect(
                                                                                      borderRadius: BorderRadius.circular(12),
                                                                                      child: CatImageWidget(
                                                                                        url: subCategoriesModel.image,
                                                                                        boxFit: 'cover',
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                title: Text(
                                                                                  subCategoriesModel.category,
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
                                                                            fontFamily: 'Nunito',
                                                                            fontWeight:
                                                                                FontWeight.bold),
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
                                                                                  resetToInitialList();
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
                                                                            resetToInitialList();
                                                                            sortProductsByPriceRange(1,
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
                                                                            resetToInitialList();
                                                                            sortProductsByPriceRange(2000,
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
                                                                            resetToInitialList();
                                                                            sortProductsByPriceRange(5000,
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
                                                                            resetToInitialList();
                                                                            sortProductsByPriceRange(10000,
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
                                                                            resetToInitialList();
                                                                            sortProductsByPriceRange(20000,
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
                                                                            resetToInitialList();
                                                                            sortProductsByPriceRange(40000,
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
                                                                                FontWeight.bold, fontFamily: 'Nunito',),
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
                                                                                  resetToInitialList();
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
                                                                      physics:  const ClampingScrollPhysics(),
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
                                                                            resetToInitialList();
                                                                            sortAndFilterProductsByRating4();
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
                                                                            resetToInitialList();
                                                                            sortAndFilterProductsByRating3();
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
                                                                            resetToInitialList();
                                                                            sortAndFilterProductsByRating2();
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
                                                                            resetToInitialList();
                                                                            sortAndFilterProductsByRating1();
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
                                                                  fontFamily: 'Nunito',
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
                                                        sortProductsFromLowToHigh();
                                                      } else if (value ==
                                                          'Price:High to Low') {
                                                        sortProductsFromHighToLow();
                                                      } else {
                                                        sortProductsRatingFromHighToLow();
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
                                    products.isEmpty
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
                                              const Text('Coming Soon..',style: TextStyle( fontFamily: 'Nunito',),)
                                            ]),
                                          )
                                        : GridView.builder(
                                            physics:  const ClampingScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: products.length,
                                            itemBuilder: (context, index) {
                                              ProductsModel productsModel =
                                                  products[index];
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
                                                      productsModel:
                                                          productsModel,
                                                      index: index,
                                                    )),
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
                                                    mainAxisSpacing: 10,
                                                    crossAxisSpacing: 10),
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
