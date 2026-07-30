import 'dart:convert';

import 'package:flouka/core/helper_function/prefs.dart';

const String guestCartStorageKey = 'flouka-cart-v1';

class GuestCartItem {
  final int productId;
  final String title;
  final String vendorName;
  final num price;
  final String? image;
  final int qty;
  final int storeId;
  final int stockId;
  final String? variantLabel;

  const GuestCartItem({
    required this.productId,
    required this.title,
    required this.vendorName,
    required this.price,
    required this.image,
    required this.qty,
    required this.storeId,
    required this.stockId,
    this.variantLabel,
  });

  GuestCartItem copyWith({int? qty}) {
    return GuestCartItem(
      productId: productId,
      title: title,
      vendorName: vendorName,
      price: price,
      image: image,
      qty: qty ?? this.qty,
      storeId: storeId,
      stockId: stockId,
      variantLabel: variantLabel,
    );
  }

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'title': title,
        'vendorName': vendorName,
        'price': price,
        'image': image,
        'qty': qty,
        'storeId': storeId,
        'stockId': stockId,
        'variantLabel': variantLabel,
      };

  factory GuestCartItem.fromJson(Map<String, dynamic> json) {
    return GuestCartItem(
      productId: (json['productId'] as num).toInt(),
      title: json['title']?.toString() ?? '',
      vendorName: json['vendorName']?.toString() ?? '',
      price: json['price'] as num? ?? 0,
      image: json['image']?.toString(),
      qty: (json['qty'] as num?)?.toInt() ?? 1,
      storeId: (json['storeId'] as num).toInt(),
      stockId: (json['stockId'] as num).toInt(),
      variantLabel: json['variantLabel']?.toString(),
    );
  }
}

class GuestCartLocalDataSource {
  List<GuestCartItem> load() {
    final raw = sharedPreferences.getString(guestCartStorageKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      final decoded = jsonDecode(raw);
      final items = decoded is Map ? decoded['items'] : decoded;
      if (items is! List) return [];
      return items
          .whereType<Map>()
          .map((e) => GuestCartItem.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> save(List<GuestCartItem> items) async {
    await sharedPreferences.setString(
      guestCartStorageKey,
      jsonEncode({
        'items': items.map((e) => e.toJson()).toList(),
      }),
    );
  }

  Future<void> clear() async {
    await save(const []);
  }
}
