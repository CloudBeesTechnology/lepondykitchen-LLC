// ignore_for_file: avoid_print

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:animate_do/animate_do.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_web/constant.dart';
// import 'package:user_web/constant.dart';
import 'package:user_web/model/feeds.dart';

import '../../providers/restuarant_providers/slider_provider.dart';

class RestaurantNewSlider extends ConsumerStatefulWidget {
  const RestaurantNewSlider({
    super.key,
  });

  @override
  ConsumerState<RestaurantNewSlider> createState() =>
      _RestaurantNewSliderState();
}

class _RestaurantNewSliderState extends ConsumerState<RestaurantNewSlider> {
  int _current = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  String category = '';

  @override
  Widget build(BuildContext context) {
    final allList = ref.watch(allListRestaurantProvider);
    final isLoading = ref.watch(feedsRestaurantProvider).isLoading ||
        ref.watch(bannersRestaurantProvider).isLoading;

    return  MediaQuery.of(context).size.width >= 1100 ?
      Container(
        decoration: BoxDecoration(
        // color: Color(0x282727).withOpacity(0.4),
        image: DecorationImage(
       image: AssetImage('assets/image/le pondy banner.png'), // Change to NetworkImage if needed// Ensures it covers the entire container
       // alignment: Alignment.center,
          fit: BoxFit.cover
       ),
        ),
        child: Stack(
          children: [
            Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Gap(100),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // const Gap(30),
                    Text('Order Your',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 30,fontFamily: 'Nunito', color: Colors.deepOrange.shade600, ),),
                    const Gap(12),
                    Text('Favourite Food',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 30,fontFamily: 'Nunito', color: Colors.black)),
                  ],
                ),
                const Gap(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('We offer a wide array of services',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 14,fontFamily: 'Nunito', color: Colors.black)),
                  ],
                ),
              const Gap(90),
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceAround,
             children: [
               Column(
                 children: [
                   Image.asset(
                     'assets/image/live event.png',
                     height: 50,
                     width: 50,
                   ),
                   Text('Live Event Stalls',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18,fontFamily: 'Nunito', color: Colors.black)),
                   Text('Bring your brand to life with vibrant calls.',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 12,fontFamily: 'Nunito', color: Colors.black)),
                   Text('Create moments that captivate and connect',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 12,fontFamily: 'Nunito', color: Colors.black)),
                 ],
               ),
               Column(
                 children: [
                   Image.asset(
                     'assets/image/order.png',
                     height: 55,
                     width: 55,
                   ),
                   Text('Online Order',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18,fontFamily: 'Nunito', color: Colors.black)),
                   Text('Enjoy signature authentic cuisine delivered straight to.',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 12,fontFamily: 'Nunito', color: Colors.black)),
                   Text('Your doorstep click above to order online now. ',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 12,fontFamily: 'Nunito', color: Colors.black)),
                 ],
               ),
               Column(
                 children: [
                   Image.asset(
                     'assets/image/party.png',
                     height: 55,
                     width: 55,
                   ),
                   Text('Private Party',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20,fontFamily: 'Nunito', color: Colors.black)),
                   Text('We believe delicious food brings every event to life.',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 12,fontFamily: 'Nunito', color: Colors.black)),
                   Text('Our goal is to provide the best and widest variety for your',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 12,fontFamily: 'Nunito', color: Colors.black)),
                   Text('special occasions',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 12,fontFamily: 'Nunito', color: Colors.black)),
                 ],
               ),
             ],
            )
              ],
            )
          ],
        )
      ) :  Container(
        decoration: BoxDecoration(
          // color: Color(0x282727).withOpacity(0.4),
          image: DecorationImage(
              image: AssetImage('assets/image/le pondy banner.png'), // Change to NetworkImage if needed// Ensures it covers the entire container
              // alignment: Alignment.center,
              fit: BoxFit.cover
          ),
        ),
        child: Stack(
          children: [
            Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Gap(25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // const Gap(30),
                    Text('Order Your',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20,fontFamily: 'Nunito', color: Colors.deepOrange.shade600 ),),
                    const Gap(12),
                    Text('Favourite Food',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20,fontFamily: 'Nunito', color: Colors.black)),
                  ],
                ),
                const Gap(8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('We offer a wide array of services',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 12,fontFamily: 'Nunito', color: Colors.black)),
                  ],
                ),
                const Gap(18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Image.asset(
                          'assets/image/live event.png',
                          height: 45,
                          width: 45,
                        ),
                        Text('Live event Stalls',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 14,fontFamily: 'Nunito', color: Colors.black)),
                        Text('Bring your brand to life with vibrant calls.',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 10,fontFamily: 'Nunito', color: Colors.black)),
                        Text('Create moments that captivate and connect.',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 10,fontFamily: 'Nunito', color: Colors.black)),
                      ],
                    ),
                  ],
                ),
                const Gap(18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Image.asset(
                          'assets/image/order.png',
                          height: 40,
                          width: 40,
                        ),
                        Text('Online Order',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 15,fontFamily: 'Nunito', color: Colors.black)),
                        Text('Enjoy signature cuisine delivered straight to.',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 10,fontFamily: 'Nunito', color: Colors.black)),
                        Text('Your doorstep click above to order online now. ',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 10,fontFamily: 'Nunito', color: Colors.black)),
                      ],
                    ),
                  ],
                ),
                const Gap(18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Image.asset(
                          'assets/image/party.png',
                          height: 40,
                          width: 40,
                        ),
                        Text('Private Party',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 15,fontFamily: 'Nunito', color: Colors.black)),
                        Text('We believe delicious food brings every event to life.',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 10,fontFamily: 'Nunito', color: Colors.black)),
                        Text('Our goal is to provide the best and variety for your.',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 10,fontFamily: 'Nunito', color: Colors.black)),
                        Text('special occasions.',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 10,fontFamily: 'Nunito', color: Colors.black)),
                      ],
                    ),
                  ],
                ),
                const Gap(8),
              ],
            )
          ],
        )
    ) ;

  }
}
