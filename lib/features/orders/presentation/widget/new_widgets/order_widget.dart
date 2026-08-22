import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_radius.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/core/helper_function/convert.dart';
import 'package:flouka/core/widgets/vendor_cancelled_recovery_widget.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flouka/features/orders/domain/entity/order_entity.dart';
import 'package:flouka/features/orders/presentation/provider/get_edit_order_provider.dart';
import 'package:flouka/features/orders/presentation/widget/item_out_of_stock_widget.dart';
import 'package:flouka/features/orders/presentation/widget/new_widgets/order_store_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Order list card — hi-fi soft card + status pill (no purple shadow).
class OrderWidget extends StatelessWidget {
  const OrderWidget({super.key, required this.order});

  final OrderEntity order;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.borderColor),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: order.status.color,
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(16),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _OrderIdRow(order: order),
                    if (order.status == OrderStatus.cancelled) ...[
                      const SizedBox(height: 12),
                      VendorCancelledRecoveryWidget(
                        refundAmount: order.total != null
                            ? formatPrice(order.total!)
                            : null,
                        reason: LanguageProvider.translate(
                          'orders',
                          order.status.des,
                        ),
                      ),
                    ],
                    if (order.isAnyUnavailable()) ...[
                      const SizedBox(height: 12),
                      ItemOutOfStockWidget(id: order.id!),
                    ],
                    ...List.generate(order.vendorOrders?.length ?? 0, (v) {
                      final vendor = order.vendorOrders![v];
                      return OrderStoreWidget(
                        vendor: vendor,
                        order: order,
                      );
                    }),
                    if (order.isAnyUnavailable() ||
                        order.status == OrderStatus.paid) ...[
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 44,
                        child: OutlinedButton(
                          onPressed: () {
                            context.read<GetEditOrderProvider>().cancelOrder(
                                  id: order.id!,
                                  isFromOrderDetails: true,
                                );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColor.DealColor,
                            side: BorderSide(color: AppColor.DealColor),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(AppRadius.pill),
                            ),
                          ),
                          child: Text(
                            LanguageProvider.translate(
                              'orders',
                              'cancel_entire_order',
                            ),
                            style: TextStyleClass.smallStyle(
                              color: AppColor.DealColor,
                            ).copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ],
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

class _OrderIdRow extends StatelessWidget {
  const _OrderIdRow({required this.order});

  final OrderEntity order;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            '#FLK-${order.id}',
            style: TextStyleClass.smallStyle(color: AppColor.deepColor).copyWith(
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: order.status.color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: Border.all(color: order.status.color.withValues(alpha: 0.45)),
          ),
          child: Text(
            LanguageProvider.translate('orders', order.status.text),
            style: TextStyleClass.captionStyle(color: order.status.color)
                .copyWith(fontWeight: FontWeight.w700, fontSize: 11),
          ),
        ),
      ],
    );
  }
}
