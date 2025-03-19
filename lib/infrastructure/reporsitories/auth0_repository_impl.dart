import 'package:auth0_app/domain/datasource/auth0_datasource.dart';
import 'package:auth0_app/repositories/auth0_repository.dart';
import 'package:auth0_flutter/auth0_flutter.dart';

class Auth0RepositoryImpl extends Auth0Repository {
  final Auth0Datasource auth0datasource;

  Auth0RepositoryImpl(this.auth0datasource);

  @override
  Future<Credentials?> login(
      void Function(Object error, StackTrace stackTrace) onError) {
    return auth0datasource.login(onError);
  }

  @override
  Future<void> logout() {
    return auth0datasource.logout();
  }
}
