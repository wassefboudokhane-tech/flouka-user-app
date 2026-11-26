import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flouka/app.dart';
import 'package:flouka/core/analytics.dart';
import 'package:flouka/core/l10n.dart';
import 'package:flouka/router.dart';
import 'package:flouka/screens/public_screens.dart';
import 'package:flouka/state/flouka_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<FloukaApp> app({ConsentChoice consent = ConsentChoice.accepted, AppLang lang = AppLang.fr}) async {
    final binding = TestWidgetsFlutterBinding.ensureInitialized();
    await binding.setSurfaceSize(const Size(390, 1400));
    binding.platformDispatcher.views.first.physicalSize = const Size(390, 1400);
    binding.platformDispatcher.views.first.devicePixelRatio = 1;
    addTearDown(() async {
      await binding.setSurfaceSize(null);
      binding.platformDispatcher.views.first.resetPhysicalSize();
      binding.platformDispatcher.views.first.resetDevicePixelRatio();
    });
    SharedPreferences.setMockInitialValues({
      'consent': consent == ConsentChoice.accepted
          ? 'yes'
          : consent == ConsentChoice.refused
              ? 'no'
              : '',
      'lang': lang == AppLang.ar ? 'ar' : 'fr',
    });
    final prefs = await SharedPreferences.getInstance();
    final state = FloukaState(prefs: prefs, analytics: FkAnalytics());
    await state.hydrate();
    if (consent == ConsentChoice.unknown) {
      state.consent = ConsentChoice.unknown;
    }
    return FloukaApp(state: state, router: createRouter(state));
  }

  testWidgets('consent is the first screen', (tester) async {
    await tester.pumpWidget(await app(consent: ConsentChoice.unknown));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.textContaining('Mesure'), findsWidgets);
    expect(find.text('Flouka'), findsWidgets);
  });

  testWidgets('home has no cart', (tester) async {
    await tester.pumpWidget(await app());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.textContaining('panier'), findsNothing);
    expect(find.textContaining('Panier'), findsNothing);
    expect(find.textContaining('Vu chez eux'), findsWidgets);
    expect(find.textContaining('CRÉER MA BOUTIQUE'), findsWidgets);
  });

  testWidgets('Arabic home is RTL', (tester) async {
    await tester.pumpWidget(await app(lang: AppLang.ar));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.textContaining('أنشئ متجري'), findsOneWidget);
    final dirs = tester.widgetList<Directionality>(find.byType(Directionality));
    expect(dirs.any((d) => d.textDirection == TextDirection.rtl), isTrue);
  });
}
