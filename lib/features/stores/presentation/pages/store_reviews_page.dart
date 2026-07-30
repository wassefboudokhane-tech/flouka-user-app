import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/core/constants/app_lotties.dart';
import 'package:flouka/core/widgets/button_widget.dart';
import 'package:flouka/core/widgets/loading_animation_widget.dart';
import 'package:flouka/features/auth/presentation/providers/auth_provider.dart';
import 'package:flouka/features/reviews/presentation/providres/create_rate_provider.dart';
import 'package:flouka/features/stores/presentation/providers/store_reviews_provider.dart';
import 'package:flouka/features/stores/presentation/widgets/all_reviews_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/helper_function/navigation.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text(LanguageProvider.translate('global', 'all_reviews')),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          Provider.of<StoreReviewsProvider>(context, listen: false)
              .setStoreId(widget.storeId);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: Provider.of<StoreReviewsProvider>(context, listen: false).controller,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AllReviewsContainer(),
              _WriteReviewSection(storeId: widget.storeId),
              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _WriteReviewSection extends StatelessWidget {
  final int storeId;
  const _WriteReviewSection({required this.storeId});

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = AuthProvider.isLogin();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LanguageProvider.translate('global', 'write_a_review'),
            style: TextStyleClass.normalStyle(),
          ),
          SizedBox(height: 1.h),
          if (!isLoggedIn)
            Text(
              LanguageProvider.translate('global', 'login_required'),
              style: TextStyleClass.smallStyle(color: Colors.grey.shade600),
            )
          else
            ButtonWidget(
              onTap: () {
                Provider.of<CreateRateProvider>(context, listen: false)
                    .gotoReviewPage(itemId: storeId, orderId: 0, product: false);
              },
              text: LanguageProvider.translate('buttons', 'write_review'),
              width: double.infinity,
              height: 5.h,
              borderRadius: 8,
              color: AppColor.primaryColor,
              textStyle:
                  TextStyleClass.normalStyle(color: Colors.white),
            ),
        ],
      ),
    );
  }
}
