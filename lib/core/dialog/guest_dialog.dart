import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/core/constants/constants.dart';
import 'package:flouka/core/helper_function/navigation.dart';
import 'package:flouka/features/auth/presentation/providers/auth_provider.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

void checkGuest(Function onTap) {
  if (AuthProvider.isLogin()) {
    onTap();
  } else {
    showGuestDialog();
  }
}

/// Guest gate — flat Flouka branding (web → mobile), no 3D lock asset.
void showGuestDialog() {
  showDialog(
    context: Constants.globalContext(),
    barrierColor: Colors.black.withValues(alpha: 0.45),
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        insetPadding: EdgeInsets.symmetric(horizontal: 6.w),
        child: Padding(
          padding: EdgeInsets.fromLTRB(5.w, 3.h, 5.w, 2.5.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColor.limeColor.withValues(alpha: 0.45),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.lock_outline, color: AppColor.deepColor, size: 28),
              ),
              SizedBox(height: 2.h),
              Text(
                LanguageProvider.translate('warning', 'must_login'),
                style: TextStyleClass.normalStyle(color: AppColor.inkColor)
                    .copyWith(fontWeight: FontWeight.w800, fontSize: 17.sp),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 1.h),
              Text(
                LanguageProvider.translate('warning', 'must_login_first'),
                style: TextStyleClass.smallStyle(color: AppColor.mutedColor)
                    .copyWith(height: 1.45),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 2.5.h),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        navPop();
                        Provider.of<AuthProvider>(
                          Constants.globalContext(),
                          listen: false,
                        ).goToLoginView();
                      },
                      borderRadius: BorderRadius.circular(999),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 1.4.h),
                        decoration: BoxDecoration(
                          color: AppColor.limeColor,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          LanguageProvider.translate('buttons', 'login'),
                          textAlign: TextAlign.center,
                          style: TextStyleClass.normalStyle(color: AppColor.deepColor)
                              .copyWith(fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: InkWell(
                      onTap: navPop,
                      borderRadius: BorderRadius.circular(999),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 1.4.h),
                        decoration: BoxDecoration(
                          color: AppColor.softColor,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: const Color(0xffE6DDF2)),
                        ),
                        child: Text(
                          LanguageProvider.translate('buttons', 'cancel'),
                          textAlign: TextAlign.center,
                          style: TextStyleClass.normalStyle(color: AppColor.deepColor)
                              .copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
