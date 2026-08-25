import 'package:flouka/core/pending_address_store.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  tearDown(PendingAddressStore.clear);

  test('retains a defensive copy and the requested operation', () {
    final source = <String, dynamic>{'address_id': 9, 'address': 'Tunis'};

    PendingAddressStore.save(
      source,
      forOperation: PendingAddressOperation.update,
    );
    source['address'] = 'changed outside';

    expect(PendingAddressStore.hasData, isTrue);
    expect(PendingAddressStore.operation, PendingAddressOperation.update);
    expect(PendingAddressStore.data!['address'], 'Tunis');
  });

  test('clear resets both payload and operation', () {
    PendingAddressStore.save({
      'address': 'Tunis',
    }, forOperation: PendingAddressOperation.update);

    PendingAddressStore.clear();

    expect(PendingAddressStore.hasData, isFalse);
    expect(PendingAddressStore.operation, PendingAddressOperation.create);
  });
}
