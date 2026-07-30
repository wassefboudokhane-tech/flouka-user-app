import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/core/helper_function/navigation.dart';
import 'package:flouka/core/widgets/list_text_field_widget.dart';
import 'package:flouka/features/auth/presentation/providers/auth_provider.dart';
import 'package:flouka/features/auth/presentation/providers/otp_provider.dart';
import 'package:flouka/features/auth/presentation/widgets/custom_text_with_under_line_login_text.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/widgets/flouka_primary_button.dart';
import '../widgets/login_social_media_list_widget.dart';
import '../widgets/or_divider_widget.dart';

/// Phone-only signup — mirrors web `/auth/login`.
class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider = Provider.of(context);
    final OtpProvider otpProvider = Provider.of(context);
    return Scaffold(
      backgroundColor: AppColor.canvasColor,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.pageGutter + 8,
          ),
          child: Form(
            key: authProvider.registerFormKey,
            child: Column(
              children: [
                const SizedBox(height: 32),
                Image.asset(AppImages.logo, width: 112),
                const SizedBox(height: 16),
                Text(
                  LanguageProvider.translate('auth', 'auth_welcome'),
                  textAlign: TextAlign.center,
                  style: TextStyleClass.smallStyle().copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: AppColor.inkColor,
                  ),
                ),
                const SizedBox(height: 32),
                ListTextFieldWidget(
                  inputs: authProvider.registerTextFieldList,
                ),
                const SizedBox(height: 16),
                FloukaPrimaryButton(
                  onTap: () => otpProvider.goToOTPView(),
                  text: 'Get started',
                ),
                const SizedBox(height: 16),
                const OrDividerWidget(),
                const SizedBox(height: 16),
                const LoginSocialMediaListWidget(),
                const SizedBox(height: 16),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: CustomTextWithUnderLineText(
                    customText: 'Already have an account?',
                    underLineText: 'Login',
                    onTap: () => navPop(),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
