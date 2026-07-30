import 'package:flouka/features/home/presentation/widgets/marketplace_product_rail.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flouka/features/products/domain/entity/product_entity.dart';
import 'package:flutter/material.dart';

/// PDP related / similar products — unified `ProductRail` shell.
class HotDealsWidget extends StatelessWidget {
  const HotDealsWidget({
    super.key,
    required this.products,
    this.isSimilar = true,
  });

  final List<ProductEntity> products;
  final bool isSimilar;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: MarketplaceProductRail(
        title: LanguageProvider.translate('home', 'related_products'),
        products: products,
        isSimilar: isSimilar,
      ),
    );
  }
}
