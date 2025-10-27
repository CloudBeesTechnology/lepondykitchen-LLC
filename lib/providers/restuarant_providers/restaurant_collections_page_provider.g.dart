// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant_collections_page_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$collectionsPageRestaurantNotifierHash() =>
    r'cdb7a634b8e481ff3a4e7515c2c8db0c0af21076';

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

abstract class _$CollectionsPageRestaurantNotifier
    extends BuildlessAutoDisposeNotifier<BrandPageState> {
  late final String category;

  BrandPageState build(
    String category,
  );
}

/// See also [CollectionsPageRestaurantNotifier].
@ProviderFor(CollectionsPageRestaurantNotifier)
const collectionsPageRestaurantNotifierProvider =
    CollectionsPageRestaurantNotifierFamily();

/// See also [CollectionsPageRestaurantNotifier].
class CollectionsPageRestaurantNotifierFamily extends Family<BrandPageState> {
  /// See also [CollectionsPageRestaurantNotifier].
  const CollectionsPageRestaurantNotifierFamily();

  /// See also [CollectionsPageRestaurantNotifier].
  CollectionsPageRestaurantNotifierProvider call(
    String category,
  ) {
    return CollectionsPageRestaurantNotifierProvider(
      category,
    );
  }

  @override
  CollectionsPageRestaurantNotifierProvider getProviderOverride(
    covariant CollectionsPageRestaurantNotifierProvider provider,
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
  String? get name => r'collectionsPageRestaurantNotifierProvider';
}

/// See also [CollectionsPageRestaurantNotifier].
class CollectionsPageRestaurantNotifierProvider
    extends AutoDisposeNotifierProviderImpl<CollectionsPageRestaurantNotifier,
        BrandPageState> {
  /// See also [CollectionsPageRestaurantNotifier].
  CollectionsPageRestaurantNotifierProvider(
    String category,
  ) : this._internal(
          () => CollectionsPageRestaurantNotifier()..category = category,
          from: collectionsPageRestaurantNotifierProvider,
          name: r'collectionsPageRestaurantNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$collectionsPageRestaurantNotifierHash,
          dependencies: CollectionsPageRestaurantNotifierFamily._dependencies,
          allTransitiveDependencies: CollectionsPageRestaurantNotifierFamily
              ._allTransitiveDependencies,
          category: category,
        );

  CollectionsPageRestaurantNotifierProvider._internal(
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
    covariant CollectionsPageRestaurantNotifier notifier,
  ) {
    return notifier.build(
      category,
    );
  }

  @override
  Override overrideWith(CollectionsPageRestaurantNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: CollectionsPageRestaurantNotifierProvider._internal(
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
  AutoDisposeNotifierProviderElement<CollectionsPageRestaurantNotifier,
      BrandPageState> createElement() {
    return _CollectionsPageRestaurantNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CollectionsPageRestaurantNotifierProvider &&
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
mixin CollectionsPageRestaurantNotifierRef
    on AutoDisposeNotifierProviderRef<BrandPageState> {
  /// The parameter `category` of this provider.
  String get category;
}

class _CollectionsPageRestaurantNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<
        CollectionsPageRestaurantNotifier,
        BrandPageState> with CollectionsPageRestaurantNotifierRef {
  _CollectionsPageRestaurantNotifierProviderElement(super.provider);

  @override
  String get category =>
      (origin as CollectionsPageRestaurantNotifierProvider).category;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
