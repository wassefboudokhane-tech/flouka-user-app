import 'package:flouka/core/config/app_styles.dart';
import 'package:flutter/material.dart';

import '../../../../core/config/app_color.dart';
import '../../../../core/config/app_radius.dart';
import '../../../language/presentation/provider/language_provider.dart';
import '../../domain/entity/order_details_entity.dart';

class CustomOrderPaymentWayWidget extends StatelessWidget {
  const CustomOrderPaymentWayWidget({super.key, required this.orderDetailsEntity});
  final OrderDetailsEntity orderDetailsEntity;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColor.canvasColor,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColor.borderColor),
      ),
      child: Row(
        children: [
          Text(
            LanguageProvider.translate('global', 'payment_details'),
            style: TextStyleClass.smallStyle(color: AppColor.mutedColor),
          ),
          const Spacer(),
          Text(
            LanguageProvider.translate('global', orderDetailsEntity.paymentMethod ?? ''),
            style: TextStyleClass.smallStyle(color: AppColor.inkColor).copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
