import '../../../products/domain/entity/product_entity.dart';

class CartEntity {
  int? id;
  int? quantity;
  num? stock;
  ProductEntity? product;
  CartVariantEntity? variant;
  num? unitPrice;
  int storeId;
  /// Present on guest lines — used to sync `store_product_stock_id` after login.
  int? storeProductStockId;

  /// Other shops that stock this product, and how the cart could be grouped.
  final List<CartAlsoAt> alsoAt;
  final int parcelsNow;
  final int parcelsGrouped;

  num get subTotal => (quantity??0) * (unitPrice??0);

  bool get isGuestLine => id != null && id! < 0;

  CartEntity({
    this.id,
    this.quantity,
    this.product,
    this.variant,
    this.unitPrice,
    required this.storeId,
    this.stock,
    this.storeProductStockId,
    this.alsoAt = const [],
    this.parcelsNow = 1,
    this.parcelsGrouped = 1,
  });
}

class CartAlsoAt {
  final int storeId;
  final String name;
  final num price;
  final num deliverySaving;

  const CartAlsoAt({
    required this.storeId,
    required this.name,
    required this.price,
    required this.deliverySaving,
  });
}

class CartVariantEntity {
  int? id;
  int? productId;
  String? name;
  String? sku;
  num? price;
  num? offerPrice;
  num? finalPrice;
  String? createdAt;
  String? updatedAt;

  List<CartVariantAttributeEntity> attributeValues;

  CartVariantEntity({
    this.id,
    this.productId,
    this.name,
    this.sku,
    this.price,
    this.offerPrice,
    this.finalPrice,
    this.createdAt,
    this.updatedAt,
    this.attributeValues = const [],
  });
}

class CartVariantAttributeEntity {
  String? attributeName;
  String? valueName;
  String? valueCode;

  CartVariantAttributeEntity({
    this.attributeName,
    this.valueName,
    this.valueCode,
  });
}

class CartVendorGroup {
  final int storeId;
  final List<CartEntity> items;

  const CartVendorGroup({
    required this.storeId,
    required this.items,
  });

  StoreEntity? get store =>
      items.isNotEmpty ? items.first.product?.store : null;
}