import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_radius.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/core/widgets/flouka_search_pill.dart';
import 'package:flouka/features/home/presentation/widgets/delivery_dropdown_widget.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flouka/features/notification/presentation/provider/notifications_provider.dart';
import 'package:flouka/features/products/presentation/providers/categories_product_search_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Home header — flat deep band, search, 3 trust badges (mockup F4).
class HomeAppbarWidget extends StatelessWidget {
  const HomeAppbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final badges = [
      LanguageProvider.translate('global', 'cod_badge'),
      LanguageProvider.translate('global', 'delivery_24_48'),
      LanguageProvider.translate('global', 'return_7_days'),
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        AppSpacing.pageGutter,
        top + 8,
        AppSpacing.pageGutter,
        14,
      ),
      decoration: BoxDecoration(
        color: AppColor.deepColor,
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(AppRadius.homeHeader),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Expanded(child: DeliveryDropdownWidget()),
              const SizedBox(width: 8),
              _NotificationButton(
                onTap: () {
                  Provider.of<NotificationProvider>(context, listen: false)
                      .goToNotificationPage();
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          FloukaSearchPill(
            hint: LanguageProvider.translate('global', 'search'),
            readOnly: true,
            onTap: () {
              Provider.of<CategoriesProductSearchProvider>(
                context,
                listen: false,
              ).goToPage();
            },
          ),
          const SizedBox(height: 11),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: AppColor.limeColor.withValues(alpha: 0.13),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppColor.limeColor.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                for (var i = 0; i < badges.length; i++) ...[
                  if (i > 0) const SizedBox(width: 6),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 5,
                          height: 5,
                          margin: const EdgeInsets.only(top: 4),
                          decoration: BoxDecoration(
                            color: AppColor.limeColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            badges[i],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyleClass.captionStyle(
                              color: AppColor.backgroundColor,
                            ).copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 10,
                              height: 1.25,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationButton extends StatelessWidget {
  const _NotificationButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.1),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 38,
          height: 38,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Icon(
                Icons.notifications_none_rounded,
                color: AppColor.backgroundColor,
                size: 20,
              ),
              PositionedDirectional(
                top: 8,
                end: 9,
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: AppColor.limeColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColor.deepColor,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
