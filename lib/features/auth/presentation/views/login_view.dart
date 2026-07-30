import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/core/config/app_theme.dart';
import 'package:flouka/core/constants/app_images.dart';
import 'package:flouka/core/constants/constants.dart';
import 'package:flouka/core/widgets/flouka_primary_button.dart';
import 'package:flouka/core/widgets/list_text_field_widget.dart';
import 'package:flouka/features/auth/presentation/providers/auth_provider.dart';
import 'package:flouka/features/auth/presentation/widgets/login_social_media_list_widget.dart';
import 'package:flouka/features/auth/presentation/widgets/or_divider_widget.dart';
import 'package:flouka/features/auth/presentation/widgets/terms_checkbox_widget.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Phone OTP auth — mirrors web `/auth/login` (join = login + register).
class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider = Provider.of(context);
    final welcome = LanguageProvider.translate('auth', 'auth_welcome');
    final parts = welcome.split('\n');
    final title = parts.isNotEmpty ? parts.first : welcome;
    final subtitle = parts.length > 1 ? parts.sublist(1).join('\n') : '';

    return AnnotatedRegion(
      value: Constants.isTablet ? barColor() : lightBarColor(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColor.canvasColor,
        body: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              child: IgnorePointer(
                child: Image.asset(AppImages.topAuth, fit: BoxFit.fitWidth),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: IgnorePointer(
                child: Image.asset(AppImages.bottomAuth, fit: BoxFit.fitWidth),
              ),
            ),
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.pageGutter + 8,
                ),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Form(
                  key: authProvider.loginFormKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      Image.asset(AppImages.logo, width: 112),
                      const SizedBox(height: 20),
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyleClass.headStyle(color: AppColor.inkColor)
                            .copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 22,
                          height: 1.2,
                        ),
                      ),
                      if (subtitle.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          subtitle,
                          textAlign: TextAlign.center,
                          style: TextStyleClass.normalStyle(
                            color: AppColor.mutedColor,
                          ).copyWith(fontSize: 14, height: 1.4),
                        ),
                      ],
                      const SizedBox(height: 28),
                      ListTextFieldWidget(
                        inputs: authProvider.loginTextFieldList,
                      ),
                      const SizedBox(height: 12),
                      const TermsCheckboxWidget(),
                      const SizedBox(height: 16),
                      FloukaPrimaryButton(
                        onTap: () => authProvider.sendOTP(),
                        text: 'Get started',
                      ),
                      const SizedBox(height: 20),
                      const OrDividerWidget(),
                      const SizedBox(height: 16),
                      const LoginSocialMediaListWidget(),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
