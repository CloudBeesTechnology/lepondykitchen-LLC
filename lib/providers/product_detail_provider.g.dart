// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_detail_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$productDetailProviderHash() =>
    r'ac3d2cf07c99304e340460d22e291241408c823c';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$ProductDetailProvider
    extends BuildlessAutoDisposeAsyncNotifier<ProductsModel?> {
  late final String productID;

  FutureOr<ProductsModel?> build(
    String productID,
  );
}

/// See also [ProductDetailProvider].
@ProviderFor(ProductDetailProvider)
const productDetailProviderProvider = ProductDetailProviderFamily();

/// See also [ProductDetailProvider].
class ProductDetailProviderFamily extends Family<AsyncValue<ProductsModel?>> {
  /// See also [ProductDetailProvider].
  const ProductDetailProviderFamily();

  /// See also [ProductDetailProvider].
  ProductDetailProviderProvider call(
    String productID,
  ) {
    return ProductDetailProviderProvider(
      productID,
    );
  }

  @override
  ProductDetailProviderProvider getProviderOverride(
    covariant ProductDetailProviderProvider provider,
  ) {
    return call(
      provider.productID,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'productDetailProviderProvider';
}

/// See also [ProductDetailProvider].
class ProductDetailProviderProvider
    extends AutoDisposeAsyncNotifierProviderImpl<ProductDetailProvider,
        ProductsModel?> {
  /// See also [ProductDetailProvider].
  ProductDetailProviderProvider(
    String productID,
  ) : this._internal(
          () => ProductDetailProvider()..productID = productID,
          from: productDetailProviderProvider,
          name: r'productDetailProviderProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$productDetailProviderHash,
          dependencies: ProductDetailProviderFamily._dependencies,
          allTransitiveDependencies:
              ProductDetailProviderFamily._allTransitiveDependencies,
          productID: productID,
        );

  ProductDetailProviderProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.productID,
  }) : super.internal();

  final String productID;

  @override
  FutureOr<ProductsModel?> runNotifierBuild(
    covariant ProductDetailProvider notifier,
  ) {
    return notifier.build(
      productID,
    );
  }

  @override
  Override overrideWith(ProductDetailProvider Function() create) {
    return ProviderOverride(
      origin: this,
      override: ProductDetailProviderProvider._internal(
        () => create()..productID = productID,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        productID: productID,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<ProductDetailProvider, ProductsModel?>
      createElement() {
    return _ProductDetailProviderProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductDetailProviderProvider &&
        other.productID == productID;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, productID.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ProductDetailProviderRef
    on AutoDisposeAsyncNotifierProviderRef<ProductsModel?> {
  /// The parameter `productID` of this provider.
  String get productID;
}

class _ProductDetailProviderProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<ProductDetailProvider,
        ProductsModel?> with ProductDetailProviderRef {
  _ProductDetailProviderProviderElement(super.provider);

  @override
  String get productID => (origin as ProductDetailProviderProvider).productID;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
