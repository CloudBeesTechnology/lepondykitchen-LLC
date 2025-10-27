import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_web/model/products_model.dart';
part 'restaurant_hot_deal_datatable.g.dart';

@riverpod
Stream<List<ProductsModel>> hotDealsStreamRestaurant(Ref ref) {
  return FirebaseFirestore.instance
      .collection('Hot Deals')
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
