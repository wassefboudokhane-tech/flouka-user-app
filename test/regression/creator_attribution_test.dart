import 'package:flouka/core/creator_attribution.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late DateTime clock;

  setUp(() {
    clock = DateTime(2026, 11, 1, 10);
    CreatorAttributionStore.now = () => clock;
    CreatorAttributionStore.onChanged = null;
    CreatorAttributionStore.restore(null, null);
  });

  tearDown(() {
    CreatorAttributionStore.now = DateTime.now;
    CreatorAttributionStore.onChanged = null;
    CreatorAttributionStore.restore(null, null);
  });

  test('reads the creator from a shared link', () {
    expect(
      parseCreatorRef(
        Uri.parse('https://flouka.tn/product?id=12&creator=Yasmine'),
      ),
      'yasmine',
    );
    expect(
      parseCreatorRef(Uri.parse('https://flouka.tn/product?id=12&ref=@mehdi')),
      'mehdi',
    );
    expect(parseCreatorRef(Uri.parse('https://flouka.tn/product?id=12')), isNull);
  });

  test('rejects refs that are not a plain handle', () {
    expect(normalizeCreatorRef('a'), isNull);
    expect(normalizeCreatorRef('yas mine'), isNull);
    expect(normalizeCreatorRef('<script>'), isNull);
    expect(CreatorAttributionStore.capture('yas mine'), isFalse);
    expect(CreatorAttributionStore.activeRef(), isNull);
  });

  test('last click wins', () {
    CreatorAttributionStore.capture('yasmine');
    CreatorAttributionStore.capture('mehdi');
    expect(CreatorAttributionStore.activeRef(), 'mehdi');
  });

  test('credit lasts 7 days then expires', () {
    CreatorAttributionStore.capture('yasmine');

    clock = clock.add(const Duration(days: 7));
    expect(CreatorAttributionStore.activeRef(), 'yasmine');

    clock = clock.add(const Duration(minutes: 1));
    expect(CreatorAttributionStore.activeRef(), isNull);
  });

  test('an invalid link does not erase an existing credit', () {
    CreatorAttributionStore.capture('yasmine');
    CreatorAttributionStore.capture(
      parseCreatorRef(Uri.parse('https://flouka.tn/product?id=3')),
    );
    expect(CreatorAttributionStore.activeRef(), 'yasmine');
  });

  test('changes are reported for persistence and survive a restore', () {
    final saved = <CreatorAttribution?>[];
    CreatorAttributionStore.onChanged = saved.add;

    CreatorAttributionStore.capture('yasmine');
    expect(saved.single?.ref, 'yasmine');

    final stored = saved.single!;
    CreatorAttributionStore.restore(null, null);
    expect(CreatorAttributionStore.activeRef(), isNull);

    CreatorAttributionStore.restore(
      stored.ref,
      stored.capturedAt.millisecondsSinceEpoch,
    );
    expect(CreatorAttributionStore.activeRef(), 'yasmine');

    CreatorAttributionStore.clear();
    expect(saved.last, isNull);
  });
}
