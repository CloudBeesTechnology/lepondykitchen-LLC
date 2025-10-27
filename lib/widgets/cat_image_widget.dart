import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CatImageWidget extends StatefulWidget {
  final String url;
  final String boxFit;

  const CatImageWidget({
    super.key,
    required this.url,
    required this.boxFit,
  });

  @override
  State<CatImageWidget> createState() => _CatImageWidgetState();
}

class _CatImageWidgetState extends State<CatImageWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      lowerBound: 0.0,
      upperBound: 1.0,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fitType =
    widget.boxFit == 'cover' ? BoxFit.cover : BoxFit.fill;

    if (kIsWeb) {
      // ✅ ExtendedImage for Web with Fade Animation
      return ExtendedImage.network(
        widget.url,
        fit: fitType,
        width: double.infinity,
        height: double.infinity,
        cache: true,
        loadStateChanged: (state) {
          switch (state.extendedImageLoadState) {
            case LoadState.loading:
              return Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
              );
            case LoadState.completed:
              _controller.forward();
              return FadeTransition(
                opacity: _controller,
                child: state.completedWidget,
              );
            case LoadState.failed:
              return const Icon(Icons.error, color: Colors.red);
          }
        },
      );
    } else {
      // ✅ CachedNetworkImage for Mobile with fadeIn
      return CachedNetworkImage(
        imageUrl: widget.url,
        fit: fitType,
        width: double.infinity,
        height: double.infinity,
        fadeInDuration: const Duration(milliseconds: 400),
        fadeOutDuration: const Duration(milliseconds: 150),
        placeholder: (context, url) => Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        errorWidget: (context, url, error) =>
        const Icon(Icons.error, color: Colors.red),
      );
    }
  }
}






class CatImageWidgets extends StatefulWidget {
  final String url;
  final String boxFit;

  const CatImageWidgets({
    super.key,
    required this.url,
    required this.boxFit,
  });

  @override
  State<CatImageWidgets> createState() => _CatImageWidgetsState();
}

class _CatImageWidgetsState extends State<CatImageWidgets>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      lowerBound: 0.0,
      upperBound: 1.0,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fitType =
    widget.boxFit == 'cover' ? BoxFit.contain : BoxFit.fill;

    if (kIsWeb) {
      // ✅ ExtendedImage for Web with Fade Animation
      return ExtendedImage.network(
        widget.url,
        fit: fitType,
        width: double.infinity,
        height: double.infinity,
        cache: true,
        loadStateChanged: (state) {
          switch (state.extendedImageLoadState) {
            case LoadState.loading:
              return Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
              );
            case LoadState.completed:
              _controller.forward();
              return FadeTransition(
                opacity: _controller,
                child: state.completedWidget,
              );
            case LoadState.failed:
              return const Icon(Icons.error, color: Colors.red);
          }
        },
      );
    } else {
      // ✅ CachedNetworkImage for Mobile with fadeIn
      return CachedNetworkImage(
        imageUrl: widget.url,
        fit: fitType,
        width: double.infinity,
        height: double.infinity,
        fadeInDuration: const Duration(milliseconds: 400),
        fadeOutDuration: const Duration(milliseconds: 150),
        placeholder: (context, url) => Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        errorWidget: (context, url, error) =>
        const Icon(Icons.error, color: Colors.red),
      );
    }
  }
}