import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_web/model/cities_model.dart';
part 'cities_list_provider.g.dart';

@riverpod
Stream<List<CitiesModel>> getCitiesList(Ref ref) {
  return FirebaseFirestore.instance.collection('Cities').snapshots().map((e) {
    return e.docs.map((e) {
      return CitiesModel.fromMap(e.data(), e.id);
    }).toList();
  });
}
