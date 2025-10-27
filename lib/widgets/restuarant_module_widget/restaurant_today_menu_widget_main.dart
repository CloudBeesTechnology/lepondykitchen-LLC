import 'dart:convert';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:user_web/model/cart_model.dart';
import 'package:user_web/model/formatter.dart';
import 'package:user_web/model/today_menu_model.dart';
import 'package:user_web/providers/currency_provider.dart';
import 'package:user_web/providers/vendors_list_home_provider.dart';
import 'package:user_web/widgets/cat_image_widget.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:user_web/constant.dart';
import '../../model/products_model.dart';
// ignore: depend_on_referenced_packages
import 'package:like_button/like_button.dart' as like;
import '../../providers/restuarant_providers/restaurant_cart_storage_provider.dart';
import '../../providers/restuarant_providers/restaurant_favorite_storage_provider.dart';

class RestaurantTodayMenuWidgetMain extends ConsumerStatefulWidget {
  final TodayMenuModel productsModel;
  final int index;
  const RestaurantTodayMenuWidgetMain(
      {super.key, required this.productsModel, required this.index});

  @override
  ConsumerState<RestaurantTodayMenuWidgetMain> createState() =>
      _RestaurantTodayMenuWidgetMainState();
}

class _RestaurantTodayMenuWidgetMainState
    extends ConsumerState<RestaurantTodayMenuWidgetMain> {
  var logger = Logger();
  bool isHovered = false;

  String extractDescription(String jsonString) {
    try {
      List<dynamic> decodedJson = jsonDecode(jsonString);
      return decodedJson.first["insert"] ?? "";
    } catch (e) {
      return jsonString; // Fallback if parsing fails
    }
  }

  @override
  Widget build(BuildContext context) {
    final currency = ref.watch(currencySymbolProvider).value ?? '';
    final cartStorage =
    ref.read(cartStorageRestaurantProviderProvider.notifier);
    final cartStorageData = ref.watch(cartStorageRestaurantProviderProvider);
    final favoriteStorageData =
    ref.watch(favoriteStorageRestaurantProviderProvider);
    final favoriteStorage =
    ref.read(favoriteStorageRestaurantProviderProvider.notifier);
    final vendorStatus = ref
        .watch(getVendorOpenStatusProvider(widget.productsModel.vendorId))
        .value;

   return  InkWell(
     onTap: () {
       if (MediaQuery.of(context).size.width <= 1100) {
         context.go('/restaurant/todayMenu-detail/${widget.productsModel.uid}');
       }
     },
     // onHover: (value) {
     //   setState(() {
     //     isHovered = value;
     //   });
     // },
     child: Transform.scale(
       scale: MediaQuery.of(context).size.width >= 1100
           ? (isHovered == true ? 1.05 : 1.0)
           : (isHovered == true ? 1 : 1.0),

       child: Container(
         decoration: BoxDecoration(
           color: AdaptiveTheme.of(context).mode.isDark == true
               ? Colors.black87
               : Colors.white,
           // color: Colors.white,
           borderRadius: BorderRadius.circular(10),
         ),
         child: Column(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             // const Gap(10),
             Expanded(
               flex: 4,
               child: Stack(
                 children: [
                   Stack(
                     alignment: Alignment.center,
                     children: [
                       SizedBox(
                           height: MediaQuery.of(context).size.width >= 1100 ? 220 : 180,
                           width: double.infinity,
                           child: ClipRRect(
                             borderRadius: const BorderRadius.only(
                               topRight:Radius.circular(10),
                               topLeft:Radius.circular(10) ,
                               bottomRight: Radius.circular(10),
                               bottomLeft:Radius.circular(10) ,
                             ),
                             child: CatImageWidget(
                               url: widget.productsModel.image1,
                               boxFit: 'cover',
                             ),
                           )),
                     ],
                   ),
                   Align(
                     alignment: Alignment.center,
                     child: FadeIn(
                       duration: const Duration(milliseconds: 100),
                       animate: isHovered,
                       child: Container(
                         height: MediaQuery.of(context).size.height,
                         decoration: BoxDecoration(
                           color: Colors.black.withValues(alpha:0.6),
                           borderRadius: const BorderRadius.only(
                               topLeft: Radius.circular(10),
                               topRight: Radius.circular(10)),
                         ),
                         width: double.infinity,
                         child: InkWell(
                           onTap: () {
                             context.go('/restaurant/todayMenu-detail/${widget.productsModel.uid}');
                           },
                           // child: const Icon(
                           //   Icons.visibility,
                           //   color: Colors.white,
                           //   size: 40,
                           // ),
                         ),
                       ),
                     ),
                   ),
                   widget.productsModel.percantageDiscount == 0
                       ? const SizedBox.shrink()
                       : Align(
                     alignment: Alignment.bottomLeft,
                     child: Padding(
                       padding: const EdgeInsets.only(bottom: 12),
                       child: Container(
                           height: 20,
                           width: 70,
                           decoration: BoxDecoration(
                               color: Color(0xFFB623).withOpacity(1.0),
                               borderRadius: BorderRadius.circular(1)),
                           child: Padding(
                             padding: const EdgeInsets.only(left: 6),
                             child: Text(
                               '${widget.productsModel.percantageDiscount}% OFF',
                               style: const TextStyle(
                                 // color: Colors.white,
                                 fontSize: 15,
                               ),
                             ),
                           )),
                     ),
                   ),
                 ],
               ),
             ),
             const Gap(10),
             Row(
               children: [
                 const SizedBox(width: 8), // For left padding
                    Text(
                     widget.productsModel.name,
                     maxLines: 1,
                     overflow: TextOverflow.ellipsis,
                     style: TextStyle(
                       fontSize: MediaQuery.of(context).size.width >= 1100 ? 16 : 13,
                       fontFamily: 'Nunito',
                       fontWeight: FontWeight.bold,
                     ),
                   ),
                 // Padding(
                 //   padding: const EdgeInsets.only(right: 10),
                 //   child: Container(
                 //     width: MediaQuery.of(context).size.width >= 1100 ? 50 : 40,
                 //     height: MediaQuery.of(context).size.width >= 1100 ? 25 : 20,
                 //     decoration: BoxDecoration(
                 //       color: const Color(0xFF2B8C3F),
                 //       borderRadius: BorderRadius.circular(10),
                 //     ),
                 //     child: Row(
                 //       mainAxisAlignment: MainAxisAlignment.center,
                 //       children: [
                 //         Text(
                 //           widget.productsModel.totalNumberOfUserRating.toString(),
                 //           style: TextStyle(
                 //             fontFamily: 'Nunito',
                 //             fontSize: MediaQuery.of(context).size.width >= 1100 ? 12 : 10,
                 //             color: Colors.white,
                 //           ),
                 //         ),
                 //         const Gap(5),
                 //         const Icon(Icons.star, size: 12, color: Colors.white),
                 //       ],
                 //     ),
                 //   ),
                 // ),
               ],
             ),
             const Gap(5),
             Row(
               crossAxisAlignment: CrossAxisAlignment.start, // Align text at the top
               children: [
                 // Expanded( // Ensures description takes available space
                 //   child: Padding(
                 //     padding: EdgeInsets.only(left: 15),
                 //     child: Text(
                 //       extractDescription(widget.productsModel.description),
                 //       maxLines: 2, // Allows it to break into the next line
                 //       overflow: TextOverflow.ellipsis,
                 //       style: TextStyle(
                 //         fontFamily: 'Nunito',
                 //         fontSize: MediaQuery.of(context).size.width >= 1100 ? 12 : 10,
                 //         color: Colors.grey,
                 //       ),
                 //     ),
                 //   ),
                 // ),
                 Padding(
                   padding: EdgeInsets.only(left: 10),
                   child: Align(
                     alignment: Alignment.topRight, // Keeps price aligned properly
                     child: Text(
                       // '$currency${Formatter().converter(widget.productsModel.unitPrice1!.toDouble())} for one',
                       '$currency${widget.productsModel.unitPrice1!.toDouble().toStringAsFixed(2)} for one',
                       style: TextStyle(
                         fontFamily: 'Nunito',
                         fontSize: MediaQuery.of(context).size.width >= 1100 ?14 : 12,
                         // color: Colors.grey,
                       ),
                     ),
                   ),
                 ),
               ],
             ),
           ],
         ),
       ),
     ),
   );


    //  Transform.scale(
    //   scale: MediaQuery.of(context).size.width >= 1100
    //       ? (isHovered ? 1.07 : 1.0)
    //       : 1.0,
    //   child: InkWell(
    //     hoverColor: Colors.transparent,
    //     onHover: (value) {
    //       setState(() {
    //         isHovered = value;
    //       });
    //     },
    //     onTap: () {
    //       context.go('/restaurant/todayMenu-detail/${widget.productsModel.uid}');
    //       // context.go('/restaurant/product-detail/${productsModel.uid}');
    //     },
    //     child: Padding(
    //       padding: const EdgeInsets.all(8.0),
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           Container(
    //             width: 95,
    //             height: 95,
    //             decoration: BoxDecoration(
    //               shape: BoxShape.circle,
    //               color: Colors.white,
    //               border: Border.all(color: Colors.grey.shade300, width: 1),
    //             ),
    //             child: ClipOval(
    //               child: Image.network(
    //                 widget.productsModel.image1,
    //                 fit: BoxFit.cover,
    //               ),
    //             ),
    //           ),
    //
    //           const SizedBox(height: 8),
    //           Text(
    //             widget.productsModel.name,
    //             textAlign: TextAlign.center,
    //             maxLines: 1,
    //             overflow: TextOverflow.ellipsis,
    //             style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'Nunito'),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
