import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/products_model.dart';
part 'restaurant_new_arrival_provider.g.dart';

@riverpod
Stream<List<ProductsModel>> newArrivalStreamRestaurant(Ref ref,String module) {
  return FirebaseFirestore.instance
      .collection('Products')
      .where('module', isEqualTo:module)
      .limit(7)
      .snapshots()
      .map((snapshot) {
    if (snapshot.docs.isEmpty) {
      return [];
    } else {
      final products = snapshot.docs.map((doc) {
        return ProductsModel.fromMap(doc.data(), doc.id);
      }).toList();

      // Sort the list by timeCreated
      products.sort(
          (a, b) => b.timeCreated.compareTo(a.timeCreated)); // Descending order
      // Or for ascending order:
      // products.sort((a, b) => a.timeCreated.compareTo(b.timeCreated));

      return products;
    }
  });
}
