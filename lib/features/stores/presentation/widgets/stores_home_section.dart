import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/core/widgets/flouka_network_image.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flouka/features/stores/domain/entity/store_entity.dart';
import 'package:flouka/features/stores/presentation/providers/store_details_provider.dart';
import 'package:flouka/features/stores/presentation/providers/stores_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Shops as logos, not circular photos.
class StoresHomeSection extends StatelessWidget {
  const StoresHomeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final stores = context.watch<StoresProvider>().homeStores;
    if (stores.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.pageGutter, 18, AppSpacing.pageGutter, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LanguageProvider.translate('home', 'by_store'),
            style: TextStyleClass.railTitleStyle(color: AppColor.inkColor),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: stores.length.clamp(0, 6),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.78,
            ),
            itemBuilder: (context, index) => _Logo(store: stores[index]),
          ),
        ],
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo({required this.store});
  final StoreEntity store;

  @override
  Widget build(BuildContext context) {
    final logo = store.logo.isNotEmpty ? store.logo : store.vendor.logo;
    final initial = store.name.isEmpty ? '' : store.name.characters.first;
    return InkWell(
      onTap: () {
        context.read<StoreDetailsProvider>().goToStoreDetailsPage(store.id);
      },
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppColor.borderColor),
              ),
              padding: const EdgeInsets.all(12),
              child: logo.isEmpty
                  ? Text(
                      initial,
                      style: TextStyleClass.semiHeadStyle(color: AppColor.inkColor).copyWith(
                        fontWeight: FontWeight.w300,
                        fontSize: 28,
                      ),
                    )
                  : FloukaNetworkImage(url: logo, fit: BoxFit.contain),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            store.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyleClass.captionStyle(color: AppColor.inkColor),
          ),
        ],
      ),
    );
  }
}
