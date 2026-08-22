import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/widgets/flouka_screen_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_lotties.dart';
import '../../../../core/widgets/empty_animation.dart';
import '../../../../core/widgets/loading_animation_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../language/presentation/provider/language_provider.dart';
import '../../../products/presentation/widgets/review_widget.dart';
import '../providres/product_reviews_provider.dart';

class ProductReviewsPage extends StatelessWidget {
  const ProductReviewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final reviewProvider = Provider.of<ProductReviewsProvider>(context);
    reviewProvider.pagination();
    return Scaffold(
      backgroundColor: AppColor.canvasColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FloukaScreenHeader(
              title: LanguageProvider.translate('global', 'product_reviews'),
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: reviewProvider.controller,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.pageGutter,
                  vertical: 8,
                ),
                child: Builder(
                  builder: (context) {
                    if (reviewProvider.data == null) {
                      return const LoadingAnimationWidget(gif: Lotties.loading);
                    }
                    if (reviewProvider.data!.isEmpty) {
                      return const EmptyAnimation(
                        gif: Lotties.noSearch,
                        title: '',
                      );
                    }
                    return Column(
                      children: [
                        Wrap(
                          children: List.generate(
                            reviewProvider.data!.length,
                            (index) => ReviewItemWidget(
                              review: reviewProvider.data![index],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (reviewProvider.paginationStarted)
                          const LoadingWidget(),
                        const SizedBox(height: 16),
                      ],
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
