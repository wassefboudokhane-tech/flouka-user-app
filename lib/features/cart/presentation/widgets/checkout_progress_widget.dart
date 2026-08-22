import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_radius.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flutter/material.dart';

class CheckoutProgressWidget extends StatelessWidget {
  const CheckoutProgressWidget({super.key, this.activeStep = 2});

  final int activeStep;

  @override
  Widget build(BuildContext context) {
    const labels = ['address_step', 'payment_step', 'confirmation_step'];
    return Row(
      children: List.generate(3, (index) {
        final done = index < activeStep;
        final active = index == activeStep;
        return Expanded(
          child: Padding(
            padding: EdgeInsetsDirectional.only(end: index < 2 ? 6 : 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  child: SizedBox(
                    height: 4,
                    child: ColoredBox(
                      color: done || active
                          ? AppColor.deepColor
                          : AppColor.borderColor,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  LanguageProvider.translate('checkout', labels[index]),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyleClass.captionStyle(
                    color: active
                        ? AppColor.deepColor
                        : AppColor.mutedColor,
                  ).copyWith(
                    fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
