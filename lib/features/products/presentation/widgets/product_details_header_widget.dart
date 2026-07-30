import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flouka/core/constants/app_images.dart';
import 'package:flutter/material.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/config/app_color.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/dialog/report_dialog.dart';
import '../../../../core/widgets/circle_action_button_widget.dart';
import '../../../favorite/presentation/providers/favorite_provider.dart';
import '../../../language/presentation/provider/language_provider.dart';
import '../../domain/entity/product_entity.dart';
import '../providers/products_details_provider.dart';

class ProductDetailsHeaderWidget extends StatelessWidget {
  const ProductDetailsHeaderWidget({super.key, required this.productEntity});
  final ProductEntity productEntity;

  @override
  Widget build(BuildContext context) {
    final ProductDetailsProvider productDetailsProvider = Provider.of(context);
    final images = productDetailsProvider.images();
    return Column(
      children: [
        SizedBox(
          height: 32.h,
          width: 100.w,
          child: Stack(
            children: [
              Positioned.fill(
                child: CarouselSlider(
                  items: images.map((item) {
                    return PinchZoom(
                      child: CachedNetworkImage(
                        imageUrl: item.image,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    );
                  }).toList(),
                  controller: productDetailsProvider.controller,
                  options: CarouselOptions(
                    viewportFraction: 1.0,
                    enlargeCenterPage: false,
                    autoPlay: false,
                    onPageChanged: (index, reason) {
                      productDetailsProvider.changeImageIndex(index: index);
                    },
                  ),
                ),
              ),
              Positioned(
                top: 2.h,
                right: 2.w,
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        reportDialog(
                          title: LanguageProvider.translate('global', 'complaint'),
                          type: 'product',
                          id: productDetailsProvider.data?.id ?? 0,
                        );
                      },
                      child: const CircleActionButtonWidget(
                        svgImage: AppImages.flag,
                        color: Colors.red,
                      ),
                    ),
                    SizedBox(height: 1.5.h),
                    InkWell(
                      onTap: () async {
                        String url =
                            '${Constants.baseUri}product?id=${productEntity.id}';
                        final box = context.findRenderObject() as RenderBox?;
                        await Share.share(
                          "${LanguageProvider.translate('settings', 'share_description').replaceFirst('*product*', '${productEntity.title}').replaceFirst('*description*', '${productEntity.description}')}\n$url",
                          sharePositionOrigin: Constants.isTablet
                              ? (box!.localToGlobal(Offset.zero) & box.size)
                              : null,
                        );
                      },
                      child: const CircleActionButtonWidget(
                        svgImage: AppImages.share,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 1.5.h),
                    InkWell(
                      onTap: () {
                        FavoriteProvider favoriteProvider =
                            Provider.of(context, listen: false);
                        favoriteProvider.toggleFavorite(productEntity);
                      },
                      child: Container(
                        width: 8.w,
                        height: 8.w,
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
                            bool isFav =
                                provider.favoriteIds.contains(productEntity.id);
                            return Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              color: Colors.white,
                              size: 22,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (images.length > 1) ...[
          SizedBox(height: 1.h),
          SizedBox(
            height: 7.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              itemCount: images.length,
              separatorBuilder: (_, __) => SizedBox(width: 2.w),
              itemBuilder: (context, index) {
                final selected = productDetailsProvider.imageIndex == index;
                return InkWell(
                  onTap: () {
                    productDetailsProvider.animateToImage(index: index);
                  },
                  child: Container(
                    width: 7.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: selected
                            ? AppColor.primaryColor
                            : AppColor.borderColor,
                        width: selected ? 2 : 1,
                      ),
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(images[index].image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}
