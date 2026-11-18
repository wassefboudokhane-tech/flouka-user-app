import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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
        // The animations were drawn in the old purple: shown in greys.
        ColorFiltered(
          colorFilter: const ColorFilter.matrix(<double>[
            0.2126, 0.7152, 0.0722, 0, 0,
            0.2126, 0.7152, 0.0722, 0, 0,
            0.2126, 0.7152, 0.0722, 0, 0,
            0, 0, 0, 1, 0,
          ]),
          child: Lottie.asset(
            gif,
            fit: BoxFit.cover,
            width: width,
            height: height,
          ),
        ),
        SizedBox(height: 5.h),
        Text(
          LanguageProvider.translate("global", "loading"),
          style: TextStyleClass.smallStyle(color: AppColor.mutedColor),
        ),
      ],
    );
  }
}
