// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant_hot_deals_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$hotDealStreamRestaurantHash() =>
    r'61de9e2798af5c2c8f399d83db99d3b19e974f36';

/// See also [hotDealStreamRestaurant].
@ProviderFor(hotDealStreamRestaurant)
final hotDealStreamRestaurantProvider =
    AutoDisposeStreamProvider<List<ProductsModel>>.internal(
  hotDealStreamRestaurant,
  name: r'hotDealStreamRestaurantProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$hotDealStreamRestaurantHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HotDealStreamRestaurantRef
    = AutoDisposeStreamProviderRef<List<ProductsModel>>;
String _$hotDealStreamRestaurantByVendorHash() =>
    r'07f4953d003ee3e932a3b9001437a337ee7caa48';

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

/// See also [hotDealStreamRestaurantByVendor].
@ProviderFor(hotDealStreamRestaurantByVendor)
const hotDealStreamRestaurantByVendorProvider =
    HotDealStreamRestaurantByVendorFamily();

/// See also [hotDealStreamRestaurantByVendor].
class HotDealStreamRestaurantByVendorFamily
    extends Family<AsyncValue<List<ProductsModel>>> {
  /// See also [hotDealStreamRestaurantByVendor].
  const HotDealStreamRestaurantByVendorFamily();

  /// See also [hotDealStreamRestaurantByVendor].
  HotDealStreamRestaurantByVendorProvider call(
    String venodorId,
  ) {
    return HotDealStreamRestaurantByVendorProvider(
      venodorId,
    );
  }

  @override
  HotDealStreamRestaurantByVendorProvider getProviderOverride(
    covariant HotDealStreamRestaurantByVendorProvider provider,
  ) {
    return call(
      provider.venodorId,
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
  String? get name => r'hotDealStreamRestaurantByVendorProvider';
}

/// See also [hotDealStreamRestaurantByVendor].
class HotDealStreamRestaurantByVendorProvider
    extends AutoDisposeStreamProvider<List<ProductsModel>> {
  /// See also [hotDealStreamRestaurantByVendor].
  HotDealStreamRestaurantByVendorProvider(
    String venodorId,
  ) : this._internal(
          (ref) => hotDealStreamRestaurantByVendor(
            ref as HotDealStreamRestaurantByVendorRef,
            venodorId,
          ),
          from: hotDealStreamRestaurantByVendorProvider,
          name: r'hotDealStreamRestaurantByVendorProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$hotDealStreamRestaurantByVendorHash,
          dependencies: HotDealStreamRestaurantByVendorFamily._dependencies,
          allTransitiveDependencies:
              HotDealStreamRestaurantByVendorFamily._allTransitiveDependencies,
          venodorId: venodorId,
        );

  HotDealStreamRestaurantByVendorProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.venodorId,
  }) : super.internal();

  final String venodorId;

  @override
  Override overrideWith(
    Stream<List<ProductsModel>> Function(
            HotDealStreamRestaurantByVendorRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: HotDealStreamRestaurantByVendorProvider._internal(
        (ref) => create(ref as HotDealStreamRestaurantByVendorRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        venodorId: venodorId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<ProductsModel>> createElement() {
    return _HotDealStreamRestaurantByVendorProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HotDealStreamRestaurantByVendorProvider &&
        other.venodorId == venodorId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, venodorId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin HotDealStreamRestaurantByVendorRef
    on AutoDisposeStreamProviderRef<List<ProductsModel>> {
  /// The parameter `venodorId` of this provider.
  String get venodorId;
}

class _HotDealStreamRestaurantByVendorProviderElement
    extends AutoDisposeStreamProviderElement<List<ProductsModel>>
    with HotDealStreamRestaurantByVendorRef {
  _HotDealStreamRestaurantByVendorProviderElement(super.provider);

  @override
  String get venodorId =>
      (origin as HotDealStreamRestaurantByVendorProvider).venodorId;
}

String _$flashSalesStreamRestaurantByVendorHash() =>
    r'fc559c34bc7d5f53cca67b72d4b9ed0e39bf3dd7';

/// See also [flashSalesStreamRestaurantByVendor].
@ProviderFor(flashSalesStreamRestaurantByVendor)
const flashSalesStreamRestaurantByVendorProvider =
    FlashSalesStreamRestaurantByVendorFamily();

/// See also [flashSalesStreamRestaurantByVendor].
class FlashSalesStreamRestaurantByVendorFamily
    extends Family<AsyncValue<List<ProductsModel>>> {
  /// See also [flashSalesStreamRestaurantByVendor].
  const FlashSalesStreamRestaurantByVendorFamily();

  /// See also [flashSalesStreamRestaurantByVendor].
  FlashSalesStreamRestaurantByVendorProvider call(
    String venodorId,
  ) {
    return FlashSalesStreamRestaurantByVendorProvider(
      venodorId,
    );
  }

  @override
  FlashSalesStreamRestaurantByVendorProvider getProviderOverride(
    covariant FlashSalesStreamRestaurantByVendorProvider provider,
  ) {
    return call(
      provider.venodorId,
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
  String? get name => r'flashSalesStreamRestaurantByVendorProvider';
}

/// See also [flashSalesStreamRestaurantByVendor].
class FlashSalesStreamRestaurantByVendorProvider
    extends AutoDisposeStreamProvider<List<ProductsModel>> {
  /// See also [flashSalesStreamRestaurantByVendor].
  FlashSalesStreamRestaurantByVendorProvider(
    String venodorId,
  ) : this._internal(
          (ref) => flashSalesStreamRestaurantByVendor(
            ref as FlashSalesStreamRestaurantByVendorRef,
            venodorId,
          ),
          from: flashSalesStreamRestaurantByVendorProvider,
          name: r'flashSalesStreamRestaurantByVendorProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$flashSalesStreamRestaurantByVendorHash,
          dependencies: FlashSalesStreamRestaurantByVendorFamily._dependencies,
          allTransitiveDependencies: FlashSalesStreamRestaurantByVendorFamily
              ._allTransitiveDependencies,
          venodorId: venodorId,
        );

  FlashSalesStreamRestaurantByVendorProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.venodorId,
  }) : super.internal();

  final String venodorId;

  @override
  Override overrideWith(
    Stream<List<ProductsModel>> Function(
            FlashSalesStreamRestaurantByVendorRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FlashSalesStreamRestaurantByVendorProvider._internal(
        (ref) => create(ref as FlashSalesStreamRestaurantByVendorRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        venodorId: venodorId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<ProductsModel>> createElement() {
    return _FlashSalesStreamRestaurantByVendorProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FlashSalesStreamRestaurantByVendorProvider &&
        other.venodorId == venodorId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, venodorId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FlashSalesStreamRestaurantByVendorRef
    on AutoDisposeStreamProviderRef<List<ProductsModel>> {
  /// The parameter `venodorId` of this provider.
  String get venodorId;
}

class _FlashSalesStreamRestaurantByVendorProviderElement
    extends AutoDisposeStreamProviderElement<List<ProductsModel>>
    with FlashSalesStreamRestaurantByVendorRef {
  _FlashSalesStreamRestaurantByVendorProviderElement(super.provider);

  @override
  String get venodorId =>
      (origin as FlashSalesStreamRestaurantByVendorProvider).venodorId;
}

String _$hotDealPageStreamRestaurantHash() =>
    r'e6c44ce5c7a49a743184314eefba65776de08bb0';

/// See also [hotDealPageStreamRestaurant].
@ProviderFor(hotDealPageStreamRestaurant)
final hotDealPageStreamRestaurantProvider =
    AutoDisposeStreamProvider<List<ProductsModel>>.internal(
  hotDealPageStreamRestaurant,
  name: r'hotDealPageStreamRestaurantProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$hotDealPageStreamRestaurantHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HotDealPageStreamRestaurantRef
    = AutoDisposeStreamProviderRef<List<ProductsModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
