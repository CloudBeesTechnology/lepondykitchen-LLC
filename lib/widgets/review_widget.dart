import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logger/logger.dart';
import 'package:user_web/model/rating.dart';
import 'package:user_web/constant.dart';

import 'rating_summary_mobile.dart';
import 'rating_summary_web.dart';

class ReviewWidget extends StatefulWidget {
  final String productUID;
  final num totalNumberOfUserRating;
  final num totalRating;
  final String collection;
  const ReviewWidget(
      {super.key,
      required this.productUID,
      required this.totalNumberOfUserRating,
      required this.totalRating,
      required this.collection});

  @override
  State<ReviewWidget> createState() => _ReviewWidgetState();
}

class _ReviewWidgetState extends State<ReviewWidget> {
  bool ratingStatus = true;
  List<RatingModel> ratings = [];
  var logger = Logger();

  Future<List<RatingModel>> getRating() {
    return FirebaseFirestore.instance
        .collection(widget.collection)
        .doc(widget.productUID)
        .collection('Ratings')
        .get()
        .then((event) {
      if (event.docs.isNotEmpty) {
        setState(() {
          ratingStatus = true;
        });
      } else {
        setState(() {
          ratingStatus = false;
        });
      }
      ratings.clear();
      for (var e in event.docs) {
        var r = RatingModel.fromMap(e.data(), e.id);
        ratings.add(r);
        logger.d('Ratings are $ratings');
      }
      return event.docs
          .map((e) => RatingModel.fromMap(e.data(), e.id))
          .toList();
    });
  }

  @override
  void initState() {
    getRating();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.totalRating != 0 &&
            ratings.isNotEmpty &&
            MediaQuery.of(context).size.width >= 1100)
          RatingSummaryWeb(
            ratings: ratings,
            totalRating: widget.totalRating,
            totalNumberOfUserRating: widget.totalNumberOfUserRating,
          ),
        if (widget.totalRating != 0 &&
            ratings.isNotEmpty &&
            MediaQuery.of(context).size.width <= 1100)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RatingSummaryMobile(
              ratings: ratings,
              totalRating: widget.totalRating,
              totalNumberOfUserRating: widget.totalNumberOfUserRating,
            ),
          ),
        if (widget.totalRating != 0)
          const Divider(
            color: Color.fromARGB(255, 202, 199, 199),
          ),
        FutureBuilder<List<RatingModel>>(
            future: getRating(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ratingStatus == false
                    ? SizedBox(
                        width: double.infinity,
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: const Text(
                                    'No review has been made on this product')
                                .tr()),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              RatingModel ratingModel = snapshot.data![index];
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                    leading: Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: appColor),
                                      child: Center(
                                        child: Text(
                                          ratingModel.fullname[0],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20.r),
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      ratingModel.fullname,
                                      style: TextStyle(fontSize: 14.r),
                                    ),
                                    subtitle: RatingBarIndicator(
                                      rating: ratingModel.rating.toDouble(),
                                      itemBuilder: (context, index) => Icon(
                                        Icons.star,
                                        color: appColor,
                                      ),
                                      itemCount: 5,
                                      itemSize: 15,
                                      direction: Axis.horizontal,
                                    ),
                                    trailing: Text(ratingModel.timeCreated),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20),
                                    child: Text(
                                      ratingModel.review,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(fontSize: 12.r),
                                    ),
                                  ),
                                ],
                              );
                            }),
                      );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
      ],
    );
  }
}
