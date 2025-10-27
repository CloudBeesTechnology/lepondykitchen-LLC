import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_web/model/feeds.dart';
part 'restaurant_banner_provider.g.dart';

@riverpod
Future<List<FeedsModel>> restaurantfetchBanners( Ref ref) {
  return FirebaseFirestore.instance
      .collection('Banners').where('module',isEqualTo: 'Restaurant')
      .get()
      .then((snapshot) {
    return snapshot.docs.map((doc) {
      return FeedsModel.fromMap(doc.data(), doc.id);
    }).toList();
  });
}
