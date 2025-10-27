import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'legal_page_provider.g.dart';

@riverpod
Future<dynamic> getAboutUsDetails( Ref ref) async {
  var value = await FirebaseFirestore.instance
      .collection('About us')
      .doc('About us')
      .get();
  return value['About us'];
}

@riverpod
Future<dynamic> getPrivacyPolicyDetails( Ref ref) async {
  var value = await FirebaseFirestore.instance
      .collection('Privacy Policy')
      .doc('Privacy Policy')
      .get();
  return value['Privacy Policy'];
}
@riverpod
Future<dynamic> getFAQDetails(Ref ref) async {
  var value = await FirebaseFirestore.instance
      .collection('FAQ')
      .doc('FAQ')
      .get();
  return value['FAQ'];
}
@riverpod
Future<dynamic> getTermsAndConditionsDetails(
  Ref ref) async {
  var value = await FirebaseFirestore.instance
      .collection('Terms & Conditions')
      .doc('Terms & Conditions')
      .get();
  return value['Terms & Conditions'];
}
