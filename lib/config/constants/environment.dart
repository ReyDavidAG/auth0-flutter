import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String domain = dotenv.env['AUTH0_DOMAIN'] ?? 'No domain';
  static String clientId = dotenv.env['AUTH0_CLIENT_ID'] ?? 'No client id';
  static String audience = dotenv.env['AUTH0_AUDIENCE'] ?? 'No audience';
}
