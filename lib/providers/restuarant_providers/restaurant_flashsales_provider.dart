import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/products_model.dart';
part 'restaurant_flashsales_provider.g.dart';

@riverpod
Stream<List<ProductsModel>> flashsalesStreamRestaurant(Ref ref) {
  return FirebaseFirestore.instance
      .collection('Flash Sales')
      .where('module', isEqualTo: 'Restaurant')
      .limit(8)
      .snapshots()
      .map((snapshot) {
    if (snapshot.docs.isEmpty) {
      return [];
    } else {
      return snapshot.docs.map((doc) {
        return ProductsModel.fromMap(doc.data(), doc.id);
      }).toList();
    }
  });
}

@riverpod
Stream<List<ProductsModel>> flashsalesPageStreamRestaurant(Ref ref) {
  return FirebaseFirestore.instance
      .collection('Flash Sales')
      .where('module', isEqualTo: 'Restaurant')
      .snapshots()
      .map((snapshot) {
    if (snapshot.docs.isEmpty) {
      return [];
    } else {
      return snapshot.docs.map((doc) {
        return ProductsModel.fromMap(doc.data(), doc.id);
      }).toList();
    }
  });
}

@riverpod
Stream<String> flashSalesTimeStreamRestaurant(Ref ref) {
  return FirebaseFirestore.instance
      .collection('Flash Sales Time')
      .doc('Flash Sales Time')
      .snapshots()
      .map((doc) => doc.exists ? doc['Flash Sales Time'] : '');
}

@riverpod
Future<void> deleteFlashSalesCollectionRestaurant(Ref ref) async {
  FirebaseFirestore.instance
      .collection('Flash Sales Time')
      .doc('Flash Sales Time')
      .set({'Flash Sales Time': ''});
  final snapshot =
      await FirebaseFirestore.instance.collection('Flash Sales').get();
  for (final ds in snapshot.docs) {
    await ds.reference.delete();
  }
}
