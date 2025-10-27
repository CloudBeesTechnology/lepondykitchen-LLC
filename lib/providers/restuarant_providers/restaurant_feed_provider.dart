import 'package:riverpod/riverpod.dart';
import 'package:user_web/model/feeds.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'restaurant_feed_provider.g.dart';

@riverpod
class AllFeedsRestaurant extends _$AllFeedsRestaurant {
  @override
  FeedsModel build() {
    return FeedsModel(
        category: '',
        title: '',
        detail: '',
        subCategory: '',
        image: '',
        subCategoryCollections: '');
  }

  // @riverpod
  // Stream<List<FeedsModel>> feeds() {
  //   return FirebaseFirestore.instance.collection('Sliders').snapshots().map(
  //     (snapshot) {
  //       if (snapshot.docs.isEmpty) {
  //         return [];
  //       } else {
  //         return snapshot.docs.map((doc) {
  //           return FeedsModel.fromMap(doc.data(), doc.id);
  //         }).toList();
  //       }
  //     },
  //   );
  // }
}

@riverpod
Future<List<String>> getCategoriesForFeedsRestaurant(Ref ref) async {
  var cat = await FirebaseFirestore.instance
      .collection('Categories')
      .where('module', isEqualTo: 'Restaurant')
      .get();
  return cat.docs.map((doc) => doc['category'] as String).toList();
}

@riverpod
Future<List<String>> getSubCategoriesForFeedsRestaurant(
  Ref ref,
  String category,
) async {
  // if (category != '' && selected == true) {
  var sub = await FirebaseFirestore.instance
      .collection('Sub Categories')
      .where('module', isEqualTo: 'Restaurant')
      .where('category', isEqualTo: category)
      .get();
  return sub.docs.map((doc) => doc['name'] as String).toList();
}

@riverpod
Future<List<String>> getSubCategoriesCollectionsForFeedsRestaurant(
    Ref ref, String subcategory) async {
  var sub = await FirebaseFirestore.instance
      .collection('Sub categories collections')
      .where('module', isEqualTo: 'Restaurant')
      .where('sub-category', isEqualTo: subcategory)
      .get();
  return sub.docs.map((e) => e['name'] as String).toList();
}

@riverpod
Stream<List<FeedsModel>> getFeedsRestaurant(Ref ref) {
  return FirebaseFirestore.instance
      .collection('Sliders')
      .where('module', isEqualTo: 'Restaurant')
      .snapshots()
      .map(
    (snapshot) {
      if (snapshot.docs.isEmpty) {
        return [];
      } else {
        return snapshot.docs.map((doc) {
          return FeedsModel.fromMap(doc.data(), doc.id);
        }).toList();
      }
    },
  );
}
