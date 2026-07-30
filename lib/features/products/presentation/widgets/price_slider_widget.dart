import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flouka/features/products/presentation/providers/search_filter_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PriceSliderWidget extends StatelessWidget {
  const PriceSliderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final filterProvider = Provider.of<SearchFilterProvider>(context);
    final range = filterProvider.priceRange;
    final currency = LanguageProvider.translate('global', 'currency');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _PriceChip(
              label: '${range.start.round()} $currency',
            ),
            Text(
              '—',
              style: TextStyleClass.captionStyle(color: AppColor.mutedColor),
            ),
            _PriceChip(
              label: '${range.end.round()} $currency',
            ),
          ],
        ),
        const SizedBox(height: 4),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppColor.primaryColor,
            inactiveTrackColor: AppColor.borderColor,
            rangeThumbShape: const RoundRangeSliderThumbShape(enabledThumbRadius: 10),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 18),
            thumbColor: AppColor.deepColor,
            overlayColor: AppColor.primaryColor.withValues(alpha: 0.15),
            trackHeight: 4,
          ),
          child: RangeSlider(
            values: range,
            min: 0,
            max: 20000,
            divisions: 100,
            onChanged: (values) {
              filterProvider.selectPriceRange(values);
            },
          ),
        ),
      ],
    );
  }
}

class _PriceChip extends StatelessWidget {
  const _PriceChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColor.softColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColor.borderColor),
      ),
      child: Text(
        label,
        style: TextStyleClass.captionStyle(color: AppColor.deepColor)
            .copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }
}
