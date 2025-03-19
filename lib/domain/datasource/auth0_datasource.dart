import 'package:auth0_flutter/auth0_flutter.dart';

abstract class Auth0Datasource {
  Future<Credentials?> login(
      void Function(Object error, StackTrace stackTrace) onError);
  Future<void> logout();
}
