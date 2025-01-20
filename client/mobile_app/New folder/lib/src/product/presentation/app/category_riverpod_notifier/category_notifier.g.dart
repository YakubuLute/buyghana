// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$categoryNotifierHash() => r'8013951c8df1523daf6b109773a4c0e2d3ca51fe';

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

abstract class _$CategoryNotifier
    extends BuildlessAutoDisposeNotifier<ProductCategory> {
  late final GlobalKey<State<StatefulWidget>>? familyKey;

  ProductCategory build([
    GlobalKey<State<StatefulWidget>>? familyKey,
  ]);
}

/// See also [CategoryNotifier].
@ProviderFor(CategoryNotifier)
const categoryNotifierProvider = CategoryNotifierFamily();

/// See also [CategoryNotifier].
class CategoryNotifierFamily extends Family<ProductCategory> {
  /// See also [CategoryNotifier].
  const CategoryNotifierFamily();

  /// See also [CategoryNotifier].
  CategoryNotifierProvider call([
    GlobalKey<State<StatefulWidget>>? familyKey,
  ]) {
    return CategoryNotifierProvider(
      familyKey,
    );
  }

  @override
  CategoryNotifierProvider getProviderOverride(
    covariant CategoryNotifierProvider provider,
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
  String? get name => r'categoryNotifierProvider';
}

/// See also [CategoryNotifier].
class CategoryNotifierProvider
    extends AutoDisposeNotifierProviderImpl<CategoryNotifier, ProductCategory> {
  /// See also [CategoryNotifier].
  CategoryNotifierProvider([
    GlobalKey<State<StatefulWidget>>? familyKey,
  ]) : this._internal(
          () => CategoryNotifier()..familyKey = familyKey,
          from: categoryNotifierProvider,
          name: r'categoryNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$categoryNotifierHash,
          dependencies: CategoryNotifierFamily._dependencies,
          allTransitiveDependencies:
              CategoryNotifierFamily._allTransitiveDependencies,
          familyKey: familyKey,
        );

  CategoryNotifierProvider._internal(
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
  ProductCategory runNotifierBuild(
    covariant CategoryNotifier notifier,
  ) {
    return notifier.build(
      familyKey,
    );
  }

  @override
  Override overrideWith(CategoryNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: CategoryNotifierProvider._internal(
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
  AutoDisposeNotifierProviderElement<CategoryNotifier, ProductCategory>
      createElement() {
    return _CategoryNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CategoryNotifierProvider && other.familyKey == familyKey;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, familyKey.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin CategoryNotifierRef on AutoDisposeNotifierProviderRef<ProductCategory> {
  /// The parameter `familyKey` of this provider.
  GlobalKey<State<StatefulWidget>>? get familyKey;
}

class _CategoryNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<CategoryNotifier,
        ProductCategory> with CategoryNotifierRef {
  _CategoryNotifierProviderElement(super.provider);

  @override
  GlobalKey<State<StatefulWidget>>? get familyKey =>
      (origin as CategoryNotifierProvider).familyKey;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
