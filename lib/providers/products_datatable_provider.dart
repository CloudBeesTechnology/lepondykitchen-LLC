import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_web/model/products_model.dart';
part 'products_datatable_provider.g.dart';
 bool isLoading = false;
 
@riverpod
class ProductsNotifier extends _$ProductsNotifier {
  @override
  List<ProductsModel> build() {
    _getProducts();
    return [];
  }



  void _getProducts() {
    isLoading = true;
    FirebaseFirestore.instance
        .collection('Products')
        .snapshots()
        .listen((event) {
      var logger = Logger();
      isLoading = false;
      logger.d("Logger is working!");
      state =
          event.docs.map((doc) => ProductsModel.fromMap(doc, doc.id)).toList();
    });
  }


 
}



@riverpod
Future<List<String>> getCategories( Ref ref) async {
  final snapshot =
      await FirebaseFirestore.instance.collection('Categories').get();
  return snapshot.docs.map((e) => e.data()['category'] as String).toList();
}

@riverpod
Future<List<String>> getSubCollections(
   Ref ref, String category, String collection) async {
  final snapshot = await FirebaseFirestore.instance
      .collection('Sub Collections')
      .where('category', isEqualTo: category)
      .where('collection', isEqualTo: collection)
      .get();
  return snapshot.docs.map((e) => e.data()['subCollection'] as String).toList();
}

@riverpod
Future<List<String>> getCollections(
    Ref ref, String category) async {
  final snapshot = await FirebaseFirestore.instance
      .collection('Collections')
      .where('category', isEqualTo: category)
      .get();
  return snapshot.docs.map((e) => e.data()['collection'] as String).toList();
}

@riverpod
Future<List<String>> getBrands( Ref ref) async {
  final snapshot = await FirebaseFirestore.instance
      .collection('Brands')
      // .where('category', isEqualTo: category)
      .get();
  return snapshot.docs.map((e) => e.data()['collection'] as String).toList();
}
