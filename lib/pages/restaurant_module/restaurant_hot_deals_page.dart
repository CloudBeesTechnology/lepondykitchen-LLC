import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_web/widgets/footer_widget.dart';
import '../../model/products_model.dart';
import '../../providers/restuarant_providers/restaurant_hot_deals_provider.dart';
import '../../widgets/restuarant_module_widget/restaurant_product_widget_main.dart';

class RestaurantHotDealsPage extends ConsumerStatefulWidget {
  const RestaurantHotDealsPage({super.key});

  @override
  ConsumerState<RestaurantHotDealsPage> createState() => _RestaurantHotDealsPageState();
}

class _RestaurantHotDealsPageState extends ConsumerState<RestaurantHotDealsPage> {
  final PagingController<int, ProductsModel> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(hotDealPageStreamRestaurantProvider);
    return Scaffold(
      backgroundColor: AdaptiveTheme.of(context).mode.isDark == true
          ? null
          : const Color.fromARGB(255, 247, 240, 240),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.width >= 1100 ? 200 : 150,
              width: double.infinity,
              decoration: BoxDecoration(
                  // color: Color.fromARGB(255, 230, 224, 237),
                  image: DecorationImage(
                      // opacity: 0.3,
                      fit: MediaQuery.of(context).size.width >= 1100
                          ? BoxFit.cover
                          : BoxFit.fill,
                      image: const AssetImage('assets/image/hot deals.png'))),
            ),
            Padding(
              padding: MediaQuery.of(context).size.width >= 1100
                  ? const EdgeInsets.only(left: 60, right: 50)
                  : const EdgeInsets.all(0),
              child: Column(
                children: [
                  const Gap(20),
                  if (MediaQuery.of(context).size.width >= 1100)
                    Align(
                      alignment: MediaQuery.of(context).size.width >= 1100
                          ? Alignment.centerLeft
                          : Alignment.center,
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              context.go('/restaurant');
                            },
                            child: const Text(
                              'Home',
                              style: TextStyle(fontSize: 10),
                            ).tr(),
                          ),
                          const Text(
                            '/ Hot Deals',
                            style: TextStyle(fontSize: 10),
                          ).tr(),
                        ],
                      ),
                    ),
                  Align(
                    alignment: MediaQuery.of(context).size.width >= 1100
                        ? Alignment.centerLeft
                        : Alignment.center,
                    child: const Text(
                      'Amazing Hot Deals',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ).tr(),
                  ),
                  const Gap(10),
                ],
              ),
            ),
            products.when(data: (v) {
              return Padding(
                padding: MediaQuery.of(context).size.width >= 1100
                    ? const EdgeInsets.only(left: 50, right: 50)
                    : const EdgeInsets.all(0),
                child: AnimationLimiter(
                  child: GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: v.length,
                    itemBuilder: (context, index) {
                      ProductsModel productsModel = v[index];
                      return AnimationConfiguration.staggeredGrid(
                        position: index,
                        duration: const Duration(milliseconds: 500),
                        columnCount:
                            MediaQuery.of(context).size.width >= 1100 ? 5 : 2,
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          curve: Curves.easeInOut,
                          child: FadeInAnimation(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                  onTap: () {
                                    context.go(
                                        '/restaurant/product-detail/${productsModel.uid}');
                                  },
                                  child:RestaurantProductWidgetMain(
                                      index: index,
                                      productsModel: productsModel)),
                            ),
                          ),
                        ),
                      );
                    },
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio:
                            MediaQuery.of(context).size.width >= 1100
                                ? 0.7
                                : 0.57,
                        crossAxisCount:
                            MediaQuery.of(context).size.width >= 1100 ? 5 : 2,
                        mainAxisSpacing: 5,
                        crossAxisSpacing: 5),
                  ),
                ),
              );
            }, error: (r, e) {
              return Text('$r');
            }, loading: () {
              return Padding(
                padding: MediaQuery.of(context).size.width >= 1100
                    ? const EdgeInsets.only(left: 50, right: 50)
                    : const EdgeInsets.all(0),
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        MediaQuery.of(context).size.width >= 1100 ? 5 : 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: 20,
                  itemBuilder: (BuildContext context, int index) {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Container(
                              color: Colors.grey[300],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 16,
                                  width: 120,
                                  color: Colors.grey[300],
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  height: 16,
                                  width: 80,
                                  color: Colors.grey[300],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            }),
            const Gap(20),
            const FooterWidget()
          ],
        ),
      ),
    );
  }
}
