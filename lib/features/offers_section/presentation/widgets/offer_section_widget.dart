import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/features/offers_section/domain/entity/offer_section_entity.dart';
import 'package:flouka/features/products/presentation/providers/recommend_products_provider.dart';
import 'package:flouka/features/products/presentation/widgets/hot_deals_home_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class OffersSectionWidget extends StatelessWidget {
  const OffersSectionWidget({super.key, required this.offerSectionEntity});
  final OfferSectionEntity offerSectionEntity;

  @override
  Widget build(BuildContext context) {
    if (offerSectionEntity.products.isEmpty) return const SizedBox.shrink();

    final cardWidth = 43.w;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
      decoration: BoxDecoration(
        color: offerSectionEntity.color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColor.borderColor.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      offerSectionEntity.title,
                      style: TextStyleClass.normalStyle(
                        color: offerSectionEntity.titleColor ?? Colors.white,
                      ).copyWith(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w800,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (offerSectionEntity.description.isNotEmpty)
                      Text(
                        offerSectionEntity.description,
                        style: TextStyleClass.smallStyle(
                          color: offerSectionEntity.descriptionColor ?? Colors.white,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              if (offerSectionEntity.buttonText.isNotEmpty)
                InkWell(
                  onTap: () {
                    Provider.of<RecommendProductsProvider>(context, listen: false)
                        .goToPage({
                      'title': offerSectionEntity.title,
                      'section_id': offerSectionEntity.id,
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 0.8.h,
                      horizontal: 3.w,
                    ),
                    decoration: BoxDecoration(
                      color: offerSectionEntity.buttonColor ?? AppColor.limeColor,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      offerSectionEntity.buttonText,
                      maxLines: 2,
                      style: TextStyleClass.captionStyle(
                        color: offerSectionEntity.buttonTextColor ??
                            AppColor.deepColor,
                      ).copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 1.2.h),
          SizedBox(
            height: cardWidth * 1.55,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: offerSectionEntity.products.length,
              separatorBuilder: (_, __) => SizedBox(width: 2.5.w),
              itemBuilder: (context, index) {
                return HotDealsHomeContainerWidget(
                  product: offerSectionEntity.products[index],
                  width: cardWidth,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
