import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_radius.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/core/helper_function/convert.dart';
import 'package:flouka/core/widgets/svg_widget.dart';
import 'package:flouka/features/auth/presentation/providers/auth_provider.dart';
import 'package:flouka/features/cart/presentation/providers/checkout_provider.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entity/payment_method_entity.dart';

class PaymentMthodItemWidget extends StatelessWidget {
  const PaymentMthodItemWidget({super.key, required this.paymentMethodEntity});
  final PaymentMethodEntity paymentMethodEntity;

  @override
  Widget build(BuildContext context) {
    final checkoutProvider = Provider.of<CheckoutProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final selected =
        checkoutProvider.isPaymentMethodSelected(paymentMethodEntity);
    final disabled = checkoutProvider.isPaymentMethodDisabled(paymentMethodEntity);
    final isWallet = paymentMethodEntity.toAPI == 'wallet';
    final walletBalance = authProvider.userEntity?.wallet ?? 0;

    return Opacity(
      opacity: disabled ? 0.55 : 1,
      child: InkWell(
        onTap: disabled
            ? null
            : () => checkoutProvider.selectPaymentMethod(paymentMethodEntity),
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            color: selected ? AppColor.softColor : AppColor.backgroundColor,
            borderRadius: BorderRadius.circular(AppRadius.btn),
            border: Border.all(
              color: selected ? AppColor.deepColor : AppColor.borderColor,
              width: selected ? 1.8 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SvgWidget(
                    svg: paymentMethodEntity.image,
                    color: selected ? AppColor.deepColor : AppColor.mutedColor,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      LanguageProvider.translate(
                        'global',
                        paymentMethodEntity.paymentMethod,
                      ),
                      style: TextStyleClass.smallStyle(
                        color: AppColor.deepColor,
                      ).copyWith(
                        fontWeight:
                            selected ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ),
                  if (paymentMethodEntity.isRecommended)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColor.limeColor,
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                      child: Text(
                        LanguageProvider.translate(
                          'checkout',
                          'recommended_badge',
                        ),
                        style: TextStyleClass.captionStyle(
                          color: AppColor.deepColor,
                        ).copyWith(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  if (selected)
                    Padding(
                      padding: const EdgeInsetsDirectional.only(start: 8),
                      child: Icon(
                        Icons.check_circle_rounded,
                        color: AppColor.primaryColor,
                        size: 20,
                      ),
                    ),
                ],
              ),
              if (paymentMethodEntity.subtitleKey != null && !isWallet) ...[
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 36),
                  child: Text(
                    LanguageProvider.translate(
                      'checkout',
                      paymentMethodEntity.subtitleKey!,
                    ),
                    style: TextStyleClass.captionStyle(color: AppColor.mutedColor)
                        .copyWith(fontSize: 11.5, height: 1.3),
                  ),
                ),
              ],
              if (isWallet) ...[
                const SizedBox(height: 8),
                Text(
                  LanguageProvider.translate('checkout', 'wallet_balance')
                      .replaceAll(
                    '*balance*',
                    formatPrice(convertDataToNum(walletBalance) ?? 0),
                  ),
                  style: TextStyleClass.captionStyle(),
                ),
                if (disabled) ...[
                  const SizedBox(height: 4),
                  Text(
                    LanguageProvider.translate('checkout', 'wallet_insufficient')
                        .replaceAll(
                      '*amount*',
                      formatPrice(checkoutProvider.walletShortfall()),
                    ),
                    style: TextStyleClass.captionStyle(color: AppColor.DealColor),
                  ),
                  const SizedBox(height: 6),
                  TextButton(
                    onPressed: () {
                      checkoutProvider.selectPaymentMethod(
                        checkoutProvider.paymentMethods.first,
                      );
                    },
                    child: Text(
                      LanguageProvider.translate(
                        'recovery',
                        'wallet_use_cod',
                      ),
                      style: TextStyleClass.captionStyle(
                        color: AppColor.primaryColor,
                      ).copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}
