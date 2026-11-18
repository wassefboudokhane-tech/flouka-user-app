import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../products/domain/entity/product_review_entity.dart';
import '../../../products/presentation/widgets/review_widget.dart';

class RatingBottomSheetWidget extends StatelessWidget {
  const RatingBottomSheetWidget({super.key, required this.review});
  final ProductReviewEntity review;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35.h,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(4),
          topRight: Radius.circular(4),
        ),
      ),
      child: Container(
        // Add your content here
        child: Column(
          children: [
            SizedBox(height: 5.h),
            ReviewItemWidget(textColor: const Color(0xFF1A1A1A), review: review, onlyOne: true),
          ],
        ),
      ),
    );
  }
}
