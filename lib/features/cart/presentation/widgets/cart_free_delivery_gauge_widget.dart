import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_radius.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/features/cart/presentation/providers/checkout_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Free-delivery progress gauge in white card (hi-fi refonte).
class CartFreeDeliveryGaugeWidget extends StatelessWidget {
  const CartFreeDeliveryGaugeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final checkoutProvider = context.watch<CheckoutProvider>();
    final progress = checkoutProvider.freeDeliveryProgress();
    final label = checkoutProvider.freeDelvieryText();
    if (label == null || label.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: AppColor.backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColor.borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              label,
              style: TextStyleClass.captionStyle(color: AppColor.navColor)
                  .copyWith(fontWeight: FontWeight.w600, fontSize: 12.5),
            ),
            const SizedBox(height: 9),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.pill),
              child: SizedBox(
                height: AppSpacing.freeDeliveryGaugeHeight,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(color: AppColor.canvasColor),
                    FractionallySizedBox(
                      alignment: AlignmentDirectional.centerStart,
                      widthFactor: progress,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColor.primaryColor,
                              AppColor.limeColor,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
