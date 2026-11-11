import 'package:flouka/features/products/domain/entity/product_entity.dart';

class CreatorEntity {
  final int id;

  /// Public handle, also used as the attribution ref and promo code.
  final String handle;
  final String name;
  final String? avatar;
  final String bio;
  final String? niche;
  final bool isFollowed;

  /// Products the creator recommends. Empty until the storefront is loaded.
  final List<ProductEntity> products;

  const CreatorEntity({
    required this.id,
    required this.handle,
    required this.name,
    required this.avatar,
    required this.bio,
    required this.niche,
    required this.isFollowed,
    this.products = const [],
  });

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    return parts.take(2).map((p) => p[0].toUpperCase()).join();
  }
}
