
import 'package:cloud_firestore/cloud_firestore.dart';
class UserModel {
  final String phonenumber;
  final String uid;
  final String email;
  final String displayName;
  final String token;
  final String referralCode;
  final String photoUrl;
  final String? address;
  final String? module;
  final num? totalNumberOfUserRating;
  final num? totalRating;
  final DateTime? timeCreated;
  final bool? isOpened;

  UserModel({
    this.module,
    this.timeCreated,
    this.isOpened,
    required this.email,
    this.totalRating,
    this.totalNumberOfUserRating,
    required this.displayName,
    this.address,
    required this.photoUrl,
    required this.uid,
    required this.token,
    required this.phonenumber,
    required this.referralCode,
  });

  UserModel.fromMap(Map<String, dynamic> data, this.uid)
      : displayName = data['fullname'],
        isOpened = data['isOpened'],
        module = data['module'],
        timeCreated = data['timeCreated'] != null ? (data['timeCreated'] as Timestamp).toDate() : null,
        totalRating = data['totalRating'],
        totalNumberOfUserRating = data['totalNumberOfUserRating'],
        email = data['email'],
        address = data['address'],
        photoUrl = data['photoUrl'],
        referralCode = data['personalReferralCode'],
        token = data['tokenID'],
        phonenumber = data['phone'];

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      email: json['email'],
      displayName: json['displayName'],
      phonenumber: json['phonenumber'],
      token: json['token'],
      referralCode: json['referralCode'],
      photoUrl: json['photoUrl'],
      address: json['address'],
      module: json['module'],
      totalNumberOfUserRating: json['totalNumberOfUserRating'],
      totalRating: json['totalRating'],
      timeCreated: json['timeCreated'] != null
          ? DateTime.parse(json['timeCreated'])
          : null,
      isOpened: json['isOpened'],
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'phonenumber': phonenumber,
      'token': token,
      'referralCode': referralCode,
      'photoUrl': photoUrl,
      'address': address,
      'module': module,
      'totalNumberOfUserRating': totalNumberOfUserRating,
      'totalRating': totalRating,
      'timeCreated': timeCreated?.toIso8601String(),
      'isOpened': isOpened,
    };
  }
}
