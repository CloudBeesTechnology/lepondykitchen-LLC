// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coupon_detail_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$couponNotifierHash() => r'3409e5284538d3273f1f1a0d5cf0aba841c7c2cc';

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

abstract class _$CouponNotifier
    extends BuildlessAutoDisposeAsyncNotifier<CouponDetails?> {
  late final String couponCode;

  FutureOr<CouponDetails?> build(
    String couponCode,
  );
}

/// See also [CouponNotifier].
@ProviderFor(CouponNotifier)
const couponNotifierProvider = CouponNotifierFamily();

/// See also [CouponNotifier].
class CouponNotifierFamily extends Family<AsyncValue<CouponDetails?>> {
  /// See also [CouponNotifier].
  const CouponNotifierFamily();

  /// See also [CouponNotifier].
  CouponNotifierProvider call(
    String couponCode,
  ) {
    return CouponNotifierProvider(
      couponCode,
    );
  }

  @override
  CouponNotifierProvider getProviderOverride(
    covariant CouponNotifierProvider provider,
  ) {
    return call(
      provider.couponCode,
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
  String? get name => r'couponNotifierProvider';
}

/// See also [CouponNotifier].
class CouponNotifierProvider extends AutoDisposeAsyncNotifierProviderImpl<
    CouponNotifier, CouponDetails?> {
  /// See also [CouponNotifier].
  CouponNotifierProvider(
    String couponCode,
  ) : this._internal(
          () => CouponNotifier()..couponCode = couponCode,
          from: couponNotifierProvider,
          name: r'couponNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$couponNotifierHash,
          dependencies: CouponNotifierFamily._dependencies,
          allTransitiveDependencies:
              CouponNotifierFamily._allTransitiveDependencies,
          couponCode: couponCode,
        );

  CouponNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.couponCode,
  }) : super.internal();

  final String couponCode;

  @override
  FutureOr<CouponDetails?> runNotifierBuild(
    covariant CouponNotifier notifier,
  ) {
    return notifier.build(
      couponCode,
    );
  }

  @override
  Override overrideWith(CouponNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: CouponNotifierProvider._internal(
        () => create()..couponCode = couponCode,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        couponCode: couponCode,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<CouponNotifier, CouponDetails?>
      createElement() {
    return _CouponNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CouponNotifierProvider && other.couponCode == couponCode;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, couponCode.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CouponNotifierRef on AutoDisposeAsyncNotifierProviderRef<CouponDetails?> {
  /// The parameter `couponCode` of this provider.
  String get couponCode;
}

class _CouponNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<CouponNotifier,
        CouponDetails?> with CouponNotifierRef {
  _CouponNotifierProviderElement(super.provider);

  @override
  String get couponCode => (origin as CouponNotifierProvider).couponCode;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
