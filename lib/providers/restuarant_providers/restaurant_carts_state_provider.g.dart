// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant_carts_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getDeliveryFeeHash() => r'6f63424639dc2e6bda7e288abb64060a0ba8df30';

/// See also [getDeliveryFee].
@ProviderFor(getDeliveryFee)
final getDeliveryFeeProvider = AutoDisposeFutureProvider<dynamic>.internal(
  getDeliveryFee,
  name: r'getDeliveryFeeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getDeliveryFeeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetDeliveryFeeRef = AutoDisposeFutureProviderRef<dynamic>;
String _$getCouponStatusHash() => r'fa522028d2d412978dc3702c1ddfb47a74c11965';

/// See also [getCouponStatus].
@ProviderFor(getCouponStatus)
final getCouponStatusProvider = AutoDisposeFutureProvider<bool>.internal(
  getCouponStatus,
  name: r'getCouponStatusProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getCouponStatusHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetCouponStatusRef = AutoDisposeFutureProviderRef<bool>;
String _$cartStateRestaurantHash() =>
    r'95a67d5d842c194992b6a8fdfbf86a7c529004f4';

/// See also [CartStateRestaurant].
@ProviderFor(CartStateRestaurant)
final cartStateRestaurantProvider =
    AutoDisposeNotifierProvider<CartStateRestaurant, CartStateModel>.internal(
  CartStateRestaurant.new,
  name: r'cartStateRestaurantProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$cartStateRestaurantHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CartStateRestaurant = AutoDisposeNotifier<CartStateModel>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
