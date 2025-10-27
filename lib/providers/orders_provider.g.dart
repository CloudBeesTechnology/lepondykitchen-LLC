// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orders_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$ordersStreamHash() => r'1d3c19888b7c5284233ae1791681d296001af513';

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

/// See also [ordersStream].
@ProviderFor(ordersStream)
const ordersStreamProvider = OrdersStreamFamily();

/// See also [ordersStream].
class OrdersStreamFamily extends Family<AsyncValue<List<OrderModel2>>> {
  /// See also [ordersStream].
  const OrdersStreamFamily();

  /// See also [ordersStream].
  OrdersStreamProvider call(
    String status,
  ) {
    return OrdersStreamProvider(
      status,
    );
  }

  @override
  OrdersStreamProvider getProviderOverride(
    covariant OrdersStreamProvider provider,
  ) {
    return call(
      provider.status,
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
  String? get name => r'ordersStreamProvider';
}

/// See also [ordersStream].
class OrdersStreamProvider
    extends AutoDisposeStreamProvider<List<OrderModel2>> {
  /// See also [ordersStream].
  OrdersStreamProvider(
    String status,
  ) : this._internal(
          (ref) => ordersStream(
            ref as OrdersStreamRef,
            status,
          ),
          from: ordersStreamProvider,
          name: r'ordersStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$ordersStreamHash,
          dependencies: OrdersStreamFamily._dependencies,
          allTransitiveDependencies:
              OrdersStreamFamily._allTransitiveDependencies,
          status: status,
        );

  OrdersStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.status,
  }) : super.internal();

  final String status;

  @override
  Override overrideWith(
    Stream<List<OrderModel2>> Function(OrdersStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: OrdersStreamProvider._internal(
        (ref) => create(ref as OrdersStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        status: status,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<OrderModel2>> createElement() {
    return _OrdersStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is OrdersStreamProvider && other.status == status;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, status.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin OrdersStreamRef on AutoDisposeStreamProviderRef<List<OrderModel2>> {
  /// The parameter `status` of this provider.
  String get status;
}

class _OrdersStreamProviderElement
    extends AutoDisposeStreamProviderElement<List<OrderModel2>>
    with OrdersStreamRef {
  _OrdersStreamProviderElement(super.provider);

  @override
  String get status => (origin as OrdersStreamProvider).status;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
