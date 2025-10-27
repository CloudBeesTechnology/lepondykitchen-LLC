import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_web/widgets/vendor_list_home_widget.dart';
import '../constant.dart';
import '../model/user.dart';

class NearbyVendors extends StatefulWidget {
  final double lat;
  final double long;
  const NearbyVendors({super.key, required this.lat, required this.long});
  @override
  _NearbyVendorsState createState() => _NearbyVendorsState();
}

class _NearbyVendorsState extends State<NearbyVendors> {
  Stream<List<DocumentSnapshot>>? vendorStream;
  var logger = Logger();
  List<UserModel> vendors = [];

  @override
  void initState() {
    super.initState();
    fetchVendorsNearby();
  }

  @override
  void didUpdateWidget(NearbyVendors oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.lat != widget.lat || oldWidget.long != widget.long) {
      fetchVendorsNearby();
    }
  }

  void fetchVendorsNearby() {
    GeoPoint tokyoStation = GeoPoint(widget.lat, widget.long);
    final GeoFirePoint center = GeoFirePoint(tokyoStation);
    double radius = radiusKM;
    String field = 'geo';

    final CollectionReference<Map<String, dynamic>> collectionReference =
        FirebaseFirestore.instance.collection('vendors');

    GeoPoint geopointFrom(Map<String, dynamic> data) =>
        (data['geo'] as Map<String, dynamic>)['geopoint'] as GeoPoint;

    setState(() {
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

  int current = 0;
  final CarouselSliderController _controller = CarouselSliderController();
  bool isHovered = false;
  bool stopHovering = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: MediaQuery.of(context).size.width >= 1100
              ? const EdgeInsets.only(left: 50, right: 50)
              : const EdgeInsets.all(0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Text(
              //     'Near By Stores',
              //     style: TextStyle(
              //         // color: Colors.white,
              //         fontFamily: 'LilitaOne',
              //         // fontWeight: FontWeight.bold,
              //         fontSize:
              //             MediaQuery.of(context).size.width >= 1100 ? 30 : 20),
              //   ).tr(),
              // ),

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
              // Padding(
              //   padding: MediaQuery.of(context).size.width >= 1100
              //       ? const EdgeInsets.all(0)
              //       : const EdgeInsets.all(8.0),
              //   child: Center(
              //     child: OutlinedButton(
              //       onPressed: () {
              //       context.go('/nearby-vendors/${widget.lat}/${widget.long}');
              //       },
              //       child: Text(
              //         'See All',
              //         style: TextStyle(
              //             fontWeight: FontWeight.bold,
              //             color: AdaptiveTheme.of(context).mode.isDark == true
              //                 ? Colors.white
              //                 : Colors.black,
              //             fontSize: MediaQuery.of(context).size.width >= 1100
              //                 ? 15
              //                 : 12),
              //       ).tr(),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
        // StreamBuilder<List<DocumentSnapshot>>(
        //   stream: vendorStream,
        //   builder: (context, snapshot) {
        //     if (snapshot.hasError) {
        //       logger.e('Error: ${snapshot.error}');
        //       return Center(child: Text('Error loading vendors'));
        //     }
        //
        //     if (snapshot.connectionState == ConnectionState.waiting) {
        //       return Padding(
        //         padding: MediaQuery.of(context).size.width >= 1100
        //             ? const EdgeInsets.only(left: 50, right: 50)
        //             : const EdgeInsets.all(0),
        //         child: SizedBox(
        //           height: 200,
        //           //   width: double.infinity,
        //           child: ListView.builder(
        //             shrinkWrap: true,
        //             scrollDirection: Axis.horizontal,
        //             itemCount: 10,
        //             itemBuilder: (context, index) {
        //               return Shimmer.fromColors(
        //                 baseColor: Colors.grey[300]!,
        //                 highlightColor: Colors.grey[100]!,
        //                 child: Container(
        //                   width: 170.0,
        //                   height: double.infinity,
        //                   margin: const EdgeInsets.all(8.0),
        //                   decoration: BoxDecoration(
        //                     color: Colors.white,
        //                     borderRadius: BorderRadius.circular(8.0),
        //                   ),
        //                 ),
        //               );
        //             },
        //           ),
        //         ),
        //       );
        //     }
        //
        //     if (!snapshot.hasData || snapshot.data!.isEmpty) {
        //       return Padding(
        //         padding: MediaQuery.of(context).size.width >= 1100
        //             ? const EdgeInsets.only(left: 50, right: 50)
        //             : const EdgeInsets.all(0),
        //         child: SizedBox(
        //           height: 200,
        //           //   width: double.infinity,
        //           child: ListView.builder(
        //             shrinkWrap: true,
        //             scrollDirection: Axis.horizontal,
        //             itemCount: 10,
        //             itemBuilder: (context, index) {
        //               return Shimmer.fromColors(
        //                 baseColor: Colors.grey[300]!,
        //                 highlightColor: Colors.grey[100]!,
        //                 child: Container(
        //                   width: 170.0,
        //                   height: double.infinity,
        //                   margin: const EdgeInsets.all(8.0),
        //                   decoration: BoxDecoration(
        //                     color: Colors.white,
        //                     borderRadius: BorderRadius.circular(8.0),
        //                   ),
        //                 ),
        //               );
        //             },
        //           ),
        //         ),
        //       );
        //     }
        //
        //     // Convert vendor documents to UserModel
        //     vendors = snapshot.data!.map((doc) {
        //       var vendorData = doc.data() as Map<String, dynamic>;
        //       return UserModel.fromMap(vendorData, doc.id);
        //     }).toList();
        //
        //     return Padding(
        //       padding: MediaQuery.of(context).size.width >= 1100
        //           ? const EdgeInsets.only(left: 50, right: 50)
        //           : const EdgeInsets.all(0),
        //       child: MouseRegion(
        //         onEnter: (_) {
        //           setState(() {
        //             isHovered = true;
        //           });
        //         },
        //         onExit: (_) {
        //           setState(() {
        //             isHovered = false;
        //           });
        //         },
        //         child: Stack(
        //           alignment: Alignment.center,
        //           children: [
        //             SizedBox(
        //               height: 200,
        //               width: double.infinity,
        //               child: CarouselSlider.builder(
        //                 carouselController: _controller,
        //                 options: CarouselOptions(
        //                     enlargeStrategy: CenterPageEnlargeStrategy.height,
        //                     initialPage: 0,
        //                     disableCenter: true,
        //                     enableInfiniteScroll:
        //                         vendors.length < 5 ? false : true,
        //                     padEnds: false,
        //                     aspectRatio: 1,
        //                     viewportFraction:
        //                         MediaQuery.of(context).size.width >= 1100
        //                             ? 0.2
        //                             : 0.7,
        //                     reverse: false,
        //                     autoPlay: stopHovering == true ||
        //                             MediaQuery.of(context).size.width <= 1100
        //                         ? false
        //                         : vendors.length < 5
        //                             ? false
        //                             : true,
        //                     autoPlayInterval: const Duration(seconds: 3),
        //                     autoPlayAnimationDuration:
        //                         const Duration(milliseconds: 800),
        //                     autoPlayCurve: Curves.fastOutSlowIn,
        //                     enlargeCenterPage: false,
        //                     // onPageChanged: callbackFunction,
        //                     scrollDirection: Axis.horizontal,
        //                     onPageChanged: (index, reason) {
        //                       setState(() {
        //                         current = index;
        //                         // // ignore: avoid_print
        //                         // print('current is $current');
        //                       });
        //                     }),
        //                 // scrollDirection: Axis.horizontal,
        //                 // physics: const BouncingScrollPhysics(),
        //                 // shrinkWrap: true,
        //                 itemCount: vendors.length < 5 ? vendors.length : 5,
        //                 itemBuilder: (context, int d, int index) {
        //                   UserModel productsModel = vendors[d];
        //                   return Padding(
        //                     padding: const EdgeInsets.all(8.0),
        //                     child: InkWell(
        //                       hoverColor: Colors.transparent,
        //                       onHover: (value) {
        //                         setState(() {
        //                           stopHovering = value;
        //                         });
        //                       },
        //                       onTap: () {},
        //                       child: SizedBox(
        //                           height: 250,
        //                           // width: 200,
        //                           child: Card(
        //                             child: VendorListHomeWidget(
        //                                 isNewWidget: true,
        //                                 showModule: false,
        //                                 vendor: productsModel),
        //                           )),
        //                     ),
        //                   );
        //                 },
        //               ),
        //             ),
        //             if (MediaQuery.of(context).size.width >= 1100)
        //               isHovered == false
        //                   ? const SizedBox.shrink()
        //                   : current == 0
        //                       ? const SizedBox.shrink()
        //                       : Align(
        //                           alignment: Alignment.centerLeft,
        //                           child: Padding(
        //                             padding: const EdgeInsets.all(8.0),
        //                             child: InkWell(
        //                               onTap: () {
        //                                 _controller.previousPage();
        //                               },
        //                               child: Container(
        //                                   height: 30,
        //                                   width: 30,
        //                                   decoration: BoxDecoration(
        //                                     color: appColor,
        //                                     shape: BoxShape.circle,
        //                                   ),
        //                                   child: const Center(
        //                                       child: Icon(
        //                                     Icons.chevron_left,
        //                                     color: Colors.white,
        //                                   ))),
        //                             ),
        //                           )),
        //             if (MediaQuery.of(context).size.width >= 1100)
        //               isHovered == false
        //                   ? const SizedBox.shrink()
        //                   : Align(
        //                       alignment: Alignment.centerRight,
        //                       child: Padding(
        //                         padding: const EdgeInsets.all(8.0),
        //                         child: InkWell(
        //                           onTap: () {
        //                             _controller.nextPage();
        //                           },
        //                           child: Container(
        //                               height: 30,
        //                               width: 30,
        //                               decoration: BoxDecoration(
        //                                 color: appColor,
        //                                 shape: BoxShape.circle,
        //                               ),
        //                               child: const Center(
        //                                   child: Icon(
        //                                 Icons.chevron_right,
        //                                 color: Colors.white,
        //                               ))),
        //                         ),
        //                       )),
        //             if (MediaQuery.of(context).size.width <= 1100)
        //               current == 0
        //                   ? const SizedBox.shrink()
        //                   : Align(
        //                       alignment: Alignment.centerLeft,
        //                       child: Padding(
        //                         padding: const EdgeInsets.all(8.0),
        //                         child: InkWell(
        //                           onTap: () {
        //                             _controller.previousPage();
        //                           },
        //                           child: Container(
        //                               height: 30,
        //                               width: 30,
        //                               decoration: BoxDecoration(
        //                                 color: appColor,
        //                                 shape: BoxShape.circle,
        //                               ),
        //                               child: const Center(
        //                                   child: Icon(
        //                                 Icons.chevron_left,
        //                                 color: Colors.white,
        //                               ))),
        //                         ),
        //                       )),
        //             if (MediaQuery.of(context).size.width <= 1100)
        //               Align(
        //                   alignment: Alignment.centerRight,
        //                   child: Padding(
        //                     padding: const EdgeInsets.all(8.0),
        //                     child: InkWell(
        //                       onTap: () {
        //                         _controller.nextPage();
        //                       },
        //                       child: Container(
        //                           height: 30,
        //                           width: 30,
        //                           decoration: BoxDecoration(
        //                             color: appColor,
        //                             shape: BoxShape.circle,
        //                           ),
        //                           child: const Center(
        //                               child: Icon(
        //                             Icons.chevron_right,
        //                             color: Colors.white,
        //                           ))),
        //                     ),
        //                   )),
        //           ],
        //         ),
        //       ),
        //     );
        //   },
        // ),
      ],
    );
  }
}
