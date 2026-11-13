import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flouka/features/creators/data/models/creator_model.dart';
import 'package:flouka/features/creators/domain/entity/creator_entity.dart';
import 'package:flouka/features/creators/domain/repo/creator_repo.dart';
import 'package:flouka/features/creators/presentation/providers/creators_provider.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeRepo implements CreatorRepo {
  _FakeRepo(this.result);

  final Either<DioException, List<CreatorEntity>> result;

  @override
  Future<Either<DioException, List<CreatorEntity>>> getCreators() async =>
      result;

  @override
  Future<Either<DioException, CreatorEntity?>> getCreator(int id) async =>
      const Right(null);
}

void main() {
  final failure = Left<DioException, List<CreatorEntity>>(
    DioException(requestOptions: RequestOptions(path: 'get_creators')),
  );

  test('release build shows nothing when the endpoint is missing', () async {
    final provider = CreatorsProvider(_FakeRepo(failure), allowDemoData: false);
    await provider.load();

    expect(provider.creators, isEmpty);
    expect(provider.isDemo, isFalse);
  });

  test('debug build falls back to sample creators', () async {
    final provider = CreatorsProvider(_FakeRepo(failure), allowDemoData: true);
    await provider.load();

    expect(provider.creators, demoCreators);
    expect(provider.isDemo, isTrue);
  });

  test('backend creators always win over sample data', () async {
    final real = CreatorModel.fromJson({
      'id': '7',
      'handle': 'nour',
      'name': 'Nour H.',
      'bio': 'Bio',
      'is_follow': 1,
    });
    final provider = CreatorsProvider(
      _FakeRepo(Right([real])),
      allowDemoData: true,
    );
    await provider.load();

    expect(provider.creators.single.handle, 'nour');
    expect(provider.creators.single.id, 7);
    expect(provider.creators.single.isFollowed, isTrue);
    expect(provider.creators.single.initials, 'NH');
    expect(provider.isDemo, isFalse);
  });
}
