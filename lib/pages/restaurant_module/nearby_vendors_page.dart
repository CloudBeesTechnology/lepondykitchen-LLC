import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_web/constant.dart';
import 'package:user_web/model/user.dart';
import '../../widgets/footer_widget.dart';
import '../../widgets/vendor_list_home_widget.dart';

class NearbyVendorsPage extends StatefulWidget {
  final double lat;
  final double long;
  const NearbyVendorsPage({super.key, required this.lat, required this.long});

  @override
  State<NearbyVendorsPage> createState() => _NearbyVendorsPageState();
}

class _NearbyVendorsPageState extends State<NearbyVendorsPage> {
  Stream<List<DocumentSnapshot>>? vendorStream;
  var logger = Logger();
  List<UserModel> vendors = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchVendorsNearby();
  }

  void fetchVendorsNearby() {
    setState(() {
      isLoading = true;
    });
    GeoPoint tokyoStation = GeoPoint(widget.lat, widget.long);
    final GeoFirePoint center = GeoFirePoint(tokyoStation);
    double radius = radiusKM;
    String field = 'geo';

    final CollectionReference<Map<String, dynamic>> collectionReference =
        FirebaseFirestore.instance.collection('vendors');

    GeoPoint geopointFrom(Map<String, dynamic> data) =>
        (data['geo'] as Map<String, dynamic>)['geopoint'] as GeoPoint;

    setState(() {
      isLoading = false;
      vendorStream =
          GeoCollectionReference<Map<String, dynamic>>(collectionReference)
              .subscribeWithin(
        center: center,
        radiusInKm: radius,
        field: field,
        geopointFrom: geopointFrom,
      );
    });

    logger.d('Vendor stream initialized');
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
                            '/ Nearby Vendors',
                            style: TextStyle(fontSize: 10),
                          ).tr(),
                        ],
                      ),
                    ),
                  const Gap(10),
                ],
              ),
            ),

            StreamBuilder<List<DocumentSnapshot>>(
              stream: vendorStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  logger.e('Error: ${snapshot.error}');
                  return Center(child: Text('Error loading vendors'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Padding(
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
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Padding(
                    padding: MediaQuery.of(context).size.width >= 1100
                        ? const EdgeInsets.only(left: 100, right: 100)
                        : const EdgeInsets.all(0),
                    child: Center(
                      child: Icon(
                        Icons.shopping_bag_outlined,
                        color: appColor,
                        size: 200,
                      ),
                    ),
                  );
                }

                // Convert vendor documents to UserModel
                vendors = snapshot.data!.map((doc) {
                  var vendorData = doc.data() as Map<String, dynamic>;
                  return UserModel.fromMap(vendorData, doc.id);
                }).toList();

                return Padding(
                  padding: MediaQuery.of(context).size.width >= 1100
                      ? const EdgeInsets.only(left: 50, right: 50)
                      : const EdgeInsets.all(0),
                  child: GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: vendors.length,
                    itemBuilder: (context, index) {
                      UserModel productsModel = vendors[index];
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
                            MediaQuery.of(context).size.width >= 1100 ? 1 : 1.5,
                        crossAxisCount:
                            MediaQuery.of(context).size.width >= 1100 ? 4 : 1,
                        mainAxisSpacing: 5,
                        crossAxisSpacing: 5),
                  ),
                );
              },
            ),
            const Gap(20),
            const FooterWidget()
          ],
        ),
      ),
    );
  }
}
