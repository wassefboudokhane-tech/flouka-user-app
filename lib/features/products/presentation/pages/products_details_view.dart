import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/core/constants/app_lotties.dart';
import 'package:flouka/core/widgets/loading_animation_widget.dart';
import 'package:flouka/features/chat/presentation/provider/message_provider.dart';
import 'package:flouka/features/products/presentation/widgets/product_details_buy_footer_widget.dart';
import 'package:flouka/features/products/presentation/widgets/product_details_header_widget.dart';
import 'package:flouka/features/products/presentation/widgets/product_details_vendor_trust_widget.dart';
import 'package:flouka/features/products/presentation/widgets/review_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/config/app_color.dart';
import '../../../../core/config/app_radius.dart';
import '../../../../core/dialog/guest_dialog.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../language/presentation/provider/language_provider.dart';
import '../../../reviews/presentation/providres/product_reviews_provider.dart';
import '../providers/product_variant_provider.dart';
import '../providers/products_details_provider.dart';
import '../widgets/avg_rating_widget.dart';
import '../widgets/frequently_list_widget.dart';
import '../widgets/hot_deals_widget.dart';
import '../widgets/product_attributes_widget.dart';
import '../widgets/review_with_images_section.dart';

class ProductsDetailsView extends StatelessWidget {
  const ProductsDetailsView({super.key, required this.showAppBar});
  final bool showAppBar;

  @override
  Widget build(BuildContext context) {
    final productDetailsProvider = Provider.of<ProductDetailsProvider>(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (result, _) {
        if (!result) {
          productDetailsProvider.backToLastProduct();
        }
      },
      child: Scaffold(
        backgroundColor: AppColor.canvasColor,
        appBar: null,
        bottomNavigationBar:
            productDetailsProvider.data != null &&
                productDetailsProvider.shouldShowAddToCart()
            ? const ProductDetailsBuyFooterWidget()
            : null,
        body: Builder(
          builder: (context) {
            if (productDetailsProvider.data == null) {
              if (productDetailsProvider.errorMessage != null) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.pageGutter),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.error_outline, size: 44),
                        const SizedBox(height: 12),
                        Text(
                          productDetailsProvider.errorMessage!,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: productDetailsProvider.refresh,
                          child: Text(
                            LanguageProvider.translate('buttons', 'retry'),
                          ),
                        ),
                        TextButton(
                          onPressed: productDetailsProvider.backToLastProduct,
                          child: Text(
                            LanguageProvider.translate('buttons', 'back'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return const Center(
                child: LoadingAnimationWidget(gif: Lotties.loading),
              );
            }
            final product = productDetailsProvider.data!;
            final variant = productDetailsProvider.variantEntity();
            final displayPrice = variant != null
                ? (variant.offerPrice ?? variant.price)
                : (product.offerPrice ?? product.price);
            final rawStrike = variant != null
                ? (variant.offerPrice != null ? variant.price : null)
                : (product.offerPrice != null ? product.price : null);
            final strikePrice = (rawStrike != null && rawStrike != displayPrice)
                ? rawStrike
                : null;

            return SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ProductDetailsHeaderWidget(productEntity: product),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.pageGutter,
                      16,
                      AppSpacing.pageGutter,
                      0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (product.store != null)
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      '${LanguageProvider.translate('global', 'sold_by')} ',
                                  style: TextStyleClass.captionStyle(
                                    color: AppColor.mutedColor,
                                  ).copyWith(fontSize: 11.5, height: 1),
                                ),
                                TextSpan(
                                  text: product.store!.name.toUpperCase(),
                                  style: TextStyleClass.vendorStyle().copyWith(
                                    fontSize: 11.5,
                                    height: 1,
                                  ),
                                ),
                                if (product.store!.address.isNotEmpty)
                                  TextSpan(
                                    text: ' · ${product.store!.address}',
                                    style: TextStyleClass.captionStyle(
                                      color: AppColor.mutedColor,
                                    ).copyWith(fontSize: 11.5, height: 1),
                                  ),
                              ],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        const SizedBox(height: 6),
                        Text(
                          product.title ?? '',
                          style:
                              TextStyleClass.semiHeadStyle(
                                color: AppColor.inkColor,
                              ).copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                height: 1.24,
                                letterSpacing: -0.01,
                              ),
                        ),
                        const SizedBox(height: 11),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              '${displayPrice ?? 0}',
                              style: TextStyleClass.pdpPriceStyle(),
                            ),
                            const SizedBox(width: 9),
                            Text(
                              LanguageProvider.translate('global', 'currency'),
                              style:
                                  TextStyleClass.smallStyle(
                                    color: AppColor.mutedColor,
                                  ).copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                            ),
                            if (strikePrice != null) ...[
                              const SizedBox(width: 9),
                              Text(
                                '$strikePrice',
                                style:
                                    TextStyleClass.smallStyle(
                                      color: AppColor.mutedColor,
                                    ).copyWith(
                                      decoration: TextDecoration.lineThrough,
                                      fontSize: 13,
                                    ),
                              ),
                            ],
                            if ((product.discountPercentage ?? 0) > 0) ...[
                              const SizedBox(width: 9),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColor.redSoft,
                                  borderRadius: BorderRadius.circular(
                                    AppRadius.pill,
                                  ),
                                ),
                                child: Text(
                                  '-${product.discountPercentage!.toStringAsFixed(0)}%',
                                  style:
                                      TextStyleClass.captionStyle(
                                        color: AppColor.DealColor,
                                      ).copyWith(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 11,
                                      ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 13),
                        if (product.store != null)
                          ProductDetailsVendorTrustWidget(
                            store: product.store!,
                            rating: (product.rate ?? 0).toDouble(),
                          ),
                        const SizedBox(height: 13),
                        const ProductAttributesWidget(),
                        if (product.store != null) ...[
                          const SizedBox(height: 4),
                          _ChatVendorButton(storeId: product.store!.id),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    color: AppColor.backgroundColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.pageGutter,
                      vertical: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LanguageProvider.translate(
                            'global',
                            'Proudact Reating & Reviwes',
                          ),
                          style: TextStyleClass.normalStyle().copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        AvgRatingWidget(rating: product.rate ?? 0),
                        if (product.reviewImages.isNotEmpty) ...[
                          ReviewWithImagesSection(
                            reviewImages: product.reviewImages,
                          ),
                          const SizedBox(height: 10),
                        ],
                        if (product.reviews.isNotEmpty) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                LanguageProvider.translate(
                                  'global',
                                  'all_reviews',
                                ),
                                style: TextStyleClass.normalStyle(),
                              ),
                              InkWell(
                                onTap: () {
                                  Provider.of<ProductReviewsProvider>(
                                    context,
                                    listen: false,
                                  ).goToPage({'product_id': product.id});
                                },
                                child: Text(
                                  LanguageProvider.translate(
                                    'global',
                                    'see_all',
                                  ),
                                  style: TextStyleClass.normalStyle(
                                    color: AppColor.primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            children: List.generate(
                              product.reviews.length,
                              (index) => ReviewItemWidget(
                                review: product.reviews[index],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (product.related.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      color: AppColor.backgroundColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.pageGutter,
                        vertical: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            LanguageProvider.translate(
                              'global',
                              'Frequently Bought Together',
                            ),
                            style: TextStyleClass.normalStyle().copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 10),
                          FrequentlyListWidget(
                            relatedProducts: product.related,
                          ),
                        ],
                      ),
                    ),
                  ],
                  if ((product.description ?? '').isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      color: AppColor.backgroundColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.pageGutter,
                        vertical: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            LanguageProvider.translate('global', 'Description'),
                            style: TextStyleClass.normalStyle().copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            product.description!,
                            style: TextStyleClass.normalStyle(
                              color: AppColor.mutedColor,
                            ).copyWith(height: 1.6),
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (product.recommended.isNotEmpty)
                    HotDealsWidget(products: product.recommended),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ChatVendorButton extends StatelessWidget {
  const _ChatVendorButton({required this.storeId});

  final int storeId;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {
        if (!AuthProvider.isLogin()) {
          showGuestDialog();
          return;
        }
        Provider.of<MessageProvider>(
          context,
          listen: false,
        ).goToMessagePage(orderId: 0, storeId: storeId);
      },
      icon: Icon(
        Icons.chat_bubble_outline,
        color: AppColor.deepColor,
        size: 18,
      ),
      label: Text(
        LanguageProvider.translate('global', 'chat_vendor'),
        style: TextStyleClass.smallStyle(
          color: AppColor.deepColor,
        ).copyWith(fontWeight: FontWeight.w700),
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColor.deepColor,
        side: BorderSide(color: AppColor.borderColor),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
      ),
    );
  }
}
