import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_radius.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flouka/features/products/presentation/providers/categories_product_search_provider.dart';
import 'package:flutter/material.dart';

/// Search field — merch pill + optional animated hints from main.
class SearchbarContainer extends StatefulWidget {
  final VoidCallback? onTap;
  final TextEditingController? controller;
  final VoidCallback? onChanged;
  final String? hintText;
  final bool readOnly;
  final bool autoFocus;
  final Widget? suffixIcon;
  final EdgeInsetsGeometry? margin;
  final Color? fillColor;

  const SearchbarContainer({
    super.key,
    this.onTap,
    this.controller,
    this.onChanged,
    this.hintText,
    this.readOnly = true,
    this.autoFocus = false,
    this.suffixIcon,
    this.margin,
    this.fillColor,
  });

  @override
  State<SearchbarContainer> createState() => _SearchbarContainerState();
}

class _SearchbarContainerState extends State<SearchbarContainer> {
  @override
  Widget build(BuildContext context) {
    final showHints = widget.controller != null &&
        widget.controller!.text.isEmpty &&
        (widget.hintText == null || widget.hintText!.isEmpty) &&
        CategoriesProductSearchProvider.searchHints.isNotEmpty;

    final pill = Container(
      height: AppSpacing.searchHeight,
      decoration: BoxDecoration(
        color: widget.fillColor ?? Colors.white,
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
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Row(
            children: [
              Icon(Icons.search, color: AppColor.mutedColor, size: 22),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  readOnly: widget.readOnly,
                  autofocus: widget.autoFocus,
                  onTap: widget.onTap,
                  onChanged: (_) {
                    widget.onChanged?.call();
                    setState(() {});
                  },
                  style: TextStyleClass.textFieldStyle(color: AppColor.inkColor),
                  cursorColor: AppColor.deepColor,
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    hintText: showHints
                        ? null
                        : (widget.hintText ??
                            LanguageProvider.translate('categories', 'search')),
                    hintStyle: TextStyleClass.textFieldStyle(
                      color: AppColor.mutedColor,
                    ),
                  ),
                ),
              ),
              if (widget.suffixIcon != null) widget.suffixIcon!,
            ],
          ),
          if (showHints)
            PositionedDirectional(
              start: 30,
              child: IgnorePointer(
                child: AnimatedTextKit(
                  repeatForever: true,
                  pause: const Duration(milliseconds: 800),
                  animatedTexts: CategoriesProductSearchProvider.searchHints
                      .map(
                        (e) => TypewriterAnimatedText(
                          e,
                          textStyle: TextStyleClass.textFieldStyle(
                            color: AppColor.mutedColor,
                          ),
                          speed: const Duration(milliseconds: 80),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
        ],
      ),
    );

    if (widget.margin == null) return pill;
    return Padding(padding: widget.margin!, child: pill);
  }
}
