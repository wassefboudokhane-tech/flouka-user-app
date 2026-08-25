import 'package:flouka/features/cart/domain/utils/cart_merge.dart';
import 'package:flutter_test/flutter_test.dart';

MergeCartItem item({
  required int productId,
  required int stockId,
  required int quantity,
  int? serverCartId,
}) {
  return MergeCartItem(
    id: productId,
    title: 'Product $productId',
    vendorName: 'Store',
    price: 10,
    image: null,
    qty: quantity,
    storeId: 1,
    stockId: stockId,
    serverCartId: serverCartId,
  );
}

void main() {
  group('guest cart merge', () {
    test('keeps variants of the same product as separate lines', () {
      final merged = mergeGuestIntoServer(
        [item(productId: 7, stockId: 70, quantity: 1, serverCartId: 1)],
        [item(productId: 7, stockId: 71, quantity: 2)],
      );

      expect(merged, hasLength(2));
      expect(merged.map((line) => line.stockId), containsAll([70, 71]));
    });

    test('merges only the same stock and keeps the larger quantity', () {
      final merged = mergeGuestIntoServer(
        [item(productId: 7, stockId: 70, quantity: 1, serverCartId: 5)],
        [item(productId: 7, stockId: 70, quantity: 3)],
      );

      expect(merged, hasLength(1));
      expect(merged.single.qty, 3);
      expect(merged.single.serverCartId, 5);
    });

    test('calculates server increases per variant', () {
      final server = [
        item(productId: 7, stockId: 70, quantity: 1, serverCartId: 5),
        item(productId: 7, stockId: 71, quantity: 2, serverCartId: 6),
      ];
      final merged = mergeGuestIntoServer(server, [
        item(productId: 7, stockId: 70, quantity: 4),
      ]);

      final increases = serverQtyIncreases(merged, server);

      expect(increases, hasLength(1));
      expect(increases.single.serverCartId, 5);
      expect(increases.single.delta, 3);
    });
  });
}
