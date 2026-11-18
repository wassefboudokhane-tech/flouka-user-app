import 'package:flouka/core/creator_attribution.dart';
import 'package:flouka/features/creators/domain/entity/creator_entity.dart';
import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/widgets/flouka_network_image.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/core/helper_function/convert.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../favorite/presentation/providers/favorite_provider.dart';
import '../../domain/entity/product_entity.dart';
import '../providers/products_details_provider.dart';

/// Shared product card: photo, shop, title, price and a small add button. No frame.
class HotDealsHomeContainerWidget extends StatelessWidget {
  const HotDealsHomeContainerWidget({
    super.key,
    required this.product,
    this.isSimilar = false,
    this.width,
    this.creator,
  });

  final ProductEntity product;
  final bool isSimilar;
  final double? width;

  /// Set when the card sits in a creator's shop: opening it credits them.
  final CreatorEntity? creator;

  /// Rail / grid cell height — must cover image + vendor + title + price + CTA.
  static double estimatedHeight(double cardWidth) {
    // image + vendor + title (2 lines) + price row + gaps.
    return AppSpacing.productCardImageHeight + 96;
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
        final from = creator;
        // Same rule as a ?creator= link: 7 days, last click wins.
        if (from != null) CreatorAttributionStore.capture(from.handle);
        Provider.of<ProductDetailsProvider>(context, listen: false).goToPage({
          'product_id': product.id,
          'is_similar': isSimilar,
          if (from != null) 'creator': from,
        });
      },
      child: SizedBox(
        width: cardWidth,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: AppSpacing.productCardImageHeight,
              width: double.infinity,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColor.softColor,
                        image: product.image != null
                            ? DecorationImage(
                                image: floukaImageProvider(product.image!),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                    ),
                  ),
                  if (product.discountPercentage != null)
                    PositionedDirectional(
                      top: 8,
                      start: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        color: AppColor.inkColor,
                        child: Text(
                          '-${product.discountPercentage!.toStringAsFixed(0)} %',
                          style: TextStyleClass.captionStyle(color: Colors.white)
                              .copyWith(fontSize: 10, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  PositionedDirectional(
                    top: 6,
                    end: 6,
                    child: Consumer<FavoriteProvider>(
                      builder: (context, provider, _) {
                        final isFav = provider.favoriteIds.contains(product.id);
                        return InkWell(
                          onTap: () => provider.toggleFavorite(product),
                          customBorder: const CircleBorder(),
                          child: SizedBox(
                            width: 30,
                            height: 30,
                            child: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              color: AppColor.inkColor,
                              size: 18,
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
              const SizedBox(height: 8),
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
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.end,
                    spacing: 6,
                    children: [
                      Text(
                        formatPriceWithCurrency(displayPrice),
                        style: TextStyleClass.priceStyle(),
                        maxLines: 1,
                      ),
                      if (hasOffer)
                        Text(
                          formatPrice(product.price ?? 0),
                          style: TextStyleClass.captionStyle().copyWith(
                            decoration: TextDecoration.lineThrough,
                            fontSize: 11,
                          ),
                        ),
                    ],
                  ),
                ),
                if (rate > 0 && ratingLabel.isNotEmpty)
                  Text(
                    '★ ${rate.toStringAsFixed(1)}',
                    style: TextStyleClass.captionStyle().copyWith(fontSize: 11),
                  ),
                const SizedBox(width: 6),
                Semantics(
                  button: true,
                  label: LanguageProvider.translate('buttons', 'add_to_cart'),
                  child: InkWell(
                    onTap: () {
                      final from = creator;
                      // Adding from a creator shop credits them, same as opening
                      // the product. Last click wins, for 7 days.
                      if (from != null) CreatorAttributionStore.capture(from.handle);
                      Provider.of<ProductDetailsProvider>(
                        context,
                        listen: false,
                      ).addToCart(product, creator: from);
                    },
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColor.inkColor),
                      ),
                      alignment: Alignment.center,
                      child: Icon(Icons.add, size: 16, color: AppColor.inkColor),
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
