// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'today_menu_datatable_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getCategoriesHash() => r'c5be7f9013a147e15ea390c42c0d4e33609a56e7';

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

/// See also [getCategories].
@ProviderFor(getCategories)
const getCategoriesProvider = GetCategoriesFamily();

/// See also [getCategories].
class GetCategoriesFamily extends Family<AsyncValue<List<String>>> {
  /// See also [getCategories].
  const GetCategoriesFamily();

  /// See also [getCategories].
  GetCategoriesProvider call(
    String module,
  ) {
    return GetCategoriesProvider(
      module,
    );
  }

  @override
  GetCategoriesProvider getProviderOverride(
    covariant GetCategoriesProvider provider,
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
  String? get name => r'getCategoriesProvider';
}

/// See also [getCategories].
class GetCategoriesProvider extends AutoDisposeFutureProvider<List<String>> {
  /// See also [getCategories].
  GetCategoriesProvider(
    String module,
  ) : this._internal(
          (ref) => getCategories(
            ref as GetCategoriesRef,
            module,
          ),
          from: getCategoriesProvider,
          name: r'getCategoriesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getCategoriesHash,
          dependencies: GetCategoriesFamily._dependencies,
          allTransitiveDependencies:
              GetCategoriesFamily._allTransitiveDependencies,
          module: module,
        );

  GetCategoriesProvider._internal(
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
    FutureOr<List<String>> Function(GetCategoriesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetCategoriesProvider._internal(
        (ref) => create(ref as GetCategoriesRef),
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
    return _GetCategoriesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetCategoriesProvider && other.module == module;
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
mixin GetCategoriesRef on AutoDisposeFutureProviderRef<List<String>> {
  /// The parameter `module` of this provider.
  String get module;
}

class _GetCategoriesProviderElement
    extends AutoDisposeFutureProviderElement<List<String>>
    with GetCategoriesRef {
  _GetCategoriesProviderElement(super.provider);

  @override
  String get module => (origin as GetCategoriesProvider).module;
}

String _$getSubCollectionsHash() => r'bd9d6c462a6b1aef32a447e45049071be2d03abd';

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
    String module,
  ) {
    return GetSubCollectionsProvider(
      category,
      collection,
      module,
    );
  }

  @override
  GetSubCollectionsProvider getProviderOverride(
    covariant GetSubCollectionsProvider provider,
  ) {
    return call(
      provider.category,
      provider.collection,
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
  String? get name => r'getSubCollectionsProvider';
}

/// See also [getSubCollections].
class GetSubCollectionsProvider
    extends AutoDisposeFutureProvider<List<String>> {
  /// See also [getSubCollections].
  GetSubCollectionsProvider(
    String category,
    String collection,
    String module,
  ) : this._internal(
          (ref) => getSubCollections(
            ref as GetSubCollectionsRef,
            category,
            collection,
            module,
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
          module: module,
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
    required this.module,
  }) : super.internal();

  final String category;
  final String collection;
  final String module;

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
        module: module,
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
        other.collection == collection &&
        other.module == module;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, category.hashCode);
    hash = _SystemHash.combine(hash, collection.hashCode);
    hash = _SystemHash.combine(hash, module.hashCode);

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

  /// The parameter `module` of this provider.
  String get module;
}

class _GetSubCollectionsProviderElement
    extends AutoDisposeFutureProviderElement<List<String>>
    with GetSubCollectionsRef {
  _GetSubCollectionsProviderElement(super.provider);

  @override
  String get category => (origin as GetSubCollectionsProvider).category;
  @override
  String get collection => (origin as GetSubCollectionsProvider).collection;
  @override
  String get module => (origin as GetSubCollectionsProvider).module;
}

String _$getCollectionsHash() => r'029dadcb531698cebdae5eb2d697ac4b8ef7b617';

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
    String module,
  ) {
    return GetCollectionsProvider(
      category,
      module,
    );
  }

  @override
  GetCollectionsProvider getProviderOverride(
    covariant GetCollectionsProvider provider,
  ) {
    return call(
      provider.category,
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
  String? get name => r'getCollectionsProvider';
}

/// See also [getCollections].
class GetCollectionsProvider extends AutoDisposeFutureProvider<List<String>> {
  /// See also [getCollections].
  GetCollectionsProvider(
    String category,
    String module,
  ) : this._internal(
          (ref) => getCollections(
            ref as GetCollectionsRef,
            category,
            module,
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
          module: module,
        );

  GetCollectionsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.category,
    required this.module,
  }) : super.internal();

  final String category;
  final String module;

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
        module: module,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<String>> createElement() {
    return _GetCollectionsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetCollectionsProvider &&
        other.category == category &&
        other.module == module;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, category.hashCode);
    hash = _SystemHash.combine(hash, module.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetCollectionsRef on AutoDisposeFutureProviderRef<List<String>> {
  /// The parameter `category` of this provider.
  String get category;

  /// The parameter `module` of this provider.
  String get module;
}

class _GetCollectionsProviderElement
    extends AutoDisposeFutureProviderElement<List<String>>
    with GetCollectionsRef {
  _GetCollectionsProviderElement(super.provider);

  @override
  String get category => (origin as GetCollectionsProvider).category;
  @override
  String get module => (origin as GetCollectionsProvider).module;
}

String _$getBrandsHash() => r'51d565e34976db916253e54605dca38c38d91847';

/// See also [getBrands].
@ProviderFor(getBrands)
const getBrandsProvider = GetBrandsFamily();

/// See also [getBrands].
class GetBrandsFamily extends Family<AsyncValue<List<String>>> {
  /// See also [getBrands].
  const GetBrandsFamily();

  /// See also [getBrands].
  GetBrandsProvider call(
    String module,
  ) {
    return GetBrandsProvider(
      module,
    );
  }

  @override
  GetBrandsProvider getProviderOverride(
    covariant GetBrandsProvider provider,
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
  String? get name => r'getBrandsProvider';
}

/// See also [getBrands].
class GetBrandsProvider extends AutoDisposeFutureProvider<List<String>> {
  /// See also [getBrands].
  GetBrandsProvider(
    String module,
  ) : this._internal(
          (ref) => getBrands(
            ref as GetBrandsRef,
            module,
          ),
          from: getBrandsProvider,
          name: r'getBrandsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getBrandsHash,
          dependencies: GetBrandsFamily._dependencies,
          allTransitiveDependencies: GetBrandsFamily._allTransitiveDependencies,
          module: module,
        );

  GetBrandsProvider._internal(
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
    FutureOr<List<String>> Function(GetBrandsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetBrandsProvider._internal(
        (ref) => create(ref as GetBrandsRef),
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
    return _GetBrandsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetBrandsProvider && other.module == module;
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
mixin GetBrandsRef on AutoDisposeFutureProviderRef<List<String>> {
  /// The parameter `module` of this provider.
  String get module;
}

class _GetBrandsProviderElement
    extends AutoDisposeFutureProviderElement<List<String>> with GetBrandsRef {
  _GetBrandsProviderElement(super.provider);

  @override
  String get module => (origin as GetBrandsProvider).module;
}

String _$todayMenuNotifierHash() => r'd8732b425627b5e270b0be94bce4354c62f4d2a6';

/// See also [TodayMenuNotifier].
@ProviderFor(TodayMenuNotifier)
final todayMenuNotifierProvider = AutoDisposeNotifierProvider<TodayMenuNotifier,
    List<TodayMenuModel>>.internal(
  TodayMenuNotifier.new,
  name: r'todayMenuNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$todayMenuNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TodayMenuNotifier = AutoDisposeNotifier<List<TodayMenuModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
