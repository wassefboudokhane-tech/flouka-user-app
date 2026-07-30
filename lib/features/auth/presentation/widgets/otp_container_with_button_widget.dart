import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/features/auth/presentation/providers/auth_provider.dart';
import 'package:flouka/features/auth/presentation/providers/otp_provider.dart';
import 'package:flouka/features/auth/presentation/widgets/custom_otp_field.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// OTP title, phone hint, pin field, resend — illustration removed so cells stay visible.
class OtpContainerWithButton extends StatelessWidget {
  const OtpContainerWithButton({super.key});

  @override
  Widget build(BuildContext context) {
    final otpProvider = Provider.of<OtpProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final phone = authProvider.loginTextFieldList[0].controller.text.trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          LanguageProvider.translate('auth', 'otp'),
          textAlign: TextAlign.center,
          style: TextStyleClass.headStyle(color: AppColor.inkColor).copyWith(
            fontWeight: FontWeight.w800,
            fontSize: 22,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 10),
        Text.rich(
          TextSpan(
            style: TextStyleClass.normalStyle(color: AppColor.mutedColor)
                .copyWith(fontSize: 14, height: 1.45),
            children: [
              TextSpan(
                text: LanguageProvider.translate(
                  'auth',
                  'Enter the verification code sent to',
                ),
              ),
              TextSpan(
                text: phone.isEmpty ? '—' : phone,
                style: TextStyleClass.normalStyle(color: AppColor.deepColor)
                    .copyWith(fontWeight: FontWeight.w700, fontSize: 14),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 28),
        CustomOTPField(
          onCompleted: (_) => otpProvider.checkCode(),
        ),
        const SizedBox(height: 20),
        Center(
          child: Selector<OtpProvider, int>(
            selector: (_, p) => p.counter,
            builder: (context, counter, _) {
              final canResend = counter <= 0;
              final text = canResend
                  ? LanguageProvider.translate('auth', 'resend_otp')
                  : '${LanguageProvider.translate('auth', 'resend_otp_after')} ${otpProvider.sendCode(counter)}';

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
                    textAlign: TextAlign.center,
                    style: TextStyleClass.normalStyle(
                      color: canResend
                          ? AppColor.primaryColor
                          : AppColor.mutedColor,
                    ).copyWith(
                      fontWeight: canResend ? FontWeight.w700 : FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
