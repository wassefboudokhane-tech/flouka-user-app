import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flouka/features/creators/domain/entity/creator_entity.dart';

abstract class CreatorRepo {
  Future<Either<DioException, List<CreatorEntity>>> getCreators();
  Future<Either<DioException, CreatorEntity?>> getCreator(int id);
}
