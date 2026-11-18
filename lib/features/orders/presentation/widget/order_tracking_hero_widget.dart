import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flouka/features/orders/domain/entity/order_details_entity.dart';
import 'package:flouka/features/orders/domain/entity/order_entity.dart';
import 'package:flutter/material.dart';

class OrderTrackingHeroWidget extends StatelessWidget {
  const OrderTrackingHeroWidget({super.key, required this.order});

  final OrderDetailsEntity order;

  String _headline(OrderStatus? status) {
    if (status == OrderStatus.fulfilled) {
      return LanguageProvider.translate('orders', 'order_delivered');
    }
    if (status == OrderStatus.processing || status == OrderStatus.paid) {
      return LanguageProvider.translate('orders', 'order_processing');
    }
    return LanguageProvider.translate('orders', 'order_arriving_today');
  }

  int _progressSteps(OrderStatus? status) {
    final level = status?.level ?? 1;
    if (level >= 10) return 4;
    if (level >= 7) return 3;
    if (level >= 4) return 2;
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    final status = order.status;
    final vendor = order.vendorOrder?.store?.name ?? '';
    final itemCount = order.vendorOrder?.items?.length ?? 0;
    final payment = order.paymentMethod == 'cash'
        ? LanguageProvider.translate('global', 'cod_badge')
        : order.paymentMethod ?? '';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.canvasColor,
        border: Border.all(color: AppColor.borderColor),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LanguageProvider.translate('orders', status?.text ?? ''),
            style: TextStyleClass.captionStyle(color: AppColor.mutedColor),
          ),
          const SizedBox(height: 8),
          Text(
            _headline(status),
            style: TextStyleClass.headStyle(color: AppColor.inkColor).copyWith(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            LanguageProvider.translate('orders', 'tracking_subline')
                .replaceAll('*vendor*', vendor)
                .replaceAll('*count*', '$itemCount')
                .replaceAll('*payment*', payment),
            style: TextStyleClass.smallStyle(color: AppColor.mutedColor),
          ),
          const SizedBox(height: 14),
          Row(
            children: List.generate(4, (index) {
              final active = index < _progressSteps(status);
              return Expanded(
                child: Container(
                  height: 3,
                  margin: EdgeInsetsDirectional.only(end: index == 3 ? 0 : 4),
                  color: active ? AppColor.inkColor : AppColor.borderColor,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
