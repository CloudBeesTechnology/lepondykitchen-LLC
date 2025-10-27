import 'package:flutter/material.dart';
import 'package:user_web/pages/product_details_page.dart';

class RestaurantProductDetail extends StatefulWidget {
  final String id;
  const RestaurantProductDetail({super.key, required this.id});

  @override
  State<RestaurantProductDetail> createState() =>
      _RestaurantProductDetailState();
}

class _RestaurantProductDetailState extends State<RestaurantProductDetail> {
  @override
  Widget build(BuildContext context) {
    return ProductDetailPage(
      productUID: widget.id,
    );
  }
}
