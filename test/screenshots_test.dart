import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flouka/app.dart';
import 'package:flouka/core/analytics.dart';
import 'package:flouka/core/l10n.dart';
import 'package:flouka/data/models.dart';
import 'package:flouka/router.dart';
import 'package:flouka/state/flouka_state.dart';

const _out = '/cursor/stores/bc-c8bcdff5-65ea-438a-949d-4220d6388e2e/media/y1-app';

class _ShotHost extends StatelessWidget {
  const _ShotHost({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => RepaintBoundary(child: child);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final enabled = Platform.environment['SCREENSHOTS'] == '1';
  if (!enabled) {
    test('screenshots opt-in via SCREENSHOTS=1', () {});
    return;
  }

  Future<void> pumpAt(WidgetTester tester, String location, {AppLang lang = AppLang.fr}) async {
    SharedPreferences.setMockInitialValues({'consent': 'yes', 'lang': lang == AppLang.ar ? 'ar' : 'fr'});
    final prefs = await SharedPreferences.getInstance();
    final state = FloukaState(prefs: prefs, analytics: FkAnalytics());
    await state.hydrate();
    if (location.startsWith('/studio') || location.startsWith('/marque-studio') || location == '/onboarding' || location == '/brand/onboarding') {
      await state.signIn(
        role: location.contains('marque') || location.contains('brand') ? AccountRole.brand : AccountRole.creator,
      );
    }
    final router = createRouter(state, initialLocation: location);
    await tester.binding.setSurfaceSize(const Size(390, 844));
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    await tester.pumpWidget(_ShotHost(child: FloukaApp(state: state, router: router)));
    await tester.pump();
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 80)));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
  }

  Future<void> shot(WidgetTester tester, String name) async {
    await tester.runAsync(() async {
      final boundary = tester.renderObject<RenderRepaintBoundary>(find.byType(_ShotHost));
      final image = await boundary.toImage(pixelRatio: 2);
      final data = await image.toByteData(format: ui.ImageByteFormat.png);
      final dir = Directory(_out)..createSync(recursive: true);
      File('${dir.path}/$name.png').writeAsBytesSync(data!.buffer.asUint8List());
      image.dispose();
    });
  }

  const pages = <String, String>{
    '01-accueil': '/',
    '02-createur': '/shop/nour.demo',
    '03-collection': '/shop/nour.demo/rituels-du-soir',
    '04-produit': '/p/bougie-jasmin',
    '05-marque': '/marque/maison-demo',
    '06-recherche': '/search?q=bougie',
    '07-auth': '/auth',
    '08-onboarding': '/onboarding',
    '09-ajout-produit': '/studio/add',
    '10-studio': '/studio',
    '11-stats': '/studio/stats',
    '12-profil': '/studio/profile',
    '13-marque-onboarding': '/brand/onboarding',
    '14-marque-dashboard': '/marque-studio',
  };

  for (final e in pages.entries) {
    testWidgets('shot ${e.key}', (tester) async {
      await pumpAt(tester, e.value);
      await shot(tester, e.key);
    });
  }

  testWidgets('shot 01-accueil-ar', (tester) async {
    await pumpAt(tester, '/', lang: AppLang.ar);
    await shot(tester, '01-accueil-ar');
  });

  testWidgets('shot 02-createur-ar', (tester) async {
    await pumpAt(tester, '/shop/nour.demo', lang: AppLang.ar);
    await shot(tester, '02-createur-ar');
  });
}
