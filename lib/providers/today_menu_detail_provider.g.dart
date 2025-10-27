// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'today_menu_detail_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$todayMenuDetailProviderHash() =>
    r'51a23b662e8beaab232028d537e7046882f4da12';

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

abstract class _$TodayMenuDetailProvider
    extends BuildlessAutoDisposeAsyncNotifier<TodayMenuModel?> {
  late final String menuID;

  FutureOr<TodayMenuModel?> build(
    String menuID,
  );
}

/// See also [TodayMenuDetailProvider].
@ProviderFor(TodayMenuDetailProvider)
const todayMenuDetailProviderProvider = TodayMenuDetailProviderFamily();

/// See also [TodayMenuDetailProvider].
class TodayMenuDetailProviderFamily
    extends Family<AsyncValue<TodayMenuModel?>> {
  /// See also [TodayMenuDetailProvider].
  const TodayMenuDetailProviderFamily();

  /// See also [TodayMenuDetailProvider].
  TodayMenuDetailProviderProvider call(
    String menuID,
  ) {
    return TodayMenuDetailProviderProvider(
      menuID,
    );
  }

  @override
  TodayMenuDetailProviderProvider getProviderOverride(
    covariant TodayMenuDetailProviderProvider provider,
  ) {
    return call(
      provider.menuID,
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
  String? get name => r'todayMenuDetailProviderProvider';
}

/// See also [TodayMenuDetailProvider].
class TodayMenuDetailProviderProvider
    extends AutoDisposeAsyncNotifierProviderImpl<TodayMenuDetailProvider,
        TodayMenuModel?> {
  /// See also [TodayMenuDetailProvider].
  TodayMenuDetailProviderProvider(
    String menuID,
  ) : this._internal(
          () => TodayMenuDetailProvider()..menuID = menuID,
          from: todayMenuDetailProviderProvider,
          name: r'todayMenuDetailProviderProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$todayMenuDetailProviderHash,
          dependencies: TodayMenuDetailProviderFamily._dependencies,
          allTransitiveDependencies:
              TodayMenuDetailProviderFamily._allTransitiveDependencies,
          menuID: menuID,
        );

  TodayMenuDetailProviderProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.menuID,
  }) : super.internal();

  final String menuID;

  @override
  FutureOr<TodayMenuModel?> runNotifierBuild(
    covariant TodayMenuDetailProvider notifier,
  ) {
    return notifier.build(
      menuID,
    );
  }

  @override
  Override overrideWith(TodayMenuDetailProvider Function() create) {
    return ProviderOverride(
      origin: this,
      override: TodayMenuDetailProviderProvider._internal(
        () => create()..menuID = menuID,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        menuID: menuID,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<TodayMenuDetailProvider,
      TodayMenuModel?> createElement() {
    return _TodayMenuDetailProviderProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TodayMenuDetailProviderProvider && other.menuID == menuID;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, menuID.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TodayMenuDetailProviderRef
    on AutoDisposeAsyncNotifierProviderRef<TodayMenuModel?> {
  /// The parameter `menuID` of this provider.
  String get menuID;
}

class _TodayMenuDetailProviderProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<TodayMenuDetailProvider,
        TodayMenuModel?> with TodayMenuDetailProviderRef {
  _TodayMenuDetailProviderProviderElement(super.provider);

  @override
  String get menuID => (origin as TodayMenuDetailProviderProvider).menuID;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
