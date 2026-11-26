import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flouka/app.dart';
import 'package:flouka/core/analytics.dart';
import 'package:flouka/core/analytics_sdks.dart';
import 'package:flouka/core/deep_link.dart';
import 'package:flouka/core/env.dart';
import 'package:flouka/core/tokens.dart';
import 'package:flouka/router.dart';
import 'package:flouka/state/flouka_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FkEnv.load();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: FkTokens.white,
    ),
  );

  final analytics = FkAnalytics();
  analytics.onStart = () => FkAnalyticsSdks.start(FkEnv.instance);
  analytics.onEvent = FkAnalyticsSdks.capture;

  final state = FloukaState(analytics: analytics);
  await state.hydrate();
  if (state.analyticsAllowed) {
    await analytics.start();
  }

  final router = createRouter(state);
  runApp(FloukaApp(state: state, router: router));

  if (!kIsWeb) {
    try {
      final links = AppLinks();
      links.uriLinkStream.listen((uri) {
        router.go(FkDeepLink.parse(uri).location);
      });
    } catch (e) {
      debugPrint('app_links skipped: $e');
    }
  }
}
