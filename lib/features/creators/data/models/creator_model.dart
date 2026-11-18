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
    super.products,
    super.instagram,
    super.tiktok,
    super.validatedProductIds,
    super.posts,
  });

  factory CreatorModel.fromJson(Map<String, dynamic> json) {
    final products = <ProductEntity>[];
    final validated = <int>{};
    final rawProducts = json['products'];
    if (rawProducts is List) {
      for (final item in rawProducts) {
        if (item is Map<String, dynamic>) {
          products.add(ProductModel.fromJson(item));
        }
      }
    }
    validated.addAll(brandValidatedIds(rawProducts));
    final posts = <CreatorPostEntity>[];
    final rawPosts = json['posts'];
    if (rawPosts is List) {
      for (final item in rawPosts) {
        if (item is! Map<String, dynamic>) continue;
        final url = item['video_url']?.toString();
        if (url == null || url.isEmpty) continue;
        final brand = item['brand'];
        final product = item['product'];
        posts.add(CreatorPostEntity(
          id: convertStringToInt(item['id']),
          videoUrl: url,
          platform: item['platform']?.toString(),
          brandName: brand is Map ? brand['name']?.toString() : null,
          productTitle: product is Map ? product['title']?.toString() : null,
          productImage: product is Map ? product['image']?.toString() : null,
        ));
      }
    }
    String? social(dynamic v) {
      final s = v?.toString().trim() ?? '';
      return s.isEmpty ? null : s;
    }
    return CreatorModel(
      id: convertStringToInt(json['id']),
      handle: (json['handle'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      avatar: json['avatar']?.toString(),
      bio: (json['bio'] ?? '').toString(),
      niche: json['niche']?.toString(),
      products: products,
      instagram: social(json['instagram']),
      tiktok: social(json['tiktok']),
      validatedProductIds: validated,
      posts: posts,
    );
  }
}

/// Ids of the products the brand approved, from get_creator's product list.
Set<int> brandValidatedIds(dynamic rawProducts) => {
      if (rawProducts is List)
        for (final item in rawProducts)
          if (item is Map && item['brand_validated'] == true) convertStringToInt(item['id']),
    };
