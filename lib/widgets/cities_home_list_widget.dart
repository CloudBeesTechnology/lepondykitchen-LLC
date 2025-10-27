import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:carousel_slider/carousel_slider.dart'; // Import carousel_slider
import 'package:shimmer/shimmer.dart';
import 'package:user_web/providers/cities_list_provider.dart';
import 'package:user_web/widgets/cities_home_widget.dart';

class CitiesHomeListWidget extends ConsumerStatefulWidget {
  const CitiesHomeListWidget({super.key});

  @override
  ConsumerState<CitiesHomeListWidget> createState() =>
      _CitiesHomeListWidgetState();
}

class _CitiesHomeListWidgetState extends ConsumerState<CitiesHomeListWidget> {
  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    final cities = ref.watch(getCitiesListProvider);

    return cities.when(
      data: (citiesList) {
        // If data is fetched, display the carousel of cities
        return CarouselSlider.builder(
          itemCount: citiesList.length,
          itemBuilder: (context, index, realIndex) {
            final city = citiesList[index];
            return InkWell(
              onTap: () {},
              hoverColor: Colors.transparent,
              onHover: (value) {
                setState(() {
                  isHovered = value;
                });
              },
              child: CitiesHomeWidget(
                city: city,
              ),
            );
          },
          options: CarouselOptions(
            height: 200, // Adjust carousel height
            disableCenter: true,
            aspectRatio: 1,
            viewportFraction:
                MediaQuery.of(context).size.width >= 1100 ? 0.2 : 0.65,
            enlargeStrategy: CenterPageEnlargeStrategy.height,
            enableInfiniteScroll: true,
            padEnds: false,
            enlargeCenterPage: false, // Zoom effect for the centered item
            autoPlay: isHovered == true ? false : true, // Enable auto play
            autoPlayInterval: const Duration(seconds: 3),
            // viewportFraction: 0.8, // Show multiple items
            initialPage: 0,
          ),
        );
      },
      loading: () {
        // While loading, display shimmer effect in a carousel
        return CarouselSlider.builder(
          itemCount: 6, // Example placeholder count
          itemBuilder: (context, index, realIndex) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      height: 150,
                      width: 250,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      height: 20,
                      width: 100,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          },
          options: CarouselOptions(
            height: 200, // Adjust carousel height
            disableCenter: true,
            aspectRatio: 1,
            viewportFraction:
                MediaQuery.of(context).size.width >= 1100 ? 0.2 : 0.8,
            enlargeStrategy: CenterPageEnlargeStrategy.height,
            enableInfiniteScroll: true,
            padEnds: false,
            enlargeCenterPage: false, // Zoom effect for the centered item
            autoPlay: true, // Enable auto play
            autoPlayInterval: const Duration(seconds: 3),
            // viewportFraction: 0.8, // Show multiple items
            initialPage: 0,
          ),
        );
      },
      error: (error, stack) {
        // Handle error state
        return Center(
          child: Text('Failed to load cities: $error'),
        );
      },
    );
  }
}
