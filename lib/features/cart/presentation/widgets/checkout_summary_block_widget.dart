import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_radius.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flutter/material.dart';

import 'checkout_terms_widget.dart';
import 'coupons_widget.dart';
import 'price_details_widget.dart';

/// Checkout block 3 — coupon, partial shipment, price recap.
class CheckoutSummaryBlockWidget extends StatelessWidget {
  const CheckoutSummaryBlockWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.backgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColor.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LanguageProvider.translate('checkout', 'summary_title'),
            style: TextStyleClass.railTitleStyle(),
          ),
          const SizedBox(height: 12),
          const CouponsWidget(),
          const SizedBox(height: 8),
          const CheckoutTermsWidget(),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColor.softColor,
              borderRadius: BorderRadius.circular(AppRadius.btn),
            ),
            child: const PriceDetailesList(isBold: true),
          ),
        ],
      ),
    );
  }
}
