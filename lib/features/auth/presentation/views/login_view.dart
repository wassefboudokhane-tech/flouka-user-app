import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/core/config/app_theme.dart';
import 'package:flouka/core/constants/constants.dart';
import 'package:flouka/core/widgets/flouka_back_button.dart';
import 'package:flouka/core/widgets/flouka_primary_button.dart';
import 'package:flouka/features/auth/presentation/providers/auth_provider.dart';
import 'package:flouka/features/auth/presentation/providers/otp_provider.dart';
import 'package:flouka/features/auth/presentation/widgets/auth_phone_field.dart';
import 'package:flouka/features/auth/presentation/widgets/country_widget.dart';
import 'package:flouka/features/auth/presentation/widgets/custom_otp_field.dart';
import 'package:flouka/features/auth/presentation/widgets/terms_checkbox_widget.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Unified phone + OTP auth — hi-fi mockup.
class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final isOtpStep = authProvider.authStep == AuthStep.otp;

    return AnnotatedRegion(
      value: Constants.isTablet ? barColor() : lightBarColor(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColor.canvasColor,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.pageGutter + 4,
            ),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Form(
              key: authProvider.loginFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 4, bottom: 8),
                    child: FloukaBackButton(
                      onTap: () {
                        if (isOtpStep) {
                          authProvider.backToPhoneStep();
                        } else {
                          Navigator.of(context).maybePop();
                        }
                      },
                    ),
                  ),
                  if (isOtpStep)
                    const _OtpStep()
                  else
                    _PhoneStep(authProvider: authProvider),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PhoneStep extends StatelessWidget {
  const _PhoneStep({required this.authProvider});

  final AuthProvider authProvider;

  @override
  Widget build(BuildContext context) {
    final welcome = LanguageProvider.translate('auth', 'auth_welcome');
    final parts = welcome.split('\n');
    final title = parts.isNotEmpty ? parts.first : welcome;
    final subtitle = parts.length > 1 ? parts.sublist(1).join('\n') : '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: TextStyleClass.headStyle(color: AppColor.deepColor).copyWith(
            fontWeight: FontWeight.w800,
            fontSize: 24,
            height: 1.2,
          ),
        ),
        if (subtitle.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyleClass.normalStyle(color: AppColor.mutedColor)
                .copyWith(fontSize: 15, height: 1.45),
          ),
        ],
        const SizedBox(height: 24),
        AuthPhoneField(field: authProvider.loginTextFieldList.first),
        const SizedBox(height: 14),
        const TermsCheckboxWidget(),
        const SizedBox(height: 16),
        ListenableBuilder(
          listenable: authProvider.loginTextFieldList.first.controller,
          builder: (context, _) {
            final phone =
                authProvider.loginTextFieldList.first.controller.text.trim();
            return Selector<AuthProvider, bool>(
              selector: (_, p) => p.termsAccepted,
              builder: (context, termsAccepted, __) {
                return FloukaPrimaryButton(
                  onTap: () => authProvider.sendOTP(),
                  text: 'send_otp',
                  enabled: termsAccepted && phone.length >= phoneLength,
                );
              },
            );
          },
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: authProvider.continueAsGuest,
          child: Text(
            LanguageProvider.translate('auth', 'guest_description'),
            style: TextStyleClass.normalStyle(color: AppColor.mutedColor)
                .copyWith(fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ),
      ],
    );
  }
}

class _OtpStep extends StatelessWidget {
  const _OtpStep();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final phone = authProvider.loginTextFieldList.first.controller.text.trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          LanguageProvider.translate('auth', 'otp'),
          style: TextStyleClass.headStyle(color: AppColor.deepColor).copyWith(
            fontWeight: FontWeight.w800,
            fontSize: 24,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 10),
        Text.rich(
          TextSpan(
            style: TextStyleClass.normalStyle(color: AppColor.mutedColor)
                .copyWith(fontSize: 15, height: 1.45),
            children: [
              TextSpan(
                text: LanguageProvider.translate(
                  'auth',
                  'Enter the verification code sent to',
                ),
              ),
              TextSpan(
                text: ' $defaultCountry $phone',
                style: TextStyleClass.normalStyle(color: AppColor.deepColor)
                    .copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: TextButton(
            onPressed: authProvider.backToPhoneStep,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              LanguageProvider.translate('auth', 'change_phone'),
              style: TextStyleClass.smallStyle(color: AppColor.primaryColor)
                  .copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        ),
        const SizedBox(height: 16),
        CustomOTPField(
          onCompleted: (_) =>
              context.read<OtpProvider>().checkCode(),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColor.softColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColor.borderColor),
          ),
          child: Text(
            LanguageProvider.translate('auth', 'otp_sms_hint'),
            style: TextStyleClass.captionStyle(color: AppColor.mutedColor)
                .copyWith(fontSize: 12, height: 1.35),
          ),
        ),
        const SizedBox(height: 14),
        Center(
          child: Selector<OtpProvider, int>(
            selector: (_, p) => p.counter,
            builder: (context, counter, _) {
              final canResend = counter <= 0;
              final text = canResend
                  ? LanguageProvider.translate('auth', 'resend_otp')
                  : '${LanguageProvider.translate('auth', 'resend_otp_after')} $counter ${LanguageProvider.translate('time', 'sec')}';

              return InkWell(
                onTap: canResend
                    ? () => authProvider.sendOTP(isResend: true)
                    : null,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: Text(
                    text,
                    style: TextStyleClass.normalStyle(
                      color: canResend
                          ? AppColor.primaryColor
                          : AppColor.mutedColor,
                    ).copyWith(
                      fontWeight:
                          canResend ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        Selector<OtpProvider, bool>(
          selector: (_, p) => p.isOtpComplete,
          builder: (context, complete, _) {
            return FloukaPrimaryButton(
              onTap: () => context.read<OtpProvider>().checkCode(),
              text: 'verify',
              enabled: complete,
            );
          },
        ),
      ],
    );
  }
}
