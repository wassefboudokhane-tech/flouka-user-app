
import 'package:flouka/features/products/domain/entity/variant_entity.dart';
import 'package:flouka/features/products/presentation/providers/products_details_provider.dart';

extension ProductVariantProvider on ProductDetailsProvider {
  void onTap(int index, int id) {
    if (variants[index] == id) {
      return;
    }
    if (hide(index, id)) {
      return;
    }
    variants[index] = id;
    variants.removeWhere((key, value) => key > index);
    rebuild();
  }

  bool hide(int index, int id) {
    final stocks = data!.variants;
    if (stocks.isEmpty) return false;

    final ids = variants.entries
        .where((e) => e.key < index)
        .map((e) => e.value)
        .toList();
    ids.add(id);

    final available = stocks.where((variant) {
      final comboSet = variant.combination.toSet();
      return (variant.stock?.quantity ?? 0) > 0 &&
          ids.every((item) => comboSet.contains(item));
    }).toList();

    return available.isEmpty;
  }

  /// Show qty + ATC when product has stock or selectable attributes.
  bool shouldShowAddToCart() {
    if (data == null) return false;
    if (data!.attributes.isNotEmpty) return true;
    return data!.stock != null;
  }

  /// True when the user can actually add (all attrs matched or simple stock).
  bool isAllAttributesSelected() {
    return canAddToCart();
  }

  bool canAddToCart() {
    if (data == null) return false;
    if (data!.attributes.isEmpty) {
      return data!.stock != null;
    }
    if (variants.length != data!.attributes.length) return false;
    return variantEntity()?.stock != null;
  }

  bool isSelected(int index, int id) {
    return variants.containsKey(index) && variants[index] == id;
  }

  VariantEntity? variantEntity() {
    final stocks = data!.variants;
    final ids = variants.values.toList();
    if (data!.attributes.isNotEmpty && ids.length != data!.attributes.length) {
      return null;
    }
    final matches = stocks.where((item) {
      return item.combination.length == ids.length &&
          item.combination.toSet().containsAll(ids);
    }).toList();
    if (matches.isNotEmpty) {
      return matches.first;
    }
    return null;
  }

  /// Prefill first in-stock combination (web parity).
  void selectDefaultAttributes() {
    variants = {};
    final attrs = data?.attributes ?? [];
    final stocks = data?.variants ?? [];
    if (attrs.isEmpty) return;

    for (final variant in stocks) {
      if ((variant.stock?.quantity ?? 0) <= 0) continue;
      final combo = variant.combination.toSet();
      final next = <int, int>{};
      for (var i = 0; i < attrs.length; i++) {
        final match = attrs[i].values.where((v) => combo.contains(v.id));
        if (match.isEmpty) break;
        next[i] = match.first.id;
      }
      if (next.length == attrs.length) {
        variants = next;
        return;
      }
    }

    for (var i = 0; i < attrs.length; i++) {
      if (attrs[i].values.isNotEmpty) {
        variants[i] = attrs[i].values.first.id;
      }
    }
  }
}
