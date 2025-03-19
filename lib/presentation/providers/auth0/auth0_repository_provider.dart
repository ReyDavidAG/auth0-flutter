import 'package:auth0_app/infrastructure/datasources/auth0_inf_datasource.dart';
import 'package:auth0_app/infrastructure/reporsitories/auth0_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final auth0RepositoryProvider = Provider<Auth0RepositoryImpl>(
    (ref) => Auth0RepositoryImpl(Auth0InfDatasource()));
