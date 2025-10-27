import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:user_web/model/cities_model.dart';
import 'package:user_web/widgets/cat_image_widget.dart';

class CitiesHomeWidget extends StatefulWidget {
  final CitiesModel city;
  const CitiesHomeWidget({super.key, required this.city});

  @override
  State<CitiesHomeWidget> createState() => _CitiesHomeWidgetState();
}

class _CitiesHomeWidgetState extends State<CitiesHomeWidget> {
  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: InkWell(
        hoverColor: Colors.transparent,
        onTap: () {
          context.go('/city/${widget.city.cityName}');
        },
        onHover: (value) {
          setState(() {
            isHovered = value;
          });
        },
        child: Transform.scale(
          scale: MediaQuery.of(context).size.width >= 1100
              ? (isHovered ? 1.05 : 1.0)
              : (isHovered ? 1 : 1.0),
          child: Column(
            children: [
              // Image.network(
              //   city.image,
              //   height: 150,
              //   width: 250,
              //   fit: BoxFit.cover,
              // ),
              SizedBox(
                  height: 150,
                  width: 250,
                  child:
                      CatImageWidget(url: widget.city.image, boxFit: 'cover')),
              const SizedBox(height: 8),
              Text(
                widget.city.cityName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
