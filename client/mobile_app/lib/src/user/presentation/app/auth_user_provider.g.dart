// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_user_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authUserHash() => r'c40171fa01beacdcb2d3a4b7b67b26fa8d6c2826';

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

abstract class _$AuthUser extends BuildlessAutoDisposeNotifier<AuthUserState> {
  late final GlobalKey<State<StatefulWidget>>? familyKey;

  AuthUserState build([
    GlobalKey<State<StatefulWidget>>? familyKey,
  ]);
}

/// See also [AuthUser].
@ProviderFor(AuthUser)
const authUserProvider = AuthUserFamily();

/// See also [AuthUser].
class AuthUserFamily extends Family<AuthUserState> {
  /// See also [AuthUser].
  const AuthUserFamily();

  /// See also [AuthUser].
  AuthUserProvider call([
    GlobalKey<State<StatefulWidget>>? familyKey,
  ]) {
    return AuthUserProvider(
      familyKey,
    );
  }

  @override
  AuthUserProvider getProviderOverride(
    covariant AuthUserProvider provider,
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
  String? get name => r'authUserProvider';
}

/// See also [AuthUser].
class AuthUserProvider
    extends AutoDisposeNotifierProviderImpl<AuthUser, AuthUserState> {
  /// See also [AuthUser].
  AuthUserProvider([
    GlobalKey<State<StatefulWidget>>? familyKey,
  ]) : this._internal(
          () => AuthUser()..familyKey = familyKey,
          from: authUserProvider,
          name: r'authUserProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$authUserHash,
          dependencies: AuthUserFamily._dependencies,
          allTransitiveDependencies: AuthUserFamily._allTransitiveDependencies,
          familyKey: familyKey,
        );

  AuthUserProvider._internal(
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
  AuthUserState runNotifierBuild(
    covariant AuthUser notifier,
  ) {
    return notifier.build(
      familyKey,
    );
  }

  @override
  Override overrideWith(AuthUser Function() create) {
    return ProviderOverride(
      origin: this,
      override: AuthUserProvider._internal(
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
  AutoDisposeNotifierProviderElement<AuthUser, AuthUserState> createElement() {
    return _AuthUserProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AuthUserProvider && other.familyKey == familyKey;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, familyKey.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AuthUserRef on AutoDisposeNotifierProviderRef<AuthUserState> {
  /// The parameter `familyKey` of this provider.
  GlobalKey<State<StatefulWidget>>? get familyKey;
}

class _AuthUserProviderElement
    extends AutoDisposeNotifierProviderElement<AuthUser, AuthUserState>
    with AuthUserRef {
  _AuthUserProviderElement(super.provider);

  @override
  GlobalKey<State<StatefulWidget>>? get familyKey =>
      (origin as AuthUserProvider).familyKey;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
