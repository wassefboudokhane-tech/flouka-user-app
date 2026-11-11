import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/features/categories/presentation/widgets/popular_categories_Section.dart';
import 'package:flouka/features/creators/presentation/widgets/home_creators_row_widget.dart';
import 'package:flouka/features/home/presentation/widgets/far_away_container_widget.dart';
import 'package:flouka/features/home/presentation/widgets/home_appbar_widget.dart';
import 'package:flouka/features/home/presentation/widgets/home_promo_band_widget.dart';
import 'package:flouka/features/home/presentation/widgets/home_stories_row_widget.dart';
import 'package:flouka/features/home/presentation/widgets/home_under_fifty_rail.dart';
import 'package:flouka/features/home/presentation/widgets/marketplace_product_rail.dart';
import 'package:flouka/features/home/presentation/widgets/recommended_section.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flouka/features/products/presentation/providers/categories_product_search_provider.dart';
import 'package:flouka/features/products/presentation/providers/home_products_provider.dart';
import 'package:flouka/features/stores/presentation/widgets/stores_home_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

/// Home layout aligned with refonte: stories → promo → rails.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final homeProducts = Provider.of<HomeProductsProvider>(context);

    return Scaffold(
      backgroundColor: AppColor.canvasColor,
      body: Column(
        children: [
          const HomeAppbarWidget(),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final maxW = constraints.maxWidth.clamp(0, 1100).toDouble();
                return Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxW),
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await homeProducts.getProducts();
                      },
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (authProvider.isAwayFromHome())
                              const FarAwayContainerWidget(),
                            const HomeStoriesRowWidget(),
                            const HomeCreatorsRowWidget(),
                            const HomePromoBandWidget(),
                            MarketplaceProductRail(
                              title: LanguageProvider.translate(
                                'home',
                                'best_selling',
                              ),
                              products: homeProducts.productsList,
                              onSeeAll: () {
                                Provider.of<CategoriesProductSearchProvider>(
                                  context,
                                  listen: false,
                                ).goToPage({'best_selling': 1});
                              },
                            ),
                            if (homeProducts.productsList.isEmpty)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.pageGutter,
                                  vertical: 16,
                                ),
                                child: Text(
                                  LanguageProvider.translate(
                                    'orders',
                                    'empty_search',
                                  ),
                                  style: TextStyleClass.smallStyle(
                                    color: AppColor.mutedColor,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            const StoresHomeSection(),
                            HomeUnderFiftyRail(
                              products: homeProducts.productsList,
                            ),
                            const RecommendedSection(),
                            const PopularCategoriesSection(),
                            const SizedBox(height: AppSpacing.section),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
