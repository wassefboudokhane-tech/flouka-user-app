import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';
// import 'package:provider/provider.dart';
// import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/language/presentation/provider/language_provider.dart';
import '../constants/constants.dart';
import '../network/connectivity_status_provider.dart';
import 'convert.dart';
import 'helper_function.dart';
import 'prefs.dart';

class ApiHandel {
  static ApiHandel? _instance;
  late Dio dio;
  static const Duration _connectTimeout = Duration(seconds: 10);
  static const Duration _receiveTimeout = Duration(seconds: 15);

  void _markOnline() {
    try {
      Constants.globalContext().read<ConnectivityStatusProvider>().markOnline();
    } catch (_) {}
  }

  void _markOffline() {
    try {
      Constants.globalContext()
          .read<ConnectivityStatusProvider>()
          .markOffline();
    } catch (_) {}
  }

  ApiHandel._();

  String? token;
  String? lang;
  late CancelToken cancelToken;

  static ApiHandel get getInstance {
    _instance ??= ApiHandel._(); // Instantiate if null
    return _instance!;
  }

  Future<void> init() async {
    lang = sharedPreferences.getString('language_code') ?? "fr";
    token = sharedPreferences.getString('token');
    dio = Dio(
      BaseOptions(
        baseUrl: Constants.domain,
        connectTimeout: _connectTimeout,
        sendTimeout: _receiveTimeout,
        receiveTimeout: _receiveTimeout,
        // will not throw errors
        validateStatus: (status) => true,
        headers: {
          "lang": lang ?? "fr",
          'Content-Type': 'application/json',
          if (token != null && token!.isNotEmpty)
            "Authorization": 'Bearer $token',
        },
      ),
    );
    try {
      final value = await Future.wait([
        for (var i in LanguageProvider.languages)
          Dio(
            BaseOptions(
              connectTimeout: _connectTimeout,
              receiveTimeout: _receiveTimeout,
            ),
          ).get(
            '${Constants.baseUri}app_languages/user/${i.languageCode}.json',
          ),
      ]).timeout(const Duration(seconds: 10));
      Map data = {};
      for (int i = 0; i < LanguageProvider.languages.length; i++) {
        data[LanguageProvider.languages[i].languageCode] = value[i].data;
      }
      languages = data;
    } catch (e, st) {
      debugPrint('Language files load failed (CORS / network): $e\n$st');
      languages = {};
    }
  }

  Map languages = {};

  void cancelFunction() async {
    cancelToken.cancel();
  }

  void updateHeader(String token, {String? language}) {
    if (language != null) {
      lang = language;
    }
    dio.options = BaseOptions(
      baseUrl: Constants.domain,
      connectTimeout: _connectTimeout,
      sendTimeout: _receiveTimeout,
      receiveTimeout: _receiveTimeout,
      validateStatus: (status) => true,
      // baseUrl: Constants.domain,
      headers: {
        if (token.isNotEmpty) "Authorization": 'Bearer $token',
        "lang": lang ?? "fr",
        'Content-Type': 'application/json',
      },
    );
  }

  Future<Either<DioException, Response>> get(
    path, [
    Map<String, dynamic>? data,
  ]) async {
    try {
      await reLogin(path);
      cancelToken = CancelToken();
      Response response = await dio.get(
        path,
        queryParameters: data,
        cancelToken: cancelToken,
      );
      print("AaAAAAAAAAAAAAa${path}");
      print("AaAAAAAAAAAAAAa${data}");

      if (response.statusCode == 200) {
        _markOnline();
        return Right(response);
      }
      log('error1');
      print("AaAAAAAAAAAAAAa${path}");

      return Left(dioException(response));
    } on DioException catch (e) {
      log(e.response?.data.toString() ?? "");
      if (e.response == null) _markOffline();

      return Left(e.response == null ? e : dioException(e.response!));
    } catch (e) {
      log('error3');
      print("AaAAAAAAAAAAAAa${path}");
      return Left(
        DioException(
          requestOptions: RequestOptions(baseUrl: Constants.domain, path: path),
          message: 'Server Error',
        ),
      );
    }
  }

  Future<Either<DioException, Response>> delete(
    path, [
    Map<String, dynamic>? data,
  ]) async {
    try {
      await reLogin(path);
      cancelToken = CancelToken();
      Response response = await dio.delete(
        path,
        queryParameters: data,
        cancelToken: cancelToken,
      );
      log(path.toString());

      if (response.statusCode == 200) {
        _markOnline();
        return Right(response);
      }
      log('error1');

      print("AaAAAAAAAAAAAAa${path}");
      return Left(dioException(response));
    } on DioException catch (e) {
      log(e.response?.data.toString() ?? "");
      if (e.response == null) _markOffline();
      print("AaAAAAAAAAAAAAa${path}");
      return Left(e.response == null ? e : dioException(e.response!));
    } catch (e) {
      log('error3');
      print("AaAAAAAAAAAAAAa${path}");
      return Left(
        DioException(
          requestOptions: RequestOptions(baseUrl: Constants.domain, path: path),
          message: 'Server Error',
        ),
      );
    }
  }

  Future<Either<DioException, Response>> post(
    path,
    Map<String, dynamic> data,
  ) async {
    try {
      await reLogin(path);

      cancelToken = CancelToken();
      Response response = await dio.post(
        path,
        data: FormData.fromMap(data),
        cancelToken: cancelToken,
      );
      print("AaAAAAAAAAAAAAa${path}");
      print("AaAAAAAAAAAAAAa${data}");

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          ((!response.data.containsKey('code')) ||
              response.data['code'] == 200)) {
        _markOnline();
        return Right(response);
      }
      log('error1');
      log(response.data.toString());
      print("ssssssssssssssss${path}");
      print("ssssssssssssssss${response.statusCode}");
      print("ssssssssssssssss${response.data}");
      return Left(dioException(response));
    } on DioException catch (e) {
      log(e.response?.data.toString() ?? "");
      if (e.response == null) _markOffline();
      // print(" ON $e");
      log('error2');
      print("AAAAAAAAAAAA${data}");
      print("AAAAAAAAAAAA${path}");
      return Left(e.response == null ? e : dioException(e.response!));
    } catch (e, line) {
      log('error3');
      print("AAAAAAAAAAAA${path}");
      return Left(
        DioException(
          requestOptions: RequestOptions(baseUrl: Constants.domain, path: path),
          message: 'Server Error',
        ),
      );
    }
  }

  DioException dioException(Response response) {
    String msg = 'Server Error';
    if (response.data is Map) {
      Map data = response.data;
      if (data['message'] is Map) {
        msg = convertMapToString(data['message']);
      } else if (data['message'] is List) {
        msg = data['message'].join('\n');
      } else {
        msg = data['message'];
      }
    }
    return DioException(
      requestOptions: response.requestOptions,
      message: msg,
      type: msg == 'Server Error'
          ? DioExceptionType.unknown
          : DioExceptionType.badResponse,
      response: response,
      error: 'Server Error',
    );
  }

  Future<Either<DioException, Response>> download(String path) async {
    try {
      debugPrint([path].toString());
      await reLogin(path);
      cancelToken = CancelToken();
      Response response = await dio.download(
        path,
        await getDownloadPath(path.split('/').last),
        cancelToken: cancelToken,
      );
      if (response.statusCode == 200) {
        return Right(response);
      }
      return Left(dioException(response));
    } on DioException catch (e) {
      debugPrint(e.error.toString());
      return Left(e.response == null ? e : dioException(e.response!));
    } catch (e) {
      debugPrint(e.toString());
      return Left(
        DioException(
          requestOptions: RequestOptions(baseUrl: Constants.domain, path: path),
          message: 'Server Error',
        ),
      );
    }
  }

  Future reLogin(String url) async {
    String? token = sharedPreferences.getString('token');
    if (!url.contains('refresh_token') &&
        token != null &&
        token.isNotEmpty &&
        JwtDecoder.isExpired(token)) {
      final refreshed = await Provider.of<AuthProvider>(
        Constants.globalContext(),
        listen: false,
      ).refreshToken();
      if (!refreshed) {
        final request = RequestOptions(baseUrl: Constants.domain, path: url);
        throw DioException(
          requestOptions: request,
          response: Response(
            requestOptions: request,
            statusCode: 401,
            data: const {'message': 'Session expired'},
          ),
        );
      }
    }
  }
}
