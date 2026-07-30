import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_radius.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flutter/material.dart';

/// Primary CTA — mirrors web `.fw-btn-primary` (lime + deep text).
class FloukaPrimaryButton extends StatelessWidget {
  const FloukaPrimaryButton({
    super.key,
    required this.onTap,
    required this.text,
    this.width,
    this.height,
    this.widget,
    this.translateKey = true,
    this.enabled = true,
  });

  final VoidCallback onTap;
  final String text;
  final double? width;
  final double? height;
  final Widget? widget;
  final bool translateKey;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final label =
        translateKey ? LanguageProvider.translate('buttons', text) : text;
    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: Container(
          width: width ?? double.infinity,
          height: height ?? AppSpacing.ctaHeight,
          decoration: BoxDecoration(
            color: AppColor.limeColor,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            boxShadow: [
              BoxShadow(
                color: AppColor.primaryColor.withValues(alpha: 0.22),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget != null) ...[
                widget!,
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyleClass.buttonStyle(color: AppColor.deepColor)
                      .copyWith(fontWeight: FontWeight.w800),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
