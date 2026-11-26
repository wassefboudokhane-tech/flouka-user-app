import 'package:flutter_test/flutter_test.dart';
import 'package:flouka/core/deep_link.dart';

void main() {
  test('parses creator storefront', () {
    final d = FkDeepLink.parse(Uri.parse('https://flouka.app/shop/nour.demo'));
    expect(d.kind, FkDeepLinkKind.creator);
    expect(d.handle, 'nour.demo');
    expect(d.location, '/shop/nour.demo');
  });

  test('parses collection', () {
    final d = FkDeepLink.parse(Uri.parse('https://www.flouka.app/shop/nour.demo/rituels-du-soir'));
    expect(d.kind, FkDeepLinkKind.collection);
    expect(d.location, '/shop/nour.demo/rituels-du-soir');
  });

  test('parses product and brand', () {
    expect(FkDeepLink.parse(Uri.parse('https://flouka.app/p/bougie-jasmin')).location, '/p/bougie-jasmin');
    expect(FkDeepLink.parse(Uri.parse('https://flouka.app/marque/maison-demo')).location, '/marque/maison-demo');
  });

  test('parses custom scheme and search', () {
    expect(FkDeepLink.parse(Uri.parse('flouka://shop/nour.demo')).kind, FkDeepLinkKind.creator);
    expect(FkDeepLink.parse(Uri.parse('https://flouka.app/recherche?q=bougie')).query, 'bougie');
  });

  test('rejects unknown hosts', () {
    expect(FkDeepLink.parse(Uri.parse('https://shopmy.com/x')).kind, FkDeepLinkKind.unknown);
  });
}
