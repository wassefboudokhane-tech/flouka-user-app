import 'package:flutter_dotenv/flutter_dotenv.dart';

class FkEnv {
  FkEnv._();
  static final FkEnv instance = FkEnv._();

  String _read(String key, {String fallback = '', String define = ''}) {
    if (define.isNotEmpty) return define;
    if (dotenv.isInitialized) {
      final v = dotenv.env[key];
      if (v != null && v.isNotEmpty) return v;
    }
    return fallback;
  }

  String get apiBase =>
      _read('FLOUKA_API_BASE', define: const String.fromEnvironment('FLOUKA_API_BASE'))
          .replaceAll(RegExp(r'/$'), '');

  String get siteUrl => _read(
        'FLOUKA_SITE_URL',
        fallback: 'https://flouka.app',
        define: const String.fromEnvironment('FLOUKA_SITE_URL'),
      ).replaceAll(RegExp(r'/$'), '');

  String get posthogKey =>
      _read('POSTHOG_API_KEY', define: const String.fromEnvironment('POSTHOG_API_KEY'));

  String get posthogHost => _read(
        'POSTHOG_HOST',
        fallback: 'https://eu.i.posthog.com',
        define: const String.fromEnvironment('POSTHOG_HOST'),
      );

  String get clarityId =>
      _read('CLARITY_PROJECT_ID', define: const String.fromEnvironment('CLARITY_PROJECT_ID'));

  String get firebaseProjectId => _read(
        'FIREBASE_PROJECT_ID',
        define: const String.fromEnvironment('FIREBASE_PROJECT_ID'),
      );

  String get firebaseApiKey =>
      _read('FIREBASE_API_KEY', define: const String.fromEnvironment('FIREBASE_API_KEY'));

  String get firebaseAndroidAppId => _read(
        'FIREBASE_ANDROID_APP_ID',
        define: const String.fromEnvironment('FIREBASE_ANDROID_APP_ID'),
      );

  String get firebaseIosAppId =>
      _read('FIREBASE_IOS_APP_ID', define: const String.fromEnvironment('FIREBASE_IOS_APP_ID'));

  String get firebaseSenderId => _read(
        'FIREBASE_MESSAGING_SENDER_ID',
        define: const String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID'),
      );

  String get ga4Id =>
      _read('GA4_MEASUREMENT_ID', define: const String.fromEnvironment('GA4_MEASUREMENT_ID'));

  String get ctaVariant => _read(
        'FLOUKA_CTA_VARIANT',
        fallback: 'ink',
        define: const String.fromEnvironment('FLOUKA_CTA_VARIANT'),
      );

  bool get useDemoCatalog {
    final v = _read(
      'FLOUKA_USE_DEMO_CATALOG',
      fallback: 'true',
      define: const String.fromEnvironment('FLOUKA_USE_DEMO_CATALOG'),
    ).toLowerCase();
    return v != 'false' && v != '0';
  }

  bool get hasPosthog => posthogKey.isNotEmpty && !posthogKey.contains('YOUR_');
  bool get hasClarity => clarityId.isNotEmpty && !clarityId.contains('YOUR_');
  bool get hasFirebase =>
      firebaseProjectId.isNotEmpty &&
      firebaseApiKey.isNotEmpty &&
      !firebaseApiKey.contains('YOUR_') &&
      !firebaseApiKey.contains('PLACEHOLDER');

  static Future<void> load() async {
    try {
      await dotenv.load(fileName: '.env');
    } catch (_) {
      try {
        await dotenv.load(fileName: '.env.example');
      } catch (_) {}
    }
  }
}
