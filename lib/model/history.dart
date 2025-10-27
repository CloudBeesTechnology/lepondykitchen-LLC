import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryModel {
  final String message;
  final String amount;
  final String paymentSystem;
  final String? uid;
  final DateTime timeCreated;

  HistoryModel({
    required this.message,
    required this.amount,
    required this.paymentSystem,
    required this.timeCreated,
    this.uid,
  });

  // Factory constructor to create a HistoryModel from a Firestore document
  factory HistoryModel.fromMap(Map<String, dynamic> data, String? uid) {
    return HistoryModel(
      message: data['message'],
      amount: data['amount'],
      paymentSystem: data['paymentSystem'],
      timeCreated: (data['timeCreated'] as Timestamp)
          .toDate(), // Convert Timestamp to DateTime
      uid: uid,
    );
  }

  // Converts a HistoryModel instance to a map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'amount': amount,
      'paymentSystem': paymentSystem,
      'timeCreated':
          Timestamp.fromDate(timeCreated), // Convert DateTime to Timestamp
    };
  }
}
