import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flouka/features/products/domain/utils/parse_product_options.dart';
import 'package:flouka/features/products/domain/utils/synthesize_options.dart';
import 'package:flouka/features/products/presentation/providers/product_variant_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/config/app_styles.dart';
import '../providers/product_quantity_provider.dart';
import '../providers/products_details_provider.dart';
import 'add_to_cart_widget.dart';

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
            return Padding(
              padding: EdgeInsets.only(bottom: 1.5.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    attr.name,
                    style: TextStyleClass.semiHeadStyle(color: Colors.black)
                        .copyWith(fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 0.8.h),
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
                              horizontal: 3.5.w,
                              vertical: 0.7.h,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColor.deepColor
                                  : Colors.white,
                              border: Border.all(
                                color: isSelected
                                    ? AppColor.deepColor
                                    : AppColor.borderColor,
                                width: isSelected ? 2 : 1,
                              ),
                              borderRadius: BorderRadius.circular(33),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (swatch != null) ...[
                                  Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: _parseHex(swatch),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.black.withValues(alpha: 0.12),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                ],
                                Text(
                                  attribute.value,
                                  style: TextStyleClass.normalStyle(
                                    color: isHidden
                                        ? AppColor.mutedColor
                                        : isSelected
                                            ? Colors.white
                                            : AppColor.inkColor,
                                  ).copyWith(
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w400,
                                  ),
                                ),
                              ],
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
              padding: EdgeInsets.only(bottom: 1.h),
              child: Text(
                [
                  LanguageProvider.translate('global', 'shared_image_hint'),
                  if (selectedColorLabel != null) ' · $selectedColorLabel',
                ].join(),
                style: TextStyleClass.smallStyle(color: AppColor.mutedColor),
              ),
            ),
        ],
        SizedBox(height: 1.h),
        if (productDetailsProvider.shouldShowAddToCart())
          const AddToCartWidget(),
      ],
    );
  }

  Color _parseHex(String hex) {
    var value = hex.replaceFirst('#', '');
    if (value.length == 6) value = 'FF$value';
    return Color(int.parse(value, radix: 16));
  }
}
