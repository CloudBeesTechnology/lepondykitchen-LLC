import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/products_model.dart';

part 'restaurant_brands_page_provider.g.dart';

@riverpod
class BrandPageRestaurantNotifier extends _$BrandPageRestaurantNotifier {
  @override
  BrandPageRestaurantState build(String category) {
    state = BrandPageRestaurantState(
      category: '',
      imageUrl: '',
      products: [],
      initProducts: [],
      isLoaded: false,
      currency: '',
    );

    getCateRestaurant(category);
    getProductsRestaurant();
    return state;
  }

  Future<void> getCateRestaurant(String category) async {
    state = state.copyWith(isLoaded: true);
    final snapshot = await FirebaseFirestore.instance
        .collection('Brands')
        .where('collection', isEqualTo: category)
        .where('module', isEqualTo: 'Restaurant')
        .get();

    if (snapshot.docs.isNotEmpty) {
      final doc = snapshot.docs.first;
      state = state.copyWith(
        category: doc['category'],
        imageUrl: doc['backgroundImage'],
        isLoaded: false,
      );
    }
  }

  Future<void> getProductsRestaurant() async {
    state = state.copyWith(isLoaded: true);
    FirebaseFirestore.instance
        .collection('Products')
        .where('brand', isEqualTo: category)
        .where('module', isEqualTo: 'Restaurant')
        .snapshots()
        .listen((event) {
      final products =
          event.docs.map((e) => ProductsModel.fromMap(e, e.id)).toList();
      state = state.copyWith(
        products: products,
        initProducts: products,
        isLoaded: false,
      );
    });
  }

  Future<void> getCurrency() async {
    final doc = await FirebaseFirestore.instance
        .collection('Currency Settings')
        .doc('Currency Settings')
        .get();
    state = state.copyWith(currency: doc['Currency symbol']);
  }

  void resetToInitialList() {
    state = state.copyWith(products: state.initProducts);
  }

  void sortProductsFromLowToHigh() {
    final sortedProducts = List<ProductsModel>.from(state.products)
      ..sort((a, b) => a.unitPrice1!.compareTo(b.unitPrice1!));
    state = state.copyWith(products: sortedProducts);
  }

  void sortProductsFromHighToLow() {
    final sortedProducts = List<ProductsModel>.from(state.products)
      ..sort((a, b) => b.unitPrice1!.compareTo(a.unitPrice1!));
    state = state.copyWith(products: sortedProducts);
  }

  void sortProductsRatingFromHighToLow() {
    final sortedProducts = List<ProductsModel>.from(state.products)
      ..sort((a, b) =>
          b.totalNumberOfUserRating!.compareTo(a.totalNumberOfUserRating!));
    state = state.copyWith(products: sortedProducts);
  }

  void sortProductsByPriceRange(int minPrice, int maxPrice) {
    final filteredProducts = state.products
        .where((product) =>
            product.unitPrice1! >= minPrice && product.unitPrice1! <= maxPrice)
        .toList()
      ..sort((a, b) => a.unitPrice1!.compareTo(b.unitPrice1!));
    state = state.copyWith(products: filteredProducts);
  }

  void sortAndFilterProductsByRating(double minRating) {
    final filteredAndSortedProducts = state.products.where((product) {
      double ratio = product.totalRating! / product.totalNumberOfUserRating!;
      return ratio >= minRating;
    }).toList()
      ..sort((a, b) {
        double ratioA = a.totalRating! / a.totalNumberOfUserRating!;
        double ratioB = b.totalRating! / b.totalNumberOfUserRating!;
        return ratioB.compareTo(ratioA);
      });
    state = state.copyWith(products: filteredAndSortedProducts);
  }
}

class BrandPageRestaurantState {
  final String category;
  final String imageUrl;
  final List<ProductsModel> products;
  final List<ProductsModel> initProducts;
  final bool isLoaded;
  final String currency;

  BrandPageRestaurantState({
    required this.category,
    required this.imageUrl,
    required this.products,
    required this.initProducts,
    required this.isLoaded,
    required this.currency,
  });

  BrandPageRestaurantState copyWith({
    String? category,
    String? imageUrl,
    List<ProductsModel>? products,
    List<ProductsModel>? initProducts,
    bool? isLoaded,
    String? currency,
  }) {
    return BrandPageRestaurantState(
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      products: products ?? this.products,
      initProducts: initProducts ?? this.initProducts,
      isLoaded: isLoaded ?? this.isLoaded,
      currency: currency ?? this.currency,
    );
  }
}


// Assume ProductsModel is defined elsewhere in your project