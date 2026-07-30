import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flouka/core/constants/constants.dart';
import 'package:flouka/features/address/data/model/neighborhood_model.dart';
import '../../../../core/helper_function/api.dart';
import '../model/area_model.dart';
import '../model/city_model.dart';

class CityRemoteDataSource {
  final ApiHandel apiHandel;
  CityRemoteDataSource(this.apiHandel);

  /// Staging marketplace often has empty cities; fall back to prod geo API.
  Dio _geoDio() {
    return Dio(
      BaseOptions(
        baseUrl: Constants.geoDomain,
        validateStatus: (status) => true,
        headers: {
          'Content-Type': 'application/json',
          'lang': apiHandel.lang ?? 'fr',
        },
      ),
    );
  }

  List<CityModel> _parseCities(dynamic raw) {
    final list = <CityModel>[];
    if (raw is List) {
      for (final i in raw) {
        list.add(CityModel.fromJson(i));
      }
    }
    return list;
  }

  List<AreaModel> _parseAreas(dynamic raw) {
    final list = <AreaModel>[];
    if (raw is List) {
      for (final i in raw) {
        list.add(AreaModel.fromJson(i));
      }
    }
    return list;
  }

  List<NeighborhoodModel> _parseNeighborhoods(dynamic raw) {
    final list = <NeighborhoodModel>[];
    if (raw is List) {
      for (final i in raw) {
        list.add(NeighborhoodModel.fromJson(i));
      }
    }
    return list;
  }

  Future<Either<DioException, List<CityModel>>> getCities() async {
    final response = await apiHandel.get('get_cities', {});
    if (response.isRight()) {
      final list = _parseCities(response.getOrElse(() => throw '').data['data']);
      if (list.isNotEmpty) return Right(list);
    }
    return _getCitiesFromGeo();
  }

  Future<Either<DioException, List<CityModel>>> _getCitiesFromGeo() async {
    try {
      final response = await _geoDio().get('get_cities');
      if (response.statusCode != 200) {
        return Left(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
            message: response.data is Map
                ? (response.data['message']?.toString() ?? 'Geo cities error')
                : 'Geo cities error',
          ),
        );
      }
      return Right(_parseCities(response.data['data']));
    } on DioException catch (e) {
      return Left(e);
    }
  }

  Future<Either<DioException, List<AreaModel>>> getArea(
    Map<String, dynamic> data,
  ) async {
    final response = await apiHandel.post('get_areas', data);
    if (response.isRight()) {
      final list =
          _parseAreas(response.getOrElse(() => throw '').data['data']);
      if (list.isNotEmpty) return Right(list);
    }
    return _getAreasFromGeo(data);
  }

  Future<Either<DioException, List<AreaModel>>> _getAreasFromGeo(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _geoDio().post(
        'get_areas',
        data: FormData.fromMap(data),
      );
      final code = response.data is Map ? response.data['code'] : null;
      if (response.statusCode != 200 || (code != null && code != 200)) {
        return Left(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
            message: response.data is Map
                ? (response.data['message']?.toString() ?? 'Geo areas error')
                : 'Geo areas error',
          ),
        );
      }
      return Right(_parseAreas(response.data['data']));
    } on DioException catch (e) {
      return Left(e);
    }
  }

  Future<Either<DioException, List<NeighborhoodModel>>> getNeighborhoods(
    Map<String, dynamic> data,
  ) async {
    final response = await apiHandel.post('get_neighborhoods', data);
    if (response.isRight()) {
      final list = _parseNeighborhoods(
        response.getOrElse(() => throw '').data['data'],
      );
      if (list.isNotEmpty) return Right(list);
    }
    return _getNeighborhoodsFromGeo(data);
  }

  Future<Either<DioException, List<NeighborhoodModel>>>
      _getNeighborhoodsFromGeo(Map<String, dynamic> data) async {
    try {
      final response = await _geoDio().post(
        'get_neighborhoods',
        data: FormData.fromMap(data),
      );
      final code = response.data is Map ? response.data['code'] : null;
      if (response.statusCode != 200 || (code != null && code != 200)) {
        return Left(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
            message: response.data is Map
                ? (response.data['message']?.toString() ??
                    'Geo neighborhoods error')
                : 'Geo neighborhoods error',
          ),
        );
      }
      return Right(_parseNeighborhoods(response.data['data']));
    } on DioException catch (e) {
      return Left(e);
    }
  }
}
