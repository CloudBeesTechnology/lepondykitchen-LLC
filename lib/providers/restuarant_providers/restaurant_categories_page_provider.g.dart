// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant_categories_page_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$categoriesPageRestaurantNotifierHash() =>
    r'633e4d3b426815634ed90767e19bbfa46973ed6b';

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

abstract class _$CategoriesPageRestaurantNotifier
    extends BuildlessAutoDisposeNotifier<BrandPageState> {
  late final String category;

  BrandPageState build(
    String category,
  );
}

/// See also [CategoriesPageRestaurantNotifier].
@ProviderFor(CategoriesPageRestaurantNotifier)
const categoriesPageRestaurantNotifierProvider =
    CategoriesPageRestaurantNotifierFamily();

/// See also [CategoriesPageRestaurantNotifier].
class CategoriesPageRestaurantNotifierFamily extends Family<BrandPageState> {
  /// See also [CategoriesPageRestaurantNotifier].
  const CategoriesPageRestaurantNotifierFamily();

  /// See also [CategoriesPageRestaurantNotifier].
  CategoriesPageRestaurantNotifierProvider call(
    String category,
  ) {
    return CategoriesPageRestaurantNotifierProvider(
      category,
    );
  }

  @override
  CategoriesPageRestaurantNotifierProvider getProviderOverride(
    covariant CategoriesPageRestaurantNotifierProvider provider,
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
  String? get name => r'categoriesPageRestaurantNotifierProvider';
}

/// See also [CategoriesPageRestaurantNotifier].
class CategoriesPageRestaurantNotifierProvider
    extends AutoDisposeNotifierProviderImpl<CategoriesPageRestaurantNotifier,
        BrandPageState> {
  /// See also [CategoriesPageRestaurantNotifier].
  CategoriesPageRestaurantNotifierProvider(
    String category,
  ) : this._internal(
          () => CategoriesPageRestaurantNotifier()..category = category,
          from: categoriesPageRestaurantNotifierProvider,
          name: r'categoriesPageRestaurantNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$categoriesPageRestaurantNotifierHash,
          dependencies: CategoriesPageRestaurantNotifierFamily._dependencies,
          allTransitiveDependencies:
              CategoriesPageRestaurantNotifierFamily._allTransitiveDependencies,
          category: category,
        );

  CategoriesPageRestaurantNotifierProvider._internal(
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
  BrandPageState runNotifierBuild(
    covariant CategoriesPageRestaurantNotifier notifier,
  ) {
    return notifier.build(
      category,
    );
  }

  @override
  Override overrideWith(CategoriesPageRestaurantNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: CategoriesPageRestaurantNotifierProvider._internal(
        () => create()..category = category,
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
  AutoDisposeNotifierProviderElement<CategoriesPageRestaurantNotifier,
      BrandPageState> createElement() {
    return _CategoriesPageRestaurantNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CategoriesPageRestaurantNotifierProvider &&
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
mixin CategoriesPageRestaurantNotifierRef
    on AutoDisposeNotifierProviderRef<BrandPageState> {
  /// The parameter `category` of this provider.
  String get category;
}

class _CategoriesPageRestaurantNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<CategoriesPageRestaurantNotifier,
        BrandPageState> with CategoriesPageRestaurantNotifierRef {
  _CategoriesPageRestaurantNotifierProviderElement(super.provider);

  @override
  String get category =>
      (origin as CategoriesPageRestaurantNotifierProvider).category;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
