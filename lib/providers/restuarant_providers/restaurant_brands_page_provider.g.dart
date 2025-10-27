// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant_brands_page_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$brandPageRestaurantNotifierHash() =>
    r'e5454c103655de269ea5256b5bac588ba22b8a71';

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

abstract class _$BrandPageRestaurantNotifier
    extends BuildlessAutoDisposeNotifier<BrandPageRestaurantState> {
  late final String category;

  BrandPageRestaurantState build(
    String category,
  );
}

/// See also [BrandPageRestaurantNotifier].
@ProviderFor(BrandPageRestaurantNotifier)
const brandPageRestaurantNotifierProvider = BrandPageRestaurantNotifierFamily();

/// See also [BrandPageRestaurantNotifier].
class BrandPageRestaurantNotifierFamily
    extends Family<BrandPageRestaurantState> {
  /// See also [BrandPageRestaurantNotifier].
  const BrandPageRestaurantNotifierFamily();

  /// See also [BrandPageRestaurantNotifier].
  BrandPageRestaurantNotifierProvider call(
    String category,
  ) {
    return BrandPageRestaurantNotifierProvider(
      category,
    );
  }

  @override
  BrandPageRestaurantNotifierProvider getProviderOverride(
    covariant BrandPageRestaurantNotifierProvider provider,
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
  String? get name => r'brandPageRestaurantNotifierProvider';
}

/// See also [BrandPageRestaurantNotifier].
class BrandPageRestaurantNotifierProvider
    extends AutoDisposeNotifierProviderImpl<BrandPageRestaurantNotifier,
        BrandPageRestaurantState> {
  /// See also [BrandPageRestaurantNotifier].
  BrandPageRestaurantNotifierProvider(
    String category,
  ) : this._internal(
          () => BrandPageRestaurantNotifier()..category = category,
          from: brandPageRestaurantNotifierProvider,
          name: r'brandPageRestaurantNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$brandPageRestaurantNotifierHash,
          dependencies: BrandPageRestaurantNotifierFamily._dependencies,
          allTransitiveDependencies:
              BrandPageRestaurantNotifierFamily._allTransitiveDependencies,
          category: category,
        );

  BrandPageRestaurantNotifierProvider._internal(
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
  BrandPageRestaurantState runNotifierBuild(
    covariant BrandPageRestaurantNotifier notifier,
  ) {
    return notifier.build(
      category,
    );
  }

  @override
  Override overrideWith(BrandPageRestaurantNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: BrandPageRestaurantNotifierProvider._internal(
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
  AutoDisposeNotifierProviderElement<BrandPageRestaurantNotifier,
      BrandPageRestaurantState> createElement() {
    return _BrandPageRestaurantNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BrandPageRestaurantNotifierProvider &&
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
mixin BrandPageRestaurantNotifierRef
    on AutoDisposeNotifierProviderRef<BrandPageRestaurantState> {
  /// The parameter `category` of this provider.
  String get category;
}

class _BrandPageRestaurantNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<BrandPageRestaurantNotifier,
        BrandPageRestaurantState> with BrandPageRestaurantNotifierRef {
  _BrandPageRestaurantNotifierProviderElement(super.provider);

  @override
  String get category =>
      (origin as BrandPageRestaurantNotifierProvider).category;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
