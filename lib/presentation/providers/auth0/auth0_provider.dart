import 'dart:convert';

import 'package:auth0_app/domain/entities/auth0_params.dart';
import 'package:auth0_app/presentation/providers/auth0/auth0_repository_provider.dart';
import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

AndroidOptions _getAndroidOptions() => const AndroidOptions(
      encryptedSharedPreferences: true,
    );
final storage = FlutterSecureStorage(aOptions: _getAndroidOptions());

final auth0Provider = StateNotifierProvider<Auth0Provider, Auth0Params>((ref) {
  final auth0 = ref.watch(auth0RepositoryProvider);
  return Auth0Provider(login: auth0.login, logout: auth0.logout);
});

typedef Auth0Login = Future<Credentials?> Function(
    void Function(Object error, StackTrace stackTrace) onError);
typedef Auth0Logout = Future<void> Function();

class Auth0Provider extends StateNotifier<Auth0Params> {
  Auth0Provider({
    required this.login,
    required this.logout,
  }) : super(Auth0Params.initial());

  Auth0Login? login;
  Auth0Logout? logout;

  Future<void> loginAction() async {
    state = state.copyWith(isLoading: true);
    final credentials = await login!(
      (error, stackTrace) => state = state.copyWith(isLoading: false),
    );
    await storage.write(
        key: 'credentials',
        value: jsonEncode(credentials!.toMap()),
        aOptions: _getAndroidOptions());
    await storage.write(
        key: 'userProfile',
        value: jsonEncode(credentials.user.toMap()),
        aOptions: _getAndroidOptions());
    state = state.copyWith(
        isLoading: false, isAuthenticated: true, credentials: credentials);
  }

  Future<void> logoutAction() async {
    state = state.copyWith(isLoading: true);
    await logout!();
    await storage.delete(key: 'credentials', aOptions: _getAndroidOptions());
    await storage.delete(key: 'userProfile', aOptions: _getAndroidOptions());
    state = state.copyWith(
        isLoading: false, isAuthenticated: false, credentials: null);
  }

  Future<void> checkSession() async {
    final credentials = await storage.read(key: 'credentials');
    final userProfile = await storage.read(key: 'userProfile');
    state = state.copyWith(isLoading: true);
    if (credentials == null || userProfile == null) {
      state = state.copyWith(
          isLoading: false, isAuthenticated: false, credentials: null);
      await storage.deleteAll(aOptions: _getAndroidOptions());
      await logout!();
      return;
    }
    final credentialsMap = jsonDecode(credentials) as Map<String, dynamic>;
    state = state.copyWith(
        isAuthenticated: true,
        isLoading: false,
        credentials: Credentials(
          idToken: credentialsMap['idToken'],
          accessToken: credentialsMap['accessToken'],
          refreshToken: credentialsMap['refreshToken'],
          tokenType: credentialsMap['tokenType'],
          expiresAt: DateTime.parse(credentialsMap['expiresAt']),
          user: UserProfile.fromMap(jsonDecode(userProfile)),
        ));

    state = state.copyWith(isLoading: false);
  }
}

extension on UserProfile {
  Map<String, dynamic> toMap() {
    return {
      'sub': sub,
      'name': name,
      'givenName': givenName,
      'familyName': familyName,
      'middleName': middleName,
      'nickname': nickname,
      'preferredUsername': preferredUsername,
      'profileUrl': profileUrl?.toString(),
      'pictureUrl': pictureUrl?.toString(),
      'websiteUrl': websiteUrl?.toString(),
      'email': email,
      'isEmailVerified': isEmailVerified,
      'gender': gender,
      'birthdate': birthdate,
      'zoneinfo': zoneinfo,
      'locale': locale,
      'phoneNumber': phoneNumber,
      'isPhoneNumberVerified': isPhoneNumberVerified,
      'address': address,
      'updatedAt': updatedAt?.toIso8601String(),
      'customClaims': customClaims,
    };
  }
}
