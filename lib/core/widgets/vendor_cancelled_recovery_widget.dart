import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/core/widgets/recovery_card_widget.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flouka/features/products/presentation/providers/categories_product_search_provider.dart';
import 'package:flouka/features/tickets/presentation/provider/tickets_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VendorCancelledRecoveryWidget extends StatelessWidget {
  const VendorCancelledRecoveryWidget({
    super.key,
    this.refundAmount,
    this.reason,
    this.alternativesCount = 0,
  });

  final String? refundAmount;
  final String? reason;
  final int alternativesCount;

  @override
  Widget build(BuildContext context) {
    final altLabel = LanguageProvider.translate('recovery', 'vendor_cancel_alternatives')
        .replaceAll('*num*', alternativesCount.toString());

    return RecoveryCardWidget(
      section: 'recovery',
      titleKey: 'vendor_cancel_title',
      preservedKey: 'vendor_cancel_preserved',
      actionKey: 'vendor_cancel_alternatives',
      onAction: alternativesCount > 0
          ? () {
              Provider.of<CategoriesProductSearchProvider>(
                context,
                listen: false,
              ).goToPage();
            }
          : null,
      secondaryKey: 'vendor_cancel_ticket',
      onSecondary: () {
        Provider.of<TicketsProvider>(context, listen: false).goToTicketsPage();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (reason != null && reason!.isNotEmpty)
            Text(reason!, style: TextStyleClass.captionStyle()),
          if (refundAmount != null) ...[
            const SizedBox(height: 6),
            Text(
              LanguageProvider.translate('recovery', 'vendor_cancel_refund')
                  .replaceAll('*amount*', refundAmount!),
              style: TextStyleClass.captionStyle(color: AppColor.primaryColor)
                  .copyWith(fontWeight: FontWeight.w700),
            ),
          ],
          if (alternativesCount > 0) ...[
            const SizedBox(height: 6),
            Text(
              altLabel,
              style: TextStyleClass.captionStyle(color: AppColor.mutedColor),
            ),
          ],
        ],
      ),
    );
  }
}
