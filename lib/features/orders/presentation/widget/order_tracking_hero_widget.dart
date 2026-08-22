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
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColor.deepColor,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -50,
            right: -40,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.limeColor.withValues(alpha: 0.14),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: AppColor.limeColor,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    LanguageProvider.translate('orders', status?.text ?? '')
                        .toUpperCase(),
                    style: TextStyleClass.captionStyle(color: AppColor.limeColor)
                        .copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                      letterSpacing: 0.06,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                _headline(status),
                style: TextStyleClass.headStyle(color: Colors.white).copyWith(
                  fontSize: 23,
                  fontWeight: FontWeight.w800,
                  height: 1.15,
                  letterSpacing: -0.02,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                LanguageProvider.translate('orders', 'tracking_subline')
                    .replaceAll('*vendor*', vendor)
                    .replaceAll('*count*', '$itemCount')
                    .replaceAll('*payment*', payment),
                style: TextStyleClass.smallStyle(
                  color: Colors.white.withValues(alpha: 0.6),
                ).copyWith(fontSize: 12.5, height: 1.4),
              ),
              const SizedBox(height: 15),
              Row(
                children: List.generate(4, (index) {
                  final active = index < _progressSteps(status);
                  return Expanded(
                    child: Container(
                      height: 5,
                      margin: EdgeInsetsDirectional.only(end: index == 3 ? 0 : 5),
                      decoration: BoxDecoration(
                        color: active
                            ? AppColor.limeColor
                            : Colors.white.withValues(alpha: 0.22),
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
