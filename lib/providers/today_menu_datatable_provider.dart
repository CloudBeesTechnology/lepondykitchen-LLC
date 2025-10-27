// ignore_for_file: avoid_build_context_in_providers

import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../model/today_menu_model.dart';
part 'today_menu_datatable_provider.g.dart';

bool isLoading = false;

@riverpod
class TodayMenuNotifier extends _$TodayMenuNotifier {
  @override
  List<TodayMenuModel> build() {
    _getProducts();
    return [];
  }

  void _getProducts() {
    isLoading = true;
    FirebaseFirestore.instance
        .collection('Today menu')
        .snapshots()
        .listen((event) {
      var logger = Logger();
      isLoading = false;
      logger.d("Logger is working!");
      var state =
      event.docs.map((doc) => TodayMenuModel.fromMap(doc, doc.id)).toList();
    });
  }


}

@riverpod
Future<List<String>> getCategories(Ref ref, String module) async {
  final snapshot = await FirebaseFirestore.instance
      .collection('Categories')
      .where('module', isEqualTo: module)
      .get();
  return snapshot.docs.map((e) => e.data()['category'] as String).toList();
}

@riverpod
Future<List<String>> getSubCollections(
    Ref ref, String category, String collection, String module) async {
  final snapshot = await FirebaseFirestore.instance
      .collection('Sub Collections')
      .where('category', isEqualTo: category)
      .where('collection', isEqualTo: collection)
      .where('module', isEqualTo: module)
      .get();
  return snapshot.docs.map((e) => e.data()['subCollection'] as String).toList();
}

@riverpod
Future<List<String>> getCollections(
    Ref ref, String category, String module) async {
  final snapshot = await FirebaseFirestore.instance
      .collection('Collections')
      .where('category', isEqualTo: category)
      .where('module', isEqualTo: module)
      .get();
  return snapshot.docs.map((e) => e.data()['collection'] as String).toList();
}

@riverpod
Future<List<String>> getBrands(Ref ref, String module) async {
  final snapshot = await FirebaseFirestore.instance
      .collection('Brands')
      .where('module', isEqualTo: module)
  // .where('category', isEqualTo: category)
      .get();
  return snapshot.docs.map((e) => e.data()['collection'] as String).toList();
}


