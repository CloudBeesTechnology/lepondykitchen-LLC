// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track_order_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$trackOrderProviderHash() =>
    r'b02c18ca1ad70fd20e0c19ad9444ccc95d1a1c17';

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

/// See also [trackOrderProvider].
@ProviderFor(trackOrderProvider)
const trackOrderProviderProvider = TrackOrderProviderFamily();

/// See also [trackOrderProvider].
class TrackOrderProviderFamily extends Family<Object?> {
  /// See also [trackOrderProvider].
  const TrackOrderProviderFamily();

  /// See also [trackOrderProvider].
  TrackOrderProviderProvider call(
    String orderID,
    BuildContext context,
  ) {
    return TrackOrderProviderProvider(
      orderID,
      context,
    );
  }

  @override
  TrackOrderProviderProvider getProviderOverride(
    covariant TrackOrderProviderProvider provider,
  ) {
    return call(
      provider.orderID,
      provider.context,
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
  String? get name => r'trackOrderProviderProvider';
}

/// See also [trackOrderProvider].
class TrackOrderProviderProvider extends AutoDisposeProvider<Object?> {
  /// See also [trackOrderProvider].
  TrackOrderProviderProvider(
    String orderID,
    BuildContext context,
  ) : this._internal(
          (ref) => trackOrderProvider(
            ref as TrackOrderProviderRef,
            orderID,
            context,
          ),
          from: trackOrderProviderProvider,
          name: r'trackOrderProviderProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$trackOrderProviderHash,
          dependencies: TrackOrderProviderFamily._dependencies,
          allTransitiveDependencies:
              TrackOrderProviderFamily._allTransitiveDependencies,
          orderID: orderID,
          context: context,
        );

  TrackOrderProviderProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.orderID,
    required this.context,
  }) : super.internal();

  final String orderID;
  final BuildContext context;

  @override
  Override overrideWith(
    Object? Function(TrackOrderProviderRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TrackOrderProviderProvider._internal(
        (ref) => create(ref as TrackOrderProviderRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        orderID: orderID,
        context: context,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<Object?> createElement() {
    return _TrackOrderProviderProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TrackOrderProviderProvider &&
        other.orderID == orderID &&
        other.context == context;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, orderID.hashCode);
    hash = _SystemHash.combine(hash, context.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TrackOrderProviderRef on AutoDisposeProviderRef<Object?> {
  /// The parameter `orderID` of this provider.
  String get orderID;

  /// The parameter `context` of this provider.
  BuildContext get context;
}

class _TrackOrderProviderProviderElement
    extends AutoDisposeProviderElement<Object?> with TrackOrderProviderRef {
  _TrackOrderProviderProviderElement(super.provider);

  @override
  String get orderID => (origin as TrackOrderProviderProvider).orderID;
  @override
  BuildContext get context => (origin as TrackOrderProviderProvider).context;
}

String _$trackParcelOrderProviderHash() =>
    r'efe1d17917cc73fb4f656fabe054d4c9ce8f4902';

/// See also [trackParcelOrderProvider].
@ProviderFor(trackParcelOrderProvider)
const trackParcelOrderProviderProvider = TrackParcelOrderProviderFamily();

/// See also [trackParcelOrderProvider].
class TrackParcelOrderProviderFamily extends Family<Object?> {
  /// See also [trackParcelOrderProvider].
  const TrackParcelOrderProviderFamily();

  /// See also [trackParcelOrderProvider].
  TrackParcelOrderProviderProvider call(
    String orderID,
    BuildContext context,
  ) {
    return TrackParcelOrderProviderProvider(
      orderID,
      context,
    );
  }

  @override
  TrackParcelOrderProviderProvider getProviderOverride(
    covariant TrackParcelOrderProviderProvider provider,
  ) {
    return call(
      provider.orderID,
      provider.context,
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
  String? get name => r'trackParcelOrderProviderProvider';
}

/// See also [trackParcelOrderProvider].
class TrackParcelOrderProviderProvider extends AutoDisposeProvider<Object?> {
  /// See also [trackParcelOrderProvider].
  TrackParcelOrderProviderProvider(
    String orderID,
    BuildContext context,
  ) : this._internal(
          (ref) => trackParcelOrderProvider(
            ref as TrackParcelOrderProviderRef,
            orderID,
            context,
          ),
          from: trackParcelOrderProviderProvider,
          name: r'trackParcelOrderProviderProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$trackParcelOrderProviderHash,
          dependencies: TrackParcelOrderProviderFamily._dependencies,
          allTransitiveDependencies:
              TrackParcelOrderProviderFamily._allTransitiveDependencies,
          orderID: orderID,
          context: context,
        );

  TrackParcelOrderProviderProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.orderID,
    required this.context,
  }) : super.internal();

  final String orderID;
  final BuildContext context;

  @override
  Override overrideWith(
    Object? Function(TrackParcelOrderProviderRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TrackParcelOrderProviderProvider._internal(
        (ref) => create(ref as TrackParcelOrderProviderRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        orderID: orderID,
        context: context,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<Object?> createElement() {
    return _TrackParcelOrderProviderProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TrackParcelOrderProviderProvider &&
        other.orderID == orderID &&
        other.context == context;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, orderID.hashCode);
    hash = _SystemHash.combine(hash, context.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TrackParcelOrderProviderRef on AutoDisposeProviderRef<Object?> {
  /// The parameter `orderID` of this provider.
  String get orderID;

  /// The parameter `context` of this provider.
  BuildContext get context;
}

class _TrackParcelOrderProviderProviderElement
    extends AutoDisposeProviderElement<Object?>
    with TrackParcelOrderProviderRef {
  _TrackParcelOrderProviderProviderElement(super.provider);

  @override
  String get orderID => (origin as TrackParcelOrderProviderProvider).orderID;
  @override
  BuildContext get context =>
      (origin as TrackParcelOrderProviderProvider).context;
}

String _$fetchTrackingOrderDetailHash() =>
    r'acf540a0401d2edda7384139af64adde147d4f18';

/// See also [fetchTrackingOrderDetail].
@ProviderFor(fetchTrackingOrderDetail)
const fetchTrackingOrderDetailProvider = FetchTrackingOrderDetailFamily();

/// See also [fetchTrackingOrderDetail].
class FetchTrackingOrderDetailFamily extends Family<AsyncValue<OrderModel2>> {
  /// See also [fetchTrackingOrderDetail].
  const FetchTrackingOrderDetailFamily();

  /// See also [fetchTrackingOrderDetail].
  FetchTrackingOrderDetailProvider call(
    String orderID,
  ) {
    return FetchTrackingOrderDetailProvider(
      orderID,
    );
  }

  @override
  FetchTrackingOrderDetailProvider getProviderOverride(
    covariant FetchTrackingOrderDetailProvider provider,
  ) {
    return call(
      provider.orderID,
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
  String? get name => r'fetchTrackingOrderDetailProvider';
}

/// See also [fetchTrackingOrderDetail].
class FetchTrackingOrderDetailProvider
    extends AutoDisposeFutureProvider<OrderModel2> {
  /// See also [fetchTrackingOrderDetail].
  FetchTrackingOrderDetailProvider(
    String orderID,
  ) : this._internal(
          (ref) => fetchTrackingOrderDetail(
            ref as FetchTrackingOrderDetailRef,
            orderID,
          ),
          from: fetchTrackingOrderDetailProvider,
          name: r'fetchTrackingOrderDetailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchTrackingOrderDetailHash,
          dependencies: FetchTrackingOrderDetailFamily._dependencies,
          allTransitiveDependencies:
              FetchTrackingOrderDetailFamily._allTransitiveDependencies,
          orderID: orderID,
        );

  FetchTrackingOrderDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.orderID,
  }) : super.internal();

  final String orderID;

  @override
  Override overrideWith(
    FutureOr<OrderModel2> Function(FetchTrackingOrderDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchTrackingOrderDetailProvider._internal(
        (ref) => create(ref as FetchTrackingOrderDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        orderID: orderID,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<OrderModel2> createElement() {
    return _FetchTrackingOrderDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchTrackingOrderDetailProvider &&
        other.orderID == orderID;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, orderID.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FetchTrackingOrderDetailRef on AutoDisposeFutureProviderRef<OrderModel2> {
  /// The parameter `orderID` of this provider.
  String get orderID;
}

class _FetchTrackingOrderDetailProviderElement
    extends AutoDisposeFutureProviderElement<OrderModel2>
    with FetchTrackingOrderDetailRef {
  _FetchTrackingOrderDetailProviderElement(super.provider);

  @override
  String get orderID => (origin as FetchTrackingOrderDetailProvider).orderID;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
