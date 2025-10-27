import 'package:flutter/material.dart';
import 'restuarant_products_by_similar_widget.dart';

class RestaurantSimilarItemsWidget extends StatefulWidget {
  final String category;
  final String productID;
  const RestaurantSimilarItemsWidget(
      {super.key, required this.category, required this.productID});

  @override
  State<RestaurantSimilarItemsWidget> createState() => _RestaurantSimilarItemsWidgetState();
}

class _RestaurantSimilarItemsWidgetState extends State<RestaurantSimilarItemsWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 400,
        width: double.infinity,
        child: RestuarantProductsBySimilarWidget(
          productID: widget.productID,
          cat: widget.category,
        ));
  }
}
