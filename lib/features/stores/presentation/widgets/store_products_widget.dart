import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/core/constants/app_lotties.dart';
import 'package:flouka/core/widgets/empty_animation.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/widgets/loading_animation_widget.dart';
import '../../../products/presentation/widgets/hot_deals_home_container_widget.dart';
import '../providers/stores_product_provider.dart';

class StoreProductsWidget extends StatelessWidget {
  const StoreProductsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StoresProductProvider>(context);
    final hotDeals = provider.data;
    provider.pagination();

    return Builder(
      builder: (context) {
        if (hotDeals == null) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: LoadingAnimationWidget(gif: Lotties.loading),
          );
        }
        if (hotDeals.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              children: [
                const EmptyAnimation(
                  gif: Lotties.productAnimation,
                  title: 'empty_search',
                ),
                const SizedBox(height: 8),
                Text(
                  LanguageProvider.translate('global', 'empty_search'),
                  style: TextStyleClass.smallStyle(
                    color: AppColor.mutedColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }
        return LayoutBuilder(
          builder: (context, constraints) {
            final usable = constraints.maxWidth - AppSpacing.cardGap;
            final cardW = usable / 2;
            final aspect = cardW /
                HotDealsHomeContainerWidget.estimatedHeight(cardW);
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: hotDeals.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: AppSpacing.cardGap,
                crossAxisSpacing: AppSpacing.cardGap,
                childAspectRatio: aspect,
              ),
              itemBuilder: (context, index) {
                return HotDealsHomeContainerWidget(
                  product: hotDeals[index],
                );
              },
            );
          },
        );
      },
    );
  }
}
