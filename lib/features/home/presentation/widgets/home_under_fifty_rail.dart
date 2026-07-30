import 'package:flouka/features/home/presentation/widgets/marketplace_product_rail.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flouka/features/products/domain/entity/product_entity.dart';
import 'package:flouka/features/products/presentation/providers/categories_product_search_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Products under 50 TND — web `under50` rail.
class HomeUnderFiftyRail extends StatelessWidget {
  const HomeUnderFiftyRail({super.key, required this.products});

  final List<ProductEntity> products;

  @override
  Widget build(BuildContext context) {
    final under50 = products.where((p) {
      final price = p.offerPrice ?? p.price ?? 0;
      return price > 0 && price < 50;
    }).take(12).toList();

    if (under50.isEmpty) return const SizedBox.shrink();

    return MarketplaceProductRail(
      title: LanguageProvider.translate('home', 'under_50'),
      products: under50,
      onSeeAll: () {
        Provider.of<CategoriesProductSearchProvider>(
          context,
          listen: false,
        ).goToPage({'max_price': 50});
      },
    );
  }
}
