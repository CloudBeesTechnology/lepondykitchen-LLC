// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant_feed_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getCategoriesForFeedsRestaurantHash() =>
    r'a29c69a32e217ddfe7ff652bf1e2171366eb7732';

/// See also [getCategoriesForFeedsRestaurant].
@ProviderFor(getCategoriesForFeedsRestaurant)
final getCategoriesForFeedsRestaurantProvider =
    AutoDisposeFutureProvider<List<String>>.internal(
  getCategoriesForFeedsRestaurant,
  name: r'getCategoriesForFeedsRestaurantProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getCategoriesForFeedsRestaurantHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetCategoriesForFeedsRestaurantRef
    = AutoDisposeFutureProviderRef<List<String>>;
String _$getSubCategoriesForFeedsRestaurantHash() =>
    r'3a3a9f858361d90876657585a768892cca6da1cd';

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

/// See also [getSubCategoriesForFeedsRestaurant].
@ProviderFor(getSubCategoriesForFeedsRestaurant)
const getSubCategoriesForFeedsRestaurantProvider =
    GetSubCategoriesForFeedsRestaurantFamily();

/// See also [getSubCategoriesForFeedsRestaurant].
class GetSubCategoriesForFeedsRestaurantFamily
    extends Family<AsyncValue<List<String>>> {
  /// See also [getSubCategoriesForFeedsRestaurant].
  const GetSubCategoriesForFeedsRestaurantFamily();

  /// See also [getSubCategoriesForFeedsRestaurant].
  GetSubCategoriesForFeedsRestaurantProvider call(
    String category,
  ) {
    return GetSubCategoriesForFeedsRestaurantProvider(
      category,
    );
  }

  @override
  GetSubCategoriesForFeedsRestaurantProvider getProviderOverride(
    covariant GetSubCategoriesForFeedsRestaurantProvider provider,
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
  String? get name => r'getSubCategoriesForFeedsRestaurantProvider';
}

/// See also [getSubCategoriesForFeedsRestaurant].
class GetSubCategoriesForFeedsRestaurantProvider
    extends AutoDisposeFutureProvider<List<String>> {
  /// See also [getSubCategoriesForFeedsRestaurant].
  GetSubCategoriesForFeedsRestaurantProvider(
    String category,
  ) : this._internal(
          (ref) => getSubCategoriesForFeedsRestaurant(
            ref as GetSubCategoriesForFeedsRestaurantRef,
            category,
          ),
          from: getSubCategoriesForFeedsRestaurantProvider,
          name: r'getSubCategoriesForFeedsRestaurantProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getSubCategoriesForFeedsRestaurantHash,
          dependencies: GetSubCategoriesForFeedsRestaurantFamily._dependencies,
          allTransitiveDependencies: GetSubCategoriesForFeedsRestaurantFamily
              ._allTransitiveDependencies,
          category: category,
        );

  GetSubCategoriesForFeedsRestaurantProvider._internal(
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
    FutureOr<List<String>> Function(
            GetSubCategoriesForFeedsRestaurantRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetSubCategoriesForFeedsRestaurantProvider._internal(
        (ref) => create(ref as GetSubCategoriesForFeedsRestaurantRef),
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
    return _GetSubCategoriesForFeedsRestaurantProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetSubCategoriesForFeedsRestaurantProvider &&
        other.category == category;
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
mixin GetSubCategoriesForFeedsRestaurantRef
    on AutoDisposeFutureProviderRef<List<String>> {
  /// The parameter `category` of this provider.
  String get category;
}

class _GetSubCategoriesForFeedsRestaurantProviderElement
    extends AutoDisposeFutureProviderElement<List<String>>
    with GetSubCategoriesForFeedsRestaurantRef {
  _GetSubCategoriesForFeedsRestaurantProviderElement(super.provider);

  @override
  String get category =>
      (origin as GetSubCategoriesForFeedsRestaurantProvider).category;
}

String _$getSubCategoriesCollectionsForFeedsRestaurantHash() =>
    r'097be4b046b314905d484fb5cacddf3c4d433712';

/// See also [getSubCategoriesCollectionsForFeedsRestaurant].
@ProviderFor(getSubCategoriesCollectionsForFeedsRestaurant)
const getSubCategoriesCollectionsForFeedsRestaurantProvider =
    GetSubCategoriesCollectionsForFeedsRestaurantFamily();

/// See also [getSubCategoriesCollectionsForFeedsRestaurant].
class GetSubCategoriesCollectionsForFeedsRestaurantFamily
    extends Family<AsyncValue<List<String>>> {
  /// See also [getSubCategoriesCollectionsForFeedsRestaurant].
  const GetSubCategoriesCollectionsForFeedsRestaurantFamily();

  /// See also [getSubCategoriesCollectionsForFeedsRestaurant].
  GetSubCategoriesCollectionsForFeedsRestaurantProvider call(
    String subcategory,
  ) {
    return GetSubCategoriesCollectionsForFeedsRestaurantProvider(
      subcategory,
    );
  }

  @override
  GetSubCategoriesCollectionsForFeedsRestaurantProvider getProviderOverride(
    covariant GetSubCategoriesCollectionsForFeedsRestaurantProvider provider,
  ) {
    return call(
      provider.subcategory,
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
  String? get name => r'getSubCategoriesCollectionsForFeedsRestaurantProvider';
}

/// See also [getSubCategoriesCollectionsForFeedsRestaurant].
class GetSubCategoriesCollectionsForFeedsRestaurantProvider
    extends AutoDisposeFutureProvider<List<String>> {
  /// See also [getSubCategoriesCollectionsForFeedsRestaurant].
  GetSubCategoriesCollectionsForFeedsRestaurantProvider(
    String subcategory,
  ) : this._internal(
          (ref) => getSubCategoriesCollectionsForFeedsRestaurant(
            ref as GetSubCategoriesCollectionsForFeedsRestaurantRef,
            subcategory,
          ),
          from: getSubCategoriesCollectionsForFeedsRestaurantProvider,
          name: r'getSubCategoriesCollectionsForFeedsRestaurantProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getSubCategoriesCollectionsForFeedsRestaurantHash,
          dependencies:
              GetSubCategoriesCollectionsForFeedsRestaurantFamily._dependencies,
          allTransitiveDependencies:
              GetSubCategoriesCollectionsForFeedsRestaurantFamily
                  ._allTransitiveDependencies,
          subcategory: subcategory,
        );

  GetSubCategoriesCollectionsForFeedsRestaurantProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.subcategory,
  }) : super.internal();

  final String subcategory;

  @override
  Override overrideWith(
    FutureOr<List<String>> Function(
            GetSubCategoriesCollectionsForFeedsRestaurantRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetSubCategoriesCollectionsForFeedsRestaurantProvider._internal(
        (ref) =>
            create(ref as GetSubCategoriesCollectionsForFeedsRestaurantRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        subcategory: subcategory,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<String>> createElement() {
    return _GetSubCategoriesCollectionsForFeedsRestaurantProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetSubCategoriesCollectionsForFeedsRestaurantProvider &&
        other.subcategory == subcategory;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, subcategory.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetSubCategoriesCollectionsForFeedsRestaurantRef
    on AutoDisposeFutureProviderRef<List<String>> {
  /// The parameter `subcategory` of this provider.
  String get subcategory;
}

class _GetSubCategoriesCollectionsForFeedsRestaurantProviderElement
    extends AutoDisposeFutureProviderElement<List<String>>
    with GetSubCategoriesCollectionsForFeedsRestaurantRef {
  _GetSubCategoriesCollectionsForFeedsRestaurantProviderElement(super.provider);

  @override
  String get subcategory =>
      (origin as GetSubCategoriesCollectionsForFeedsRestaurantProvider)
          .subcategory;
}

String _$getFeedsRestaurantHash() =>
    r'1d87ba34849b0b9657fb9b89367f7476d0ce84ac';

/// See also [getFeedsRestaurant].
@ProviderFor(getFeedsRestaurant)
final getFeedsRestaurantProvider =
    AutoDisposeStreamProvider<List<FeedsModel>>.internal(
  getFeedsRestaurant,
  name: r'getFeedsRestaurantProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getFeedsRestaurantHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetFeedsRestaurantRef = AutoDisposeStreamProviderRef<List<FeedsModel>>;
String _$allFeedsRestaurantHash() =>
    r'3bf6eb19795f303fa6707cfe24a1e0c9c5f0731c';

/// See also [AllFeedsRestaurant].
@ProviderFor(AllFeedsRestaurant)
final allFeedsRestaurantProvider =
    AutoDisposeNotifierProvider<AllFeedsRestaurant, FeedsModel>.internal(
  AllFeedsRestaurant.new,
  name: r'allFeedsRestaurantProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$allFeedsRestaurantHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AllFeedsRestaurant = AutoDisposeNotifier<FeedsModel>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
