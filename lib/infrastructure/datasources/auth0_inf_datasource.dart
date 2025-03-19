import 'package:auth0_app/config/constants/environment.dart';
import 'package:auth0_app/domain/datasource/auth0_datasource.dart';
import 'package:auth0_flutter/auth0_flutter.dart';

class Auth0InfDatasource extends Auth0Datasource {
  late Auth0 auth0 = Auth0(Environment.domain, Environment.clientId);
  @override
  Future<Credentials?> login(
      void Function(Object error, StackTrace stackTrace) onError) {
    return auth0
        .webAuthentication()
        .login(
          audience: Environment.audience,
          useHTTPS: true,
        )
        .onError((error, stackTrace) {
      onError(error!, stackTrace);
      throw error;
    });
  }

  @override
  Future<void> logout() {
    return auth0.webAuthentication().logout(
          useHTTPS: true,
        );
  }
}
