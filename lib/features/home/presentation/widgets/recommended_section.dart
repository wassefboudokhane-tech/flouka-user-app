import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import '../../../products/presentation/providers/recommend_products_provider.dart';
import 'marketplace_product_rail.dart';

/// Recommended rail — same shell as bestsellers (web `ProductRail`).
class RecommendedSection extends StatelessWidget {
  const RecommendedSection({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RecommendProductsProvider>(context);
    if (provider.recommendedHomeList.isEmpty) {
      return const SizedBox.shrink();
    }
    return MarketplaceProductRail(
      title: LanguageProvider.translate('home', 'recommended'),
      products: provider.recommendedHomeList,
      onSeeAll: () => provider.goToPage(),
    );
  }
}
