// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$cartAdapterHash() => r'd5139b2379c98b502d473e4c0d9f89253b6e1d44';

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

abstract class _$CartAdapter extends BuildlessAutoDisposeNotifier<CartState> {
  late final GlobalKey<State<StatefulWidget>>? familyKey;

  CartState build([
    GlobalKey<State<StatefulWidget>>? familyKey,
  ]);
}

/// See also [CartAdapter].
@ProviderFor(CartAdapter)
const cartAdapterProvider = CartAdapterFamily();

/// See also [CartAdapter].
class CartAdapterFamily extends Family<CartState> {
  /// See also [CartAdapter].
  const CartAdapterFamily();

  /// See also [CartAdapter].
  CartAdapterProvider call([
    GlobalKey<State<StatefulWidget>>? familyKey,
  ]) {
    return CartAdapterProvider(
      familyKey,
    );
  }

  @override
  CartAdapterProvider getProviderOverride(
    covariant CartAdapterProvider provider,
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
  String? get name => r'cartAdapterProvider';
}

/// See also [CartAdapter].
class CartAdapterProvider
    extends AutoDisposeNotifierProviderImpl<CartAdapter, CartState> {
  /// See also [CartAdapter].
  CartAdapterProvider([
    GlobalKey<State<StatefulWidget>>? familyKey,
  ]) : this._internal(
          () => CartAdapter()..familyKey = familyKey,
          from: cartAdapterProvider,
          name: r'cartAdapterProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$cartAdapterHash,
          dependencies: CartAdapterFamily._dependencies,
          allTransitiveDependencies:
              CartAdapterFamily._allTransitiveDependencies,
          familyKey: familyKey,
        );

  CartAdapterProvider._internal(
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
  CartState runNotifierBuild(
    covariant CartAdapter notifier,
  ) {
    return notifier.build(
      familyKey,
    );
  }

  @override
  Override overrideWith(CartAdapter Function() create) {
    return ProviderOverride(
      origin: this,
      override: CartAdapterProvider._internal(
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
  AutoDisposeNotifierProviderElement<CartAdapter, CartState> createElement() {
    return _CartAdapterProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CartAdapterProvider && other.familyKey == familyKey;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, familyKey.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin CartAdapterRef on AutoDisposeNotifierProviderRef<CartState> {
  /// The parameter `familyKey` of this provider.
  GlobalKey<State<StatefulWidget>>? get familyKey;
}

class _CartAdapterProviderElement
    extends AutoDisposeNotifierProviderElement<CartAdapter, CartState>
    with CartAdapterRef {
  _CartAdapterProviderElement(super.provider);

  @override
  GlobalKey<State<StatefulWidget>>? get familyKey =>
      (origin as CartAdapterProvider).familyKey;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
