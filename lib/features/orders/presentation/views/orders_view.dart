import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/core/constants/app_lotties.dart';
import 'package:flouka/core/widgets/loading_animation_widget.dart';
import 'package:flouka/core/widgets/loading_widget.dart';
import 'package:flouka/features/orders/domain/entity/order_entity.dart';
import 'package:flouka/features/orders/presentation/widget/new_widgets/order_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flouka/features/orders/presentation/provider/order_provider.dart';
import '../../../language/presentation/provider/language_provider.dart';
import '../widgets/orders_empty_recovery_widget.dart';

class OrdersView extends StatelessWidget {
  const OrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<OrderProvider>(context);
    ordersProvider.pagination();

    return Scaffold(
      backgroundColor: AppColor.canvasColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.pageGutter,
                6,
                AppSpacing.pageGutter,
                12,
              ),
              child: Text(
                LanguageProvider.translate('global', 'orders'),
                style: TextStyleClass.screenTitleStyle(),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async => ordersProvider.refresh(),
                child: Builder(
                  builder: (context) {
                    if (ordersProvider.data == null) {
                      return const Center(
                        child: LoadingAnimationWidget(gif: Lotties.loading),
                      );
                    }
                    if (ordersProvider.data!.isEmpty) {
                      return ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: const [
                          SizedBox(height: 48),
                          OrdersEmptyRecoveryWidget(),
                        ],
                      );
                    }
                    return ListView.builder(
                      controller: ordersProvider.controller,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.pageGutter,
                        0,
                        AppSpacing.pageGutter,
                        24,
                      ),
                      itemCount: ordersProvider.data!.length +
                          (ordersProvider.paginationStarted ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index >= ordersProvider.data!.length) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(child: LoadingWidget()),
                          );
                        }
                        final OrderEntity order = ordersProvider.data![index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: OrderWidget(order: order),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
