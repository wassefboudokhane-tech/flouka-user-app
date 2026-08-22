import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/constants/app_lotties.dart';
import 'package:flouka/core/widgets/loading_animation_widget.dart';
import 'package:flouka/features/stores/presentation/providers/store_details_provider.dart';
import 'package:flouka/features/stores/presentation/providers/store_reviews_provider.dart';
import 'package:flouka/features/stores/presentation/providers/stores_product_provider.dart';
import 'package:flouka/features/stores/presentation/providers/stores_provider.dart';
import 'package:flouka/features/stores/presentation/widgets/store_details_hero_widget.dart';
import 'package:flouka/features/stores/presentation/widgets/stores_tabs_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StoreDetailsPage extends StatelessWidget {
  const StoreDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final storeDetailsProvider = Provider.of<StoreDetailsProvider>(context);
    final storesProvider = Provider.of<StoresProvider>(context);
    final storesProductProvider =
        Provider.of<StoresProductProvider>(context, listen: false);
    final storeReviewsProvider =
        Provider.of<StoreReviewsProvider>(context, listen: false);

    if (storesProvider.current == 0) {
      storesProductProvider.pagination();
    } else {
      storeReviewsProvider.pagination();
    }

    final store = storeDetailsProvider.storeDetailsEntity;

    return Scaffold(
      backgroundColor: AppColor.canvasColor,
      body: Builder(
        builder: (context) {
          if (store == null) {
            return const Center(
              child: LoadingAnimationWidget(gif: Lotties.loading),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await storeDetailsProvider.refresh(store.id);
              if (storesProvider.current == 0) {
                await storesProductProvider.refresh();
              } else {
                await storeReviewsProvider.refresh();
              }
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: storesProvider.current == 0
                  ? storesProductProvider.controller
                  : storeReviewsProvider.controller,
              padding: const EdgeInsets.only(bottom: 24),
              children: [
                StoreDetailsHeroWidget(store: store),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.pageGutter,
                    16,
                    AppSpacing.pageGutter,
                    0,
                  ),
                  child: const StoresTabsWidget(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
