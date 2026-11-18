import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/core/widgets/flouka_search_pill.dart';
import 'package:flouka/features/home/presentation/widgets/delivery_dropdown_widget.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flouka/features/notification/presentation/provider/notifications_provider.dart';
import 'package:flouka/features/products/presentation/providers/categories_product_search_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Home header: white, search, and the three promises in one quiet line.
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
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColor.borderColor)),
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
          Text(
            badges.join(' · '),
            textAlign: TextAlign.center,
            maxLines: 2,
            style: TextStyleClass.captionStyle(color: AppColor.mutedColor)
                .copyWith(fontSize: 11.5),
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
      color: Colors.transparent,
      shape: CircleBorder(side: BorderSide(color: AppColor.borderColor)),
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
                color: AppColor.inkColor,
                size: 20,
              ),
              PositionedDirectional(
                top: 8,
                end: 9,
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: AppColor.inkColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
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
