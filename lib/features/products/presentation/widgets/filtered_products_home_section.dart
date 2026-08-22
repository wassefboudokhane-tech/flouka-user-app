import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flouka/features/products/presentation/widgets/hot_deals_home_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../filters/presentation/providers/filter_product_provider.dart';

/// Filtered home products — uses canonical ProductCard (web parity).
class FilteredProductsHomeSection extends StatelessWidget {
  const FilteredProductsHomeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FilterProductProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const LoadingProductsListWidget();
        }
        if (provider.products?.isEmpty ?? true) {
          return Column(
            children: [
              Icon(Icons.search_off, size: 48, color: AppColor.mutedColor),
              Text(
                LanguageProvider.translate('orders', 'empty_search'),
                style: TextStyleClass.smallStyle(color: AppColor.mutedColor),
              ),
            ],
          );
        }
        return LayoutBuilder(
          builder: (context, constraints) {
            final usable = constraints.maxWidth -
                AppSpacing.pageGutter * 2 -
                AppSpacing.cardGap;
            final cardW = usable / 2;
            final aspect =
                cardW / HotDealsHomeContainerWidget.estimatedHeight(cardW);
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.pageGutter,
              ),
              itemCount: provider.products!.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: AppSpacing.cardGap,
                crossAxisSpacing: AppSpacing.cardGap,
                childAspectRatio: aspect,
              ),
              itemBuilder: (context, index) {
                return HotDealsHomeContainerWidget(
                  product: provider.products![index],
                  width: cardW,
                );
              },
            );
          },
        );
      },
    );
  }
}

class LoadingProductsListWidget extends StatelessWidget {
  const LoadingProductsListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FilterProductProvider>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageGutter),
      child: Skeletonizer(
        enabled: provider.isLoading,
        child: const SizedBox(height: 220, width: double.infinity),
      ),
    );
  }
}
