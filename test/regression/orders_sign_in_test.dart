import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flouka/features/orders/domain/entity/order_entity.dart';
import 'package:flouka/features/orders/domain/repos/order_repo.dart';
import 'package:flouka/features/orders/domain/use_case/order_use_case.dart';
import 'package:flouka/features/orders/presentation/provider/order_provider.dart';
import 'package:flutter_test/flutter_test.dart';

DioException _error(int code, String message) {
  final req = RequestOptions(path: 'user/get_user_orders');
  return DioException(
    requestOptions: req,
    response: Response(requestOptions: req, statusCode: code, data: {'message': message}),
  );
}

class _Repo implements OrderRepo {
  _Repo(this.result);
  final Either<DioException, List<OrderEntity>> result;
  int calls = 0;

  @override
  Future<Either<DioException, List<OrderEntity>>> getUserOrders(Map<String, dynamic> data) async {
    calls++;
    return result;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

OrderProvider _provider(_Repo repo, {required bool session, void Function()? forget}) {
  return OrderProvider(OrderUseCase(repo))
    ..hasSession = (() => session)
    ..forgetSession = (forget ?? () {});
}

void main() {
  test('a guest is asked to sign in and no request is sent', () async {
    final repo = _Repo(const Right([]));
    final orders = _provider(repo, session: false);
    await orders.refresh();
    expect(orders.needsLogin, isTrue);
    expect(repo.calls, 0);
  });

  test('a refused token is forgotten and the page asks to sign in', () async {
    var forgotten = false;
    final orders = _provider(_Repo(Left(_error(422, 'Invalid login credentials'))),
        session: true, forget: () => forgotten = true);
    await orders.refresh();
    expect(orders.needsLogin, isTrue);
    expect(forgotten, isTrue);
    expect(orders.data, isNull);
  });

  test('other failures stop the spinner and offer a retry', () async {
    final orders = _provider(_Repo(Left(_error(500, 'Server error'))), session: true);
    await orders.refresh();
    expect(orders.needsLogin, isFalse);
    expect(orders.loadError, 'Server error');
  });

  test('signed-in users get their orders', () async {
    final orders = _provider(_Repo(const Right([])), session: true);
    await orders.refresh();
    expect(orders.needsLogin, isFalse);
    expect(orders.data, isEmpty);
  });

  test('401 and 403 count as auth failures', () {
    expect(OrderProvider.isAuthFailure(_error(401, '')), isTrue);
    expect(OrderProvider.isAuthFailure(_error(403, '')), isTrue);
    expect(OrderProvider.isAuthFailure(_error(500, 'boom')), isFalse);
  });
}
