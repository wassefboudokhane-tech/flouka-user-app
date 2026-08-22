import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/features/home/presentation/widgets/marketplace_product_rail.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flouka/features/products/presentation/providers/recommend_products_provider.dart';
import 'package:flouka/features/products/presentation/widgets/search_empty_recovery_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchEmptyStateWidget extends StatefulWidget {
  const SearchEmptyStateWidget({super.key});

  @override
  State<SearchEmptyStateWidget> createState() => _SearchEmptyStateWidgetState();
}

class _SearchEmptyStateWidgetState extends State<SearchEmptyStateWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<RecommendProductsProvider>();
      if (provider.data == null) {
        provider.getRecommendedHomeData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final recommended = context.watch<RecommendProductsProvider>();

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        const SizedBox(height: 32),
        const SearchEmptyRecoveryWidget(),
        if (recommended.data != null && recommended.data!.isNotEmpty)
          MarketplaceProductRail(
            title: LanguageProvider.translate(
              'recovery',
              'search_similar_title',
            ),
            products: recommended.data!,
            isSimilar: true,
          ),
      ],
    );
  }
}
