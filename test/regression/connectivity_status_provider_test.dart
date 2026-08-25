import 'package:flouka/core/network/connectivity_status_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'retry executes the supplied request instead of faking online state',
    () async {
      final provider = ConnectivityStatusProvider()..markOffline();
      var attempts = 0;

      await provider.retryLastAction(() async {
        attempts++;
      });

      expect(attempts, 1);
      expect(provider.isOffline, isTrue);
    },
  );

  test('a successful retried request can mark the app online', () async {
    final provider = ConnectivityStatusProvider()..markOffline();

    await provider.retryLastAction(() async {
      provider.markOnline();
    });

    expect(provider.isOffline, isFalse);
  });
}
