import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../model/user.dart';
part 'vendors_list_home_provider.g.dart';

@riverpod
Stream<List<UserModel>> getVendorsList(Ref ref) {
  return FirebaseFirestore.instance
      .collection('vendors')
      .limit(8)
      .snapshots()
      .map((e) {
    return e.docs.map((e) {
      return UserModel.fromMap(e.data(), e.id);
    }).toList();
  });
}

@riverpod
Stream<bool> getVendorOpenStatus(Ref ref, String vendorID) {
  return FirebaseFirestore.instance
      .collection('vendors')
      .doc(vendorID)
      .snapshots()
      .map((e) {
    if (!e.exists) {
      Logger().e("Vendor document with ID $vendorID does not exist.");
      return false; // or true, depending on your app logic
    }

    final isOpened = e.data()?['isOpened'];

    if (isOpened == null) {
      Logger().w("Field 'isOpened' is missing in vendor document $vendorID.");
      return false;
    }

    Logger().d('vendor open status is $isOpened');
    return isOpened;
  });
}


@riverpod
Stream<List<UserModel>> vendorsStreamNotification(Ref ref) {
  return FirebaseFirestore.instance.collection('vendors').snapshots().map(
      (snapshot) =>
          snapshot.docs.map((e) => UserModel.fromMap(e.data(), e.id)).toList());
}

@riverpod
Stream<List<UserModel>> getVendorsByCityList(Ref ref, String city) {
  return FirebaseFirestore.instance
      .collection('vendors')
      .where('city', isEqualTo: city)
      .snapshots()
      .map((e) {
    return e.docs.map((e) {
      return UserModel.fromMap(e.data(), e.id);
    }).toList();
  });
}

@riverpod
Stream<List<UserModel>> getFavoriteVendorsList(Ref ref) {
  final userId = FirebaseAuth.instance.currentUser?.uid;

  if (userId == null) {
    return Stream.value([]);
  }

  final favoritesStream = FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('favorites')
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => doc.id).toList());

  return favoritesStream.asyncMap((favoriteIds) async {
    if (favoriteIds.isEmpty) {
      return [];
    }

    final vendorsSnapshot = await FirebaseFirestore.instance
        .collection('vendors')
        .where(FieldPath.documentId, whereIn: favoriteIds)
        .get();

    return vendorsSnapshot.docs
        .map((doc) => UserModel.fromMap(doc.data(), doc.id))
        .toList();
  });
}
