import 'package:flouka/core/config/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sizer/sizer.dart';

class CustomStarRatingWidget extends StatelessWidget {
  const CustomStarRatingWidget({super.key, this.itemSize, required this.rating,
    this.onRatingUpdate,
    this.readOnly =false});
  final double? itemSize;
  final num rating;
  final Function(num value)? onRatingUpdate;
  final bool readOnly;
  @override
  Widget build(BuildContext context) {
    return RatingBar(
      maxRating: 5,
      glowColor: Colors.transparent,
      initialRating: rating.toDouble(),
      ignoreGestures: readOnly,
      itemSize: itemSize ?? 18.sp,
      allowHalfRating: true,
      ratingWidget: RatingWidget(
        full: Icon(Icons.star, color: AppColor.inkColor),
        half: Icon(Icons.star_half, color: AppColor.inkColor),
        empty: Icon(Icons.star_border, color: AppColor.inkColor),
      ),
      onRatingUpdate: (value) {
        if(onRatingUpdate!=null){
          onRatingUpdate!(value);
        }
      },
    );
  }
}
