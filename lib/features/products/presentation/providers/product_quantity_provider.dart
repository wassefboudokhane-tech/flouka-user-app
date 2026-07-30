import 'package:flouka/core/constants/constants.dart';
import 'package:flouka/features/products/presentation/providers/products_details_provider.dart';
import 'package:flouka/features/products/presentation/providers/product_variant_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductQuantityProvider extends ChangeNotifier {
  int quantity = 1;

  int maxQuantity() {
    final productDetailsProvider = Provider.of<ProductDetailsProvider>(
      Constants.globalContext(),
      listen: false,
    );
    final hasAttrs =
        productDetailsProvider.data?.attributes.isNotEmpty ?? false;
    if (hasAttrs) {
      return productDetailsProvider.variantEntity()?.stock?.quantity ?? 0;
    }
    return productDetailsProvider.data?.stock?.quantity ?? 0;
  }

  void reset() {
    quantity = 1;
    notifyListeners();
  }

  void setQuantity(int value) {
    final max = maxQuantity();
    if (max <= 0) {
      quantity = 1;
    } else {
      quantity = value.clamp(1, max);
    }
    notifyListeners();
  }

  void increment() {
    final max = maxQuantity();
    if (quantity < max) {
      quantity++;
      notifyListeners();
    }
  }

  void decrement() {
    if (quantity > 1) {
      quantity--;
      notifyListeners();
    }
  }
}
