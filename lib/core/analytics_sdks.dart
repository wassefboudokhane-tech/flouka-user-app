import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flouka/core/env.dart';
import 'package:posthog_flutter/posthog_flutter.dart';

/// Native SDKs. Called only after consent. Never from tests.
///
/// Microsoft Clarity needs a [BuildContext] (`ClarityWidget`) — see [FloukaApp].
class FkAnalyticsSdks {
  static bool posthogReady = false;
  static bool firebaseReady = false;

  static Future<void> start(FkEnv env) async {
    if (env.hasPosthog && !posthogReady) {
      try {
        final config = PostHogConfig(env.posthogKey)
          ..host = env.posthogHost
          ..captureApplicationLifecycleEvents = true;
        await Posthog().setup(config);
        posthogReady = true;
      } catch (e) {
        debugPrint('PostHog init failed: $e');
      }
    }
    if (env.hasFirebase && !firebaseReady) {
      try {
        if (Firebase.apps.isEmpty) {
          await Firebase.initializeApp(
            options: FirebaseOptions(
              apiKey: env.firebaseApiKey,
              appId: (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS)
                  ? env.firebaseIosAppId
                  : env.firebaseAndroidAppId,
              messagingSenderId: env.firebaseSenderId,
              projectId: env.firebaseProjectId,
            ),
          );
        }
        await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
        firebaseReady = true;
      } catch (e) {
        debugPrint('Firebase Analytics init failed: $e');
      }
    }
  }

  static Future<void> capture(String name, Map<String, Object?> props) async {
    final clean = <String, Object>{};
    props.forEach((k, v) {
      if (v != null) clean[k] = v;
    });
    if (posthogReady) {
      try {
        await Posthog().capture(eventName: name, properties: clean);
      } catch (e) {
        debugPrint('PostHog capture failed: $e');
      }
    }
    if (firebaseReady) {
      try {
        await FirebaseAnalytics.instance.logEvent(name: name, parameters: clean);
      } catch (e) {
        debugPrint('GA4 capture failed: $e');
      }
    }
  }
}
