import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flouka/features/creators/data/models/creator_model.dart';
import 'package:flouka/features/creators/domain/entity/creator_entity.dart';
import 'package:flouka/features/creators/domain/repo/creator_repo.dart';
import 'package:flouka/features/creators/presentation/providers/creators_provider.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeRepo implements CreatorRepo {
  _FakeRepo(this.result, {this.follow = const Right(true)});

  final Either<DioException, List<CreatorEntity>> result;
  final Either<DioException, bool> follow;
  int followCalls = 0;

  @override
  Future<Either<DioException, bool>> toggleFollow(int id) async {
    followCalls++;
    return follow;
  }

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

  group('follow', () {
    const yasmine = CreatorEntity(
      id: 7, handle: 'yasmine', name: 'Yasmine', avatar: null, bio: '', niche: null, followersCount: 10,
    );

    test('a guest is sent to sign in and nothing is sent', () async {
      final repo = _FakeRepo(const Right([]));
      var asked = false;
      await CreatorsProvider(repo).toggleFollow(yasmine, signedIn: false, signIn: () => asked = true);
      expect(asked, isTrue);
      expect(repo.followCalls, 0);
    });

    test('following shows at once and counts one more', () async {
      final provider = CreatorsProvider(_FakeRepo(const Right([])));
      await provider.toggleFollow(yasmine, signedIn: true, signIn: () {});
      expect(provider.isFollowing(yasmine), isTrue);
      expect(provider.followersOf(yasmine), 11);
    });

    test('a refused follow is undone', () async {
      final provider = CreatorsProvider(_FakeRepo(
        const Right([]),
        follow: Left(DioException(requestOptions: RequestOptions(path: 'user/update_follow'))),
      ));
      await provider.toggleFollow(yasmine, signedIn: true, signIn: () {});
      expect(provider.isFollowing(yasmine), isFalse);
      expect(provider.followersOf(yasmine), 10);
    });
  });
}
