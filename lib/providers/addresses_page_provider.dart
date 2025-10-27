import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:loader_overlay/loader_overlay.dart';
import 'package:logger/logger.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/address.dart';
part 'addresses_page_provider.g.dart';

var logger = Logger();
@riverpod
Stream<List<AddressModel>> getDeliveryAddresses(Ref ref) {
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? user = auth.currentUser;
  // context.loaderOverlay.show();
  return FirebaseFirestore.instance
      .collection('users')
      .doc(user!.uid)
      .collection('DeliveryAddress')
      .snapshots()
      .map((e) {
    // if (context.mounted) {
    //   context.loaderOverlay.hide();
    // }
    return e.docs.map((e) {
      logger.d('addresses are $e');

      return AddressModel.fromMap(e.data(), e.id);
    }).toList();
  });
}


@riverpod
Stream<String> getUserDeliveryAddressID(Ref ref) {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  User? user = auth.currentUser;

  return firestore.collection('users').doc(user!.uid).snapshots().map((value) {
    return (value.data()?['DeliveryAddressID'] ?? '').toString();
  });
}

