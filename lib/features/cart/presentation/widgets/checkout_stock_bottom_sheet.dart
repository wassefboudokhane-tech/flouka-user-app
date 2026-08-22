import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_radius.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/core/helper_function/navigation.dart';
import 'package:flouka/features/cart/presentation/providers/cart_provider.dart';
import 'package:flouka/features/cart/presentation/providers/checkout_provider.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/constants.dart';

class CheckoutStockBottomSheet {
  static Future<void> show({required String message}) {
    final ctx = Constants.globalContext();
    final checkout = ctx.read<CheckoutProvider>();
    final cart = ctx.read<CartProvider>();

    return showModalBottomSheet<void>(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: AppColor.canvasColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.cartSummaryTop),
        ),
      ),
      builder: (context) {
        final items = cart.data ?? [];
        return Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.pageGutter,
            16,
            AppSpacing.pageGutter,
            MediaQuery.paddingOf(context).bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                LanguageProvider.translate('recovery', 'checkout_stock_title'),
                style: TextStyleClass.screenTitleStyle().copyWith(fontSize: 22),
              ),
              const SizedBox(height: 8),
              Text(
                message.isNotEmpty
                    ? message
                    : LanguageProvider.translate(
                        'recovery',
                        'checkout_stock_body',
                      ),
                style: TextStyleClass.smallStyle(color: AppColor.mutedColor)
                    .copyWith(height: 1.45),
              ),
              if (items.isNotEmpty) ...[
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: AppColor.backgroundColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColor.borderColor),
                  ),
                  child: Column(
                    children: [
                      for (var i = 0; i < items.length && i < 4; i++) ...[
                        Padding(
                          padding: const EdgeInsets.all(13),
                          child: Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: AppColor.softColor,
                                  borderRadius: BorderRadius.circular(13),
                                  border: Border.all(color: AppColor.borderColor),
                                ),
                              ),
                              const SizedBox(width: 11),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      items[i].product?.title ?? '',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyleClass.smallStyle(
                                        color: AppColor.inkColor,
                                      ).copyWith(fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      LanguageProvider.translate(
                                        'recovery',
                                        'checkout_stock_unavailable',
                                      ),
                                      style: TextStyleClass.captionStyle(
                                        color: AppColor.DealColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (i < items.length - 1 && i < 3)
                          Divider(
                            height: 1,
                            color: AppColor.canvasColor,
                            indent: 13,
                            endIndent: 13,
                          ),
                      ],
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 16),
              Material(
                color: AppColor.limeColor,
                borderRadius: BorderRadius.circular(AppRadius.pill),
                child: InkWell(
                  onTap: () {
                    navPop();
                    checkout.selectPaymentMethod(checkout.paymentMethods.first);
                  },
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  child: SizedBox(
                    height: 54,
                    child: Center(
                      child: Text(
                        LanguageProvider.translate(
                          'global',
                          'continue_available',
                        ),
                        style: TextStyleClass.buttonStyle(
                          color: AppColor.deepColor,
                        ).copyWith(fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: navPop,
                child: Text(
                  LanguageProvider.translate(
                    'recovery',
                    'checkout_stock_cancel',
                  ),
                  style: TextStyleClass.smallStyle(color: AppColor.mutedColor),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
