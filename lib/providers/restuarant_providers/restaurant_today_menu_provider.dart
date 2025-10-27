import 'dart:developer';

import 'package:flutter/material.dart' show TimeOfDay;
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:googleapis/authorizedbuyersmarketplace/v1.dart' as abm;
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_web/model/today_menu_model.dart';
import '../../model/products_model.dart';
import '../addresses_page_provider.dart';

part 'restaurant_today_menu_provider.g.dart';

// @riverpod
// Stream<List<TodayMenuModel>> todayMenuStreamRestaurant(Ref ref) {
//   return FirebaseFirestore.instance
//       .collection('Today menu dev')
//       .where('module', isEqualTo: 'Restaurant')
//       .snapshots()
//       .map((snapshot) {
//     if (snapshot.docs.isEmpty) {
//       return [];
//     } else {
//       final products = snapshot.docs.map((doc) {
//         return TodayMenuModel.fromMap(doc.data(), doc.id);
//       }).toList();
//
//       // Sort the list by timeCreated
//       products.sort(
//               (a, b) => b.timeCreated.compareTo(a.timeCreated)); // Descending order
//       // Or for ascending order:
//       // products.sort((a, b) => a.timeCreated.compareTo(b.timeCreated));
//
//       return products;
//     }
//   });
// }


// TimeOfDay _parseTimeOfDay(String timeString) {
//   final format = DateFormat.jm(); // Example: 1:30 PM
//   final DateTime dateTime = format.parse(timeString);
//   return TimeOfDay(hours: dateTime.hour, minutes: dateTime.minute);
// }
//
// DateTime _combineDateTime(DateTime date, TimeOfDay time) {
//   final hour = time.hours;
//   final minute = time.minutes;
//   return DateTime(date.year, date.month, date.day, hour!, minute!);
// }
//
//
// @riverpod
// Stream<List<TodayMenuModel>> todayMenuStreamRestaurant(Ref ref) {
//   return FirebaseFirestore.instance
//       .collection('Today menu')
//       .where('module', isEqualTo: 'Restaurant')
//       .snapshots()
//       .map((snapshot) {
//     final now = DateTime.now();
//
//     final products = snapshot.docs.map((doc) {
//       final data = doc.data();
//       final model = TodayMenuModel.fromMap(data, doc.id);
//
//       try {
//         // Firestore Timestamp to DateTime
//         final DateTime startDate = (data['startDate'] as Timestamp).toDate();
//         final DateTime endDate = (data['endDate'] as Timestamp).toDate();
//
//         // Parse validFrom and validTo (e.g., "1:50 PM") to TimeOfDay
//         final validFrom = _parseTimeOfDay(data['validFrom']);
//         final validTo = _parseTimeOfDay(data['validTo']);
//
//         // Combine date + time
//         final startDateTime = _combineDateTime(startDate, validFrom);
//         final endDateTime = _combineDateTime(endDate, validTo);
//
//         if (now.isAfter(startDateTime) && now.isBefore(endDateTime)) {
//           return model; // Only return valid items
//         } else {
//           return null; // Exclude invalid items
//         }
//       } catch (e) {
//         return null;
//       }
//     }).whereType<TodayMenuModel>().toList();
//
//     // Optional: sort by timeCreated descending
//     products.sort((a, b) => b.timeCreated.compareTo(a.timeCreated));
//     return products;
//   });
// }


@riverpod
Stream<List<TodayMenuModel>> todayMenuStreamRestaurant(Ref ref) {
  return FirebaseFirestore.instance
      .collection('Today menu')
      .where('module', isEqualTo: 'Restaurant')
      .snapshots()
      .map((snapshot) {
    final now = DateTime.now(); // Use device local time
    final List<TodayMenuModel> validMenus = [];

    for (final doc in snapshot.docs) {
      try {
        final data = doc.data();
        final model = TodayMenuModel.fromMap(data, doc.id);

        final Timestamp startStamp = data['startDate'] as Timestamp;
        final Timestamp endStamp = data['endDate'] as Timestamp;
        final DateTime startDate = startStamp.toDate(); // Local device time
        final DateTime endDate = endStamp.toDate(); // Local device time

        final TimeOfDay validFrom = _parseTimeString(data['validFrom']);
        final TimeOfDay validTo = _parseTimeString(data['validTo']);

        // Create DateTime objects using device's local time
        final DateTime startDateTime = DateTime(
          startDate.year,
          startDate.month,
          startDate.day,
          validFrom.hour,
          validFrom.minute,
        );

        final DateTime endDateTime = DateTime(
          endDate.year,
          endDate.month,
          endDate.day,
          validTo.hour,
          validTo.minute,
        );

        if (now.isAfter(startDateTime) && now.isBefore(endDateTime)) {
          validMenus.add(model);
        }
      } catch (e, stack) {
        log('Error processing menu ${doc.id}', error: e, stackTrace: stack);
      }
    }

    validMenus.sort((a, b) => b.timeCreated.compareTo(a.timeCreated));
    return validMenus;
  });
}


// Robust time parsing
TimeOfDay _parseTimeString(String time) {
  final regExp = RegExp(r'(\d{1,2}):(\d{2})\s*(AM|PM)?', caseSensitive: false);
  final match = regExp.firstMatch(time);

  if (match != null) {
    int hours = int.parse(match.group(1)!);
    final minutes = int.parse(match.group(2)!);
    final period = match.group(3)?.toLowerCase();

    // Convert 12-hour to 24-hour
    if (period == 'pm' && hours < 12) hours += 12;
    if (period == 'am' && hours == 12) hours = 0;

    return TimeOfDay(hour: hours, minute: minutes);
  }
  return const TimeOfDay(hour: 0, minute: 0); // Fallback
}




