import 'package:flouka/core/helper_function/convert.dart';
import 'package:flouka/features/creators/domain/entity/creator_entity.dart';
import 'package:flouka/features/products/data/models/product_model.dart';
import 'package:flouka/features/products/domain/entity/product_entity.dart';

class CreatorModel extends CreatorEntity {
  const CreatorModel({
    required super.id,
    required super.handle,
    required super.name,
    required super.avatar,
    required super.bio,
    required super.niche,
    required super.isFollowed,
    super.products,
  });

  factory CreatorModel.fromJson(Map<String, dynamic> json) {
    final products = <ProductEntity>[];
    final rawProducts = json['products'];
    if (rawProducts is List) {
      for (final item in rawProducts) {
        if (item is Map<String, dynamic>) {
          products.add(ProductModel.fromJson(item));
        }
      }
    }
    return CreatorModel(
      id: convertStringToInt(json['id']),
      handle: (json['handle'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      avatar: json['avatar']?.toString(),
      bio: (json['bio'] ?? '').toString(),
      niche: json['niche']?.toString(),
      isFollowed: convertDataToBool(json['is_follow']),
      products: products,
    );
  }
}
