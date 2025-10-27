// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'products_datatable_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getCategoriesHash() => r'4527e74ce45464c3f862a6771069d58ede519ae4';

/// See also [getCategories].
@ProviderFor(getCategories)
final getCategoriesProvider = AutoDisposeFutureProvider<List<String>>.internal(
  getCategories,
  name: r'getCategoriesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getCategoriesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetCategoriesRef = AutoDisposeFutureProviderRef<List<String>>;
String _$getSubCollectionsHash() => r'9f7a4d5cf329537472b34acaef88d5810e7b76f2';

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

/// See also [getSubCollections].
@ProviderFor(getSubCollections)
const getSubCollectionsProvider = GetSubCollectionsFamily();

/// See also [getSubCollections].
class GetSubCollectionsFamily extends Family<AsyncValue<List<String>>> {
  /// See also [getSubCollections].
  const GetSubCollectionsFamily();

  /// See also [getSubCollections].
  GetSubCollectionsProvider call(
    String category,
    String collection,
  ) {
    return GetSubCollectionsProvider(
      category,
      collection,
    );
  }

  @override
  GetSubCollectionsProvider getProviderOverride(
    covariant GetSubCollectionsProvider provider,
  ) {
    return call(
      provider.category,
      provider.collection,
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
  String? get name => r'getSubCollectionsProvider';
}

/// See also [getSubCollections].
class GetSubCollectionsProvider
    extends AutoDisposeFutureProvider<List<String>> {
  /// See also [getSubCollections].
  GetSubCollectionsProvider(
    String category,
    String collection,
  ) : this._internal(
          (ref) => getSubCollections(
            ref as GetSubCollectionsRef,
            category,
            collection,
          ),
          from: getSubCollectionsProvider,
          name: r'getSubCollectionsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getSubCollectionsHash,
          dependencies: GetSubCollectionsFamily._dependencies,
          allTransitiveDependencies:
              GetSubCollectionsFamily._allTransitiveDependencies,
          category: category,
          collection: collection,
        );

  GetSubCollectionsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.category,
    required this.collection,
  }) : super.internal();

  final String category;
  final String collection;

  @override
  Override overrideWith(
    FutureOr<List<String>> Function(GetSubCollectionsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetSubCollectionsProvider._internal(
        (ref) => create(ref as GetSubCollectionsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        category: category,
        collection: collection,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<String>> createElement() {
    return _GetSubCollectionsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetSubCollectionsProvider &&
        other.category == category &&
        other.collection == collection;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, category.hashCode);
    hash = _SystemHash.combine(hash, collection.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetSubCollectionsRef on AutoDisposeFutureProviderRef<List<String>> {
  /// The parameter `category` of this provider.
  String get category;

  /// The parameter `collection` of this provider.
  String get collection;
}

class _GetSubCollectionsProviderElement
    extends AutoDisposeFutureProviderElement<List<String>>
    with GetSubCollectionsRef {
  _GetSubCollectionsProviderElement(super.provider);

  @override
  String get category => (origin as GetSubCollectionsProvider).category;
  @override
  String get collection => (origin as GetSubCollectionsProvider).collection;
}

String _$getCollectionsHash() => r'71aa5ea0906d5973c00a3beae55230da5b8aff72';

/// See also [getCollections].
@ProviderFor(getCollections)
const getCollectionsProvider = GetCollectionsFamily();

/// See also [getCollections].
class GetCollectionsFamily extends Family<AsyncValue<List<String>>> {
  /// See also [getCollections].
  const GetCollectionsFamily();

  /// See also [getCollections].
  GetCollectionsProvider call(
    String category,
  ) {
    return GetCollectionsProvider(
      category,
    );
  }

  @override
  GetCollectionsProvider getProviderOverride(
    covariant GetCollectionsProvider provider,
  ) {
    return call(
      provider.category,
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
  String? get name => r'getCollectionsProvider';
}

/// See also [getCollections].
class GetCollectionsProvider extends AutoDisposeFutureProvider<List<String>> {
  /// See also [getCollections].
  GetCollectionsProvider(
    String category,
  ) : this._internal(
          (ref) => getCollections(
            ref as GetCollectionsRef,
            category,
          ),
          from: getCollectionsProvider,
          name: r'getCollectionsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getCollectionsHash,
          dependencies: GetCollectionsFamily._dependencies,
          allTransitiveDependencies:
              GetCollectionsFamily._allTransitiveDependencies,
          category: category,
        );

  GetCollectionsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.category,
  }) : super.internal();

  final String category;

  @override
  Override overrideWith(
    FutureOr<List<String>> Function(GetCollectionsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetCollectionsProvider._internal(
        (ref) => create(ref as GetCollectionsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        category: category,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<String>> createElement() {
    return _GetCollectionsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetCollectionsProvider && other.category == category;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, category.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetCollectionsRef on AutoDisposeFutureProviderRef<List<String>> {
  /// The parameter `category` of this provider.
  String get category;
}

class _GetCollectionsProviderElement
    extends AutoDisposeFutureProviderElement<List<String>>
    with GetCollectionsRef {
  _GetCollectionsProviderElement(super.provider);

  @override
  String get category => (origin as GetCollectionsProvider).category;
}

String _$getBrandsHash() => r'c841c79fd66604bf7adb89ebcf28be50ce1e83fa';

/// See also [getBrands].
@ProviderFor(getBrands)
final getBrandsProvider = AutoDisposeFutureProvider<List<String>>.internal(
  getBrands,
  name: r'getBrandsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$getBrandsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetBrandsRef = AutoDisposeFutureProviderRef<List<String>>;
String _$productsNotifierHash() => r'e36d54cf7a36ce3165ecedb874478fcdffed419f';

/// See also [ProductsNotifier].
@ProviderFor(ProductsNotifier)
final productsNotifierProvider =
    AutoDisposeNotifierProvider<ProductsNotifier, List<ProductsModel>>.internal(
  ProductsNotifier.new,
  name: r'productsNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$productsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ProductsNotifier = AutoDisposeNotifier<List<ProductsModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
