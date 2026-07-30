import 'package:flouka/features/cart/data/data_source/guest_cart_local_data_source.dart';

class MergeCartItem {
  final int id;
  final String title;
  final String vendorName;
  final num price;
  final String? image;
  final int qty;
  final int? storeId;
  final int? stockId;
  final int? serverCartId;

  const MergeCartItem({
    required this.id,
    required this.title,
    required this.vendorName,
    required this.price,
    required this.image,
    required this.qty,
    this.storeId,
    this.stockId,
    this.serverCartId,
  });

  MergeCartItem copyWith({
    int? qty,
    String? title,
    String? vendorName,
    num? price,
    String? image,
    int? storeId,
    int? stockId,
    int? serverCartId,
  }) {
    return MergeCartItem(
      id: id,
      title: title ?? this.title,
      vendorName: vendorName ?? this.vendorName,
      price: price ?? this.price,
      image: image ?? this.image,
      qty: qty ?? this.qty,
      storeId: storeId ?? this.storeId,
      stockId: stockId ?? this.stockId,
      serverCartId: serverCartId ?? this.serverCartId,
    );
  }

  factory MergeCartItem.fromGuest(GuestCartItem item) {
    return MergeCartItem(
      id: item.productId,
      title: item.title,
      vendorName: item.vendorName,
      price: item.price,
      image: item.image,
      qty: item.qty,
      storeId: item.storeId,
      stockId: item.stockId,
    );
  }
}

/// Merge guest local cart into existing server-mapped items.
/// Guest wins on qty when same product id already exists on server.
List<MergeCartItem> mergeGuestIntoServer(
  List<MergeCartItem> serverItems,
  List<MergeCartItem> guestItems,
) {
  final byId = <int, MergeCartItem>{};
  for (final item in serverItems) {
    byId[item.id] = item;
  }
  for (final guest in guestItems) {
    final existing = byId[guest.id];
    if (existing != null) {
      byId[guest.id] = existing.copyWith(
        qty: existing.qty > guest.qty ? existing.qty : guest.qty,
        title: existing.title.isNotEmpty ? existing.title : guest.title,
        vendorName: existing.vendorName.isNotEmpty
            ? existing.vendorName
            : guest.vendorName,
        price: existing.price != 0 ? existing.price : guest.price,
        image: existing.image ?? guest.image,
        storeId: existing.storeId ?? guest.storeId,
        stockId: existing.stockId ?? guest.stockId,
      );
    } else {
      byId[guest.id] = guest.copyWith(serverCartId: null);
    }
  }
  return byId.values.toList();
}

List<MergeCartItem> guestItemsNeedingServerSync(
  List<MergeCartItem> merged,
  List<MergeCartItem> serverItems,
) {
  final serverIds = serverItems.map((i) => i.id).toSet();
  return merged
      .where(
        (i) =>
            !serverIds.contains(i.id) &&
            i.stockId != null &&
            i.storeId != null,
      )
      .toList();
}

List<({int serverCartId, int delta})> serverQtyIncreases(
  List<MergeCartItem> merged,
  List<MergeCartItem> serverItems,
) {
  final serverById = {for (final i in serverItems) i.id: i};
  final result = <({int serverCartId, int delta})>[];
  for (final item in merged) {
    final server = serverById[item.id];
    final serverCartId = server?.serverCartId;
    if (serverCartId == null) continue;
    final delta = item.qty - server!.qty;
    if (delta > 0) {
      result.add((serverCartId: serverCartId, delta: delta));
    }
  }
  return result;
}
