import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flouka/core/dialog/snack_bar.dart';
import 'package:flouka/features/products/domain/entity/product_entity.dart';
import 'package:flouka/features/products/domain/user_case/product_use_case.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/constants.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

/// Home catalogue rail — same `get_products` contract as web featured listing.
class HomeProductsProvider with ChangeNotifier {
  List<ProductEntity> productsList = [];
  bool loading = false;
  final ProductUseCase productUseCase;

  HomeProductsProvider(this.productUseCase);

  Future<void> getProducts() async {
    loading = true;
    productsList = [];
    notifyListeners();

    final Map<String, dynamic> dataToUse = {
      'page': 1,
      'skip': 12,
    };
    final AuthProvider authProvider =
        Provider.of(Constants.globalContext(), listen: false);
    if (authProvider.currentLocation != null) {
      dataToUse['lat'] = authProvider.currentLocation?.latitude;
      dataToUse['lng'] = authProvider.currentLocation?.longitude;
    }

    final Either<DioException, List<ProductEntity>> response =
        await productUseCase.getProducts(dataToUse);

    response.fold(
      (l) => showToast(l.message ?? 'Error loading products'),
      (r) => productsList = List<ProductEntity>.from(r),
    );

    loading = false;
    notifyListeners();
  }
}
