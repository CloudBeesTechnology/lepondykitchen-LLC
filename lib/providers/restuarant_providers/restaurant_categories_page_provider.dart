import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_web/model/sub_categories_model.dart';
import '../../model/products_model.dart';
import '../selected_provider.dart';
part 'restaurant_categories_page_provider.g.dart';

@riverpod
class CategoriesPageRestaurantNotifier extends _$CategoriesPageRestaurantNotifier {
  @override
  BrandPageState build(String category) {
    final module = ref.watch(selectedVendorModuleProvider) ?? 'Restaurant';
    state = BrandPageState(
      collection: [],
      imageUrl: '',
      products: [],
      initProducts: [],
      isLoaded: false,
      currency: '',
    );

    getCateRestaurant(category,module);
    getProductsRestaurant(module);
    getSubCollectionsRestaurant(module);
    return state;
  }

  Future<void> getCateRestaurant(String category,String module) async {
    state = state.copyWith(isLoaded: true);
    final snapshot = await FirebaseFirestore.instance
        .collection('Categories')
        .where('module', isEqualTo: module)
        .where('category', isEqualTo: category)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final doc = snapshot.docs.first;
      state = state.copyWith(
        // category: doc['category'],
        imageUrl: doc['image'],
        isLoaded: false,
      );
    }
  }

  Future<void> getProductsRestaurant(String module) async {
    state = state.copyWith(isLoaded: true);
    FirebaseFirestore.instance
        .collection('Products')
        .where('module', isEqualTo: module)
        .where('category', isEqualTo: category)
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

  Future<void> getSubCollectionsRestaurant(String module) async {
    FirebaseFirestore.instance
        .collection('Collections')
        .where('module', isEqualTo: module)
        // .orderBy('index')
        .where('category', isEqualTo: category)
        .snapshots()
        .listen((value) {
      var fetchServices =
          value.docs.map((e) => SubCategoriesModel.fromMap(e, e.id)).toList();
      state = state.copyWith(collection: fetchServices);
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

class BrandPageState {
  final List<SubCategoriesModel> collection;
  final String imageUrl;
  final List<ProductsModel> products;
  final List<ProductsModel> initProducts;
  final bool isLoaded;
  final String currency;

  BrandPageState({
    required this.collection,
    required this.imageUrl,
    required this.products,
    required this.initProducts,
    required this.isLoaded,
    required this.currency,
  });

  BrandPageState copyWith({
    List<SubCategoriesModel>? collection,
    String? imageUrl,
    List<ProductsModel>? products,
    List<ProductsModel>? initProducts,
    bool? isLoaded,
    String? currency,
  }) {
    return BrandPageState(
      collection: collection ?? this.collection,
      imageUrl: imageUrl ?? this.imageUrl,
      products: products ?? this.products,
      initProducts: initProducts ?? this.initProducts,
      isLoaded: isLoaded ?? this.isLoaded,
      currency: currency ?? this.currency,
    );
  }
}


// Assume ProductsModel is defined elsewhere in your project