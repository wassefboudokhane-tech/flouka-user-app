import 'package:flouka/core/creator_attribution.dart';
import 'dart:math';

import 'package:flouka/core/helper_function/convert.dart';
import 'package:flouka/features/cart/presentation/providers/coupon_provider.dart';
import 'package:flouka/features/settings/domain/entities/settings_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/constants/constants.dart';
import '../views/order_confirmed_view.dart';
import '../../../../core/dialog/snack_bar.dart';
import '../../../../core/helper_function/loading.dart';
import '../../../../core/helper_function/navigation.dart';
import '../../../../core/network/recovery_error_handler.dart';
import '../../../../core/models/payment_result.dart';
import '../../../../core/widgets/payment_online_page.dart';
import '../../../address/presentation/providers/address_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../language/presentation/provider/language_provider.dart';
import '../../../orders/domain/use_case/order_use_case.dart';
import '../../../orders/presentation/provider/order_provider.dart';
import '../../../settings/presentation/provider/settings_provider.dart';
import '../../../wallet/presentation/provider/wallet_provider.dart';
import '../../domain/entity/coupon_entity.dart';
import '../../domain/entity/payment_method_entity.dart';
import '../views/checkout_view.dart';
import '../widgets/checkout_stock_bottom_sheet.dart';
import 'cart_provider.dart';

class CheckoutProvider extends ChangeNotifier {
  final OrderUseCase orderUseCase;
  CheckoutProvider(this.orderUseCase);

  RecoveryErrorInfo? activeRecovery;

  void clearRecovery() {
    activeRecovery = null;
    notifyListeners();
  }

  num subtotal() {
    num sub = 0;
    for (var element in cart.data ?? []) {
      sub += element.subTotal;
    }
    return convertDataToNum(sub.toStringAsFixed(2))!;
  }

  num deliveryPrice() {
    if (getFreeDelivery()) {
      return 0;
    }
    final settings = Constants.globalContext()
        .read<SettingsProvider>()
        .settingsEntity!;

    final num basePrice = settings.deliveryPrice;

    final int storesCount =
        cart.data?.map((e) => e.storeId).toSet().length ?? 0;

    if (storesCount <= 1) {
      return basePrice;
    }

    return basePrice + ((storesCount - 1) * (basePrice / 2));
  }

  num tax() {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(
      Constants.globalContext(),
      listen: false,
    );
    return convertDataToNum(
      (((settingsProvider.settingsEntity?.tax ?? 0) / 100) *
              (subtotal() - (couponProvider.calcDiscount() ?? 0)))
          .toStringAsFixed(2),
    )!;
  }

  num total() {
    CouponProvider couponProvider = Provider.of<CouponProvider>(
      Constants.globalContext(),
      listen: false,
    );
    return convertDataToNum((subtotal() + tax()).toStringAsFixed(2))! -
        ((couponProvider.calcDiscount() ?? 0)) +
        deliveryPrice();
  }

  num diffDeliveryNeed() {
    SettingsEntity settingsEntity = Constants.globalContext()
        .read<SettingsProvider>()
        .settingsEntity!;
    return max(settingsEntity.minFreeDelivery - subtotal(), 0);
  }

  double freeDeliveryProgress() {
    final settings = Constants.globalContext()
        .read<SettingsProvider>()
        .settingsEntity;
    if (settings == null || settings.minFreeDelivery <= 0) {
      return 1;
    }
    return (subtotal() / settings.minFreeDelivery).clamp(0.0, 1.0);
  }

  String? freeDelvieryText() {
    if (diffDeliveryNeed() > 0) {
      return LanguageProvider.translate(
        'global',
        'but_more_for_free_delivery',
      ).replaceAll('*num*', diffDeliveryNeed().toStringAsFixed(2));
    }
    if ((cart.data?.length ?? 0) == 1) {
      return LanguageProvider.translate('global', 'buy_one_more');
    }
    return LanguageProvider.translate('global', 'free_delivery');
  }

  bool getFreeDelivery() {
    return diffDeliveryNeed() == 0 && (cart.data?.length ?? 0) > 1;
  }

  CouponEntity? couponEntity;

  OrderProvider ordersProvider = Provider.of<OrderProvider>(
    Constants.globalContext(),
    listen: false,
  );
  AddressProvider addressProvider = Provider.of<AddressProvider>(
    Constants.globalContext(),
    listen: false,
  );
  final couponProvider = Provider.of<CouponProvider>(
    Constants.globalContext(),
    listen: false,
  );
  Future<int?> createOrder() async {
    final authProvider = Provider.of<AuthProvider>(
      Constants.globalContext(),
      listen: false,
    );
    final addressId = authProvider.userEntity?.addressEntity?.id;
    if (addressId == null) {
      showToast(
        LanguageProvider.translate('error', 'add_address'),
        isSnack: true,
      );
      addressProvider.goToAddressPage();
      return null;
    }

    int? orderId;
    final dataToUse = <String, dynamic>{
      'address_id': addressId,
      'total': total(),
      'delivery_price': deliveryPrice(),
      'is_free_delivery': getFreeDelivery() ? 1 : 0,
      'sub_total': subtotal(),
      'tax': tax(),
      'payment_method': selectedPaymentMethod.toAPI,
      'can_ship_auto': termsAccepted ? 1 : 0,
      'discount': couponProvider.calcDiscount() ?? 0,
    };
    final creatorRef = CreatorAttributionStore.activeRef();
    if (creatorRef != null) dataToUse['creator_ref'] = creatorRef;
    for (int i = 0; i < (couponProvider.couponEntity?.length ?? 0); i++) {
      dataToUse['coupons[$i][coupon]'] = couponProvider.couponEntity?[i].coupon;
      dataToUse['coupons[$i][discount]'] =
          couponProvider.couponEntity?[i].discount;
    }

    loading();
    final result = await orderUseCase.createOrder(dataToUse);
    dismissLoading();

    result.fold(
      (l) {
        final message = l.message ?? '';
        activeRecovery = RecoveryErrorHandler.parse(l, message: message);
        if (activeRecovery!.type == RecoveryErrorType.stock) {
          CheckoutStockBottomSheet.show(message: message);
        } else if (activeRecovery!.type == RecoveryErrorType.offline ||
            activeRecovery!.type == RecoveryErrorType.sessionExpired ||
            activeRecovery!.type == RecoveryErrorType.deliveryZone ||
            activeRecovery!.type == RecoveryErrorType.server) {
          // Banner on checkout; still surface a toast so CTA isn't a silent no-op.
          if (message.isNotEmpty) showToast(message, isSnack: true);
        } else if (message.isNotEmpty) {
          showToast(message, isSnack: true);
        }
        notifyListeners();
      },
      (r) {
        orderId = r;
        CreatorAttributionStore.clear();
        if (selectedPaymentMethod.toAPI == 'wallet') {
          final walletProvider = Provider.of<WalletProvider>(
            Constants.globalContext(),
            listen: false,
          );
          walletProvider.decreaseWallet(total());
        }
        if (selectedPaymentMethod.toAPI != 'online') {
          final vendorNames = cart.vendorGroups
              .map((group) => group.store?.name)
              .whereType<String>()
              .where((name) => name.isNotEmpty)
              .toList();
          final confirmed = OrderConfirmedView(
            orderId: r,
            total: total(),
            paymentMethod: selectedPaymentMethod,
            vendorNames: vendorNames,
          );
          // Avoid Navigator "_debugLocked" right after closing the loader.
          SchedulerBinding.instance.addPostFrameCallback((_) {
            if (!Constants.globalContext().mounted) return;
            navPR(confirmed);
            cart.refresh();
            notifyListeners();
          });
        }
      },
    );
    notifyListeners();
    return orderId;
  }

  void goToPage([Map<String, dynamic>? inputs]) async {
    termsAccepted = false;
    activeRecovery = null;
    selectedPaymentMethod = paymentMethods.first;
    navP(const CheckoutView());
  }

  /// Cash only: vendors deliver and collect themselves.
  List<PaymentMethodEntity> paymentMethods = [
    PaymentMethodEntity(
      image: AppImages.cash,
      paymentMethod: 'Cach On Delivery',
      toAPI: 'cash',
      isRecommended: true,
      subtitleKey: 'payment_cod_detail',
    ),
  ];

  PaymentMethodEntity selectedPaymentMethod = PaymentMethodEntity(
    image: AppImages.cash,
    paymentMethod: 'Cach On Delivery',
    toAPI: 'cash',
    isRecommended: true,
    subtitleKey: 'payment_cod_detail',
  );

  num walletBalance() {
    final auth = Provider.of<AuthProvider>(
      Constants.globalContext(),
      listen: false,
    );
    return convertDataToNum(auth.userEntity?.wallet) ?? 0;
  }

  bool isWalletInsufficient() => total() > walletBalance();

  num walletShortfall() =>
      isWalletInsufficient() ? total() - walletBalance() : 0;

  String selectedPaymentSubline() {
    switch (selectedPaymentMethod.toAPI) {
      case 'cash':
        return LanguageProvider.translate('checkout', 'payment_subline_cod');
      case 'wallet':
        return LanguageProvider.translate('checkout', 'payment_subline_wallet');
      case 'online':
        return LanguageProvider.translate('checkout', 'payment_subline_online');
      default:
        return LanguageProvider.translate('global', 'cod_badge');
    }
  }

  void selectPaymentMethod(PaymentMethodEntity paymentMethodEntity) {
    if (paymentMethodEntity.toAPI == 'wallet' && isWalletInsufficient()) {
      return;
    }
    selectedPaymentMethod = paymentMethodEntity;
    notifyListeners();
  }

  bool isPaymentMethodDisabled(PaymentMethodEntity entity) {
    return entity.toAPI == 'wallet' && isWalletInsufficient();
  }

  bool isPaymentMethodSelected(PaymentMethodEntity paymentMethodEntity) {
    return selectedPaymentMethod.toAPI == paymentMethodEntity.toAPI;
  }

  final settings = Provider.of<SettingsProvider>(
    Constants.globalContext(),
    listen: false,
  );
  final cart = Provider.of<CartProvider>(
    Constants.globalContext(),
    listen: false,
  );

  bool termsAccepted = false;
  void toggleTermsAccepted(bool val) {
    termsAccepted = val;
    notifyListeners();
  }

  void makeOrder() async {
    if (selectedPaymentMethod.toAPI == 'online') {
      final orderId = await createOrder();
      if (orderId == null) return;
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (!Constants.globalContext().mounted) return;
        navP(
          PaymentOnlinePage(total: total(), type: 'order_$orderId'),
          then: (val) {
            if (val == PaymentResult.paid) {
              navPU();
              ordersProvider.goToPage();
              cart.clear();
            } else if (val == PaymentResult.failed) {
              showToast(LanguageProvider.translate('error', 'error'));
              cart.refresh();
            }
          },
        );
      });
      return;
    }
    if (selectedPaymentMethod.toAPI == 'wallet' && isWalletInsufficient()) {
      return;
    }
    await createOrder();
  }
}
