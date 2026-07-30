import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_lotties.dart';
import '../../../../core/widgets/empty_animation.dart';
import '../../../../core/widgets/loading_animation_widget.dart';
import '../../../language/presentation/provider/language_provider.dart';
import '../providers/recommend_products_provider.dart';
import '../widgets/hot_deals_home_container_widget.dart';

class RecommendedProductsPage extends StatelessWidget {
  const RecommendedProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final recommendProductsProvider =
        Provider.of<RecommendProductsProvider>(context);
    recommendProductsProvider.pagination();
    return Scaffold(
      backgroundColor: AppColor.canvasColor,
      appBar: AppBar(
        title: Text(
          LanguageProvider.translate('home', recommendProductsProvider.title),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          recommendProductsProvider.refresh();
        },
        child: Builder(
          builder: (context) {
            if (recommendProductsProvider.data == null) {
              return const Center(
                child: LoadingAnimationWidget(gif: Lotties.loading),
              );
            }
            if (recommendProductsProvider.data!.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 80),
                  EmptyAnimation(gif: Lotties.noSearch, title: ''),
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
                    HotDealsHomeContainerWidget.estimatedHeight(cardW);
                return GridView.builder(
                  controller: recommendProductsProvider.controller,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.pageGutter,
                    12,
                    AppSpacing.pageGutter,
                    24,
                  ),
                  itemCount: recommendProductsProvider.data!.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: AppSpacing.cardGap,
                    crossAxisSpacing: AppSpacing.cardGap,
                    childAspectRatio: aspect.clamp(0.48, 0.62),
                  ),
                  itemBuilder: (context, index) {
                    return HotDealsHomeContainerWidget(
                      product: recommendProductsProvider.data![index],
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
