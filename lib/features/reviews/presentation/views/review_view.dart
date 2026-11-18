import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flutter/material.dart';
import '../../../language/presentation/provider/language_provider.dart';
import '../../../products/domain/entity/product_review_entity.dart';

class ReviewView extends StatelessWidget {
  const ReviewView({super.key, required this.review});
  final ProductReviewEntity review;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.canvasColor,
      appBar: AppBar(
        backgroundColor: AppColor.canvasColor,
        elevation: 0,
        foregroundColor: AppColor.inkColor,
        title: Text(
          LanguageProvider.translate('global', 'customer_reviews'),
          style: TextStyleClass.semiHeadStyle(color: AppColor.inkColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.pageGutter),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              review.user.name,
              style: TextStyleClass.smallStyle(color: AppColor.mutedColor),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                for (var i = 0; i < 5; i++)
                  Icon(
                    i < review.rating ? Icons.star : Icons.star_border,
                    size: 16,
                    color: AppColor.inkColor,
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              review.comment,
              style: TextStyleClass.smallStyle(color: AppColor.inkColor),
            ),
          ],
        ),
      ),
    );
  }
}
