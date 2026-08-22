import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/core/widgets/flouka_back_button.dart';
import 'package:flutter/material.dart';

/// Secondary screen header — back chevron + title (+ optional badge).
class FloukaScreenHeader extends StatelessWidget {
  const FloukaScreenHeader({
    super.key,
    required this.title,
    this.badge,
    this.onBack,
    this.trailing,
  });

  final String title;
  final String? badge;
  final VoidCallback? onBack;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pageGutter,
        4,
        AppSpacing.pageGutter,
        12,
      ),
      child: Row(
        children: [
          FloukaBackButton(onTap: onBack),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: TextStyleClass.screenTitleStyle(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (badge != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColor.limeColor,
                borderRadius: BorderRadius.circular(99),
              ),
              child: Text(
                badge!,
                style: TextStyleClass.captionStyle(color: AppColor.deepColor)
                    .copyWith(fontWeight: FontWeight.w800, fontSize: 11),
              ),
            ),
          if (trailing != null) ...[
            const SizedBox(width: 8),
            trailing!,
          ],
        ],
      ),
    );
  }
}
