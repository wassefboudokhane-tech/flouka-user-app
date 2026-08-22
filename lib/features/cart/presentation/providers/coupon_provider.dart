import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flouka/features/cart/presentation/providers/checkout_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/helper_function/loading.dart';
import '../../../../core/helper_function/navigation.dart';
import '../../../language/presentation/provider/language_provider.dart';
import '../../domain/entity/coupon_entity.dart';
import '../../domain/use_case/cart_use_case.dart';
import 'cart_provider.dart';

class CouponProvider extends ChangeNotifier {
  List<CouponEntity>? couponEntity;
  List<CouponField> couponsFields = [CouponField(controller: TextEditingController(), isApplied: false)];
  final CartUseCase cartUseCase;
  CouponProvider(this.cartUseCase);

  String? lastCouponError;

  Future<void> getCoupon({required CouponField couponField}) async {
    Map<String, dynamic> data = {};
    if (couponField.controller.text.isEmpty) {
      couponField.isApplied = false;
      return;
    }
    data['coupon'] = couponField.controller.text;
    if(couponsFields.isNotEmpty){
      List<String> coupons=[];
      for (var element in couponsFields) {
        coupons.add(element.controller.text);
      }
      data['coupons[]'] = coupons;
    }
    loading();
    Either<DioException, CouponEntity> response = await cartUseCase.getCoupon(
      data,
    );
    navPop();
    response.fold(
      (l) {
        lastCouponError = l.message ??
            LanguageProvider.translate('recovery', 'coupon_invalid');
        notifyListeners();
      },
      (r) {
        lastCouponError = null;
        couponEntity ??= [];
        couponEntity?.add(r);
        couponField.isApplied = true;
        couponsFields.add(CouponField(controller: TextEditingController(), isApplied: false));
        notifyListeners();
        Provider.of<CartProvider>(
          Constants.globalContext(),
          listen: false,
        ).notifyListeners();
      },
    );
  }

  void handleTap({required CouponField coupon}) {
    if (!coupon.isApplied) {
      lastCouponError = null;
      notifyListeners();
      getCoupon(couponField: coupon);
    } else {
      lastCouponError = null;
      coupon.isApplied = false;
      couponEntity?.removeWhere((element) => element.coupon == coupon.controller.text);
      couponsFields.remove(coupon);
      coupon.controller.clear();
      notifyListeners();
      coupon.controller.text = '';
    }
    Provider.of<CheckoutProvider>(Constants.globalContext(), listen: false,).notifyListeners();
  }

  // num? calcCoupon(num price) {
  //   num discount = 0;
  //   if (couponEntity != null) {
  //     if (couponEntity!.type == "percentage") {
  //       if (price > couponEntity!.max!) {
  //         discount = (couponEntity!.max! * couponEntity!.value) / 100;
  //       } else {
  //         discount = (price * couponEntity!.value) / 100;
  //       }
  //       return discount;
  //     } else {
  //       discount = couponEntity!.value;
  //       return discount;
  //     }
  //   }
  //   return null;
  // }

  num? calcDiscount(){
    num discount = 0;
    if(couponEntity!=null){
      for(var element in couponEntity!){
        discount += element.discount??0;
      }
      return discount;
    }

    return null;

  }

  void clear() {
    couponEntity = null;
    couponsFields = [CouponField(controller: TextEditingController(), isApplied: false)];
    notifyListeners();
  }
}

class CouponField{
  TextEditingController controller;
  bool isApplied;
  CouponField({required this.controller, required this.isApplied});
}