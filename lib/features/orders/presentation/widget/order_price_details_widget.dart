import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import '../../../../core/config/app_color.dart';
import '../../../../core/config/app_radius.dart';
import '../../../../core/config/app_styles.dart';
import '../provider/order_details_provider.dart';

class OrderPriceDetailsWidget extends StatelessWidget {
  const OrderPriceDetailsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final order = context.watch<OrderDetailsProvider>().data!;
    final currency = LanguageProvider.translate('global', 'currency');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.canvasColor,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColor.borderColor),
      ),
      child: Column(
        children: [
          _row(LanguageProvider.translate('global', 'price'), order.subTotal, currency),
          if ((order.deliveryPrice ?? 0) > 0) ...[
            const SizedBox(height: 8),
            _row(LanguageProvider.translate('global', 'delivery'), order.deliveryPrice, currency),
          ],
          if ((order.discount ?? 0) != 0) ...[
            const SizedBox(height: 8),
            _row(LanguageProvider.translate('global', 'discount'), order.discount, currency),
          ],
          if ((order.tax ?? 0) > 0) ...[
            const SizedBox(height: 8),
            _row(LanguageProvider.translate('global', 'tax'), order.tax, currency),
          ],
          Divider(height: 24, color: AppColor.borderColor),
          _row(LanguageProvider.translate('global', 'total'), order.total, currency, strong: true),
        ],
      ),
    );
  }

  Widget _row(String title, double? amount, String currency, {bool strong = false}) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyleClass.smallStyle(color: strong ? AppColor.inkColor : AppColor.mutedColor)
              .copyWith(fontWeight: strong ? FontWeight.w700 : FontWeight.w400),
        ),
        const Spacer(),
        Text(
          '${amount ?? 0} $currency',
          style: TextStyleClass.smallStyle(color: AppColor.inkColor)
              .copyWith(fontWeight: strong ? FontWeight.w800 : FontWeight.w600),
        ),
      ],
    );
  }
}
