import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/config/app_radius.dart';
import 'package:flouka/core/constants/app_images.dart';
import 'package:flouka/core/constants/app_lotties.dart';
import 'package:flouka/core/widgets/loading_animation_widget.dart';
import 'package:flouka/core/widgets/svg_widget.dart';
import 'package:flouka/features/cart/presentation/providers/cart_provider.dart';
import 'package:flouka/features/products/presentation/widgets/gradiant_button.dart';
import 'package:flouka/features/products/presentation/widgets/product_details_header_widget.dart';
import 'package:flouka/features/products/presentation/widgets/review_widget.dart';
import 'package:flouka/features/stores/presentation/providers/store_details_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/config/app_color.dart';
import '../../../language/presentation/provider/language_provider.dart';
import '../../../reviews/presentation/providres/product_reviews_provider.dart';
import '../providers/products_details_provider.dart';
import '../providers/product_variant_provider.dart';
import '../widgets/avg_rating_widget.dart';
import '../widgets/frequently_list_widget.dart';
import '../widgets/hot_deals_widget.dart';
import '../widgets/product_attributes_widget.dart';
import '../widgets/review_with_images_section.dart';
import 'package:flouka/core/dialog/guest_dialog.dart';
import 'package:flouka/features/auth/presentation/providers/auth_provider.dart';
import 'package:flouka/features/chat/presentation/provider/message_provider.dart';

/// Product detail — section order mirrors web `ProductDetailClient`
/// (gallery → buy box → reviews/images → FBT → description → related).
class ProductsDetailsView extends StatelessWidget {
  const ProductsDetailsView({super.key, required this.showAppBar});
  final bool showAppBar;
  @override
  Widget build(BuildContext context) {
    final ProductDetailsProvider productDetailsProvider = Provider.of(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (result, _) {
        if (!result) {
          productDetailsProvider.backToLastProduct();
        }
      },
      child: Scaffold(
        backgroundColor: AppColor.canvasColor,
        appBar: showAppBar
            ? AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => productDetailsProvider.backToLastProduct(),
          ),
          actions: [
            InkWell(
              onTap: () {
                Provider.of<CartProvider>(context, listen: false).goToPage();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: const SvgWidget(svg: AppImages.navbarCart, color: Colors.white),
              ),
            ),
          ],
          title: Text(
            productDetailsProvider.data != null
                ? '${productDetailsProvider.data?.title ?? ''}'
                : LanguageProvider.translate('global', 'what_are_you_looking_for'),
          ),
        ):null,
        body: Builder(
          builder: (context) {
            if (productDetailsProvider.data == null) {
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
            final strikePrice =
                (rawStrike != null && rawStrike != displayPrice) ? rawStrike : null;

            return SingleChildScrollView(
              child: Column(
                children: [
                  ProductDetailsHeaderWidget(productEntity: product),
                  Container(
                    width: double.infinity,
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageGutter, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (product.store != null)
                          gradiantButton(
                            vendor: product.store!,
                            onTap: () {
                              Provider.of<StoreDetailsProvider>(context, listen: false)
                                  .goToStoreDetailsPage(product.store!.id);
                            },
                            gradiantcolors: [Colors.white, AppColor.primaryColor],
                          ),
                        const SizedBox(height: 12),
                        Text(
                          product.title ?? '',
                          style: TextStyleClass.headStyle(color: AppColor.inkColor).copyWith(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if ((product.rate ?? 0) > 0) ...[
                          const SizedBox(height: 6),
                          Text(
                            '★ ${(product.rate ?? 0).toStringAsFixed(1)} · ${product.reviews.length} ${LanguageProvider.translate('global', 'all_reviews')}',
                            style: TextStyleClass.captionStyle(),
                          ),
                        ],
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${displayPrice ?? 0} ${LanguageProvider.translate('global', 'currency')}',
                              style: TextStyleClass.headStyle(color: AppColor.deepColor).copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            if (strikePrice != null) ...[
                              const SizedBox(width: 8),
                              Text(
                                '$strikePrice ${LanguageProvider.translate('global', 'currency')}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColor.mutedColor,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ],
                            if ((product.discountPercentage ?? 0) > 0) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColor.redSoft,
                                  borderRadius: BorderRadius.circular(AppRadius.pill),
                                ),
                                child: Text(
                                  '-${product.discountPercentage!.toStringAsFixed(0)}%',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: AppColor.DealColor,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColor.limeColor.withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(AppRadius.pill),
                          ),
                          child: Text(
                            LanguageProvider.translate('global', 'cod_badge'),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppColor.deepColor,
                            ),
                          ),
                        ),
                        const ProductAttributesWidget(),
                        if (product.store != null) ...[
                          const SizedBox(height: 10),
                          _ChatVendorButton(storeId: product.store!.id),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Reviews + customer images (web order)
                  Container(
                    width: double.infinity,
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageGutter, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LanguageProvider.translate('global', 'Proudact Reating & Reviwes'),
                          style: TextStyleClass.normalStyle().copyWith(fontWeight: FontWeight.w700),
                        ),
                        AvgRatingWidget(rating: product.rate ?? 0),
                        if (product.reviewImages.isNotEmpty) ...[
                          ReviewWithImagesSection(reviewImages: product.reviewImages),
                          const SizedBox(height: 10),
                        ],
                        if (product.reviews.isNotEmpty) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                LanguageProvider.translate('global', 'all_reviews'),
                                style: TextStyleClass.normalStyle(),
                              ),
                              InkWell(
                                onTap: () {
                                  Provider.of<ProductReviewsProvider>(context, listen: false)
                                      .goToPage({'product_id': product.id});
                                },
                                child: Text(
                                  LanguageProvider.translate('global', 'see_all'),
                                  style: TextStyleClass.normalStyle(color: AppColor.primaryColor),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            children: List.generate(
                              product.reviews.length,
                              (index) => ReviewItemWidget(review: product.reviews[index]),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (product.related.isNotEmpty)
                    Container(
                      width: double.infinity,
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageGutter, vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            LanguageProvider.translate('global', 'Frequently Bought Together'),
                            style: TextStyleClass.normalStyle().copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 10),
                          FrequentlyListWidget(relatedProducts: product.related),
                        ],
                      ),
                    ),
                  if ((product.description ?? '').isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageGutter, vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            LanguageProvider.translate('global', 'Description'),
                            style: TextStyleClass.normalStyle().copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            product.description!,
                            style: TextStyleClass.normalStyle(color: AppColor.mutedColor)
                                .copyWith(height: 1.6),
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (product.recommended.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    HotDealsWidget(products: product.recommended),
                  ],
                  const SizedBox(height: AppSpacing.section),
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
        Provider.of<MessageProvider>(context, listen: false).goToMessagePage(
          orderId: 0,
          storeId: storeId,
        );
      },
      icon: Icon(Icons.chat_bubble_outline, color: AppColor.deepColor, size: 18),
      label: Text(
        LanguageProvider.translate('global', 'chat_vendor'),
        style: TextStyleClass.smallStyle(color: AppColor.deepColor)
            .copyWith(fontWeight: FontWeight.w700),
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
