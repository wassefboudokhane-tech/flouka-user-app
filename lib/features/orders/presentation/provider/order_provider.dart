import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../../core/dialog/confirm_dialog.dart';
import '../../../../core/dialog/snack_bar.dart';
import '../../../../core/helper_function/navigation.dart';
import '../../../../core/models/pagination_class.dart';
import '../../../../core/models/provider_structure_model.dart';
import '../../../../core/helper_function/api.dart';
import '../../../../core/helper_function/prefs.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../language/presentation/provider/language_provider.dart';
import '../../domain/entity/order_entity.dart';
import '../../domain/use_case/order_use_case.dart';
import '../views/orders_view.dart';
import 'order_details_provider.dart';

class OrderProvider extends ChangeNotifier
    implements ProviderStructureModel<List<OrderEntity>>, PaginationClass {
  final OrderUseCase orderUseCase;

  OrderProvider(this.orderUseCase);

  @override
  List<OrderEntity>? data;

  @override
  Map? inputs;

  @override
  int pageIndex = 1;

  @override
  bool paginationFinished = false;

  @override
  bool paginationStarted = false;

  ScrollController controller = ScrollController();

  /// No session, or the server refused it: the page asks to sign in
  /// instead of loading forever.
  bool needsLogin = false;

  /// Any other failure: shown with a retry button.
  String? loadError;

  TextEditingController searchController = TextEditingController();

  void clear() {
    data = null;
    needsLogin = false;
    loadError = null;
    inputs = null;
    pageIndex = 1;
    paginationFinished = false;
    paginationStarted = false;
    notifyListeners();
  }

    @override
  Future getData() async {
    if (!hasSession()) {
      needsLogin = true;
      paginationStarted = false;
      notifyListeners();
      return;
    }
    Map<String, dynamic> dataToUse = {'page': pageIndex};
    final result = await orderUseCase.getUserOrders(dataToUse);

    result.fold((l) {
      if (isAuthFailure(l)) {
        // A stale or refused token: forget it and ask to sign in again.
        forgetSession();
        needsLogin = true;
      } else if (data == null) {
        loadError = l.response?.data is Map && l.response?.data['message'] is String
            ? l.response!.data['message'] as String
            : (l.message ?? LanguageProvider.translate('orders', 'load_failed'));
      } else {
        showToast(l.message ?? "Failed to load orders");
      }
      notifyListeners();
    }, (r) {
      pageIndex++;
      data ??= [];
      data!.addAll(r);
      if (r.isEmpty) paginationFinished = true;
      notifyListeners();
    });
    paginationStarted = false;
  }


  void updateAfterRateSuccess({required bool isProduct, required int id, required int orderId, }){
    int orderIndex = data?.indexWhere((element) => element.id == orderId) ?? -1;
    // int orderVendorIndex = data?[orderIndex].vendorOrders?.indexWhere((element) => element.id == vendorOrderId) ?? -1;

    if(orderIndex == -1) return;
    for (OrderEntity order in data??[]) {
      for (VendorOrderEntity vendorOrder in order.vendorOrders??[]) {
        if(isProduct){
          for (OrderItemEntity item in vendorOrder.items??[]) {
            if (item.productId == id) {
              item.canReviewProduct = false;
              notifyListeners();
              return;
            }
          }
        }else{
          if (vendorOrder.store?.id == id) {
            vendorOrder.canRateStore = false;
            notifyListeners();
            return;
          }
        }
      }
    }
    // if(isProduct){
    //
    //   // int index = data![orderIndex].vendorOrders?[orderVendorIndex].items?.indexWhere((element) => element.productId == id) ?? -1;
    //   // if(index != -1){
    //   //   data![orderIndex].vendorOrders?[orderVendorIndex].items?[index].canReviewProduct = false;
    //   // }
    // }else{
    //   if(data![orderIndex].vendorOrders?[orderVendorIndex].store?.id == id){
    //     data![orderIndex].vendorOrders?[orderVendorIndex].canRateStore = false;
    //   }
    // }
    notifyListeners();
  }


  /// Overridable in tests; the app reads the saved token.
  bool Function() hasSession = AuthProvider.isLogin;

  void Function() forgetSession = () {
    sharedPreferences.remove('token');
    ApiHandel.getInstance.updateHeader('');
  };

  /// 401/403, or the API's "invalid credentials" answer on a protected route.
  static bool isAuthFailure(DioException e) {
    final code = e.response?.statusCode;
    if (code == 401 || code == 403) return true;
    final body = e.response?.data;
    final text = '${body is Map ? body['message'] : ''} ${e.message ?? ''}'.toLowerCase();
    return text.contains('credential') || text.contains('unauthenticated') || text.contains('token');
  }

  @override
  void goToPage([Map<String, dynamic>? inputs]) {
    refresh();
    navP(const OrdersView());
  }

  @override
  void pagination() {
    controller.addListener(() async {
      if (controller.position.atEdge && controller.position.pixels > 50) {
        if (!paginationFinished &&
            !paginationStarted &&
            (data?.isNotEmpty ?? false)) {
          paginationStarted = true;
          notifyListeners();
          await getData();
        }
      }
    });
  }

  @override
  Future refresh() async {
    clear();
    await getData();
  }

  Future<void> cancelOrder(
    int orderId, {
    OrderDetailsProvider? detailsProvider,
  }) async {
    final Either<DioException, bool> result = await orderUseCase.cancelOrder({
      'order_id': orderId,
    });

    result.fold((error) => showToast(error.message ?? "Failed to cancel order"), (
      success,
    ) {
      if (success) {
        final order = data?.firstWhere((o) => o.id == orderId);
        if (order != null) order.status = OrderStatus.cancelled;

        if (detailsProvider?.data != null) {
          detailsProvider!.data!.status = OrderStatus.cancelled;
          detailsProvider.notifyListeners();
        }

        notifyListeners();
      }
    });
  }

  showCancelOrderDialog(OrderDetailsProvider detailsProvider, int orderId) {
    confirmDialog(
      LanguageProvider.translate('buttons', 'cancel_order'),
      LanguageProvider.translate('buttons', 'cancel_order'),
      () {
        cancelOrder(orderId);
        navPop();
      },
    );
  }
}
