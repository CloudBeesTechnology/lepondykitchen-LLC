import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_web/model/user.dart';
import '../../widgets/footer_widget.dart';
import '../../widgets/vendor_list_home_widget.dart';

class RestaurantVendorsPage extends StatefulWidget {
  const RestaurantVendorsPage({super.key});

  @override
  State<RestaurantVendorsPage> createState() => _RestaurantVendorsPageState();
}

class _RestaurantVendorsPageState extends State<RestaurantVendorsPage> {
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
        // .limit(10)
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

  String flashSales = '';
  getFlashSalesTime() {
    FirebaseFirestore.instance
        .collection('Flash Sales Time')
        .doc('Flash Sales Time')
        .snapshots()
        .listen((event) {
      setState(() {
        flashSales = event['Flash Sales Time'];
      });
    });
  }

  @override
  void initState() {
    getProducts();
    // getFlashSalesTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // // Parse the string into a DateTime object
    // DateTime targetDate = DateTime.parse(flashSales);

    // // Calculate the difference between the target date and the current date
    // DateTime currentDate = DateTime.now();
    // Duration difference = targetDate.difference(currentDate);
    return Scaffold(
      backgroundColor: AdaptiveTheme.of(context).mode.isDark == true
          ? null
          : const Color.fromARGB(255, 247, 240, 240),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Container(
            //   height: MediaQuery.of(context).size.width >= 1100 ? 200 : 150,
            //   width: double.infinity,
            //   decoration: BoxDecoration(
            //       // color: Color.fromARGB(255, 230, 224, 237),
            //       image: DecorationImage(
            //           // opacity: 0.3,
            //           fit: MediaQuery.of(context).size.width >= 1100
            //               ? BoxFit.cover
            //               : BoxFit.fill,
            //           image: const AssetImage('assets/image/flash sales.png'))),
            // ),
            Padding(
              padding: MediaQuery.of(context).size.width >= 1100
                  ? const EdgeInsets.only(left: 60, right: 100)
                  : const EdgeInsets.all(0),
              child: Column(
                children: [
                  const Gap(20),
                  if (MediaQuery.of(context).size.width >= 1100)
                    Align(
                      alignment: MediaQuery.of(context).size.width >= 1100
                          ? Alignment.centerLeft
                          : Alignment.center,
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              context.go('/restaurant');
                            },
                            child: const Text(
                              'Home',
                              style: TextStyle(fontSize: 10),
                            ).tr(),
                          ),
                          const Text(
                            '/ Vendors',
                            style: TextStyle(fontSize: 10),
                          ).tr(),
                        ],
                      ),
                    ),
                  const Gap(10),
                ],
              ),
            ),
            isLoaded == true
                ? Padding(
                    padding: MediaQuery.of(context).size.width >= 1100
                        ? const EdgeInsets.only(left: 100, right: 100)
                        : const EdgeInsets.all(0),
                    child: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio:
                            MediaQuery.of(context).size.width >= 1100 ? 1 : 1.2,
                        crossAxisCount:
                            MediaQuery.of(context).size.width >= 1100 ? 4 : 1,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                      ),
                      itemCount: 20,
                      itemBuilder: (BuildContext context, int index) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    ),
                  )
                : Padding(
                    padding: MediaQuery.of(context).size.width >= 1100
                        ? const EdgeInsets.only(left: 50, right: 50)
                        : const EdgeInsets.all(0),
                    child: GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        UserModel productsModel = products[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: VendorListHomeWidget(
                              showModule: false,
                              isNewWidget: false,
                              vendor: productsModel),
                        );
                      },
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio:
                              MediaQuery.of(context).size.width >= 1100
                                  ? 1
                                  : 1.5,
                          crossAxisCount:
                              MediaQuery.of(context).size.width >= 1100 ? 4 : 1,
                          mainAxisSpacing: 5,
                          crossAxisSpacing: 5),
                    ),
                  ),
            const Gap(20),
            const FooterWidget()
          ],
        ),
      ),
    );
  }
}
