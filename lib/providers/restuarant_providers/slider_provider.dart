import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_web/model/feeds.dart';
part 'slider_provider.g.dart';

@riverpod
Stream<List<FeedsModel>> feedsRestaurant(Ref ref) {
  return FirebaseFirestore.instance
      .collection('Sliders')
      .where('module', isEqualTo: 'Restaurant')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => FeedsModel(
                slider: doc['slider'],
                isBanner: false,
                category: doc['category'],
                title: doc['title'],
                detail: doc['detail'],
                subCategory: doc['sub-category'],
                image: doc['image'],
                subCategoryCollections: doc['sub-category-collections'],
              ))
          .toList());
}

@riverpod
Stream<List<FeedsModel>> bannersRestaurant(Ref ref) {
  return FirebaseFirestore.instance
      .collection('Banners')
      .where('module', isEqualTo: 'Restaurant')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => FeedsModel(
                slider: doc['slider'],
                isBanner: true,
                category: doc['category'],
                title: doc['title'],
                detail: doc['detail'],
                subCategory: doc['sub-category'],
                image: doc['image'],
                subCategoryCollections: doc['sub-category-collections'],
              ))
          .toList());
}

@riverpod
List<FeedsModel> allListRestaurant(Ref ref) {
  final feeds = ref.watch(feedsRestaurantProvider).value ?? [];
  final banners = ref.watch(bannersRestaurantProvider).value ?? [];
  List<FeedsModel> allList = [...feeds, ...banners];
  allList.shuffle(Random());
  return allList;
}
