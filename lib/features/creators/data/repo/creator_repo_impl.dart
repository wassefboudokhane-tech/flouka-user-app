import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flouka/features/creators/data/data_source/creator_remote_data_source.dart';
import 'package:flouka/features/creators/domain/entity/creator_entity.dart';
import 'package:flouka/features/creators/domain/repo/creator_repo.dart';

class CreatorRepoImpl implements CreatorRepo {
  final CreatorRemoteDataSource remote;

  CreatorRepoImpl(this.remote);

  @override
  Future<Either<DioException, List<CreatorEntity>>> getCreators() async {
    final result = await remote.getCreators();
    return result.fold((l) => Left(l), (r) => Right(r));
  }

  @override
  Future<Either<DioException, CreatorEntity?>> getCreator(int id) async {
    final result = await remote.getCreator(id);
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
