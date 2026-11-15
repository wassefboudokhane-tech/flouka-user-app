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
  test('no creators row when get_creators fails', () async {
    final provider = CreatorsProvider(
      _FakeRepo(
        Left(
          DioException(requestOptions: RequestOptions(path: 'get_creators')),
        ),
      ),
    );
    await provider.load();

    expect(provider.creators, isEmpty);
  });

  test('reads creators as get_creators returns them', () async {
    final real = CreatorModel.fromJson({
      'id': '7',
      'handle': 'nour',
      'name': 'Nour H.',
      'niche': 'Beauté',
      'bio': 'Bio',
      'avatar': null,
    });
    final provider = CreatorsProvider(_FakeRepo(Right([real])));
    await provider.load();

    final creator = provider.creators.single;
    expect(creator.handle, 'nour');
    expect(creator.id, 7);
    expect(creator.niche, 'Beauté');
    expect(creator.initials, 'NH');
    expect(creator.products, isEmpty);
  });
}
