import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/widgets/flouka_network_image.dart';
import 'package:flouka/core/config/app_radius.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/core/helper_function/convert.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_images.dart';
import '../../../favorite/presentation/providers/favorite_provider.dart';
import '../../domain/entity/product_entity.dart';
import '../providers/products_details_provider.dart';

/// Shared marketplace product card — hi-fi refonte (158px, 122px image).
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

  /// Rail / grid cell height — must cover image + vendor + title + price + CTA.
  static double estimatedHeight(double cardWidth) {
    // padding 10*2 + image 122 + vendor + title(2 lines) + price + CTA + gaps.
    // The extra 8px is the 2px RenderFlex overflow on the home rail.
    return AppSpacing.productCardImageHeight + 176;
  }

  String _ratingLabel() {
    final rate = product.rate ?? 0;
    if (rate <= 0) return '';
    final reviewCount = product.reviews.length;
    return LanguageProvider.translate('global', 'product_card_rating')
        .replaceAll('*rate*', rate.toStringAsFixed(1))
        .replaceAll('*num*', reviewCount.toString());
  }

  @override
  Widget build(BuildContext context) {
    final cardWidth = width ?? AppSpacing.productCardWidth;
    final displayPrice = product.offerPrice ?? product.price ?? 0;
    final hasOffer = product.offerPrice != null;
    final rate = product.rate ?? 0;
    final storeName = product.store?.name;
    final ratingLabel = _ratingLabel();

    return InkWell(
      onTap: () {
        Provider.of<ProductDetailsProvider>(context, listen: false).goToPage({
          'product_id': product.id,
          'is_similar': isSimilar,
        });
      },
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: Container(
        width: cardWidth,
        decoration: BoxDecoration(
          color: AppColor.backgroundColor,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: AppColor.borderColor),
        ),
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: AppSpacing.productCardImageHeight,
              width: double.infinity,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.btn),
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColor.softColor,
                            AppColor.backgroundColor,
                          ],
                        ),
                        image: DecorationImage(
                          image: product.image != null
                              ? floukaImageProvider(product.image!)
                              : const AssetImage(AppImages.logo),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  if (product.discountPercentage != null)
                    PositionedDirectional(
                      top: 7,
                      start: 7,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColor.DealColor,
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                        child: Text(
                          '-${product.discountPercentage!.toStringAsFixed(0)}%',
                          style: TextStyleClass.captionStyle(
                            color: AppColor.backgroundColor,
                          ).copyWith(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  PositionedDirectional(
                    top: 7,
                    end: 7,
                    child: Consumer<FavoriteProvider>(
                      builder: (context, provider, _) {
                        final isFav =
                            provider.favoriteIds.contains(product.id);
                        return InkWell(
                          onTap: () => provider.toggleFavorite(product),
                          customBorder: const CircleBorder(),
                          child: Container(
                            width: 26,
                            height: 26,
                            decoration: BoxDecoration(
                              color: isFav
                                  ? AppColor.primaryColor
                                  : AppColor.backgroundColor,
                              shape: BoxShape.circle,
                              border: isFav
                                  ? null
                                  : Border.all(color: AppColor.borderColor),
                            ),
                            child: Icon(
                              isFav
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFav
                                  ? AppColor.backgroundColor
                                  : AppColor.primaryColor,
                              size: 13,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            if (storeName != null && storeName.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                storeName,
                style: TextStyleClass.vendorStyle(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 2),
            Text(
              product.title ?? '',
              style: TextStyleClass.productTitleStyle(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (rate > 0 && ratingLabel.isNotEmpty) ...[
              const SizedBox(height: 3),
              Text(
                ratingLabel,
                style: TextStyleClass.captionStyle().copyWith(fontSize: 11),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 5),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Flexible(
                  child: Text(
                    formatPrice(displayPrice),
                    style: TextStyleClass.priceStyle(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (hasOffer) ...[
                  const SizedBox(width: 6),
                  Text(
                    formatPrice(product.price ?? 0),
                    style: TextStyleClass.captionStyle().copyWith(
                      decoration: TextDecoration.lineThrough,
                      fontSize: 11,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: Text(
                    LanguageProvider.translate('global', 'cod_badge'),
                    style: TextStyleClass.captionStyle(
                      color: AppColor.navColor,
                    ).copyWith(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Provider.of<ProductDetailsProvider>(context, listen: false)
                        .addToCart(product);
                  },
                  customBorder: const CircleBorder(),
                  child: Container(
                    width: AppSpacing.productAddBtnSize,
                    height: AppSpacing.productAddBtnSize,
                    decoration: BoxDecoration(
                      color: AppColor.limeColor,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '+',
                      style: TextStyleClass.smallStyle(
                        color: AppColor.deepColor,
                      ).copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        height: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
