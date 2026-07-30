import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flouka/injection_container.dart';
import 'app_providers.dart';
import 'core/config/app_color.dart';
import 'core/helper_function/api.dart';
import 'core/helper_function/notifications.dart';
import 'core/helper_function/prefs.dart';
import 'core/models/local_notifications.dart';
import 'features/language/presentation/provider/language_provider.dart';
import 'firebase_options.dart';
import 'flouka_app.dart';
import 'http_overrides_stub.dart'
    if (dart.library.io) 'http_overrides_io.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage event) async {
  if (event.notification != null) {
    appNotifications(
      event.notification!,
      click: true,
      fromWhereClicked: 3,
      payload: event.data,
    );
  }
}

Future<void> localMessagingBackgroundHandler(NotificationResponse response) async {
  clickNoti(response.payload!);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();

  applyHttpOverrides();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
      name: kIsWeb ? null : 'flouka',
    );
  } catch (e, st) {
    debugPrint('Firebase init skipped/failed (web preview): $e\n$st');
  }

  if (!kIsWeb) {
    await notificationsFirebase();
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  await startSharedPref();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
    overlays: [SystemUiOverlay.bottom],
  );

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: AppColor.primaryColor,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  try {
    await ApiHandel.getInstance.init();
  } catch (e, st) {
    debugPrint('ApiHandel.init failed: $e\n$st');
  }

  final language = LanguageProvider();
  await language.fetchLocale();
  await init();
  runApp(MyApp(language: language));
}

class MyApp extends StatelessWidget {
  final LanguageProvider language;

  const MyApp({required this.language, super.key});

  @override
  Widget build(BuildContext context) {
    return AppProviders(language: language, child: const MainApp());
  }
}
