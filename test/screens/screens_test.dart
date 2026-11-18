// Renders the main screens with sample data and saves them as PNG, so the
// design can be checked without a device:
//
//   SHOTS_DIR=/tmp/shots flutter test test/screens
//
// Without SHOTS_DIR the screens are still built (a smoke test) but nothing
// is written.
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flouka/app_providers.dart';
import 'package:flouka/core/config/app_theme.dart';
import 'package:flouka/core/constants/constants.dart';
import 'package:flouka/core/helper_function/prefs.dart';
import 'package:flouka/features/language/domain/entities/app_localizations.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flouka/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import 'sample_data.dart';

const _shotKey = Key('screen-shot');
const _phone = Size(390, 844);

Future<void> _loadFonts() async {
  final home = Platform.environment['HOME'] ?? '/root';
  final dirs = [
    '$home/.pub-cache/hosted/pub.dev/flutter_gallery_assets-1.0.2/lib/fonts/google_fonts',
  ];
  String? find(String name) {
    for (final d in dirs) {
      final f = File('$d/$name');
      if (f.existsSync()) return f.path;
    }
    return null;
  }

  Future<void> load(String family, String? path) async {
    if (path == null) return;
    final bytes = File(path).readAsBytesSync();
    final loader = FontLoader(family)..addFont(Future.value(ByteData.view(bytes.buffer)));
    await loader.load();
  }

  final regular = find('Rubik-Regular.ttf');
  final medium = find('Rubik-Medium.ttf') ?? regular;
  final bold = find('Rubik-Bold.ttf') ?? medium;
  // google_fonts names each weight "<Family>_<variant>".
  await load('Rubik_regular', regular);
  await load('Rubik', regular);
  for (final w in ['100', '200', '300']) {
    await load('Rubik_$w', regular);
  }
  await load('Rubik_500', medium);
  await load('Rubik_600', medium);
  for (final w in ['700', '800', '900']) {
    await load('Rubik_$w', bold);
  }
  final flutterRoot = Platform.environment['FLUTTER_ROOT'] ?? '/opt/fl/flutter';
  await load('MaterialIcons', '$flutterRoot/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf');
}

Future<void> _shoot(WidgetTester tester, String name) async {
  final dir = Platform.environment['SHOTS_DIR'];
  if (dir == null) return;
  final boundary = tester.renderObject<RenderRepaintBoundary>(find.byKey(_shotKey));
  await tester.runAsync(() async {
    final image = await boundary.toImage(pixelRatio: 2);
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    Directory(dir).createSync(recursive: true);
    File('$dir/$name.png').writeAsBytesSync(data!.buffer.asUint8List());
  });
}

/// The real providers and theme around one screen, at phone size.
Widget _app(Widget screen) {
  final language = LanguageProvider()..setLanguage(const Locale('fr'), rebuild: false);
  return RepaintBoundary(
    key: _shotKey,
    child: MediaQuery(
      data: const MediaQueryData(size: _phone, padding: EdgeInsets.only(top: 44, bottom: 20)),
      child: AppProviders(
        language: language,
        child: Sizer(
          builder: (context, orientation, deviceType) => MaterialApp(
            debugShowCheckedModeBanner: false,
            navigatorKey: Constants.navState,
            locale: const Locale('fr'),
            supportedLocales: LanguageProvider.languages,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            theme: defaultTheme,
            home: screen,
          ),
        ),
      ),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({'language_code': 'fr'});
    // The image cache asks for app folders: answer with a temp folder.
    final tmp = Directory.systemTemp.createTempSync('flouka_shots').path;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (call) async => tmp,
    );
    await startSharedPref();
    await initializeDependencies();
    await _loadFonts();
    // The phone field reads country formats a native plugin loads at start-up.
    await CountryManager().loadCountries(phoneCodesMap: {
      'TN': CountryWithPhoneCode(
        phoneCode: '216',
        countryCode: 'TN',
        exampleNumberMobileNational: '20 123 456',
        exampleNumberFixedLineNational: '71 234 567',
        phoneMaskMobileNational: '00 000 000',
        phoneMaskFixedLineNational: '00 000 000',
        exampleNumberMobileInternational: '+216 20 123 456',
        exampleNumberFixedLineInternational: '+216 71 234 567',
        phoneMaskMobileInternational: '+000 00 000 000',
        phoneMaskFixedLineInternational: '+000 00 000 000',
        countryName: 'Tunisia',
      ),
    });
  });

  Future<void> render(WidgetTester tester, String name, Widget screen, [void Function(BuildContext)? seed]) async {
    tester.view.physicalSize = _phone * 2;
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(_app(_Seeded(seed: seed, child: screen)));
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pump(const Duration(milliseconds: 300));
    await _shoot(tester, name);
    // Let pending requests and timers fail quietly: no network in tests.
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 5));
  }

  for (final s in sampleScreens) {
    testWidgets('screen ${s.name}', (tester) async {
      await render(tester, s.name, s.build(), s.seed);
    });
  }
}

/// Puts the sample data in the providers before the screen first builds.
class _Seeded extends StatefulWidget {
  const _Seeded({required this.seed, required this.child});
  final void Function(BuildContext)? seed;
  final Widget child;
  @override
  State<_Seeded> createState() => _SeededState();
}

class _SeededState extends State<_Seeded> {
  @override
  void initState() {
    super.initState();
    widget.seed?.call(context);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
