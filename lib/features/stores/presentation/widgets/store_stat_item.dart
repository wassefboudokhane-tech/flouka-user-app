import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flutter/material.dart';

enum StoreStatVariant { light, glass }

class StoreStatItem extends StatelessWidget {
  const StoreStatItem({
    super.key,
    required this.title,
    required this.value,
    this.icon,
    this.variant = StoreStatVariant.light,
    this.accentValue = false,
  });

  final String title;
  final String value;
  final Widget? icon;
  final StoreStatVariant variant;
  final bool accentValue;

  @override
  Widget build(BuildContext context) {
    final isGlass = variant == StoreStatVariant.glass;
    final valueColor = isGlass
        ? (accentValue ? AppColor.limeColor : Colors.white)
        : AppColor.deepColor;
    final labelColor =
        isGlass ? Colors.white.withValues(alpha: 0.55) : AppColor.mutedColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: isGlass
            ? Colors.white.withValues(alpha: 0.08)
            : AppColor.softColor,
        border: Border.all(
          color: isGlass
              ? Colors.white.withValues(alpha: 0.12)
              : AppColor.borderColor,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                value,
                style: TextStyleClass.headStyle(color: valueColor).copyWith(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
              if (icon != null) ...[
                const SizedBox(width: 4),
                icon!,
              ],
            ],
          ),
          const SizedBox(height: 3),
          Text(
            LanguageProvider.translate('global', title),
            style: TextStyleClass.captionStyle(color: labelColor).copyWith(
              fontSize: 10,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}
