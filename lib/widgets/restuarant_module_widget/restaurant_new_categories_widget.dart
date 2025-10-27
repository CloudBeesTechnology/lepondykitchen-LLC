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
import '../../providers/restuarant_providers/restaurant_category_providers.dart';
import '../cat_image_widget.dart';

class RestaurantNewCategoriesWidget extends ConsumerStatefulWidget {
  final String module;
  const RestaurantNewCategoriesWidget({
    super.key,
    required this.module,
  });

  @override
  ConsumerState<RestaurantNewCategoriesWidget> createState() =>
      _RestaurantNewCategoriesWidgetState();
}

class _RestaurantNewCategoriesWidgetState
    extends ConsumerState<RestaurantNewCategoriesWidget> {
  int current = 0;
  final CarouselSliderController _controller = CarouselSliderController();
  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    final cats = ref.watch(getCategoriesByModelRestaurantProvider(widget.module));
    return  Container(
      height: MediaQuery.of(context).size.width >= 1100 ? 320 : 230,
      decoration: BoxDecoration(
        color: AdaptiveTheme.of(context).mode.isDark == true
            ? null :
        Color(0xFFDF7EB).withOpacity(1.0),
        image: DecorationImage(
          image: AssetImage('assets/image/cat bg.png'),
          alignment: Alignment.center,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Prevents Expanded issues
        children: [
          Padding(
            padding: MediaQuery.of(context).size.width >= 1100
                ? const EdgeInsets.only(left: 50, right: 50)
                : const EdgeInsets.only(left: 20.0, right: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: MediaQuery.of(context).size.width >= 1100
                    ? const EdgeInsets.only(top: 10)
                    : const EdgeInsets.only(left: 8.0, top: 10),
                child: Text(
                  'Categories',
                  style: TextStyle(
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w600,
                      fontSize: MediaQuery.of(context).size.width >= 1100
                          ? 32
                          : 20),
                ).tr(),
              ),
            ),
          ),
          if (MediaQuery.of(context).size.width >= 1100) const SizedBox(height: 10),
          Padding(
            padding: MediaQuery.of(context).size.width >= 1100
                ? const EdgeInsets.symmetric(horizontal: 20)
                : EdgeInsets.zero,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.width >= 1100 ? 200 : 170,
                  child: cats.when(
                    data: (v) {
                      if (v.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.restaurant, size: 60,
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
                      return Padding(
                        padding: MediaQuery.of(context).size.width >= 1100
                            ? const EdgeInsets.only(left: 18, top: 5)
                            : const EdgeInsets.only(left: 26, top: 5),
                        child: CarouselSlider.builder(
                          key: PageStorageKey('${widget.module}-carousel'),
                          carouselController: _controller,
                          options: CarouselOptions(
                            enlargeStrategy: CenterPageEnlargeStrategy.height,
                            initialPage: 0,
                            disableCenter: true,
                            enableInfiniteScroll: false,
                            padEnds: false,
                            aspectRatio: MediaQuery.of(context).size.width >= 1100 ? 2 : 3,
                            viewportFraction: MediaQuery.of(context).size.width >= 1100 ? 0.13 : 0.28,
                            reverse: false,
                            autoPlay: false,
                            autoPlayInterval: const Duration(seconds: 3),
                            autoPlayAnimationDuration: const Duration(milliseconds: 800),
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enlargeCenterPage: false,
                            scrollDirection: Axis.horizontal,
                            onPageChanged: (index, reason) {
                              setState(() {
                                current = index;
                              });
                            },
                          ),
                          itemCount: v.length,
                          itemBuilder: (BuildContext context, int d, int index) {
                            CategoriesModel categoriesModel = v[d];
                            return CategoriesLogoWidget(categoriesModel: categoriesModel);
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
                        padding: const EdgeInsets.fromLTRB(8, 0, 0, 20),
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
                if (MediaQuery.of(context).size.width <= 1100)
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 0, 20),
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



class CategoriesLogoWidget extends StatefulWidget {
  final CategoriesModel categoriesModel;
  const CategoriesLogoWidget({super.key, required this.categoriesModel});

  @override
  State<CategoriesLogoWidget> createState() => _CategoriesLogoWidgetState();
}

class _CategoriesLogoWidgetState extends State<CategoriesLogoWidget> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: MediaQuery.of(context).size.width >= 1100
          ? (isHovered ? 1.07 : 1.0)
          : 1.0,
      child: InkWell(
        hoverColor: Colors.transparent,
        onHover: (value) {
          setState(() {
            isHovered = value;
          });
        },
        onTap: () {
          context
              .go('/restaurant/products/${widget.categoriesModel.category}');
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 95,
                height: 95,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300, width: 1),
                ),
                child: ClipOval(
                  child: CatImageWidget(
                    url: widget.categoriesModel.image,
                    boxFit: 'cover',
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Flexible(
                child: Text(
                  widget.categoriesModel.category,
                  textAlign: TextAlign.center,
                  style:  TextStyle(fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).size.width >= 1100 ? 16 : 14, fontFamily: 'Nunito'),
                ),)
            ],
          ),
        ),
      ),
    );
  }
}


