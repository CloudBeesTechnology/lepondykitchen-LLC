import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'socials_provider.g.dart';

@riverpod
Future<String> getFacebookDetails(Ref ref) async {
  var doc = await FirebaseFirestore.instance
      .collection('Social Details')
      .doc('facebook')
      .get();
  return doc['facebook'];
}

@riverpod
Future<String> getInstagramDetails(Ref ref) async {
  var value = await FirebaseFirestore.instance
      .collection('Social Details')
      .doc('instagram')
      .get();
  return value['instagram'];
}

@riverpod
Future<String> getTwitterDetails(Ref ref) async {
  var value = await FirebaseFirestore.instance
      .collection('Social Details')
      .doc('twitter')
      .get();
  return value['twitter'];
}
