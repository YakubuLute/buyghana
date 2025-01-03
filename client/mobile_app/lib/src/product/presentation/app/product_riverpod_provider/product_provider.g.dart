// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$productAdapterHash() => r'16d4ff845f0e5a0ca86ca484e9c9226ee0e32458';

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

abstract class _$ProductAdapter
    extends BuildlessAutoDisposeNotifier<ProductState> {
  late final GlobalKey<State<StatefulWidget>>? familyKey;

  ProductState build([
    GlobalKey<State<StatefulWidget>>? familyKey,
  ]);
}

/// See also [ProductAdapter].
@ProviderFor(ProductAdapter)
const productAdapterProvider = ProductAdapterFamily();

/// See also [ProductAdapter].
class ProductAdapterFamily extends Family<ProductState> {
  /// See also [ProductAdapter].
  const ProductAdapterFamily();

  /// See also [ProductAdapter].
  ProductAdapterProvider call([
    GlobalKey<State<StatefulWidget>>? familyKey,
  ]) {
    return ProductAdapterProvider(
      familyKey,
    );
  }

  @override
  ProductAdapterProvider getProviderOverride(
    covariant ProductAdapterProvider provider,
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
  String? get name => r'productAdapterProvider';
}

/// See also [ProductAdapter].
class ProductAdapterProvider
    extends AutoDisposeNotifierProviderImpl<ProductAdapter, ProductState> {
  /// See also [ProductAdapter].
  ProductAdapterProvider([
    GlobalKey<State<StatefulWidget>>? familyKey,
  ]) : this._internal(
          () => ProductAdapter()..familyKey = familyKey,
          from: productAdapterProvider,
          name: r'productAdapterProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$productAdapterHash,
          dependencies: ProductAdapterFamily._dependencies,
          allTransitiveDependencies:
              ProductAdapterFamily._allTransitiveDependencies,
          familyKey: familyKey,
        );

  ProductAdapterProvider._internal(
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
  ProductState runNotifierBuild(
    covariant ProductAdapter notifier,
  ) {
    return notifier.build(
      familyKey,
    );
  }

  @override
  Override overrideWith(ProductAdapter Function() create) {
    return ProviderOverride(
      origin: this,
      override: ProductAdapterProvider._internal(
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
  AutoDisposeNotifierProviderElement<ProductAdapter, ProductState>
      createElement() {
    return _ProductAdapterProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductAdapterProvider && other.familyKey == familyKey;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, familyKey.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ProductAdapterRef on AutoDisposeNotifierProviderRef<ProductState> {
  /// The parameter `familyKey` of this provider.
  GlobalKey<State<StatefulWidget>>? get familyKey;
}

class _ProductAdapterProviderElement
    extends AutoDisposeNotifierProviderElement<ProductAdapter, ProductState>
    with ProductAdapterRef {
  _ProductAdapterProviderElement(super.provider);

  @override
  GlobalKey<State<StatefulWidget>>? get familyKey =>
      (origin as ProductAdapterProvider).familyKey;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
