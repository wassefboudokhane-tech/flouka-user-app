import 'package:cached_network_image/cached_network_image.dart';
import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_radius.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/core/widgets/price_widget.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_images.dart';
import '../../../favorite/presentation/providers/favorite_provider.dart';
import '../../domain/entity/product_entity.dart';
import '../providers/products_details_provider.dart';

/// Shared marketplace product card — mirrors web `ProductCard`.
class HotDealsHomeContainerWidget extends StatelessWidget {
  const HotDealsHomeContainerWidget({
    super.key,
    required this.product,
    this.isSimilar = false,
    this.width,
  });

  final ProductEntity product;
  final bool isSimilar;
  final double? width;

  /// Approximate card height for a given width (1:1 image + meta + CTA).
  /// Image is inset by [AppSpacing.cardPadding], so below-image block needs
  /// enough room for vendor, 2-line title, rate, price, COD, and lime CTA.
  static double estimatedHeight(double cardWidth) {
    // Extra headroom for Rubik metrics + COD pill + lime CTA across phone/web.
    const belowImage = 180.0;
    return cardWidth + belowImage;
  }

  @override
  Widget build(BuildContext context) {
    final displayPrice = product.offerPrice ?? product.price ?? 0;
    final hasOffer = product.offerPrice != null;
    final rate = product.rate ?? 0;
    final storeName = product.store?.name;

    return InkWell(
      onTap: () {
        Provider.of<ProductDetailsProvider>(context, listen: false).goToPage({
          'product_id': product.id,
          'is_similar': isSimilar,
        });
      },
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: AppColor.borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final expand = constraints.hasBoundedHeight &&
                constraints.maxHeight < double.infinity;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadius.btn),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [AppColor.softColor, Colors.white],
                            ),
                            image: DecorationImage(
                              image: product.image != null
                                  ? CachedNetworkImageProvider(product.image!)
                                  : const AssetImage(AppImages.logo),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      if (product.discountPercentage != null)
                        PositionedDirectional(
                          top: 6,
                          start: 6,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColor.DealColor,
                              borderRadius:
                                  BorderRadius.circular(AppRadius.pill),
                            ),
                            child: Text(
                              '-${product.discountPercentage!.toStringAsFixed(0)}%',
                              style: TextStyleClass.captionStyle(
                                      color: Colors.white)
                                  .copyWith(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      PositionedDirectional(
                        top: 6,
                        end: 6,
                        child: InkWell(
                          onTap: () {
                            Provider.of<FavoriteProvider>(context,
                                    listen: false)
                                .toggleFavorite(product);
                          },
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: AppColor.primaryColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Consumer<FavoriteProvider>(
                              builder: (context, provider, child) {
                                final isFav = provider.favoriteIds
                                    .contains(product.id);
                                return Icon(
                                  isFav
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: Colors.white,
                                  size: 16,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                if (storeName != null && storeName.isNotEmpty)
                  Text(
                    storeName,
                    style: TextStyleClass.vendorStyle(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                const SizedBox(height: 4),
                Text(
                  product.title ?? '',
                  style: TextStyleClass.productTitleStyle(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (rate > 0) ...[
                  const SizedBox(height: 2),
                  Text(
                    '★ ${rate.toStringAsFixed(1)}',
                    style: TextStyleClass.captionStyle(),
                  ),
                ],
                const SizedBox(height: 4),
                Row(
                  children: [
                    Flexible(child: PriceWidget(price: displayPrice)),
                    if (hasOffer) ...[
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          '${product.price} ${LanguageProvider.translate('global', 'currency')}',
                          style: TextStyleClass.captionStyle().copyWith(
                            decoration: TextDecoration.lineThrough,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColor.limeColor.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Text(
                    LanguageProvider.translate('global', 'cod_badge'),
                    style: TextStyleClass.captionStyle(color: AppColor.deepColor)
                        .copyWith(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColor.deepColor,
                    ),
                  ),
                ),
                if (expand) const Spacer() else const SizedBox(height: 6),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColor.limeColor,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.primaryColor.withValues(alpha: 0.2),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_shopping_cart,
                        color: AppColor.deepColor,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          LanguageProvider.translate('buttons', 'add_to_cart'),
                          style: TextStyleClass.smallStyle(
                                  color: AppColor.deepColor)
                              .copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
