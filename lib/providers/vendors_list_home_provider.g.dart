// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendors_list_home_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getVendorsListHash() => r'e442907a0be2f34a25b4022f5d9df294dec9b884';

/// See also [getVendorsList].
@ProviderFor(getVendorsList)
final getVendorsListProvider =
    AutoDisposeStreamProvider<List<UserModel>>.internal(
  getVendorsList,
  name: r'getVendorsListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getVendorsListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetVendorsListRef = AutoDisposeStreamProviderRef<List<UserModel>>;
String _$getVendorOpenStatusHash() =>
    r'272243593560c97cba13804ca92b7f9ce94a2ca6';

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

/// See also [getVendorOpenStatus].
@ProviderFor(getVendorOpenStatus)
const getVendorOpenStatusProvider = GetVendorOpenStatusFamily();

/// See also [getVendorOpenStatus].
class GetVendorOpenStatusFamily extends Family<AsyncValue<bool>> {
  /// See also [getVendorOpenStatus].
  const GetVendorOpenStatusFamily();

  /// See also [getVendorOpenStatus].
  GetVendorOpenStatusProvider call(
    String vendorID,
  ) {
    return GetVendorOpenStatusProvider(
      vendorID,
    );
  }

  @override
  GetVendorOpenStatusProvider getProviderOverride(
    covariant GetVendorOpenStatusProvider provider,
  ) {
    return call(
      provider.vendorID,
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
  String? get name => r'getVendorOpenStatusProvider';
}

/// See also [getVendorOpenStatus].
class GetVendorOpenStatusProvider extends AutoDisposeStreamProvider<bool> {
  /// See also [getVendorOpenStatus].
  GetVendorOpenStatusProvider(
    String vendorID,
  ) : this._internal(
          (ref) => getVendorOpenStatus(
            ref as GetVendorOpenStatusRef,
            vendorID,
          ),
          from: getVendorOpenStatusProvider,
          name: r'getVendorOpenStatusProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getVendorOpenStatusHash,
          dependencies: GetVendorOpenStatusFamily._dependencies,
          allTransitiveDependencies:
              GetVendorOpenStatusFamily._allTransitiveDependencies,
          vendorID: vendorID,
        );

  GetVendorOpenStatusProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.vendorID,
  }) : super.internal();

  final String vendorID;

  @override
  Override overrideWith(
    Stream<bool> Function(GetVendorOpenStatusRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetVendorOpenStatusProvider._internal(
        (ref) => create(ref as GetVendorOpenStatusRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        vendorID: vendorID,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<bool> createElement() {
    return _GetVendorOpenStatusProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetVendorOpenStatusProvider && other.vendorID == vendorID;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, vendorID.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetVendorOpenStatusRef on AutoDisposeStreamProviderRef<bool> {
  /// The parameter `vendorID` of this provider.
  String get vendorID;
}

class _GetVendorOpenStatusProviderElement
    extends AutoDisposeStreamProviderElement<bool> with GetVendorOpenStatusRef {
  _GetVendorOpenStatusProviderElement(super.provider);

  @override
  String get vendorID => (origin as GetVendorOpenStatusProvider).vendorID;
}

String _$vendorsStreamNotificationHash() =>
    r'3f4b8e14c879222e374b6b9f795d635ebfbc483f';

/// See also [vendorsStreamNotification].
@ProviderFor(vendorsStreamNotification)
final vendorsStreamNotificationProvider =
    AutoDisposeStreamProvider<List<UserModel>>.internal(
  vendorsStreamNotification,
  name: r'vendorsStreamNotificationProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$vendorsStreamNotificationHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef VendorsStreamNotificationRef
    = AutoDisposeStreamProviderRef<List<UserModel>>;
String _$getVendorsByCityListHash() =>
    r'63473bf8494bf070a30760e5f246841f3bca56f6';

/// See also [getVendorsByCityList].
@ProviderFor(getVendorsByCityList)
const getVendorsByCityListProvider = GetVendorsByCityListFamily();

/// See also [getVendorsByCityList].
class GetVendorsByCityListFamily extends Family<AsyncValue<List<UserModel>>> {
  /// See also [getVendorsByCityList].
  const GetVendorsByCityListFamily();

  /// See also [getVendorsByCityList].
  GetVendorsByCityListProvider call(
    String city,
  ) {
    return GetVendorsByCityListProvider(
      city,
    );
  }

  @override
  GetVendorsByCityListProvider getProviderOverride(
    covariant GetVendorsByCityListProvider provider,
  ) {
    return call(
      provider.city,
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
  String? get name => r'getVendorsByCityListProvider';
}

/// See also [getVendorsByCityList].
class GetVendorsByCityListProvider
    extends AutoDisposeStreamProvider<List<UserModel>> {
  /// See also [getVendorsByCityList].
  GetVendorsByCityListProvider(
    String city,
  ) : this._internal(
          (ref) => getVendorsByCityList(
            ref as GetVendorsByCityListRef,
            city,
          ),
          from: getVendorsByCityListProvider,
          name: r'getVendorsByCityListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getVendorsByCityListHash,
          dependencies: GetVendorsByCityListFamily._dependencies,
          allTransitiveDependencies:
              GetVendorsByCityListFamily._allTransitiveDependencies,
          city: city,
        );

  GetVendorsByCityListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.city,
  }) : super.internal();

  final String city;

  @override
  Override overrideWith(
    Stream<List<UserModel>> Function(GetVendorsByCityListRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetVendorsByCityListProvider._internal(
        (ref) => create(ref as GetVendorsByCityListRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        city: city,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<UserModel>> createElement() {
    return _GetVendorsByCityListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetVendorsByCityListProvider && other.city == city;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, city.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetVendorsByCityListRef on AutoDisposeStreamProviderRef<List<UserModel>> {
  /// The parameter `city` of this provider.
  String get city;
}

class _GetVendorsByCityListProviderElement
    extends AutoDisposeStreamProviderElement<List<UserModel>>
    with GetVendorsByCityListRef {
  _GetVendorsByCityListProviderElement(super.provider);

  @override
  String get city => (origin as GetVendorsByCityListProvider).city;
}

String _$getFavoriteVendorsListHash() =>
    r'f38973590dbf1610d416747ff2269452aea09b3f';

/// See also [getFavoriteVendorsList].
@ProviderFor(getFavoriteVendorsList)
final getFavoriteVendorsListProvider =
    AutoDisposeStreamProvider<List<UserModel>>.internal(
  getFavoriteVendorsList,
  name: r'getFavoriteVendorsListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getFavoriteVendorsListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetFavoriteVendorsListRef
    = AutoDisposeStreamProviderRef<List<UserModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
