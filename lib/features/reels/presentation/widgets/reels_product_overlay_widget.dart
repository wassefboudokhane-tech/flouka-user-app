import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_radius.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flouka/features/products/presentation/providers/products_details_provider.dart';
import 'package:flouka/features/reels/presentation/models/reel_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReelsProductOverlayWidget extends StatelessWidget {
  const ReelsProductOverlayWidget({super.key, required this.reelItem});

  final ReelItem reelItem;

  @override
  Widget build(BuildContext context) {
    if (reelItem.reel.productId == null) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 11),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColor.backgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColor.softColor, AppColor.backgroundColor],
              ),
              border: Border.all(color: AppColor.borderColor),
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reelItem.reel.vendorName,
                  style: TextStyleClass.vendorStyle().copyWith(fontSize: 10.5),
                ),
                Text(
                  reelItem.reel.title ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyleClass.smallStyle(color: AppColor.inkColor)
                      .copyWith(fontSize: 12.5, height: 1.25),
                ),
              ],
            ),
          ),
          Material(
            color: AppColor.limeColor,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            child: InkWell(
              onTap: () {
                Provider.of<ProductDetailsProvider>(context, listen: false)
                    .goToPage({'product_id': reelItem.reel.productId});
              },
              borderRadius: BorderRadius.circular(AppRadius.pill),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                child: Text(
                  LanguageProvider.translate('reels', 'add_product'),
                  style: TextStyleClass.captionStyle(color: AppColor.deepColor)
                      .copyWith(fontWeight: FontWeight.w800, fontSize: 12.5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
