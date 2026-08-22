// ignore_for_file: unused_import

import 'package:flouka/core/constants/app_images.dart';
import 'package:flouka/core/constants/constants.dart';
import 'package:flouka/core/helper_function/navigation.dart';
import 'package:flouka/core/helper_function/prefs.dart';
import 'package:flouka/features/auth/presentation/providers/auth_provider.dart';
import 'package:flouka/features/auth/presentation/views/login_view.dart';
import 'package:flouka/features/on_boarding/domain/entity/on_boarding_entity.dart';
import 'package:flouka/features/on_boarding/presentation/views/on_boarding_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../navbar/presentation/provider/nav_bar_provider.dart';

class OnBoardingProvider extends ChangeNotifier {
  void goToOnBoardingView() {
    navPARU(const OnBoardingView());
  }

  int index = 0;
  bool get isLastSlide => index == onBoardingList.length - 1;

  void onNextButtonPressed([int? index]) {
    if (index != null) {
      this.index = index;
      notifyListeners();
      return;
    }
    if (isLastSlide) {
      finishOnboardingToLogin();
    } else {
      this.index++;
      notifyListeners();
    }
  }

  void skipButtonPressed() {
    finishOnboardingAsGuest();
  }

  void finishOnboardingToLogin() {
    sharedPreferences.setBool('onBoarding', true);
    Constants.globalContext().read<AuthProvider>().goToLoginView();
  }

  void finishOnboardingAsGuest() {
    sharedPreferences.setBool('onBoarding', true);
    Constants.globalContext().read<AuthProvider>().continueAsGuest();
  }

  OnBoardingEntity get selected => onBoardingList[index];

  final List<OnBoardingEntity> onBoardingList = [
    OnBoardingEntity(
      title1: '1_title1',
      title2: '1_title2',
      description: '1_description',
      image: AppImages.onboardingImage1,
      color: const Color(0xffD7FC70),
      btnColor: const Color(0xff35035C),
      stepColor: const Color(0xff35035C),
      textColor: const Color(0xffAD46FF),
      btnTextColor: const Color(0xffD7FC70),
      descColor: const Color(0xff35035C).withAlpha(170),
    ),
    OnBoardingEntity(
      title1: '2_title1',
      title2: '2_title2',
      description: '2_description',
      image: AppImages.onboardingImage2,
      color: const Color(0xff35035C),
      btnColor: const Color(0xffD7FC70),
      stepColor: const Color(0xffD7FC70),
      textColor: const Color(0xffD7FC70),
      btnTextColor: const Color(0xff35035C),
      descColor: Colors.white.withAlpha(170),
    ),
    OnBoardingEntity(
      title1: '3_title1',
      title2: '3_title2',
      description: '3_description',
      image: AppImages.onboardingImage3,
      color: const Color(0xff35035C),
      btnColor: const Color(0xffD7FC70),
      stepColor: const Color(0xffD7FC70),
      textColor: const Color(0xffD7FC70),
      btnTextColor: const Color(0xff35035C),
      descColor: Colors.white.withAlpha(150),
    ),
  ];
}
