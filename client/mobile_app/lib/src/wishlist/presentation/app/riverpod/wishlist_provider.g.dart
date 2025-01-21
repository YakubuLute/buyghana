// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlist_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userWishlistHash() => r'87b000372f19008e982f8b8d78a61e58039d9c30';

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

abstract class _$UserWishlist
    extends BuildlessAutoDisposeNotifier<WishlistState> {
  late final GlobalKey<State<StatefulWidget>>? familyKey;

  WishlistState build([
    GlobalKey<State<StatefulWidget>>? familyKey,
  ]);
}

/// See also [UserWishlist].
@ProviderFor(UserWishlist)
const userWishlistProvider = UserWishlistFamily();

/// See also [UserWishlist].
class UserWishlistFamily extends Family<WishlistState> {
  /// See also [UserWishlist].
  const UserWishlistFamily();

  /// See also [UserWishlist].
  UserWishlistProvider call([
    GlobalKey<State<StatefulWidget>>? familyKey,
  ]) {
    return UserWishlistProvider(
      familyKey,
    );
  }

  @override
  UserWishlistProvider getProviderOverride(
    covariant UserWishlistProvider provider,
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
  String? get name => r'userWishlistProvider';
}

/// See also [UserWishlist].
class UserWishlistProvider
    extends AutoDisposeNotifierProviderImpl<UserWishlist, WishlistState> {
  /// See also [UserWishlist].
  UserWishlistProvider([
    GlobalKey<State<StatefulWidget>>? familyKey,
  ]) : this._internal(
          () => UserWishlist()..familyKey = familyKey,
          from: userWishlistProvider,
          name: r'userWishlistProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userWishlistHash,
          dependencies: UserWishlistFamily._dependencies,
          allTransitiveDependencies:
              UserWishlistFamily._allTransitiveDependencies,
          familyKey: familyKey,
        );

  UserWishlistProvider._internal(
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
  WishlistState runNotifierBuild(
    covariant UserWishlist notifier,
  ) {
    return notifier.build(
      familyKey,
    );
  }

  @override
  Override overrideWith(UserWishlist Function() create) {
    return ProviderOverride(
      origin: this,
      override: UserWishlistProvider._internal(
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
  AutoDisposeNotifierProviderElement<UserWishlist, WishlistState>
      createElement() {
    return _UserWishlistProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserWishlistProvider && other.familyKey == familyKey;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, familyKey.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin UserWishlistRef on AutoDisposeNotifierProviderRef<WishlistState> {
  /// The parameter `familyKey` of this provider.
  GlobalKey<State<StatefulWidget>>? get familyKey;
}

class _UserWishlistProviderElement
    extends AutoDisposeNotifierProviderElement<UserWishlist, WishlistState>
    with UserWishlistRef {
  _UserWishlistProviderElement(super.provider);

  @override
  GlobalKey<State<StatefulWidget>>? get familyKey =>
      (origin as UserWishlistProvider).familyKey;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
