import 'package:flutter/material.dart';
import 'flouka_boat_loader.dart';
import 'package:sizer/sizer.dart';
import '../config/app_color.dart';
import '../config/app_styles.dart';
import '../../features/language/presentation/provider/language_provider.dart';

class LoadingAnimationWidget extends StatelessWidget {
  const LoadingAnimationWidget({
    super.key,
    required this.gif,
    this.width,
    this.height,
    this.topPadding,
  });
  final double? width;
  final double? height;
  final double? topPadding;
  final String gif;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: topPadding ?? 12.h),
        // The logo's paper boat folds and unfolds. [gif] is kept for the
        // callers but no longer drawn.
        FloukaBoatLoader(size: width ?? 120),
        SizedBox(height: 5.h),
        Text(
          LanguageProvider.translate("global", "loading"),
          style: TextStyleClass.smallStyle(color: AppColor.mutedColor),
        ),
      ],
    );
  }
}
