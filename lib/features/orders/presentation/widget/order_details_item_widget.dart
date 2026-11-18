import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_radius.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flouka/features/reviews/presentation/providres/create_rate_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/config/app_styles.dart';
import '../../../../core/widgets/flouka_network_image.dart';
import '../../domain/entity/order_details_entity.dart';
import '../../domain/entity/order_entity.dart';

class OrderDetailsItemWidget extends StatelessWidget {
  const OrderDetailsItemWidget({super.key, required this.orderDetailsEntity});
  final OrderDetailsEntity orderDetailsEntity;

  @override
  Widget build(BuildContext context) {
    final items = orderDetailsEntity.vendorOrder?.items ?? const <OrderItemEntity>[];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.canvasColor,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColor.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LanguageProvider.translate('global', 'item_summary'),
            style: TextStyleClass.smallStyle(color: AppColor.inkColor).copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          for (var index = 0; index < items.length; index++) ...[
            _Line(order: orderDetailsEntity, item: items[index]),
            if (index < items.length - 1)
              Divider(height: 20, color: AppColor.borderColor),
          ],
        ],
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({required this.order, required this.item});
  final OrderDetailsEntity order;
  final OrderItemEntity item;

  @override
  Widget build(BuildContext context) {
    final name = item.variant?.name ?? item.product?.title ?? '';
    final price = item.variant?.finalPrice ?? item.product?.finalPrice ?? item.price;
    final image = item.product?.image;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: AppColor.softColor,
            border: Border.all(color: AppColor.borderColor),
            borderRadius: BorderRadius.circular(AppRadius.card),
          ),
          clipBehavior: Clip.antiAlias,
          child: image == null || image.isEmpty
              ? null
              : FloukaNetworkImage(url: image, fit: BoxFit.cover),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyleClass.smallStyle(color: AppColor.inkColor),
              ),
              const SizedBox(height: 2),
              Text(
                LanguageProvider.translate('orders', item.status?.text ?? ''),
                style: TextStyleClass.captionStyle(color: AppColor.mutedColor),
              ),
              const SizedBox(height: 4),
              Text(
                '$price ${LanguageProvider.translate('global', 'currency')}',
                style: TextStyleClass.smallStyle(color: AppColor.inkColor).copyWith(fontWeight: FontWeight.w700),
              ),
              if (item.canReviewProduct == true)
                TextButton(
                  onPressed: () {
                    context.read<CreateRateProvider>().gotoReviewPage(
                          itemId: item.productId!,
                          orderId: order.id!,
                          product: true,
                        );
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: AppColor.inkColor,
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(LanguageProvider.translate('buttons', 'rate')),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
