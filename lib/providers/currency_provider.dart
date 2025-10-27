import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'currency_provider.g.dart';

@riverpod
Future<String> currencySymbol(Ref ref) async {
  final doc = await FirebaseFirestore.instance
      .collection('Currency Settings')
      .doc('Currency Settings')
      .get();
  return doc['Currency symbol'];
}