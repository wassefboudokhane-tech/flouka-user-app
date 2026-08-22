import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_radius.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/core/widgets/see_all_button.dart';
import 'package:flouka/features/products/domain/entity/product_entity.dart';
import 'package:flouka/features/products/presentation/widgets/hot_deals_home_container_widget.dart';
import 'package:flutter/material.dart';

/// Horizontal product rail — title + cards on canvas (no outer white box).
class MarketplaceProductRail extends StatelessWidget {
  const MarketplaceProductRail({
    super.key,
    required this.title,
    required this.products,
    this.onSeeAll,
    this.cardWidth,
    this.isSimilar = false,
  });

  final String title;
  final List<ProductEntity> products;
  final VoidCallback? onSeeAll;
  final double? cardWidth;
  final bool isSimilar;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox.shrink();

    final width = cardWidth ?? AppSpacing.productCardWidth;
    final listHeight = HotDealsHomeContainerWidget.estimatedHeight(width);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.pageGutter,
            ),
            child: Row(
              children: [
                Container(
                  width: AppSpacing.railAccentW,
                  height: AppSpacing.railAccentH,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [AppColor.limeColor, AppColor.primaryColor],
                    ),
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyleClass.railTitleStyle(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (onSeeAll != null) SeeAllButton(onPressed: onSeeAll!),
              ],
            ),
          ),
          const SizedBox(height: 11),
          SizedBox(
            height: listHeight,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.pageGutter,
              ),
              itemCount: products.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(width: AppSpacing.cardGap),
              itemBuilder: (context, index) {
                return HotDealsHomeContainerWidget(
                  product: products[index],
                  width: width,
                  isSimilar: isSimilar,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
