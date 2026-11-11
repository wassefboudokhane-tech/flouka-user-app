import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flouka/core/helper_function/api.dart';
import 'package:flouka/features/creators/data/models/creator_model.dart';

/// Endpoints expected from the backend (not live yet):
/// `get_creators` → `{data: [creator]}` and
/// `get_creator?id=` → `{data: creator with products}`.
class CreatorRemoteDataSource {
  final ApiHandel apiHandel;

  CreatorRemoteDataSource(this.apiHandel);

  Future<Either<DioException, List<CreatorModel>>> getCreators() async {
    final response = await apiHandel.get('get_creators');
    return response.fold((l) => Left(l), (r) {
      final creators = <CreatorModel>[];
      final data = r.data is Map ? r.data['data'] : null;
      if (data is List) {
        for (final item in data) {
          if (item is Map<String, dynamic>) {
            creators.add(CreatorModel.fromJson(item));
          }
        }
      }
      return Right(creators);
    });
  }

  Future<Either<DioException, CreatorModel?>> getCreator(int id) async {
    final response = await apiHandel.get('get_creator?id=$id');
    return response.fold((l) => Left(l), (r) {
      final data = r.data is Map ? r.data['data'] : null;
      if (data is Map<String, dynamic>) {
        return Right(CreatorModel.fromJson(data));
      }
      return const Right(null);
    });
  }
}
