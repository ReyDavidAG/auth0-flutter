import 'package:auth0_flutter/auth0_flutter.dart';

class Auth0Params {
  final bool isLoading;
  final bool isAuthenticated;
  final Credentials? credentials;

  Auth0Params({
    required this.isLoading,
    required this.isAuthenticated,
    required this.credentials,
  });

  Auth0Params copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    Credentials? credentials,
  }) {
    return Auth0Params(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      credentials: credentials ?? this.credentials,
    );
  }

  static Auth0Params initial() {
    return Auth0Params(
      isLoading: true,
      isAuthenticated: false,
      credentials: null,
    );
  }
}
