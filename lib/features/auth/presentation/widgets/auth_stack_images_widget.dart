import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/constants/app_images.dart';

class AuthStackImagesWidget extends StatelessWidget {
  const AuthStackImagesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final maxH = MediaQuery.sizeOf(context).height;
    return SizedBox(
      height: (maxH * 0.42).clamp(180.0, 320.0),
      width: 100.w,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Positioned.fill(child: Image.asset(AppImages.circles, fit: BoxFit.fill)),
          Positioned(
            left: 0,
            right: 0,
            bottom: -5.h,
            child: Transform.scale(
              scale: 1.15,
              child: Image.asset(AppImages.onboardingImage1, width: 50.w),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 4.h,
            child: Image.asset(AppImages.logo),
          ),
        ],
      ),
    );
  }
}
