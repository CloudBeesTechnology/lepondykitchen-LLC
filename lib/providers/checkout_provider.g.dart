// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getWalletHash() => r'a061c5c74a077074a8fb378e6bd89dd7af315ad6';

/// See also [getWallet].
@ProviderFor(getWallet)
final getWalletProvider = AutoDisposeStreamProvider<num>.internal(
  getWallet,
  name: r'getWalletProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$getWalletHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetWalletRef = AutoDisposeStreamProviderRef<num>;
String _$getCashOnDeliveryHash() => r'01e92e1d37a65abca7f9e4b15c96e0cfaf6a0737';

/// See also [getCashOnDelivery].
@ProviderFor(getCashOnDelivery)
final getCashOnDeliveryProvider = AutoDisposeStreamProvider<bool>.internal(
  getCashOnDelivery,
  name: r'getCashOnDeliveryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getCashOnDeliveryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetCashOnDeliveryRef = AutoDisposeStreamProviderRef<bool>;
String _$updateWalletHash() => r'5f83e694536c0900db52770c6524caff9ee6826e';

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

/// See also [updateWallet].
@ProviderFor(updateWallet)
const updateWalletProvider = UpdateWalletFamily();

/// See also [updateWallet].
class UpdateWalletFamily extends Family<Object?> {
  /// See also [updateWallet].
  const UpdateWalletFamily();

  /// See also [updateWallet].
  UpdateWalletProvider call(
    num total,
  ) {
    return UpdateWalletProvider(
      total,
    );
  }

  @override
  UpdateWalletProvider getProviderOverride(
    covariant UpdateWalletProvider provider,
  ) {
    return call(
      provider.total,
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
  String? get name => r'updateWalletProvider';
}

/// See also [updateWallet].
class UpdateWalletProvider extends AutoDisposeProvider<Object?> {
  /// See also [updateWallet].
  UpdateWalletProvider(
    num total,
  ) : this._internal(
          (ref) => updateWallet(
            ref as UpdateWalletRef,
            total,
          ),
          from: updateWalletProvider,
          name: r'updateWalletProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$updateWalletHash,
          dependencies: UpdateWalletFamily._dependencies,
          allTransitiveDependencies:
              UpdateWalletFamily._allTransitiveDependencies,
          total: total,
        );

  UpdateWalletProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.total,
  }) : super.internal();

  final num total;

  @override
  Override overrideWith(
    Object? Function(UpdateWalletRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UpdateWalletProvider._internal(
        (ref) => create(ref as UpdateWalletRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        total: total,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<Object?> createElement() {
    return _UpdateWalletProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UpdateWalletProvider && other.total == total;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, total.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UpdateWalletRef on AutoDisposeProviderRef<Object?> {
  /// The parameter `total` of this provider.
  num get total;
}

class _UpdateWalletProviderElement extends AutoDisposeProviderElement<Object?>
    with UpdateWalletRef {
  _UpdateWalletProviderElement(super.provider);

  @override
  num get total => (origin as UpdateWalletProvider).total;
}

String _$getPickUpAddressHash() => r'b4ccac0e4a06f67ec15dc3e890fa1f862a066409';

/// See also [getPickUpAddress].
@ProviderFor(getPickUpAddress)
const getPickUpAddressProvider = GetPickUpAddressFamily();

/// See also [getPickUpAddress].
class GetPickUpAddressFamily
    extends Family<AsyncValue<List<PickupAddressModel>>> {
  /// See also [getPickUpAddress].
  const GetPickUpAddressFamily();

  /// See also [getPickUpAddress].
  GetPickUpAddressProvider call(
    String id,
  ) {
    return GetPickUpAddressProvider(
      id,
    );
  }

  @override
  GetPickUpAddressProvider getProviderOverride(
    covariant GetPickUpAddressProvider provider,
  ) {
    return call(
      provider.id,
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
  String? get name => r'getPickUpAddressProvider';
}

/// See also [getPickUpAddress].
class GetPickUpAddressProvider
    extends AutoDisposeFutureProvider<List<PickupAddressModel>> {
  /// See also [getPickUpAddress].
  GetPickUpAddressProvider(
    String id,
  ) : this._internal(
          (ref) => getPickUpAddress(
            ref as GetPickUpAddressRef,
            id,
          ),
          from: getPickUpAddressProvider,
          name: r'getPickUpAddressProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getPickUpAddressHash,
          dependencies: GetPickUpAddressFamily._dependencies,
          allTransitiveDependencies:
              GetPickUpAddressFamily._allTransitiveDependencies,
          id: id,
        );

  GetPickUpAddressProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    FutureOr<List<PickupAddressModel>> Function(GetPickUpAddressRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetPickUpAddressProvider._internal(
        (ref) => create(ref as GetPickUpAddressRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<PickupAddressModel>> createElement() {
    return _GetPickUpAddressProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetPickUpAddressProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetPickUpAddressRef
    on AutoDisposeFutureProviderRef<List<PickupAddressModel>> {
  /// The parameter `id` of this provider.
  String get id;
}

class _GetPickUpAddressProviderElement
    extends AutoDisposeFutureProviderElement<List<PickupAddressModel>>
    with GetPickUpAddressRef {
  _GetPickUpAddressProviderElement(super.provider);

  @override
  String get id => (origin as GetPickUpAddressProvider).id;
}

String _$getCheckoutProductsHash() =>
    r'0bbe9c8d96ca524334e9cd9e73633fed5b2cb04c';

/// See also [getCheckoutProducts].
@ProviderFor(getCheckoutProducts)
const getCheckoutProductsProvider = GetCheckoutProductsFamily();

/// See also [getCheckoutProducts].
class GetCheckoutProductsFamily extends Family<List<CartModel>> {
  /// See also [getCheckoutProducts].
  const GetCheckoutProductsFamily();

  /// See also [getCheckoutProducts].
  GetCheckoutProductsProvider call(
    String cart,
  ) {
    return GetCheckoutProductsProvider(
      cart,
    );
  }

  @override
  GetCheckoutProductsProvider getProviderOverride(
    covariant GetCheckoutProductsProvider provider,
  ) {
    return call(
      provider.cart,
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
  String? get name => r'getCheckoutProductsProvider';
}

/// See also [getCheckoutProducts].
class GetCheckoutProductsProvider extends AutoDisposeProvider<List<CartModel>> {
  /// See also [getCheckoutProducts].
  GetCheckoutProductsProvider(
    String cart,
  ) : this._internal(
          (ref) => getCheckoutProducts(
            ref as GetCheckoutProductsRef,
            cart,
          ),
          from: getCheckoutProductsProvider,
          name: r'getCheckoutProductsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getCheckoutProductsHash,
          dependencies: GetCheckoutProductsFamily._dependencies,
          allTransitiveDependencies:
              GetCheckoutProductsFamily._allTransitiveDependencies,
          cart: cart,
        );

  GetCheckoutProductsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.cart,
  }) : super.internal();

  final String cart;

  @override
  Override overrideWith(
    List<CartModel> Function(GetCheckoutProductsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetCheckoutProductsProvider._internal(
        (ref) => create(ref as GetCheckoutProductsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        cart: cart,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<List<CartModel>> createElement() {
    return _GetCheckoutProductsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetCheckoutProductsProvider && other.cart == cart;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, cart.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetCheckoutProductsRef on AutoDisposeProviderRef<List<CartModel>> {
  /// The parameter `cart` of this provider.
  String get cart;
}

class _GetCheckoutProductsProviderElement
    extends AutoDisposeProviderElement<List<CartModel>>
    with GetCheckoutProductsRef {
  _GetCheckoutProductsProviderElement(super.provider);

  @override
  String get cart => (origin as GetCheckoutProductsProvider).cart;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
