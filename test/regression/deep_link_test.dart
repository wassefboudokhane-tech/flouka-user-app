import 'package:flouka/core/models/deep_link.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses product and store cold-start links', () {
    final product = parseDeepLink(
      Uri.parse('https://floka.zeroonez.com/product?id=12'),
    );
    final store = parseDeepLink(
      Uri.parse('https://floka.zeroonez.com/store?id=4'),
    );

    expect(product?.kind, DeepLinkKind.product);
    expect(product?.id, 12);
    expect(store?.kind, DeepLinkKind.store);
    expect(store?.id, 4);
  });

  test('rejects missing ids and unsupported paths', () {
    expect(
      parseDeepLink(Uri.parse('https://floka.zeroonez.com/product')),
      isNull,
    );
    expect(
      parseDeepLink(Uri.parse('https://floka.zeroonez.com/other?id=1')),
      isNull,
    );
  });
}
