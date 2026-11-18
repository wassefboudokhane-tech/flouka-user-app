import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/features/creators/presentation/widgets/home_creators_row_widget.dart';
import 'package:flouka/features/home/presentation/widgets/far_away_container_widget.dart';
import 'package:flouka/features/home/presentation/widgets/home_appbar_widget.dart';
import 'package:flouka/features/home/presentation/widgets/home_category_tiles.dart';
import 'package:flouka/features/home/presentation/widgets/home_claim_widget.dart';
import 'package:flouka/features/home/presentation/widgets/home_share_banner.dart';
import 'package:flouka/features/home/presentation/widgets/marketplace_product_rail.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flouka/features/products/presentation/providers/categories_product_search_provider.dart';
import 'package:flouka/features/products/presentation/providers/home_products_provider.dart';
import 'package:flouka/features/stores/presentation/widgets/stores_home_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

/// Home in the same order as the site: promise, creators, one rail, share, categories, shops.
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
                            const HomeClaimWidget(),
                            const HomeCreatorsRowWidget(),
                            MarketplaceProductRail(
                              title: LanguageProvider.translate(
                                'home',
                                'most_recommended',
                              ),
                              products: homeProducts.productsList,
                              onSeeAll: () {
                                Provider.of<CategoriesProductSearchProvider>(
                                  context,
                                  listen: false,
                                ).goToPage({'best_selling': 1});
                              },
                            ),
                            const HomeShareBanner(),
                            const HomeCategoryTiles(),
                            const StoresHomeSection(),
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
