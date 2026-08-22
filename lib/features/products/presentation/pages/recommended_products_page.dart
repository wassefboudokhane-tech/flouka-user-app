import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_radius.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/core/constants/app_lotties.dart';
import 'package:flouka/core/widgets/flouka_screen_header.dart';
import 'package:flouka/core/widgets/loading_animation_widget.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flouka/features/navbar/presentation/provider/nav_bar_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/recommend_products_provider.dart';
import '../widgets/hot_deals_home_container_widget.dart';

/// Category / section product grid — hi-fi header + empty recovery.
class RecommendedProductsPage extends StatelessWidget {
  const RecommendedProductsPage({super.key});

  String _displayTitle(RecommendProductsProvider provider) {
    final raw = provider.title;
    final translated = LanguageProvider.translate('home', raw);
    // API titles (e.g. "Gift Ideas") are not i18n keys — show as-is.
    if (translated == raw || raw.contains(' ')) return raw;
    return translated;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RecommendProductsProvider>(context);
    provider.pagination();

    return Scaffold(
      backgroundColor: AppColor.canvasColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FloukaScreenHeader(title: _displayTitle(provider)),
            Expanded(
              child: RefreshIndicator(
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
                        padding: const EdgeInsets.only(top: 24, bottom: 24),
                        children: [
                          _CategoryEmptyRecovery(
                            title: _displayTitle(provider),
                            onBrowse: () {
                              Navigator.maybePop(context);
                              context.read<NavBarProvider>().changeIndex(0);
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
                            HotDealsHomeContainerWidget.estimatedHeight(cardW);
                        return GridView.builder(
                          controller: provider.controller,
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(
                            AppSpacing.pageGutter,
                            0,
                            AppSpacing.pageGutter,
                            24,
                          ),
                          itemCount: provider.data!.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: AppSpacing.cardGap,
                            crossAxisSpacing: AppSpacing.cardGap,
                            childAspectRatio: aspect,
                          ),
                          itemBuilder: (context, index) {
                            return HotDealsHomeContainerWidget(
                              product: provider.data![index],
                            );
                          },
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

class _CategoryEmptyRecovery extends StatelessWidget {
  const _CategoryEmptyRecovery({
    required this.title,
    required this.onBrowse,
  });

  final String title;
  final VoidCallback onBrowse;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageGutter),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        decoration: BoxDecoration(
          color: AppColor.backgroundColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColor.borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: AppColor.softColor,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColor.borderColor),
              ),
              child: Center(
                child: Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColor.deepColor, width: 2.5),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              LanguageProvider.translate('recovery', 'category_empty_title'),
              style: TextStyleClass.headStyle(color: AppColor.deepColor)
                  .copyWith(fontSize: 21, height: 1.15),
            ),
            const SizedBox(height: 9),
            Text(
              LanguageProvider.translate('recovery', 'category_empty_body')
                  .replaceAll('*category*', title),
              style: TextStyleClass.normalStyle(color: AppColor.mutedColor)
                  .copyWith(fontSize: 13.5, height: 1.5),
            ),
            const SizedBox(height: 18),
            Material(
              color: AppColor.limeColor,
              borderRadius: BorderRadius.circular(AppRadius.pill),
              child: InkWell(
                onTap: onBrowse,
                borderRadius: BorderRadius.circular(AppRadius.pill),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: Center(
                    child: Text(
                      LanguageProvider.translate(
                        'recovery',
                        'category_empty_action',
                      ),
                      style: TextStyleClass.buttonStyle(
                        color: AppColor.deepColor,
                      ).copyWith(fontWeight: FontWeight.w800, fontSize: 14),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
