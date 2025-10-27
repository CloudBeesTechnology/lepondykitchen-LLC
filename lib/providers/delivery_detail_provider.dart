import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/delivery_detail_model.dart';
part 'delivery_detail_provider.g.dart';
  var logger = Logger();
@riverpod
class DeliveryDetailsNotifier extends _$DeliveryDetailsNotifier {
  @override
  Stream<DeliveryDetails?> build() {
    return getDeliveryDetails();
  }


  Stream<DeliveryDetails?> getDeliveryDetails() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .snapshots()
        .map((e) {
      final data = e.data()!;
      return DeliveryDetails(
        deliveryAddress: data['DeliveryAddress'],
        houseNumber: data['HouseNumber'],
        closestBusStop: data['ClosestBustStop'],
      );
    });
  }
}
