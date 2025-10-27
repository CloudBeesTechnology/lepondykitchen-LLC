import 'package:cloud_firestore/cloud_firestore.dart';

class CouponModel {
  final String coupon;
  final num percentage;
  final dynamic timeCreated;
  final String? title;
  final String uid;
  final DateTime? validFrom;
  final DateTime? validTo;

  CouponModel({
    required this.coupon,
    required this.uid,
    required this.percentage,
    this.timeCreated,
    this.title,
    this.validFrom,
    this.validTo,
  });

  CouponModel.fromMap(Map<String, dynamic> data, this.uid)
      : coupon = data['coupon'],
        percentage = data['percentage'],
        title = data['title'],
        timeCreated = data['timeCreated'],
        validFrom = data.containsKey('validFrom') && data['validFrom'] != null
            ? (data['validFrom'] as Timestamp).toDate()
            : null,
        validTo = data.containsKey('validTo') && data['validTo'] != null
            ? (data['validTo'] as Timestamp).toDate()
            : null;

  Map<String, dynamic> toMap() {
    return {
      'coupon': coupon,
      'percentage': percentage,
      'timeCreated': timeCreated,
      'title': title,
      'validFrom': validFrom,
      'validTo': validTo,
    };
  }
}
