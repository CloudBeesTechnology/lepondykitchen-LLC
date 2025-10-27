import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:logger/logger.dart';
import 'package:user_web/model/rating.dart';

class RatingSummaryMobile extends StatefulWidget {
  final num totalNumberOfUserRating;
  final num totalRating;
  final List<RatingModel> ratings;
  const RatingSummaryMobile(
      {super.key,
      required this.totalNumberOfUserRating,
      required this.totalRating,
      required this.ratings});

  @override
  State<RatingSummaryMobile> createState() => _RatingSummaryMobileState();
}

class _RatingSummaryMobileState extends State<RatingSummaryMobile> {
  num rating1 = 0;
  num rating2 = 0;
  num rating3 = 0;
  num rating4 = 0;
  num rating5 = 0;
  ratings1() {
    setState(() {
      rating1 = widget.ratings
          .where((r) => r.rating >= 1.0 && r.rating <= 1.44)
          .toList()
          .length;
    });
  }

  ratings2() {
    setState(() {
      rating2 = widget.ratings
          .where((r) => r.rating > 1.44 && r.rating <= 2.44) // Adjusted range
          .toList()
          .length;
    });
  }

  ratings3() {
    setState(() {
      rating3 = widget.ratings
          .where((r) => r.rating > 2.44 && r.rating <= 3.44) // Adjusted range
          .toList()
          .length;
    });
  }

  ratings4() {
    setState(() {
      rating4 = widget.ratings
          .where((r) => r.rating > 3.44 && r.rating <= 4.44) // Adjusted range
          .toList()
          .length;
    });
  }

  ratings5() {
    setState(() {
      rating5 = widget.ratings
          .where((r) =>
              r.rating > 4.44 &&
              r.rating <= 5.0) // Adjusted range for consistency
          .toList()
          .length;
    });
  }

  var logger = Logger();
  @override
  void initState() {
    logger.d('ssss ${widget.ratings}');
    ratings1();
    ratings2();
    ratings3();
    ratings4();
    ratings5();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  // The default text style
                  style: DefaultTextStyle.of(context).style.copyWith(
                        fontSize: 60.r, // Default font size for unstyled text
                      ),
                  children: <TextSpan>[
                    TextSpan(
                      text:
                          '${(widget.totalRating / widget.totalNumberOfUserRating).toStringAsFixed(1)} ',
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold), // Black text
                    ),
                    TextSpan(
                      text: 'Out of 5',
                      style: TextStyle(
                        color: Colors.grey, // Blue text
                        fontSize: 12.r, // Larger font size
                      ),
                    ),
                  ],
                ),
              ),
              RatingBarIndicator(
                rating: 5,
                itemBuilder: (context, index) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                itemCount: 5,
                itemSize: 15.r,
                direction: Axis.horizontal,
              ),
              Text(
                '${widget.totalNumberOfUserRating} Reviews',
                style: TextStyle(
                  color: Colors.grey, // Blue text
                  fontSize: 12.r, // Larger font size
                ),
              )
            ],
          ),
          const Gap(10),
          Column(
            children: [
              Row(
                children: [
                  const Text(
                    '5 Star',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Gap(10),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 0.0), // Invisible thumb
                      overlayShape: const RoundSliderOverlayShape(
                          overlayRadius: 0.0), // No overlay
                    ),
                    child: Slider(
                      // thumbColor: Colors.transparent,
                      value: rating5.toDouble(),
                      min: 0,
                      max: widget.totalNumberOfUserRating.toDouble(),
                      // More control over decimal precision
                      label: widget.totalNumberOfUserRating
                          .toDouble()
                          .toStringAsFixed(1),
                      onChanged: (double newRating) {},
                    ),
                  ),
                  const Gap(5),
                  Text(rating5.toString())
                ],
              ),
              Row(
                children: [
                  const Text(
                    '4 Star',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Gap(10),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 0.0), // Invisible thumb
                      overlayShape: const RoundSliderOverlayShape(
                          overlayRadius: 0.0), // No overlay
                    ),
                    child: Slider(
                      // thumbColor: Colors.transparent,
                      value: rating4.toDouble(),
                      min: 0,
                      max: 40,
                      // More control over decimal precision
                      label: widget.totalNumberOfUserRating
                          .toDouble()
                          .toStringAsFixed(1),
                      onChanged: (double newRating) {},
                    ),
                  ),
                  const Gap(5),
                  Text(rating4.toString())
                ],
              ),
              Row(
                children: [
                  const Text('3 Star', style: TextStyle(fontWeight: FontWeight.bold)),
                  const Gap(10),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 0.0), // Invisible thumb
                      overlayShape: const RoundSliderOverlayShape(
                          overlayRadius: 0.0), // No overlay
                    ),
                    child: Slider(
                      // thumbColor: Colors.transparent,
                      value: rating3.toDouble(),
                      min: 0,
                      max: widget.totalNumberOfUserRating.toDouble(),
                      // More control over decimal precision
                      label: widget.totalNumberOfUserRating
                          .toDouble()
                          .toStringAsFixed(1),
                      onChanged: (double newRating) {},
                    ),
                  ),
                  const Gap(5),
                  Text(rating3.toString())
                ],
              ),
              Row(
                children: [
                  const Text(
                    '2 Star',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Gap(10),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 0.0), // Invisible thumb
                      overlayShape: const RoundSliderOverlayShape(
                          overlayRadius: 0.0), // No overlay
                    ),
                    child: Slider(
                      // thumbColor: Colors.transparent,
                      value: rating2.toDouble(),
                      min: 0,
                      max: widget.totalNumberOfUserRating.toDouble(),
                      // More control over decimal precision
                      label: widget.totalNumberOfUserRating
                          .toDouble()
                          .toStringAsFixed(1),
                      onChanged: (double newRating) {},
                    ),
                  ),
                  const Gap(5),
                  Text(rating2.toString())
                ],
              ),
              Row(
                children: [
                  const Text(
                    '1 Star',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Gap(10),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 0.0), // Invisible thumb
                      overlayShape: const RoundSliderOverlayShape(
                          overlayRadius: 0.0), // No overlay
                    ),
                    child: Slider(
                      // thumbColor: Colors.transparent,
                      value: rating1.toDouble(),
                      min: 0,
                      max: widget.totalNumberOfUserRating.toDouble(),
                      // More control over decimal precision
                      label: widget.totalNumberOfUserRating
                          .toDouble()
                          .toStringAsFixed(1),
                      onChanged: (double newRating) {},
                    ),
                  ),
                  const Gap(5),
                  Text(rating1.toString())
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
