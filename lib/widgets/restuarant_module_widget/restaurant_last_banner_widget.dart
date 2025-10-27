import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_web/model/feeds.dart';
import '../../providers/restuarant_providers/restaurant_banner_provider.dart';
import '../cat_image_widget.dart';

class RestaurantLastBannerWidget extends ConsumerStatefulWidget {
  const RestaurantLastBannerWidget({super.key});

  @override
  ConsumerState<RestaurantLastBannerWidget> createState() => _RestaurantLastBannerWidgetState();
}

class _RestaurantLastBannerWidgetState extends ConsumerState<RestaurantLastBannerWidget> {
  FeedsModel? banner1;
  FeedsModel? banner2;

  bool isHovered = false;
  bool isHovered2 = false;

  // Selects two random banners after loading data
void selectRandomBanners(List<FeedsModel> feeds) {
  if (feeds.length < 2) {
    return; // Not enough banners to select two different ones
  }

  Random random = Random();
  
  // Select the first banner
  banner1 = feeds[random.nextInt(feeds.length)];
  
  // Select a second banner that is different from the first
  do {
    banner2 = feeds[random.nextInt(feeds.length)];
  } while (banner2 == banner1);
  
  setState(() {});
}

  @override
  Widget build(BuildContext context) {
    // Fetch the banner list from the Firestore using Riverpod provider
    final bannerListAsyncValue = ref.watch(restaurantfetchBannersProvider);

    return bannerListAsyncValue.when(data: (feeds) {
      if (feeds.isEmpty) {
        return const Text('No banners available');
      }
      // ignore: avoid_print
      print('read');
      // Only select banners if they haven't been selected yet
      if (banner1 == null || banner2 == null) {
        selectRandomBanners(feeds);
      }

      return MediaQuery.of(context).size.width >= 1100
          ? Padding(
              padding: const EdgeInsets.only(left: 50, right: 50),
              child: SizedBox(
                height: MediaQuery.of(context).size.width >= 1100 ? 250 : 150,
                width: double.infinity,
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: InkWell(
                        onTap: () {
                          context.go('/restaurant/products/${banner1?.category}');
                        },
                        onHover: (value) {
                          setState(() {
                            isHovered = value;
                          });
                        },
                        child: Transform.scale(
                          scale: MediaQuery.of(context).size.width >= 1100
                              ? (isHovered == true ? 1.02 : 1.0)
                              : (isHovered == true ? 1 : 1.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(0),
                            child: SizedBox(
                              height: double.infinity,
                              width: double.infinity,
                              child: CatImageWidget(
                                  url: banner1!.image, boxFit: 'fill'),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Gap(10),
                    Expanded(
                      flex: 2,
                      child: InkWell(
                        onTap: () {
                          context.go('/restaurant/products/${banner2!.category}');
                        },
                        onHover: (value) {
                          setState(() {
                            isHovered2 = value;
                          });
                        },
                        child: Transform.scale(
                          scale: MediaQuery.of(context).size.width >= 1100
                              ? (isHovered2 == true ? 1.02 : 1.0)
                              : (isHovered2 == true ? 1 : 1.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(0),
                            child: SizedBox(
                              height: double.infinity,
                              width: double.infinity,
                              child: CatImageWidget(
                                  url: banner2!.image, boxFit: 'fill'),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : SizedBox(
              height: 150,
              width: double.infinity,
              child: ListView(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      context.go('/restaurant/products/${banner1!.category}');
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(0),
                      child: SizedBox(
                        height: double.infinity,
                        width: 300,
                        child: CatImageWidget(
                          url: banner1!.image,
                          boxFit: 'fill',
                        ),
                      ),
                    ),
                  ),
                  const Gap(10),
                  InkWell(
                    onTap: () {
                      context.go('/restaurant/products/${banner2!.category}');
                    },
                    child: SizedBox(
                      height: double.infinity,
                      width: 300,
                      child: CatImageWidget(
                        url: banner2!.image,
                        boxFit: 'fill',
                      ),
                    ),
                  ),
                ],
              ),
            );
    }, error: (e, r) {
      return Text('$e');
    }, loading: () {
      return SizedBox(
        height: MediaQuery.of(context).size.width >= 1100 ? 250 : 150,
        width: double.infinity,
        child: MediaQuery.of(context).size.width >= 1100
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        height: double.infinity,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                      width:
                          10.0), // Add some spacing between the shimmer containers
                  Expanded(
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        height: double.infinity,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              )
            : ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: 2,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: 300.0,
                        //  height: 200.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
      );
    });
  }
}
