import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flouka/features/products/domain/utils/parse_product_options.dart';
import 'package:flouka/features/products/domain/utils/synthesize_options.dart';
import 'package:flouka/features/products/presentation/providers/product_quantity_provider.dart';
import 'package:flouka/features/products/presentation/providers/product_variant_provider.dart';
import 'package:flouka/features/products/presentation/providers/product_variant_provider.dart';
import 'package:flouka/features/products/presentation/providers/products_details_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductAttributesWidget extends StatelessWidget {
  const ProductAttributesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final productDetailsProvider =
        Provider.of<ProductDetailsProvider>(context);
    final productQuantity = Provider.of<ProductQuantityProvider>(context);
    final product = productDetailsProvider.data;
    if (product == null) return const SizedBox.shrink();

    final isSynthetic = isSyntheticProduct(product);
    final attributes = product.attributes;

    String? selectedColorLabel;
    final colorAttrIndex = attributes.indexWhere(isColorAttribute);
    if (colorAttrIndex >= 0) {
      final selectedId = productDetailsProvider.variants[colorAttrIndex];
      if (selectedId != null) {
        final val = attributes[colorAttrIndex]
            .values
            .where((v) => v.id == selectedId);
        if (val.isNotEmpty) selectedColorLabel = val.first.value;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (attributes.isNotEmpty) ...[
          ...List.generate(attributes.length, (index) {
            final attr = attributes[index];
            final isColor = isColorAttribute(attr);
            final selectedId = productDetailsProvider.variants[index];
            String? selectedLabel;
            if (selectedId != null) {
              final match = attr.values.where((v) => v.id == selectedId);
              if (match.isNotEmpty) selectedLabel = match.first.value;
            }
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        attr.name,
                        style: TextStyleClass.smallStyle(
                          color: AppColor.mutedColor,
                        ).copyWith(fontWeight: FontWeight.w700, fontSize: 12.5),
                      ),
                      if (selectedLabel != null)
                        Text(
                          selectedLabel,
                          style: TextStyleClass.smallStyle(
                            color: AppColor.deepColor,
                          ).copyWith(fontWeight: FontWeight.w600, fontSize: 12),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(attr.values.length, (attributeIndex) {
                      final attribute = attr.values[attributeIndex];
                      final attributeId = attribute.id;
                      final isHidden =
                          productDetailsProvider.hide(index, attributeId);
                      final isSelected =
                          productDetailsProvider.isSelected(index, attributeId);
                      final swatch = isColor
                          ? swatchForColor(attribute.value, attribute.code)
                          : null;

                      return AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        opacity: isHidden ? 0.4 : 1,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(33),
                          onTap: isHidden
                              ? null
                              : () {
                                  productDetailsProvider.onTap(
                                    index,
                                    attributeId,
                                  );
                                  productQuantity.reset();
                                },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: isColor ? 0 : 16,
                              vertical: isColor ? 0 : 9,
                            ),
                            width: isColor ? 34 : null,
                            height: isColor ? 34 : null,
                            decoration: BoxDecoration(
                              color: isColor
                                  ? (swatch != null
                                      ? _parseHex(swatch)
                                      : AppColor.softColor)
                                  : (isHidden
                                      ? AppColor.canvasColor
                                      : Colors.white),
                              border: Border.all(
                                color: isSelected
                                    ? AppColor.deepColor
                                    : AppColor.borderColor,
                                width: isSelected ? (isColor ? 2.5 : 2) : 1,
                              ),
                              borderRadius: BorderRadius.circular(
                                isColor ? 99 : 11,
                              ),
                            ),
                            child: isColor
                                ? null
                                : Text(
                                    attribute.value,
                                    style: TextStyleClass.smallStyle(
                                      color: isHidden
                                          ? AppColor.mutedColor
                                          : isSelected
                                              ? AppColor.deepColor
                                              : AppColor.mutedColor,
                                    ).copyWith(
                                      fontWeight: isSelected
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                      fontSize: 12.5,
                                      decoration: isHidden
                                          ? TextDecoration.lineThrough
                                          : null,
                                    ),
                                  ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            );
          }),
          if (isSynthetic && colorAttrIndex >= 0)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                [
                  LanguageProvider.translate('global', 'shared_image_hint'),
                  if (selectedColorLabel != null) ' · $selectedColorLabel',
                ].join(),
                style: TextStyleClass.smallStyle(color: AppColor.mutedColor),
              ),
            ),
        ],
      ],
    );
  }

  Color _parseHex(String hex) {
    var value = hex.replaceFirst('#', '');
    if (value.length == 6) value = 'FF$value';
    return Color(int.parse(value, radix: 16));
  }
}
