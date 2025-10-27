import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_web/model/brand_model.dart';

class RestaurantBrandsWidget extends StatefulWidget {
  const RestaurantBrandsWidget({
    super.key,
  });

  @override
  State<RestaurantBrandsWidget> createState() => _RestaurantBrandsWidgetState();
}

class _RestaurantBrandsWidgetState extends State<RestaurantBrandsWidget> {
  List<BrandModel> cats = [];
  bool isLoading = false;

  getCats() {
    setState(() {
      isLoading = true;
    });
    List<BrandModel> categories = [];
    return FirebaseFirestore.instance
        .collection('Brands')
        .where('module', isEqualTo: 'Restaurant')
        .snapshots()
        .listen((value) {
      setState(() {
        isLoading = false;
      });
      cats.clear();
      for (var element in value.docs) {
        setState(() {
          var fetchServices = BrandModel.fromMap(element.data(), element.id);
          categories.insert(0, fetchServices);
          cats = categories;
        });
      }
    });
  }

  @override
  void initState() {
    getCats();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: MediaQuery.of(context).size.width >= 1100
              ? const EdgeInsets.only(left: 50, right: 50)
              : const EdgeInsets.all(0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                // child: Text(
                //   'BRANDS',
                //   style: TextStyle(
                //       fontFamily: 'LilitaOne',
                //       fontSize:
                //           MediaQuery.of(context).size.width >= 1100 ? 30 : 20),
                // ).tr(),
              ),
            ],
          ),
        ),
        const Gap(10),
        // SizedBox(
        //   width: double.infinity,
        //   child: isLoading
        //       ? Padding(
        //           padding: MediaQuery.of(context).size.width >= 1100
        //               ? const EdgeInsets.all(0)
        //               : const EdgeInsets.all(8.0),
        //           child: GridView.builder(
        //             //  shrinkWrap: true,
        //             //     physics: const NeverScrollableScrollPhysics(),
        //             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //               crossAxisCount:
        //                   MediaQuery.of(context).size.width >= 1100 ? 6 : 3,
        //               childAspectRatio: 1,
        //               crossAxisSpacing: 10,
        //               mainAxisSpacing: 10,
        //             ),
        //             shrinkWrap: true,
        //             physics: const NeverScrollableScrollPhysics(),
        //             itemCount: 9,
        //             itemBuilder: (BuildContext context, int index) {
        //               return Shimmer.fromColors(
        //                 baseColor: Colors.grey[300]!,
        //                 highlightColor: Colors.grey[100]!,
        //                 child: Container(
        //                   color: Colors.white,
        //                 ),
        //               );
        //             },
        //           ),
        //         )
        //       : Padding(
        //           padding: MediaQuery.of(context).size.width >= 1100
        //               ? const EdgeInsets.all(0)
        //               : const EdgeInsets.all(8.0),
        //           child: LayoutBuilder(
        //             builder: (context, constraints) {
        //               // Determine number of columns based on screen width
        //               int columnCount =
        //                   MediaQuery.of(context).size.width >= 1100 ? 6 : 3;
        //               return GridView.builder(
        //                 shrinkWrap: true,
        //                 physics: const NeverScrollableScrollPhysics(),
        //                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //                   crossAxisCount: columnCount,
        //                   childAspectRatio: 1,
        //                   crossAxisSpacing: 10,
        //                   mainAxisSpacing: 10,
        //                 ),
        //                 itemCount: cats.length,
        //                 itemBuilder: (context, index) {
        //                   return GestureDetector(
        //                     onTap: () {
        //                       context.go(
        //                           '/restaurant/brand/${cats[index].collection}');
        //                     },
        //                     child: BrandLogoWidget(brandModel: cats[index]),
        //                   );
        //                 },
        //               );
        //             },
        //           ),
        //         ),
        // ),
      ],
    );
  }
}

// The BrandLogoWidget remains unchanged from the original code
class BrandLogoWidget extends StatefulWidget {
  final BrandModel brandModel;
  const BrandLogoWidget({super.key, required this.brandModel});

  @override
  State<BrandLogoWidget> createState() => _BrandLogoWidgetState();
}

class _BrandLogoWidgetState extends State<BrandLogoWidget> {
  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: Transform.scale(
        scale: isHovered ? 1.05 : 1.0,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AdaptiveTheme.of(context).mode.isDark == true
                ? Colors.black87
                : Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 2,
                  color: const Color.fromARGB(255, 247, 240, 240),
                ),
                borderRadius: BorderRadius.circular(12),
                color: AdaptiveTheme.of(context).mode.isDark == true
                    ? Colors.black87
                    : Colors.white,
              ),
              child: Center(
                child: Image.network(
                  widget.brandModel.image,
                  height: 130,
                  width: 130,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
