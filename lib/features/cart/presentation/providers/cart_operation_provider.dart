import 'package:flouka/core/constants/app_lotties.dart';
import 'package:flouka/core/dialog/guest_dialog.dart';
import 'package:flouka/core/helper_function/loading.dart';
import 'package:flouka/features/address/presentation/providers/address_provider.dart';
import 'package:flouka/features/cart/data/data_source/guest_cart_local_data_source.dart';
import 'package:flouka/features/cart/domain/utils/guest_cart_mapper.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/dialog/snack_bar.dart';
import '../../../../core/dialog/success_dialog.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import 'cart_provider.dart';
import 'checkout_provider.dart';

extension CartOperations on CartProvider {
  Future increaseCart(int cartId) async {
    if (isGuestMode) {
      if (data == null) return;
      final index = data!.indexWhere((element) => element.id == cartId);
      if (index < 0) return;
      data![index].quantity = (data![index].quantity ?? 0) + 1;
      await persistGuestFromData();
      rebuild();
      return;
    }
    Map<String, dynamic> dataToUse = {};
    dataToUse['id'] = cartId;
    final result = await cartUseCase.increaseCart(dataToUse);
    result.fold(
      (l) {
        showToast(l.message!);
      },
      (r) {
        final item = data!.firstWhere((element) => element.id == cartId);
        item.quantity = (item.quantity ?? 0) + 1;
        rebuild();
      },
    );
    rebuild();
  }

  Future decreaseCart(int cartId) async {
    if (isGuestMode) {
      if (data == null) return;
      final index = data!.indexWhere((element) => element.id == cartId);
      if (index < 0) return;
      final item = data![index];
      if ((item.quantity ?? 0) <= 1) {
        data!.removeAt(index);
      } else {
        item.quantity = (item.quantity ?? 0) - 1;
      }
      await persistGuestFromData();
      rebuild();
      return;
    }
    Map<String, dynamic> dataToUse = {};
    dataToUse['id'] = cartId;
    final result = await cartUseCase.decreaseCart(dataToUse);
    result.fold(
      (l) {
        showToast(l.message!);
      },
      (r) {
        final item = data!.firstWhere((element) => element.id == cartId);
        if (item.quantity == 1) {
          data!.remove(item);
        } else {
          item.quantity = (item.quantity ?? 0) - 1;
        }
        rebuild();
      },
    );
    rebuild();
  }

  Future deleteCart() async {
    if (isGuestMode) {
      data = [];
      await guestCartLocal.clear();
      rebuild();
      return;
    }
    Map<String, dynamic> dataToUse = {};
    final result = await cartUseCase.deleteCart(dataToUse);
    result.fold(
      (l) {
        showToast(l.message!);
      },
      (r) {},
    );
  }

  bool checkIfProductIsInCart(int productId) {
    return data?.any((element) => element.product!.id == productId) ?? false;
  }

  Future deleteCartItem(int cartId) async {
    if (isGuestMode) {
      data?.removeWhere((element) => element.id == cartId);
      await persistGuestFromData();
      rebuild();
      return;
    }
    Map<String, dynamic> dataToUse = {};
    dataToUse['id'] = cartId;
    final result = await cartUseCase.deleteCartItem(dataToUse);
    result.fold(
      (l) {
        showToast(l.message!);
      },
      (r) {
        final item = data!.firstWhere((element) => element.id == cartId);
        data!.remove(item);
        rebuild();
      },
    );
    rebuild();
  }

  Future addToCart({
    required int storeId,
    required int quantity,
    required int storeProductStockId,
    int? productId,
    String? title,
    String? vendorName,
    num? price,
    String? image,
    String? variantLabel,
  }) async {
    if (isGuestMode ||
        Provider.of<AuthProvider>(Constants.globalContext(), listen: false)
                .userEntity ==
            null) {
      if (productId == null) {
        showToast(LanguageProvider.translate('error', 'error'));
        return;
      }
      final items = guestCartLocal.load();
      final index = items.indexWhere((e) => e.stockId == storeProductStockId);
      if (index >= 0) {
        items[index] = items[index].copyWith(qty: items[index].qty + quantity);
      } else {
        items.add(
          GuestCartItem(
            productId: productId,
            title: title ?? '',
            vendorName: vendorName ?? '',
            price: price ?? 0,
            image: image,
            qty: quantity,
            storeId: storeId,
            stockId: storeProductStockId,
            variantLabel: variantLabel,
          ),
        );
      }
      await guestCartLocal.save(items);
      data = cartEntitiesFromGuest(items);
      rebuild();
      _showAddedToCartSuccess();
      return;
    }

    Map<String, dynamic> dataToUse = {};
    dataToUse['store_id'] = storeId;
    dataToUse['quantity'] = quantity;
    dataToUse['store_product_stock_id'] = storeProductStockId;
    loading();
    final result = await cartUseCase.addToCart(dataToUse);
    dismissLoading();
    result.fold(
      (l) {
        showToast(l.message!);
        print('xxxxxxxxxxxx$dataToUse');
      },
      (r) async {
        await refresh();
        _showAddedToCartSuccess();
      },
    );
  }

  void _showAddedToCartSuccess() {
    successDialog(
      msg: 'added_to_cart',
      lottie: Lotties.successAddToCart,
      onCheckout: () {
        final auth = Provider.of<AuthProvider>(
          Constants.globalContext(),
          listen: false,
        );
        if (auth.userEntity == null) {
          showGuestDialog();
          return;
        }
        if (auth.userEntity?.addressEntity == null) {
          showToast(
            LanguageProvider.translate('error', 'add_address'),
            isSnack: true,
          );
          Provider.of<AddressProvider>(
            Constants.globalContext(),
            listen: false,
          ).goToAddressPage();
          return;
        }
        Provider.of<CheckoutProvider>(
          Constants.globalContext(),
          listen: false,
        ).goToPage();
      },
    );
  }
}
