import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/core/widgets/flouka_screen_header.dart';
import 'package:flouka/features/auth/presentation/providers/auth_provider.dart';
import 'package:flouka/features/reviews/presentation/providres/create_rate_provider.dart';
import 'package:flouka/features/stores/presentation/providers/store_reviews_provider.dart';
import 'package:flouka/features/stores/presentation/widgets/all_reviews_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../language/presentation/provider/language_provider.dart';

/// Dedicated store reviews screen — mirrors web /vendors/[id]/reviews.
///
/// Pass [storeId] when navigating:
///   navP(StoreReviewsPage(storeId: id));
class StoreReviewsPage extends StatefulWidget {
  final int storeId;
  const StoreReviewsPage({super.key, required this.storeId});

  @override
  State<StoreReviewsPage> createState() => _StoreReviewsPageState();
}

class _StoreReviewsPageState extends State<StoreReviewsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<StoreReviewsProvider>(context, listen: false);
      provider.setStoreId(widget.storeId);
      provider.pagination();
    });
  }

  @override
  Widget build(BuildContext context) {
    final reviewsProvider = context.watch<StoreReviewsProvider>();

    return Scaffold(
      backgroundColor: AppColor.canvasColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FloukaScreenHeader(
              title: LanguageProvider.translate('global', 'all_reviews'),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  Provider.of<StoreReviewsProvider>(context, listen: false)
                      .setStoreId(widget.storeId);
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: reviewsProvider.controller,
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AllReviewsContainer(),
                      _WriteReviewSection(storeId: widget.storeId),
                    ],
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

class _WriteReviewSection extends StatelessWidget {
  const _WriteReviewSection({required this.storeId});

  final int storeId;

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = AuthProvider.isLogin();

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pageGutter,
        16,
        AppSpacing.pageGutter,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LanguageProvider.translate('global', 'write_a_review'),
            style: TextStyleClass.smallStyle(color: AppColor.deepColor)
                .copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          if (!isLoggedIn)
            Text(
              LanguageProvider.translate('global', 'login_required'),
              style: TextStyleClass.captionStyle(color: AppColor.mutedColor),
            )
          else
            SizedBox(
              width: double.infinity,
              height: AppSpacing.ctaHeight,
              child: ElevatedButton(
                onPressed: () {
                  Provider.of<CreateRateProvider>(context, listen: false)
                      .gotoReviewPage(
                    itemId: storeId,
                    orderId: 0,
                    product: false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.deepColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  LanguageProvider.translate('buttons', 'write_review'),
                  style: TextStyleClass.smallStyle(color: Colors.white)
                      .copyWith(fontWeight: FontWeight.w700),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
