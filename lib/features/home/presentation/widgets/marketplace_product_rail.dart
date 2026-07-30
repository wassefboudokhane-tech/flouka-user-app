import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_radius.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/core/widgets/see_all_button.dart';
import 'package:flouka/features/products/domain/entity/product_entity.dart';
import 'package:flouka/features/products/presentation/widgets/hot_deals_home_container_widget.dart';
import 'package:flutter/material.dart';

/// Horizontal product rail — mirrors web `ProductRail`.
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

  static double _defaultCardWidth(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    if (w > 700) return 190;
    if (w >= 400) return 170;
    return 150;
  }

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox.shrink();

    final width = cardWidth ?? _defaultCardWidth(context);
    final listHeight = HotDealsHomeContainerWidget.estimatedHeight(width);

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.pageGutter,
        vertical: 8,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.pageGutter,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColor.borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
              const SizedBox(width: 8),
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
          const SizedBox(height: 12),
          SizedBox(
            height: listHeight,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
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
