import 'package:flouka/core/models/payment_result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('maps paid and failed redirects to stable result values', () {
    expect(
      PaymentResult.fromUrl('https://floka.zeroonez.com/payment?status=paid'),
      PaymentResult.paid,
    );
    expect(
      PaymentResult.fromUrl('https://floka.zeroonez.com/payment?status=failed'),
      PaymentResult.failed,
    );
  });

  test('ignores callback and unrelated URLs', () {
    expect(
      PaymentResult.fromUrl('https://floka.zeroonez.com/callback?status=paid'),
      isNull,
    );
    expect(PaymentResult.fromUrl('https://example.com/'), isNull);
  });
}
