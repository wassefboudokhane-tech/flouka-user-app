import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_radius.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import '../providers/otp_provider.dart';

/// 4-digit OTP cells — Flouka merch tokens (white fill, purple focus).
class CustomOTPField extends StatelessWidget {
  const CustomOTPField({super.key, this.onCompleted});

  final ValueChanged<String>? onCompleted;

  @override
  Widget build(BuildContext context) {
    final otpProvider = Provider.of<OtpProvider>(context);
    final width = MediaQuery.sizeOf(context).width;
    // Keep cells visible on narrow phones: 4 boxes + gaps inside page gutters.
    final cell = ((width - 64) / 4 - 10).clamp(52.0, 64.0);

    return Directionality(
      textDirection: TextDirection.ltr,
      child: MaterialPinField(
        length: 4,
        pinController: otpProvider.otpController,
        keyboardType: TextInputType.number,
        autoFocus: true,
        obscureText: false,
        enableAutofill: true,
        autofillHints: const [AutofillHints.oneTimeCode],
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        mainAxisAlignment: MainAxisAlignment.center,
        theme: MaterialPinTheme(
          shape: MaterialPinShape.outlined,
          spacing: 12,
          cellSize: Size(cell, cell),
          borderRadius: BorderRadius.circular(AppRadius.btn),
          borderWidth: 1.5,
          focusedBorderWidth: 2,
          fillColor: Colors.white,
          focusedFillColor: Colors.white,
          filledFillColor: Colors.white,
          completeFillColor: Colors.white,
          borderColor: AppColor.borderColor,
          focusedBorderColor: AppColor.primaryColor,
          filledBorderColor: AppColor.primaryColor.withValues(alpha: 0.45),
          completeBorderColor: AppColor.primaryColor,
          cursorColor: AppColor.deepColor,
          textStyle: TextStyleClass.headStyle(color: AppColor.inkColor).copyWith(
            fontWeight: FontWeight.w800,
            fontSize: 22,
            height: 1,
          ),
        ),
        onCompleted: onCompleted,
        onChanged: (value) => otpProvider.onOtpChanged(value),
      ),
    );
  }
}
