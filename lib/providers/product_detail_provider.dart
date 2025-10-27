import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_web/model/products_model.dart';

part 'product_detail_provider.g.dart';

var logger = Logger();

@riverpod
class ProductDetailProvider extends _$ProductDetailProvider {
  @override
  Future<ProductsModel?> build(String productID) {
    return getProductDetail(productID);
  }

  Future<ProductsModel?> getProductDetail(
      String productID) async {
    try {
    

      // Try fetching from the 'Products' collection
      var prod = await FirebaseFirestore.instance
          .collection('Products')
          .doc(productID)
          .get();

      if (prod.exists) {
        return ProductsModel.fromMap(prod.data(), prod.id);
      }

      // Try fetching from the 'Flash Sales' collection
      var flashSales = await FirebaseFirestore.instance
          .collection('Flash Sales')
          .doc(productID)
          .get();

      if (flashSales.exists) {
        return ProductsModel.fromMap(flashSales.data(), flashSales.id);
      }

      // Try fetching from the 'Hot Deals' collection
      var hotDeals = await FirebaseFirestore.instance
          .collection('Hot Deals')
          .doc(productID)
          .get();

      if (hotDeals.exists) {
        return ProductsModel.fromMap(hotDeals.data(), hotDeals.id);
      }

      // If the product is not found in any collection, return null or throw an exception
      return null;
    } catch (e) {
      // Handle any errors that might occur
      logger.d('Error fetching product details: $e');
      return null;
    } finally {
      // if (context.mounted) {
      //   context.loaderOverlay
      //       .hide(); // Hide the loader overlay after completion
      // }
    }
  }
}
