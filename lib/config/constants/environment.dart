import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static initEnvironmet() async {
    (kReleaseMode)
        ? await dotenv.load(fileName: '.env.production')
        : await dotenv.load(fileName: '.env.development');
  }

  static String apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3000';
}
