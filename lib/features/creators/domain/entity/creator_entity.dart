import 'package:flouka/features/products/domain/entity/product_entity.dart';

class CreatorEntity {
  final int id;

  /// Public handle, also used as the attribution ref and promo code.
  final String handle;
  final String name;
  final String? avatar;
  final String bio;
  final String? niche;

  /// Products the creator recommends. Empty until the storefront is loaded.
  final List<ProductEntity> products;

  /// Instagram and TikTok usernames, when the creator gave them.
  final String? instagram;
  final String? tiktok;

  /// Products the brand approved for this creator ("Validé par la marque").
  final Set<int> validatedProductIds;

  /// Videos of validated collaborations, as links to where they were posted.
  final List<CreatorPostEntity> posts;

  const CreatorEntity({
    required this.id,
    required this.handle,
    required this.name,
    required this.avatar,
    required this.bio,
    required this.niche,
    this.products = const [],
    this.instagram,
    this.tiktok,
    this.validatedProductIds = const {},
    this.posts = const [],
  });

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    return parts.take(2).map((p) => p[0].toUpperCase()).join();
  }
}

class CreatorPostEntity {
  final int id;
  final String videoUrl;
  final String? platform;
  final String? brandName;
  final String? productTitle;
  final String? productImage;

  const CreatorPostEntity({
    required this.id,
    required this.videoUrl,
    this.platform,
    this.brandName,
    this.productTitle,
    this.productImage,
  });
}
