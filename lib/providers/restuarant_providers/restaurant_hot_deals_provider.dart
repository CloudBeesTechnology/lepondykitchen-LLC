import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/products_model.dart';
part 'restaurant_hot_deals_provider.g.dart';

@riverpod
Stream<List<ProductsModel>> hotDealStreamRestaurant(Ref ref) {
  return FirebaseFirestore.instance
      .collection('Hot Deals')
      .where('module', isEqualTo: 'Restaurant')
      .limit(7)
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
Stream<List<ProductsModel>> hotDealStreamRestaurantByVendor(
    Ref ref, String venodorId) {
  return FirebaseFirestore.instance
      .collection('Hot Deals')
      .where('vendorId', isEqualTo: venodorId)
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
Stream<List<ProductsModel>> flashSalesStreamRestaurantByVendor(
    Ref ref, String venodorId) {
  return FirebaseFirestore.instance
      .collection('Flash Sales')
      .where('vendorId', isEqualTo: venodorId)
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
Stream<List<ProductsModel>> hotDealPageStreamRestaurant(Ref ref) {
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
