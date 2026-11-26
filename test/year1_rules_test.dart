import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flouka/core/analytics.dart';
import 'package:flouka/core/brand_link.dart';
import 'package:flouka/core/l10n.dart';
import 'package:flouka/data/catalog.dart';
import 'package:flouka/state/flouka_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('FR and standard AR, RTL on AR only', () {
    expect(L10n.fr.seeAtBrand, 'VOIR CHEZ LA MARQUE');
    expect(L10n.ar.seeAtBrand, 'عرض لدى العلامة');
    expect(L10n.ar.recommendedBy(12), contains('منشئ'));
    expect(L10n.ar.isRtl, isTrue);
    expect(L10n.fr.isRtl, isFalse);
    expect(L10n.ar.seeAtBrand.contains('ينصح بيه'), isFalse);
    expect(L10n.ar.commissionNote.contains('ياخو'), isFalse);
  });

  test('demo catalog is fictional Flouka, not ShopMy', () {
    final blob = DemoCatalog.creators.map((c) => c.nameFr).join(' ');
    expect(blob.toLowerCase(), isNot(contains('shopmy')));
    expect(DemoCatalog.product('bougie-jasmin')!.sourceUrl.host, 'maisondemo.tn');
  });

  test('search finds creator brand and product', () {
    final hit = DemoCatalog.search('bougie');
    expect(hit.products, isNotEmpty);
    expect(DemoCatalog.search('نور').creators, isNotEmpty);
  });

  test('brand links stay external with utm', () {
    final uri = BrandLink.tracked(
      Uri.parse('https://maisondemo.tn/bougie-jasmin'),
      creatorHandle: 'nour.demo',
      productSlug: 'bougie-jasmin',
    );
    expect(uri.queryParameters['utm_source'], 'flouka');
    expect(uri.queryParameters['creator'], 'nour.demo');
  });

  test('analytics stay silent until start/consent', () async {
    final a = FkAnalytics();
    var started = false;
    a.onStart = () async => started = true;
    await a.event('vue_produit');
    expect(started, isFalse);
    expect(a.started, isFalse);
    await a.start();
    expect(a.started, isTrue);
    expect(started, isTrue);
  });

  test('delete account actually clears', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final state = FloukaState(prefs: prefs, analytics: FkAnalytics());
    await state.hydrate();
    await state.signIn(role: state.pendingRole);
    expect(state.signedIn, isTrue);
    await state.deleteAccount();
    expect(state.signedIn, isFalse);
    expect(state.favorites, isEmpty);
  });
}
