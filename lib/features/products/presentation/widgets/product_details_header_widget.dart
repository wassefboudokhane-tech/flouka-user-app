import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_radius.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/constants/app_images.dart';
import 'package:flouka/core/constants/constants.dart';
import 'package:flouka/core/widgets/flouka_back_button.dart';
import 'package:flouka/core/widgets/flouka_network_image.dart';
import 'package:flouka/core/widgets/svg_widget.dart';
import 'package:flouka/features/favorite/presentation/providers/favorite_provider.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flouka/features/products/presentation/providers/products_details_provider.dart';
import 'package:flutter/material.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../domain/entity/product_entity.dart';

class ProductDetailsHeaderWidget extends StatelessWidget {
  const ProductDetailsHeaderWidget({super.key, required this.productEntity});
  final ProductEntity productEntity;

  @override
  Widget build(BuildContext context) {
    final productDetailsProvider = Provider.of<ProductDetailsProvider>(context);
    final images = productDetailsProvider.images();
    final top = MediaQuery.paddingOf(context).top;

    return SizedBox(
      height: AppSpacing.pdpHeroHeight,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (images.isEmpty)
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColor.softColor,
                    AppColor.backgroundColor,
                    AppColor.canvasColor,
                  ],
                ),
              ),
            )
          else
            CarouselSlider(
              items: images.map((item) {
                return PinchZoom(
                  child: FloukaNetworkImage(
                    url: item.image,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    error: const Icon(Icons.error),
                  ),
                );
              }).toList(),
              controller: productDetailsProvider.controller,
              options: CarouselOptions(
                viewportFraction: 1.0,
                height: AppSpacing.pdpHeroHeight,
                enlargeCenterPage: false,
                autoPlay: false,
                onPageChanged: (index, reason) {
                  productDetailsProvider.changeImageIndex(index: index);
                },
              ),
            ),
          Positioned(
            top: top + 8,
            left: AppSpacing.pageGutter,
            child: FloukaBackButton(
              onTap: () => productDetailsProvider.backToLastProduct(),
            ),
          ),
          Positioned(
            top: top + 8,
            right: AppSpacing.pageGutter,
            child: Row(
              children: [
                _OverlayIconButton(
                  onTap: () async {
                    final url =
                        '${Constants.baseUri}product?id=${productEntity.id}';
                    final box = context.findRenderObject() as RenderBox?;
                    await Share.share(
                      "${LanguageProvider.translate('settings', 'share_description').replaceFirst('*product*', '${productEntity.title}').replaceFirst('*description*', '${productEntity.description}')}\n$url",
                      sharePositionOrigin: Constants.isTablet
                          ? (box!.localToGlobal(Offset.zero) & box.size)
                          : null,
                    );
                  },
                  child: const SvgWidget(
                    svg: AppImages.share,
                    width: 16,
                    height: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Consumer<FavoriteProvider>(
                  builder: (context, provider, _) {
                    final isFav =
                        provider.favoriteIds.contains(productEntity.id);
                    return _OverlayIconButton(
                      onTap: () =>
                          provider.toggleFavorite(productEntity),
                      child: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        size: 17,
                        color: AppColor.deepColor,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          if (images.length > 1)
            Positioned(
              left: 0,
              right: 0,
              bottom: 14,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(images.length, (index) {
                  final active =
                      productDetailsProvider.imageIndex == index;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: active ? 18 : 5,
                    height: 5,
                    margin: const EdgeInsets.symmetric(horizontal: 2.5),
                    decoration: BoxDecoration(
                      color: active
                          ? AppColor.deepColor
                          : AppColor.borderColor,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }
}

class _OverlayIconButton extends StatelessWidget {
  const _OverlayIconButton({required this.onTap, required this.child});

  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColor.backgroundColor.withValues(alpha: 0.9),
      borderRadius: BorderRadius.circular(AppRadius.checkoutBack),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.checkoutBack),
        child: SizedBox(
          width: 40,
          height: 40,
          child: Center(child: child),
        ),
      ),
    );
  }
}
