// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant_category_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getCategoriesStringRestaurantHash() =>
    r'1563867682986b9381d9d68c224e058582d441c7';

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

/// See also [getCategoriesStringRestaurant].
@ProviderFor(getCategoriesStringRestaurant)
const getCategoriesStringRestaurantProvider =
    GetCategoriesStringRestaurantFamily();

/// See also [getCategoriesStringRestaurant].
class GetCategoriesStringRestaurantFamily
    extends Family<AsyncValue<List<String>>> {
  /// See also [getCategoriesStringRestaurant].
  const GetCategoriesStringRestaurantFamily();

  /// See also [getCategoriesStringRestaurant].
  GetCategoriesStringRestaurantProvider call(
    String module,
  ) {
    return GetCategoriesStringRestaurantProvider(
      module,
    );
  }

  @override
  GetCategoriesStringRestaurantProvider getProviderOverride(
    covariant GetCategoriesStringRestaurantProvider provider,
  ) {
    return call(
      provider.module,
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
  String? get name => r'getCategoriesStringRestaurantProvider';
}

/// See also [getCategoriesStringRestaurant].
class GetCategoriesStringRestaurantProvider
    extends AutoDisposeFutureProvider<List<String>> {
  /// See also [getCategoriesStringRestaurant].
  GetCategoriesStringRestaurantProvider(
    String module,
  ) : this._internal(
          (ref) => getCategoriesStringRestaurant(
            ref as GetCategoriesStringRestaurantRef,
            module,
          ),
          from: getCategoriesStringRestaurantProvider,
          name: r'getCategoriesStringRestaurantProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getCategoriesStringRestaurantHash,
          dependencies: GetCategoriesStringRestaurantFamily._dependencies,
          allTransitiveDependencies:
              GetCategoriesStringRestaurantFamily._allTransitiveDependencies,
          module: module,
        );

  GetCategoriesStringRestaurantProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.module,
  }) : super.internal();

  final String module;

  @override
  Override overrideWith(
    FutureOr<List<String>> Function(GetCategoriesStringRestaurantRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetCategoriesStringRestaurantProvider._internal(
        (ref) => create(ref as GetCategoriesStringRestaurantRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        module: module,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<String>> createElement() {
    return _GetCategoriesStringRestaurantProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetCategoriesStringRestaurantProvider &&
        other.module == module;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, module.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetCategoriesStringRestaurantRef
    on AutoDisposeFutureProviderRef<List<String>> {
  /// The parameter `module` of this provider.
  String get module;
}

class _GetCategoriesStringRestaurantProviderElement
    extends AutoDisposeFutureProviderElement<List<String>>
    with GetCategoriesStringRestaurantRef {
  _GetCategoriesStringRestaurantProviderElement(super.provider);

  @override
  String get module => (origin as GetCategoriesStringRestaurantProvider).module;
}

String _$getCategoriesByModelRestaurantHash() =>
    r'543a2149110fc8e4be3ec571889e2bcafb07d2d0';

/// See also [getCategoriesByModelRestaurant].
@ProviderFor(getCategoriesByModelRestaurant)
const getCategoriesByModelRestaurantProvider =
    GetCategoriesByModelRestaurantFamily();

/// See also [getCategoriesByModelRestaurant].
class GetCategoriesByModelRestaurantFamily
    extends Family<AsyncValue<List<CategoriesModel>>> {
  /// See also [getCategoriesByModelRestaurant].
  const GetCategoriesByModelRestaurantFamily();

  /// See also [getCategoriesByModelRestaurant].
  GetCategoriesByModelRestaurantProvider call(
    String module,
  ) {
    return GetCategoriesByModelRestaurantProvider(
      module,
    );
  }

  @override
  GetCategoriesByModelRestaurantProvider getProviderOverride(
    covariant GetCategoriesByModelRestaurantProvider provider,
  ) {
    return call(
      provider.module,
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
  String? get name => r'getCategoriesByModelRestaurantProvider';
}

/// See also [getCategoriesByModelRestaurant].
class GetCategoriesByModelRestaurantProvider
    extends AutoDisposeFutureProvider<List<CategoriesModel>> {
  /// See also [getCategoriesByModelRestaurant].
  GetCategoriesByModelRestaurantProvider(
    String module,
  ) : this._internal(
          (ref) => getCategoriesByModelRestaurant(
            ref as GetCategoriesByModelRestaurantRef,
            module,
          ),
          from: getCategoriesByModelRestaurantProvider,
          name: r'getCategoriesByModelRestaurantProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getCategoriesByModelRestaurantHash,
          dependencies: GetCategoriesByModelRestaurantFamily._dependencies,
          allTransitiveDependencies:
              GetCategoriesByModelRestaurantFamily._allTransitiveDependencies,
          module: module,
        );

  GetCategoriesByModelRestaurantProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.module,
  }) : super.internal();

  final String module;

  @override
  Override overrideWith(
    FutureOr<List<CategoriesModel>> Function(
            GetCategoriesByModelRestaurantRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetCategoriesByModelRestaurantProvider._internal(
        (ref) => create(ref as GetCategoriesByModelRestaurantRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        module: module,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<CategoriesModel>> createElement() {
    return _GetCategoriesByModelRestaurantProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetCategoriesByModelRestaurantProvider &&
        other.module == module;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, module.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetCategoriesByModelRestaurantRef
    on AutoDisposeFutureProviderRef<List<CategoriesModel>> {
  /// The parameter `module` of this provider.
  String get module;
}

class _GetCategoriesByModelRestaurantProviderElement
    extends AutoDisposeFutureProviderElement<List<CategoriesModel>>
    with GetCategoriesByModelRestaurantRef {
  _GetCategoriesByModelRestaurantProviderElement(super.provider);

  @override
  String get module =>
      (origin as GetCategoriesByModelRestaurantProvider).module;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
