import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flouka/features/cart/presentation/providers/coupon_provider.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/dialog/snack_bar.dart';
import '../../../../core/helper_function/navigation.dart';
import '../../../../core/models/provider_structure_model.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/data_source/guest_cart_local_data_source.dart';
import '../../domain/entity/cart_entity.dart';
import '../../domain/use_case/cart_use_case.dart';
import '../../domain/utils/cart_merge.dart';
import '../../domain/utils/guest_cart_mapper.dart';
import '../views/cart_view.dart';

class CartProvider extends ChangeNotifier
    implements ProviderStructureModel<List<CartEntity>> {
  final CartUseCase cartUseCase;
  final GuestCartLocalDataSource guestCartLocal = GuestCartLocalDataSource();

  CartProvider(this.cartUseCase);

  @override
  List<CartEntity>? data;

  @override
  Map? inputs;

  bool _guestMergeDone = false;

  @override
  void clear() {
    data = null;
    inputs = null;
    notifyListeners();
  }

  bool get isGuestMode => !AuthProvider.isLogin();

  bool get hasItems => data != null && data!.isNotEmpty;

  int get totalItemCount {
    if (data == null) return 0;
    return data!.fold<int>(0, (sum, line) => sum + (line.quantity ?? 0));
  }

  void loadGuestCart() {
    data = cartEntitiesFromGuest(guestCartLocal.load());
    notifyListeners();
  }

  Future<void> persistGuestFromData() async {
    if (!isGuestMode || data == null) return;
    final items = <GuestCartItem>[];
    for (final line in data!) {
      final stockId = line.storeProductStockId;
      final productId = line.product?.id;
      if (stockId == null || productId == null) continue;
      items.add(
        GuestCartItem(
          productId: productId,
          title: line.variant?.name ?? line.product?.title ?? '',
          vendorName: line.product?.store?.name ?? '',
          price: line.unitPrice ?? 0,
          image: line.product?.image,
          qty: line.quantity ?? 1,
          storeId: line.storeId,
          stockId: stockId,
          variantLabel: line.variant?.attributeValues.isNotEmpty == true
              ? line.variant!.attributeValues
                    .map((a) => a.valueName ?? '')
                    .where((s) => s.isNotEmpty)
                    .join(' / ')
              : null,
        ),
      );
    }
    await guestCartLocal.save(items);
  }

  /// Push local guest lines to the server cart after login (web parity).
  Future<void> syncGuestCartAfterLogin() async {
    if (!AuthProvider.isLogin() || _guestMergeDone) {
      await refresh();
      return;
    }

    final guestItems = guestCartLocal.load();
    if (guestItems.isEmpty) {
      _guestMergeDone = true;
      await refresh();
      return;
    }

    final serverResult = await cartUseCase.getCart();
    if (serverResult.isLeft()) {
      serverResult.fold((l) => showToast(l.message ?? ''), (_) {});
      return;
    }
    final serverLines = serverResult.fold((l) {
      return <CartEntity>[];
    }, (r) => r);

    final serverItems = serverLines
        .map((line) {
          return MergeCartItem(
            id: line.product?.id ?? 0,
            title: line.variant?.name ?? line.product?.title ?? '',
            vendorName: line.product?.store?.name ?? '',
            price: line.unitPrice ?? 0,
            image: line.product?.image,
            qty: line.quantity ?? 1,
            storeId: line.storeId,
            stockId: line.storeProductStockId,
            serverCartId: line.id,
          );
        })
        .where((i) => i.id != 0)
        .toList();

    final guestMerge = guestItems.map(MergeCartItem.fromGuest).toList();
    final merged = mergeGuestIntoServer(serverItems, guestMerge);

    for (final item in guestItemsNeedingServerSync(merged, serverItems)) {
      if (item.stockId == null || item.storeId == null) return;
      final result = await cartUseCase.addToCart({
        'store_id': item.storeId,
        'quantity': item.qty,
        'store_product_stock_id': item.stockId,
      });
      if (result.isLeft()) return;
    }

    for (final bump in serverQtyIncreases(merged, serverItems)) {
      for (var i = 0; i < bump.delta; i++) {
        final result = await cartUseCase.increaseCart({
          'id': bump.serverCartId,
        });
        if (result.isLeft()) return;
      }
    }

    await guestCartLocal.clear();
    _guestMergeDone = true;
    await refresh();
  }

  void resetGuestMergeFlag() {
    _guestMergeDone = false;
  }

  @override
  Future getData() async {
    if (isGuestMode) {
      loadGuestCart();
      return;
    }
    final result = await cartUseCase.getCart();
    result.fold(
      (l) {
        showToast(l.message!);
        log(l.message!);
      },
      (r) {
        data ??= [];
        data!.addAll(r);
      },
    );

    notifyListeners();
  }

  @override
  void goToPage([Map<String, dynamic>? inputs]) async {
    Provider.of<CouponProvider>(
      Constants.globalContext(),
      listen: false,
    ).clear();
    await refresh();
    navP(const CartView());
    notifyListeners();
  }

  @override
  Future refresh() async {
    clear();
    await getData();
    notifyListeners();
  }

  num caluclateTotal() {
    if (data == null) {
      return 0;
    }
    num allSubTotal = 0;
    for (var element in data!) {
      allSubTotal += element.subTotal;
    }
    return allSubTotal;
  }

  int get vendorCount {
    if (data == null || data!.isEmpty) return 0;
    return data!.map((e) => e.storeId).toSet().length;
  }

  List<CartVendorGroup> get vendorGroups {
    if (data == null || data!.isEmpty) return const [];
    final grouped = <int, List<CartEntity>>{};
    for (final line in data!) {
      grouped.putIfAbsent(line.storeId, () => []).add(line);
    }
    return grouped.entries
        .map((entry) => CartVendorGroup(storeId: entry.key, items: entry.value))
        .toList();
  }

  ScrollController controller = ScrollController();
  void rebuild() {
    notifyListeners();
  }

  TextEditingController couponController = TextEditingController();
}
