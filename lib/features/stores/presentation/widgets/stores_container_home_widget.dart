import 'package:cached_network_image/cached_network_image.dart';
import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_radius.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/core/widgets/custom_star_rating_widget.dart';
import 'package:flouka/features/stores/domain/entity/store_entity.dart';
import 'package:flouka/features/stores/presentation/providers/store_details_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StoresContainerHomeWidget extends StatelessWidget {
  const StoresContainerHomeWidget({super.key, required this.store});

  final StoreEntity store;

  @override
  Widget build(BuildContext context) {
    final storeDetailsProvider =
        Provider.of<StoreDetailsProvider>(context, listen: false);
    return GestureDetector(
      onTap: () {
        storeDetailsProvider.goToStoreDetailsPage(store.id);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColor.borderColor),
          borderRadius: BorderRadius.circular(AppRadius.card),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColor.limeColor, width: 2),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(store.vendor.logo),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    store.name,
                    style: TextStyleClass.smallStyle(color: AppColor.deepColor)
                        .copyWith(fontWeight: FontWeight.w700, fontSize: 15),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (store.vendor.bio.isNotEmpty)
                    Text(
                      store.vendor.bio,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyleClass.captionStyle(
                        color: AppColor.mutedColor,
                      ),
                    ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      CustomStarRatingWidget(
                        rating: store.rate,
                        readOnly: true,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        store.rate.toStringAsFixed(1),
                        style: TextStyleClass.captionStyle(
                          color: AppColor.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: AppColor.mutedColor),
          ],
        ),
      ),
    );
  }
}
