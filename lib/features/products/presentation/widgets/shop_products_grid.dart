import 'package:flouka/core/constants/app_lotties.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/features/products/presentation/providers/categories_product_search_provider.dart';
import 'package:flouka/features/products/presentation/widgets/search_empty_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/widgets/loading_animation_widget.dart';
import 'hot_deals_home_container_widget.dart';

/// Uniform 2-col product grid (web ProductListingGrid parity).
class ShopProductsGrid extends StatelessWidget {
  const ShopProductsGrid({super.key, this.padding});

  final EdgeInsetsGeometry? padding;

  static const int _crossAxisCount = 2;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CategoriesProductSearchProvider>(context);
    final products = provider.data;

    if (products == null) {
      return const LoadingAnimationWidget(gif: Lotties.loading);
    }
    if (products.isEmpty) {
      return const SearchEmptyStateWidget();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final pad = padding ??
            const EdgeInsets.fromLTRB(
              AppSpacing.pageGutter,
              12,
              AppSpacing.pageGutter,
              24,
            );
        final horizontalPad = AppSpacing.pageGutter * 2;
        final usable = constraints.maxWidth - horizontalPad - AppSpacing.cardGap;
        final cardW = usable / _crossAxisCount;
        final cardH = HotDealsHomeContainerWidget.estimatedHeight(cardW);
        final aspect = cardW / cardH;

        return GridView.builder(
          padding: pad,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _crossAxisCount,
            mainAxisSpacing: AppSpacing.cardGap,
            crossAxisSpacing: AppSpacing.cardGap,
            childAspectRatio: aspect,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            return HotDealsHomeContainerWidget(
              product: products[index],
              width: cardW,
            );
          },
        );
      },
    );
  }
}
