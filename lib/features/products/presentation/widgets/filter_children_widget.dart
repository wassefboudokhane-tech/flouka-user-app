import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/core/constants/constants.dart';
import 'package:flouka/core/widgets/checkbox_widget.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flouka/features/products/presentation/providers/search_filter_provider.dart';
import 'package:flouka/features/products/presentation/widgets/price_slider_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FilterChildrenWidget extends StatefulWidget {
  const FilterChildrenWidget({super.key, required this.data});

  final Map<String, dynamic> data;

  @override
  State<FilterChildrenWidget> createState() => _FilterChildrenWidgetState();
}

class _FilterChildrenWidgetState extends State<FilterChildrenWidget> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SearchFilterProvider>(
      Constants.globalContext(),
    );
    final data = widget.data;

    if (data['title'] == 'price') {
      return const PriceSliderWidget();
    }

    final children = List<Map<String, dynamic>>.from(
      (data['children'] as List?)?.cast<Map<String, dynamic>>() ?? const [],
    );

    if (children.isEmpty) {
      final hintKey = data['title'] == 'sub_category'
          ? 'select_category_first'
          : data['title'] == 'brand'
              ? 'select_category_for_brands'
              : 'no_options';
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          LanguageProvider.translate('filter', hintKey),
          style: TextStyleClass.captionStyle(color: AppColor.mutedColor),
        ),
      );
    }

    final filtered = _query.trim().isEmpty
        ? children
        : children
            .where(
              (c) => (c['name']?.toString() ?? '')
                  .toLowerCase()
                  .contains(_query.trim().toLowerCase()),
            )
            .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (children.length > 6) ...[
          TextField(
            onChanged: (v) => setState(() => _query = v),
            style: TextStyleClass.normalStyle(color: AppColor.inkColor),
            decoration: InputDecoration(
              isDense: true,
              hintText: LanguageProvider.translate('global', 'search'),
              hintStyle: TextStyleClass.captionStyle(color: AppColor.mutedColor),
              prefixIcon: Icon(Icons.search, color: AppColor.mutedColor, size: 20),
              filled: true,
              fillColor: AppColor.softColor,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColor.borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColor.borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColor.primaryColor),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
        ...filtered.map((child) {
          return InkWell(
            onTap: () => provider.setLabelValue(data, child),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      child['name']?.toString() ?? '',
                      style: TextStyleClass.normalStyle(color: AppColor.inkColor),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  CheckBoxWidget(
                    check: child['active'] ?? false,
                    onChange: (_) => provider.setLabelValue(data, child),
                  ),
                ],
              ),
            ),
          );
        }),
        if (filtered.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              LanguageProvider.translate('filter', 'no_options'),
              style: TextStyleClass.captionStyle(color: AppColor.mutedColor),
            ),
          ),
      ],
    );
  }
}
