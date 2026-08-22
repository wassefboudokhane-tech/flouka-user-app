import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/constants/app_lotties.dart';
import 'package:flouka/core/widgets/flouka_screen_header.dart';
import 'package:flouka/core/widgets/loading_animation_widget.dart';
import 'package:flouka/core/widgets/recovery_card_widget.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flouka/features/navbar/presentation/provider/nav_bar_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/followed_stores_provider.dart';
import '../widgets/stores_container_home_widget.dart';

class FollowedStoreView extends StatelessWidget {
  const FollowedStoreView({super.key});

  @override
  Widget build(BuildContext context) {
    final followedStoresProvider = context.watch<FollowedStoresProvider>();

    return Scaffold(
      backgroundColor: AppColor.canvasColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FloukaScreenHeader(
              title: LanguageProvider.translate('settings', 'followed_stores'),
              badge: followedStoresProvider.stores != null &&
                      followedStoresProvider.stores!.isNotEmpty
                  ? '${followedStoresProvider.stores!.length}'
                  : null,
            ),
            Expanded(
              child: Builder(
                builder: (context) {
                  if (followedStoresProvider.stores == null) {
                    return const Center(
                      child: LoadingAnimationWidget(gif: Lotties.loading),
                    );
                  }
                  if (followedStoresProvider.stores!.isEmpty) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        const SizedBox(height: 48),
                        RecoveryCardWidget(
                          section: 'global',
                          titleKey: 'no_stores_followed_yet',
                          actionKey: 'explore',
                          onAction: () {
                            Provider.of<NavBarProvider>(context, listen: false)
                                .changeIndex(1);
                            Navigator.maybePop(context);
                          },
                        ),
                      ],
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () async => followedStoresProvider.refresh(),
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.pageGutter,
                        4,
                        AppSpacing.pageGutter,
                        24,
                      ),
                      itemCount: followedStoresProvider.stores!.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        return StoresContainerHomeWidget(
                          store: followedStoresProvider.stores![index],
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
