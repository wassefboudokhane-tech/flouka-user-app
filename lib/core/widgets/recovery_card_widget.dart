import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_radius.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/core/widgets/flouka_primary_button.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flutter/material.dart';

/// Reusable error / empty recovery card: what happened → what's kept → action.
class RecoveryCardWidget extends StatelessWidget {
  const RecoveryCardWidget({
    super.key,
    required this.section,
    required this.titleKey,
    this.preservedKey,
    required this.actionKey,
    this.onAction,
    this.secondaryKey,
    this.onSecondary,
    this.child,
  });

  final String section;
  final String titleKey;
  final String? preservedKey;
  final String actionKey;
  final VoidCallback? onAction;
  final String? secondaryKey;
  final VoidCallback? onSecondary;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.pageGutter),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.backgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColor.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            LanguageProvider.translate(section, titleKey),
            style: TextStyleClass.smallStyle(color: AppColor.deepColor)
                .copyWith(fontWeight: FontWeight.w800),
          ),
          if (preservedKey != null) ...[
            const SizedBox(height: 8),
            Text(
              LanguageProvider.translate(section, preservedKey!),
              style: TextStyleClass.captionStyle(color: AppColor.mutedColor),
            ),
          ],
          if (child != null) ...[
            const SizedBox(height: 12),
            child!,
          ],
          if (onAction != null) ...[
            const SizedBox(height: 14),
            FloukaPrimaryButton(
              onTap: onAction!,
              text: LanguageProvider.translate(section, actionKey),
              translateKey: false,
              height: 44,
            ),
          ],
          if (secondaryKey != null && onSecondary != null) ...[
            const SizedBox(height: 8),
            TextButton(
              onPressed: onSecondary,
              child: Text(
                LanguageProvider.translate(section, secondaryKey!),
                style: TextStyleClass.smallStyle(color: AppColor.primaryColor)
                    .copyWith(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
