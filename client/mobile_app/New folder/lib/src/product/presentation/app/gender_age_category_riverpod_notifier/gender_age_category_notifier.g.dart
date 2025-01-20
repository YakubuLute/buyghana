// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gender_age_category_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$genderAgeCategoryNotifierHash() =>
    r'bf40695c4d8d7d4f87644ad6f405abfa93a357c2';

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

abstract class _$GenderAgeCategoryNotifier
    extends BuildlessAutoDisposeNotifier<GenderAgeCategory> {
  late final GlobalKey<State<StatefulWidget>>? familyKey;

  GenderAgeCategory build([
    GlobalKey<State<StatefulWidget>>? familyKey,
  ]);
}

/// See also [GenderAgeCategoryNotifier].
@ProviderFor(GenderAgeCategoryNotifier)
const genderAgeCategoryNotifierProvider = GenderAgeCategoryNotifierFamily();

/// See also [GenderAgeCategoryNotifier].
class GenderAgeCategoryNotifierFamily extends Family<GenderAgeCategory> {
  /// See also [GenderAgeCategoryNotifier].
  const GenderAgeCategoryNotifierFamily();

  /// See also [GenderAgeCategoryNotifier].
  GenderAgeCategoryNotifierProvider call([
    GlobalKey<State<StatefulWidget>>? familyKey,
  ]) {
    return GenderAgeCategoryNotifierProvider(
      familyKey,
    );
  }

  @override
  GenderAgeCategoryNotifierProvider getProviderOverride(
    covariant GenderAgeCategoryNotifierProvider provider,
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
  String? get name => r'genderAgeCategoryNotifierProvider';
}

/// See also [GenderAgeCategoryNotifier].
class GenderAgeCategoryNotifierProvider extends AutoDisposeNotifierProviderImpl<
    GenderAgeCategoryNotifier, GenderAgeCategory> {
  /// See also [GenderAgeCategoryNotifier].
  GenderAgeCategoryNotifierProvider([
    GlobalKey<State<StatefulWidget>>? familyKey,
  ]) : this._internal(
          () => GenderAgeCategoryNotifier()..familyKey = familyKey,
          from: genderAgeCategoryNotifierProvider,
          name: r'genderAgeCategoryNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$genderAgeCategoryNotifierHash,
          dependencies: GenderAgeCategoryNotifierFamily._dependencies,
          allTransitiveDependencies:
              GenderAgeCategoryNotifierFamily._allTransitiveDependencies,
          familyKey: familyKey,
        );

  GenderAgeCategoryNotifierProvider._internal(
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
  GenderAgeCategory runNotifierBuild(
    covariant GenderAgeCategoryNotifier notifier,
  ) {
    return notifier.build(
      familyKey,
    );
  }

  @override
  Override overrideWith(GenderAgeCategoryNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: GenderAgeCategoryNotifierProvider._internal(
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
  AutoDisposeNotifierProviderElement<GenderAgeCategoryNotifier,
      GenderAgeCategory> createElement() {
    return _GenderAgeCategoryNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GenderAgeCategoryNotifierProvider &&
        other.familyKey == familyKey;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, familyKey.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GenderAgeCategoryNotifierRef
    on AutoDisposeNotifierProviderRef<GenderAgeCategory> {
  /// The parameter `familyKey` of this provider.
  GlobalKey<State<StatefulWidget>>? get familyKey;
}

class _GenderAgeCategoryNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<GenderAgeCategoryNotifier,
        GenderAgeCategory> with GenderAgeCategoryNotifierRef {
  _GenderAgeCategoryNotifierProviderElement(super.provider);

  @override
  GlobalKey<State<StatefulWidget>>? get familyKey =>
      (origin as GenderAgeCategoryNotifierProvider).familyKey;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
