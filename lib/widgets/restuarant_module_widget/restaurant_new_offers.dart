import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_web/model/products_model.dart';
import 'package:user_web/constant.dart';
import '../../providers/restuarant_providers/restaurant_new_arrival_provider.dart';
import 'restaurant_product_widget_main.dart';

class RestaurantNewOffers extends ConsumerStatefulWidget {
  final String module;
  const   RestaurantNewOffers({super.key,required this.module});

  @override
  ConsumerState<RestaurantNewOffers> createState() =>
      _RestaurantNewOffersState();
}

class _RestaurantNewOffersState extends ConsumerState<RestaurantNewOffers> {
  @override
  Widget build(BuildContext context) {
    var arrival = ref.watch(newArrivalStreamRestaurantProvider(widget.module));
    return Padding(
      padding: MediaQuery.of(context).size.width >= 1100
          ? const EdgeInsets.only(left: 50,right: 40)
          : const EdgeInsets.only(left: 20,right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: MediaQuery.of(context).size.width >= 1100 ?
            const EdgeInsets.only(bottom: 15,left: 10) :
            const EdgeInsets.only(bottom: 20,left: 2),
             child: Text(
              'New Arrivals',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.width >= 1100 ? 30 : 20,
              ),
            ).tr(),
          ),
          arrival.when(
            data: (products) {
              if (products.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.restaurant_menu, size: 60,
                          // color: Colors.grey
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Coming Soon..',
                        style: TextStyle(
                          fontSize: 18,
                          // color: Colors.grey,
                          fontFamily: 'Nunito',
                        ),
                      ).tr(),
                    ],
                  ),
                );
              }
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.of(context).size.width >= 1100
                      ? 3
                      :  2,
                  crossAxisSpacing: 26,
                  mainAxisSpacing: 26,
                  childAspectRatio: MediaQuery.of(context).size.width >= 1100 ? 1.6 : 0.9,
                ),
                itemCount: (products.length > 6) ? 6 : products.length,
                itemBuilder: (context, index) {
                  ProductsModel productsModel = products[index];
                  return GestureDetector(
                    onTap: () {
                      context.go('/restaurant/product-detail/${productsModel.uid}');
                    },
                    child: RestaurantProductWidgetMain(
                        index: index,
                        productsModel: productsModel
                    ),
                  );
                },
              );
            },
            error: (e, r) => Text('$e'),
            loading: () => GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.5,
              ),
              itemCount: 6,
              itemBuilder: (context, index) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

