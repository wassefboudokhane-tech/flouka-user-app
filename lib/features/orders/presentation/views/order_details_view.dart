import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/core/helper_function/navigation.dart';
import 'package:flouka/core/widgets/flouka_back_button.dart';
import 'package:flouka/core/widgets/vendor_cancelled_recovery_widget.dart';
import 'package:flouka/features/chat/presentation/provider/message_provider.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flouka/features/orders/domain/entity/order_entity.dart';
import 'package:flouka/features/orders/presentation/provider/order_details_provider.dart';
import 'package:flouka/features/orders/presentation/widget/item_out_of_stock_widget.dart';
import 'package:flouka/features/orders/presentation/widget/order_details_item_widget.dart';
import 'package:flouka/features/orders/presentation/widget/order_driver_card_widget.dart';
import 'package:flouka/features/orders/presentation/widget/order_price_details_widget.dart';
import 'package:flouka/features/orders/presentation/widget/order_tracking_hero_widget.dart';
import 'package:flouka/features/orders/presentation/widget/order_tracking_timeline_widget.dart';
import 'package:flouka/features/orders/presentation/widget/share_your_experience_widget.dart';
import 'package:flouka/features/tickets/presentation/provider/add_ticket_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_lotties.dart';
import '../../../../core/helper_function/convert.dart';
import '../../../../core/widgets/loading_animation_widget.dart';
import '../widget/custom_order_payment_way_widget.dart';

class OrderDetailsView extends StatelessWidget {
  const OrderDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final orderDetailsProvider = Provider.of<OrderDetailsProvider>(context);

    return Scaffold(
      backgroundColor: AppColor.canvasColor,
      body: SafeArea(
        bottom: false,
        child: Builder(
          builder: (context) {
            if (orderDetailsProvider.data == null) {
              return const Center(
                child: LoadingAnimationWidget(gif: Lotties.loading),
              );
            }
            final order = orderDetailsProvider.data!;
            final itemCount = order.vendorOrder?.items?.length ?? 0;
            final created = order.createdAt != null
                ? convertDateTimeToString(DateTime.parse(order.createdAt!))
                : '';

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.pageGutter,
                    4,
                    AppSpacing.pageGutter,
                    12,
                  ),
                  child: Row(
                    children: [
                      FloukaBackButton(onTap: navPop),
                      const SizedBox(width: 11),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '#FLK-${order.id}',
                              style: TextStyleClass.headStyle(
                                color: AppColor.deepColor,
                              ).copyWith(
                                fontSize: 19,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.02,
                              ),
                            ),
                            Text(
                              LanguageProvider.translate(
                                'orders',
                                'tracking_header_sub',
                              )
                                  .replaceAll('*date*', created)
                                  .replaceAll('*count*', '$itemCount'),
                              style: TextStyleClass.captionStyle(
                                color: AppColor.mutedColor,
                              ).copyWith(fontSize: 11.5),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.pageGutter,
                      0,
                      AppSpacing.pageGutter,
                      16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (order.vendorOrder?.isAnyUnavailable() ?? false)
                          ItemOutOfStockWidget(id: order.id!),
                        if (order.status != OrderStatus.cancelled)
                          OrderTrackingHeroWidget(order: order),
                        if (order.status == OrderStatus.cancelled) ...[
                          VendorCancelledRecoveryWidget(
                            refundAmount: order.total != null
                                ? formatPrice(order.total!)
                                : null,
                            reason: LanguageProvider.translate(
                              'orders',
                              order.status!.des,
                            ),
                          ),
                        ],
                        const SizedBox(height: 12),
                        if (order.status != OrderStatus.cancelled) ...[
                          OrderTrackingTimelineWidget(order: order),
                          const SizedBox(height: 12),
                          if (order.vendorOrder?.store?.id != null)
                            OrderDriverCardWidget(
                              storeId: order.vendorOrder!.store!.id!,
                            ),
                        ],
                        if (order.vendorOrder?.canRateStore == true) ...[
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColor.backgroundColor,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColor.borderColor),
                            ),
                            child: ShareYourExperienceWidget(
                              StoreId: order.vendorOrder!.store!.id!,
                              orderId: order.id!,
                            ),
                          ),
                        ],
                        const SizedBox(height: 12),
                        OrderDetailsItemWidget(orderDetailsEntity: order),
                        const SizedBox(height: 12),
                        CustomOrderPaymentWayWidget(orderDetailsEntity: order),
                        const SizedBox(height: 12),
                        const OrderPriceDetailsWidget(),
                      ],
                    ),
                  ),
                ),
                if (order.status != OrderStatus.cancelled &&
                    order.vendorOrder?.store?.id != null)
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.pageGutter,
                      0,
                      AppSpacing.pageGutter,
                      MediaQuery.paddingOf(context).bottom + 12,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              context
                                  .read<AddTicketProvider>()
                                  .goToAddTicketPage();
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColor.deepColor,
                              backgroundColor: AppColor.backgroundColor,
                              side: BorderSide(color: AppColor.borderColor),
                              minimumSize: const Size.fromHeight(50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                            child: Text(
                              LanguageProvider.translate(
                                'orders',
                                'file_complaint',
                              ),
                              style: TextStyleClass.smallStyle(
                                color: AppColor.deepColor,
                              ).copyWith(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: FilledButton(
                            onPressed: () {
                              context.read<MessageProvider>().goToMessagePage(
                                    orderId: order.id ?? 0,
                                    storeId: order.vendorOrder!.store!.id!,
                                  );
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColor.deepColor,
                              foregroundColor: Colors.white,
                              minimumSize: const Size.fromHeight(50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                            child: Text(
                              LanguageProvider.translate(
                                'orders',
                                'contact_vendor',
                              ),
                              style: TextStyleClass.smallStyle(color: Colors.white)
                                  .copyWith(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
