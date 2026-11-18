import 'package:flouka/features/auth/presentation/providers/auth_provider.dart';
import 'package:flouka/core/widgets/flouka_primary_button.dart';
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
    if (ordersProvider.needsLogin && ordersProvider.hasSession()) {
      // Back from the login page with a session: load the orders now.
      WidgetsBinding.instance.addPostFrameCallback((_) => ordersProvider.refresh());
    }

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
                    if (ordersProvider.needsLogin) {
                      return const _SignInPrompt();
                    }
                    if (ordersProvider.loadError != null) {
                      return _LoadFailed(
                        message: ordersProvider.loadError!,
                        onRetry: ordersProvider.refresh,
                      );
                    }
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

class _SignInPrompt extends StatelessWidget {
  const _SignInPrompt();

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(AppSpacing.pageGutter, 64, AppSpacing.pageGutter, 24),
      children: [
        Text(
          LanguageProvider.translate('orders', 'login_title'),
          style: TextStyleClass.semiHeadStyle(),
        ),
        const SizedBox(height: 8),
        Text(
          LanguageProvider.translate('orders', 'login_hint'),
          style: TextStyleClass.smallStyle(color: AppColor.mutedColor),
        ),
        const SizedBox(height: 24),
        FloukaPrimaryButton(
          text: LanguageProvider.translate('orders', 'login_cta'),
          translateKey: false,
          onTap: () => Provider.of<AuthProvider>(context, listen: false)
              .goToLoginView(replace: false),
        ),
      ],
    );
  }
}

class _LoadFailed extends StatelessWidget {
  const _LoadFailed({required this.message, required this.onRetry});

  final String message;
  final Future Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(AppSpacing.pageGutter, 64, AppSpacing.pageGutter, 24),
      children: [
        Text(message, style: TextStyleClass.normalStyle()),
        const SizedBox(height: 16),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: OutlinedButton(
            onPressed: onRetry,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColor.inkColor,
              side: BorderSide(color: AppColor.inkColor),
              shape: const RoundedRectangleBorder(),
            ),
            child: Text(LanguageProvider.translate('orders', 'retry')),
          ),
        ),
      ],
    );
  }
}
