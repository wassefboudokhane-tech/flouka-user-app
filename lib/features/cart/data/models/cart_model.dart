import 'package:flouka/core/helper_function/convert.dart';
import 'package:flouka/features/products/data/models/product_model.dart';
import '../../domain/entity/cart_entity.dart';

class CartModel extends CartEntity {
  CartModel({
    super.id,
    super.quantity,
    super.product,
    super.variant,
    super.unitPrice, required super.storeId,
    super.stock,
    super.alsoAt,
    super.parcelsNow,
    super.parcelsGrouped,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id'],
      quantity: json['quantity'],
      unitPrice: convertDataToNum(json['unit_price']),
      storeId: convertStringToInt(json['store_id']),
      stock: json['stock'] != null ? convertDataToNum(json['stock']) : null,
      product: json['product'] != null
          ? ProductModel.fromJson(json['product'])
          : null,
      variant: json['variant'] != null
          ? CartVariantModel.fromJson(json['variant'])
          : null,
      alsoAt: [
        if (json['also_at'] is List)
          for (final row in json['also_at'])
            if (row is Map)
              CartAlsoAt(
                storeId: convertStringToInt(row['store_id']),
                name: (row['name'] ?? '').toString(),
                price: convertDataToNum(row['price']) ?? 0,
                deliverySaving: convertDataToNum(row['delivery_saving']) ?? 0,
              ),
      ],
      parcelsNow: convertStringToInt(json['parcels_now'] ?? 1),
      parcelsGrouped: convertStringToInt(json['parcels_grouped'] ?? 1),
    );
  }
}

class CartVariantModel extends CartVariantEntity {
  CartVariantModel({
    super.id,
    super.productId,
    super.name,
    super.sku,
    super.price,
    super.offerPrice,
    super.finalPrice,
    super.createdAt,
    super.updatedAt,
    super.attributeValues,
  });

  factory CartVariantModel.fromJson(Map<String, dynamic> json) {
    return CartVariantModel(
      id: json['id'],
      productId: json['product_id'],
      name: json['name'],
      sku: json['sku'],
      price: json['price'],
      offerPrice: json['offer_price'],
      finalPrice: json['final_price'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      attributeValues: json['attribute_values'] != null
          ? List<CartVariantAttributeModel>.from(
        json['attribute_values'].map(
              (e) => CartVariantAttributeModel.fromJson(e),
        ),
      )
          : [],
    );
  }
}

class CartVariantAttributeModel extends CartVariantAttributeEntity {
  CartVariantAttributeModel({
    super.attributeName,
    super.valueName,
    super.valueCode,
  });

  factory CartVariantAttributeModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return CartVariantAttributeModel(
      attributeName: json['attribute_name'],
      valueName: json['value_name'],
      valueCode: json['value_code'],
    );
  }
}