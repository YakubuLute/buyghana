// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_adapter_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$orderAdapterHash() => r'b59d6173e3e14836a5951dc190edc27c7f86f190';

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

abstract class _$OrderAdapter
    extends BuildlessAutoDisposeNotifier<OrderAdapterState> {
  late final GlobalKey<State<StatefulWidget>>? familyKey;

  OrderAdapterState build([
    GlobalKey<State<StatefulWidget>>? familyKey,
  ]);
}

/// See also [OrderAdapter].
@ProviderFor(OrderAdapter)
const orderAdapterProvider = OrderAdapterFamily();

/// See also [OrderAdapter].
class OrderAdapterFamily extends Family<OrderAdapterState> {
  /// See also [OrderAdapter].
  const OrderAdapterFamily();

  /// See also [OrderAdapter].
  OrderAdapterProvider call([
    GlobalKey<State<StatefulWidget>>? familyKey,
  ]) {
    return OrderAdapterProvider(
      familyKey,
    );
  }

  @override
  OrderAdapterProvider getProviderOverride(
    covariant OrderAdapterProvider provider,
  ) {
    return call(
      provider.familyKey,
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
  String? get name => r'orderAdapterProvider';
}

/// See also [OrderAdapter].
class OrderAdapterProvider
    extends AutoDisposeNotifierProviderImpl<OrderAdapter, OrderAdapterState> {
  /// See also [OrderAdapter].
  OrderAdapterProvider([
    GlobalKey<State<StatefulWidget>>? familyKey,
  ]) : this._internal(
          () => OrderAdapter()..familyKey = familyKey,
          from: orderAdapterProvider,
          name: r'orderAdapterProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$orderAdapterHash,
          dependencies: OrderAdapterFamily._dependencies,
          allTransitiveDependencies:
              OrderAdapterFamily._allTransitiveDependencies,
          familyKey: familyKey,
        );

  OrderAdapterProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.familyKey,
  }) : super.internal();

  final GlobalKey<State<StatefulWidget>>? familyKey;

  @override
  OrderAdapterState runNotifierBuild(
    covariant OrderAdapter notifier,
  ) {
    return notifier.build(
      familyKey,
    );
  }

  @override
  Override overrideWith(OrderAdapter Function() create) {
    return ProviderOverride(
      origin: this,
      override: OrderAdapterProvider._internal(
        () => create()..familyKey = familyKey,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        familyKey: familyKey,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<OrderAdapter, OrderAdapterState>
      createElement() {
    return _OrderAdapterProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is OrderAdapterProvider && other.familyKey == familyKey;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, familyKey.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin OrderAdapterRef on AutoDisposeNotifierProviderRef<OrderAdapterState> {
  /// The parameter `familyKey` of this provider.
  GlobalKey<State<StatefulWidget>>? get familyKey;
}

class _OrderAdapterProviderElement
    extends AutoDisposeNotifierProviderElement<OrderAdapter, OrderAdapterState>
    with OrderAdapterRef {
  _OrderAdapterProviderElement(super.provider);

  @override
  GlobalKey<State<StatefulWidget>>? get familyKey =>
      (origin as OrderAdapterProvider).familyKey;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
