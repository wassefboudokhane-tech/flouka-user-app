import 'package:flouka/features/products/domain/entity/attribute_entity.dart';
import 'package:flouka/features/products/domain/entity/product_entity.dart';
import 'package:flouka/features/products/domain/entity/variant_entity.dart';
import 'package:flouka/features/products/domain/utils/parse_product_options.dart';

const int synColorAttr = -1;
const int synSizeAttr = -2;

class SynthesizedOptions {
  final List<AttributeEntity> attributes;
  final List<VariantEntity> variants;
  final bool isSynthetic;

  const SynthesizedOptions({
    required this.attributes,
    required this.variants,
    required this.isSynthetic,
  });
}

int _countValues(List<AttributeEntity> attrs) =>
    attrs.fold(0, (n, a) => n + a.values.length);

/// When the live API has thin/missing attributes, build Couleur/Taille from the
/// description so the PDP can offer pickers (same as flouka-web).
SynthesizedOptions? synthesizeOptionsFromDescription(ProductEntity product) {
  final options = parseProductOptions(product.description);
  if (options.colors.isEmpty && options.sizes.isEmpty) return null;

  final attributes = <AttributeEntity>[];
  if (options.colors.isNotEmpty) {
    attributes.add(
      AttributeEntity(
        id: synColorAttr,
        name: 'Couleur',
        values: [
          for (var i = 0; i < options.colors.length; i++)
            AttributeValeEntity(
              id: -(100 + i),
              value: options.colors[i],
              code: colorSwatch[options.colors[i]],
            ),
        ],
      ),
    );
  }
  if (options.sizes.isNotEmpty) {
    attributes.add(
      AttributeEntity(
        id: synSizeAttr,
        name: 'Taille',
        values: [
          for (var i = 0; i < options.sizes.length; i++)
            AttributeValeEntity(
              id: -(200 + i),
              value: options.sizes[i],
              code: options.sizes[i],
            ),
        ],
      ),
    );
  }

  final combos = optionCombinations(options);
  final colorValues =
      attributes.where((a) => a.id == synColorAttr).expand((a) => a.values).toList();
  final sizeValues =
      attributes.where((a) => a.id == synSizeAttr).expand((a) => a.values).toList();

  final baseStock = product.stock;
  final stockId = baseStock?.id ?? product.id ?? 0;
  final storeProductId = baseStock?.storeProductId ?? 0;

  AttributeValeEntity? findValue(List<AttributeValeEntity> values, String name) {
    for (final v in values) {
      if (v.value == name) return v;
    }
    return null;
  }

  final variants = <VariantEntity>[];
  for (var i = 0; i < combos.length; i++) {
    final combo = combos[i];
    final combination = <int>[];
    if (combo.color != null) {
      final v = findValue(colorValues, combo.color!);
      if (v != null) combination.add(v.id);
    }
    if (combo.size != null) {
      final v = findValue(sizeValues, combo.size!);
      if (v != null) combination.add(v.id);
    }
    variants.add(
      VariantEntity(
        id: -(1000 + i),
        price: product.price ?? 0,
        offerPrice: product.offerPrice,
        sku: 'SYN-${product.id}-$i',
        combination: combination,
        images: const [],
        stock: StockEntity(
          id: stockId,
          storeProductId: storeProductId,
          productVariantId: null,
          quantity: baseStock?.quantity ?? 25,
        ),
      ),
    );
  }

  return SynthesizedOptions(
    attributes: attributes,
    variants: variants,
    isSynthetic: true,
  );
}

/// Prefer richer description-parsed options over sparse API catalogs.
void mergeLiveOrSynthesize(ProductEntity product) {
  final synthetic = synthesizeOptionsFromDescription(product);
  final liveCount = _countValues(product.attributes);
  final synCount = synthetic == null ? 0 : _countValues(synthetic.attributes);

  if (synthetic != null && synCount > liveCount) {
    // Reassign lists (do not mutate List<AttributeModel>/VariantModel in place —
    // web throws when addAll receives base AttributeEntity/VariantEntity).
    product.attributes = List<AttributeEntity>.from(synthetic.attributes);
    product.variants = List<VariantEntity>.from(synthetic.variants);
    return;
  }

  final hasReal = product.attributes.isNotEmpty && product.variants.isNotEmpty;
  if (hasReal) return;

  if (synthetic != null) {
    product.attributes = List<AttributeEntity>.from(synthetic.attributes);
    product.variants = List<VariantEntity>.from(synthetic.variants);
  }
}

bool isSyntheticProduct(ProductEntity? product) {
  if (product == null) return false;
  return product.attributes.any((a) => a.id < 0) ||
      product.variants.any((v) => v.id < 0);
}

bool isColorAttribute(AttributeEntity attr) {
  return RegExp(r'couleur|color', caseSensitive: false).hasMatch(attr.name) ||
      attr.id == synColorAttr;
}
