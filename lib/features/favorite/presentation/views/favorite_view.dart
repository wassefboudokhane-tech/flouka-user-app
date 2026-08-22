import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/widgets/flouka_screen_header.dart';
import 'package:flouka/core/widgets/loading_animation_widget.dart';
import 'package:flouka/core/widgets/loading_widget.dart';
import 'package:flouka/core/widgets/recovery_card_widget.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flouka/features/navbar/presentation/provider/nav_bar_provider.dart';
import 'package:flouka/features/products/presentation/widgets/hot_deals_home_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_lotties.dart';
import '../providers/favorite_provider.dart';

class FavoriteView extends StatelessWidget {
  const FavoriteView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.canvasColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Consumer<FavoriteProvider>(
              builder: (context, provider, _) {
                final count = provider.data?.length;
                return FloukaScreenHeader(
                  title: LanguageProvider.translate('settings', 'favourite'),
                  badge: count != null && count > 0 ? '$count' : null,
                );
              },
            ),
            Expanded(
              child: Consumer<FavoriteProvider>(
                builder: (context, provider, child) {
                  provider.pagination();
                  return RefreshIndicator(
                    onRefresh: () async => provider.refresh(),
                    child: Builder(
                      builder: (context) {
                        if (provider.data == null) {
                          return const Center(
                            child: LoadingAnimationWidget(gif: Lotties.loading),
                          );
                        }
                        if (provider.data!.isEmpty) {
                          return ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: [
                              const SizedBox(height: 48),
                              RecoveryCardWidget(
                                section: 'recovery',
                                titleKey: 'favorites_empty_title',
                                actionKey: 'favorites_empty_action',
                                onAction: () {
                                  Provider.of<NavBarProvider>(
                                    context,
                                    listen: false,
                                  ).changeIndex(0);
                                },
                              ),
                            ],
                          );
                        }

                        return LayoutBuilder(
                          builder: (context, constraints) {
                            final usable = constraints.maxWidth -
                                AppSpacing.pageGutter * 2 -
                                AppSpacing.cardGap;
                            final cardW = usable / 2;
                            final aspect = cardW /
                                HotDealsHomeContainerWidget.estimatedHeight(
                                  cardW,
                                );
                            return GridView.builder(
                              controller: provider.controller,
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: const EdgeInsets.fromLTRB(
                                AppSpacing.pageGutter,
                                0,
                                AppSpacing.pageGutter,
                                24,
                              ),
                              itemCount: provider.data!.length +
                                  (provider.paginationStarted ? 1 : 0),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: AppSpacing.cardGap,
                                crossAxisSpacing: AppSpacing.cardGap,
                                childAspectRatio: aspect,
                              ),
                              itemBuilder: (context, index) {
                                if (index >= provider.data!.length) {
                                  return const Center(child: LoadingWidget());
                                }
                                return HotDealsHomeContainerWidget(
                                  product: provider.data![index],
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
