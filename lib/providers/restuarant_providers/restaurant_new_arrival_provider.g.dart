// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant_new_arrival_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$newArrivalStreamRestaurantHash() =>
    r'a7c4df746f7cbd60af55392818fcbce47b3e04ba';

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

/// See also [newArrivalStreamRestaurant].
@ProviderFor(newArrivalStreamRestaurant)
const newArrivalStreamRestaurantProvider = NewArrivalStreamRestaurantFamily();

/// See also [newArrivalStreamRestaurant].
class NewArrivalStreamRestaurantFamily
    extends Family<AsyncValue<List<ProductsModel>>> {
  /// See also [newArrivalStreamRestaurant].
  const NewArrivalStreamRestaurantFamily();

  /// See also [newArrivalStreamRestaurant].
  NewArrivalStreamRestaurantProvider call(
    String module,
  ) {
    return NewArrivalStreamRestaurantProvider(
      module,
    );
  }

  @override
  NewArrivalStreamRestaurantProvider getProviderOverride(
    covariant NewArrivalStreamRestaurantProvider provider,
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
  String? get name => r'newArrivalStreamRestaurantProvider';
}

/// See also [newArrivalStreamRestaurant].
class NewArrivalStreamRestaurantProvider
    extends AutoDisposeStreamProvider<List<ProductsModel>> {
  /// See also [newArrivalStreamRestaurant].
  NewArrivalStreamRestaurantProvider(
    String module,
  ) : this._internal(
          (ref) => newArrivalStreamRestaurant(
            ref as NewArrivalStreamRestaurantRef,
            module,
          ),
          from: newArrivalStreamRestaurantProvider,
          name: r'newArrivalStreamRestaurantProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$newArrivalStreamRestaurantHash,
          dependencies: NewArrivalStreamRestaurantFamily._dependencies,
          allTransitiveDependencies:
              NewArrivalStreamRestaurantFamily._allTransitiveDependencies,
          module: module,
        );

  NewArrivalStreamRestaurantProvider._internal(
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
    Stream<List<ProductsModel>> Function(NewArrivalStreamRestaurantRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: NewArrivalStreamRestaurantProvider._internal(
        (ref) => create(ref as NewArrivalStreamRestaurantRef),
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
  AutoDisposeStreamProviderElement<List<ProductsModel>> createElement() {
    return _NewArrivalStreamRestaurantProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is NewArrivalStreamRestaurantProvider &&
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
mixin NewArrivalStreamRestaurantRef
    on AutoDisposeStreamProviderRef<List<ProductsModel>> {
  /// The parameter `module` of this provider.
  String get module;
}

class _NewArrivalStreamRestaurantProviderElement
    extends AutoDisposeStreamProviderElement<List<ProductsModel>>
    with NewArrivalStreamRestaurantRef {
  _NewArrivalStreamRestaurantProviderElement(super.provider);

  @override
  String get module => (origin as NewArrivalStreamRestaurantProvider).module;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
