import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_radius.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/features/creators/domain/entity/creator_entity.dart';
import 'package:flouka/features/creators/presentation/widgets/creator_avatar.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flutter/material.dart';

/// "Recommended by" strip on a product opened from a creator's shop.
class CreatorRecommendationBanner extends StatelessWidget {
  const CreatorRecommendationBanner({super.key, required this.creator});

  final CreatorEntity creator;

  @override
  Widget build(BuildContext context) {
    final niche = creator.niche ?? '';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColor.softColor,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Row(
        children: [
          CreatorAvatar(creator: creator, size: 36),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LanguageProvider.translate('creators', 'recommended_by'),
                  style: TextStyleClass.captionStyle(
                    color: AppColor.mutedColor,
                  ),
                ),
                Text(
                  creator.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyleClass.smallStyle(
                    color: AppColor.inkColor,
                  ).copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          if (niche.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: AppColor.limeColor,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: Text(
                niche,
                style: TextStyleClass.captionStyle(color: AppColor.inkColor),
              ),
            ),
        ],
      ),
    );
  }
}
