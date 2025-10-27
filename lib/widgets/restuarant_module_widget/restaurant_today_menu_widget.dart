import 'dart:async';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_web/model/categories.dart';
import 'package:user_web/constant.dart';
import 'package:user_web/model/today_menu_model.dart';
import 'package:user_web/widgets/restuarant_module_widget/restaurant_product_widget_main.dart';
import 'package:user_web/widgets/restuarant_module_widget/restaurant_today_menu_widget_main.dart';
import '../../providers/restuarant_providers/restaurant_category_providers.dart';
import '../../providers/restuarant_providers/restaurant_today_menu_provider.dart';

class RestaurantTodayMenuWidget extends ConsumerStatefulWidget {
  const RestaurantTodayMenuWidget({
    super.key,
  });

  @override
  ConsumerState<RestaurantTodayMenuWidget> createState() =>
      _RestaurantTodayMenuWidgetState();
}

class _RestaurantTodayMenuWidgetState
    extends ConsumerState<RestaurantTodayMenuWidget> {
  int current = 0;
  final CarouselSliderController _controller = CarouselSliderController();
  bool isHovered = false;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    // Refresh every minute to check for expired items
    _refreshTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      ref.invalidate(todayMenuStreamRestaurantProvider);
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final todayMenu = ref.watch(todayMenuStreamRestaurantProvider);
    return Container(
      height: MediaQuery.of(context).size.width >= 1100 ? 320 : 230,
      decoration: BoxDecoration(
        color: AdaptiveTheme.of(context).mode.isDark == true
            ? null : Colors.white,
        // color: Color(0xFFFDF7EB),
        // image: DecorationImage(
        //   image: AssetImage('assets/image/cat bg.png'),
        //   alignment: Alignment.center,
        // ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Prevents Expanded issues
        children: [
          Padding(
            padding: MediaQuery.of(context).size.width >= 1100
                ? const EdgeInsets.only(left: 50, right: 50)
                : const EdgeInsets.only(left: 25.0, right: 20),
            child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: MediaQuery.of(context).size.width >= 1100
                ? const EdgeInsets.only(top: 10)
                : const EdgeInsets.only(left: 5.0, top: 10),
            child: todayMenu.when(
              data: (v) {
                String menuTitle = "Today\'s menu";
                if (v.isNotEmpty && v.first.title.trim().isNotEmpty) {
                  menuTitle = v.first.title;
                }
                return Text(
                  menuTitle,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w600,
                    fontSize: MediaQuery.of(context).size.width >= 1100 ? 32 : 19,
                  ),
                );
              },
              loading: () => const SizedBox(height: 32,),
              error: (e, r) => const Text("Today\'s menu"),
            ),
          ),
        ),
          ),
          MediaQuery.of(context).size.width >= 1100 ? const SizedBox(height: 10) : const SizedBox(height: 8),
          Padding(
            padding: MediaQuery.of(context).size.width >= 1100
                ? const EdgeInsets.symmetric(horizontal: 10)
                : EdgeInsets.zero,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.width >= 1100 ? 200 : 170,
                  child: todayMenu.when(
                    data: (v) {
                      if (v.isEmpty) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.restaurant_menu, size: 50,
                                color: Colors.grey
                            ),
                            SizedBox(height: 10),
                            Text(
                              "No menu's available",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        );
                      }
                      return  Padding(
                        padding: MediaQuery.of(context).size.width >= 1100
                            ? const EdgeInsets.only(left: 35,top: 5)
                            : const EdgeInsets.only(left: 40,top: 5),
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: v.length,
                          separatorBuilder: (context, index) => MediaQuery.of(context).size.width >= 1100 ? const SizedBox(width: 20) :const SizedBox(width: 15),
                          itemBuilder: (context, index) {
                            final TodayMenuModel productsModel = v[index];
                            return Padding(
                              padding: const EdgeInsets.only(right: 12.0), // space between items
                              child: GestureDetector(
                                onTap: () {
                                  context.go('/restaurant/todayMenu-detail/${productsModel.uid}');
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width >= 1100 ? 230 : 170,
                                  height: MediaQuery.of(context).size.width >= 1100 ? 200 : 150,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    // boxShadow: [
                                    //   BoxShadow(
                                    //     color: Colors.grey.withOpacity(0.2),
                                    //     spreadRadius: 2,
                                    //     blurRadius: 5,
                                    //     offset: Offset(0, 3),
                                    //   ),
                                    // ],
                                  ),
                                  child: RestaurantTodayMenuWidgetMain(
                                    index: index,
                                    productsModel: productsModel,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                    error: (r, e) {
                      return const Center(child: Text('Error'));
                    },
                    loading: () {
                      return Padding(
                        padding: MediaQuery.of(context).size.width >= 1100
                            ? EdgeInsets.zero
                            : const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.width >= 1100 ? 200 : 170,
                          width: double.infinity,
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: 8,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 120,
                                          height: 150,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Container(
                                          width: 30,
                                          height: 10,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(4.0),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if (MediaQuery.of(context).size.width >= 1100)
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(2, 0, 0, 20),
                        child: InkWell(
                          onTap: () {
                            _controller.previousPage();
                          },
                          child: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                  child: Icon(
                                    Icons.chevron_left,
                                    color: Colors.grey,
                                  ))),
                        ),
                      )),
                if (MediaQuery.of(context).size.width >= 1100)
                  Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 4, 20),
                        child: InkWell(
                          onTap: () {
                            _controller.nextPage();
                          },
                          child: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                  child: Icon(
                                    Icons.chevron_right,
                                    color: Colors.grey,
                                  ))),
                        ),
                      )),
                if (MediaQuery.of(context).size.width <= 1100)
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                        child: InkWell(
                          onTap: () {
                            _controller.previousPage();
                          },
                          child: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                  child: Icon(
                                    Icons.chevron_left,
                                    color: Colors.grey,
                                  ))),
                        ),
                      )),
                if (MediaQuery.of(context).size.width <= 1100)
                  Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 8, 20),
                        child: InkWell(
                          onTap: () {
                            _controller.nextPage();
                          },
                          child: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                  child: Icon(
                                    Icons.chevron_right,
                                    color: Colors.grey,
                                  ))),
                        ),
                      )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



// class CategoriesLogoWidget extends StatefulWidget {
//   final TodayMenuModel categoriesModel;
//   const CategoriesLogoWidget({super.key, required this.categoriesModel});
//
//   @override
//   State<CategoriesLogoWidget> createState() => _CategoriesLogoWidgetState();
// }
//
// class _CategoriesLogoWidgetState extends State<CategoriesLogoWidget> {
//   bool isHovered = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Transform.scale(
//       scale: MediaQuery.of(context).size.width >= 1100
//           ? (isHovered ? 1.07 : 1.0)
//           : 1.0,
//       child: InkWell(
//         hoverColor: Colors.transparent,
//         onHover: (value) {
//           setState(() {
//             isHovered = value;
//           });
//         },
//         onTap: () {
//           context
//               .go('/restaurant/products/${widget.categoriesModel.category}');
//           // context.go('/restaurant/product-detail/${productsModel.uid}');
//         },
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 width: 95,
//                 height: 95,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: Colors.white,
//                   border: Border.all(color: Colors.grey.shade300, width: 1),
//                 ),
//                 child: ClipOval(
//                   child: Image.network(
//                     widget.categoriesModel.image1,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//
//               const SizedBox(height: 8),
//               Text(
//                 widget.categoriesModel.name,
//                 textAlign: TextAlign.center,
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//                 style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'Nunito'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


