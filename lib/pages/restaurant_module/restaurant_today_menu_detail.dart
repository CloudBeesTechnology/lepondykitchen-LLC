import 'package:flutter/material.dart';
import '../today_menu_detail_page.dart';

class RestaurantTodayMenuDetail extends StatefulWidget {
  final String id;
  const RestaurantTodayMenuDetail({super.key, required this.id});

  @override
  State<RestaurantTodayMenuDetail> createState() =>
      _RestaurantTodayMenuDetailState();
}

class _RestaurantTodayMenuDetailState extends State<RestaurantTodayMenuDetail> {
  @override
  Widget build(BuildContext context) {
    return TodayMenuDetailPage(
      productUID: widget.id,
    );
  }
}
