import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:user_web/widgets/product_detail_mobile_view_widget.dart';
import 'package:user_web/widgets/product_detail_web_view_widget.dart';
import 'package:user_web/widgets/today_menu_detaiul_view_widget.dart';

class TodayMenuDetailPage extends StatefulWidget {
  final String productUID;
  const TodayMenuDetailPage({super.key, required this.productUID});

  @override
  State<TodayMenuDetailPage> createState() => _TodayMenuDetailPageState();
}

class _TodayMenuDetailPageState extends State<TodayMenuDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AdaptiveTheme.of(context).mode.isDark == true
            ? null
            : const Color.fromARGB(255, 247, 240, 240),
        body:
        // MediaQuery.of(context).size.width >= 1100
        TodayMenuDetailViewWidget(productID: widget.productUID)
      // : ProductDetailMobileViewWidget(productID: widget.productUID),
    );
  }
}
