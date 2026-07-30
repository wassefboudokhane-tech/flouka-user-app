import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_radius.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flutter/material.dart';

/// Search field — mirrors web `.fw-searchpill`.
class FloukaSearchPill extends StatelessWidget {
  const FloukaSearchPill({
    super.key,
    this.controller,
    this.hint,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.readOnly = false,
    this.autofocus = false,
    this.focusNode,
    this.suffixIcon,
    this.fillColor,
  });

  final TextEditingController? controller;
  final String? hint;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final bool readOnly;
  final bool autofocus;
  final FocusNode? focusNode;
  final Widget? suffixIcon;
  final Color? fillColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSpacing.searchHeight,
      decoration: BoxDecoration(
        color: fillColor ?? Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.btn),
        border: Border.all(color: AppColor.borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          Icon(Icons.search, color: AppColor.mutedColor, size: 22),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              readOnly: readOnly,
              autofocus: autofocus,
              onTap: onTap,
              onChanged: onChanged,
              onSubmitted: onSubmitted,
              style: TextStyleClass.textFieldStyle(color: AppColor.inkColor),
              cursorColor: AppColor.deepColor,
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: hint,
                hintStyle:
                    TextStyleClass.textFieldStyle(color: AppColor.mutedColor),
              ),
            ),
          ),
          if (suffixIcon != null) suffixIcon!,
        ],
      ),
    );
  }
}
