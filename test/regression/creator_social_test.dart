import 'package:flouka/core/creator_social.dart';
import 'package:flouka/features/creators/data/models/creator_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('social usernames become profile links, malformed ones do not', () {
    expect(creatorSocialUrl('instagram', 'yasmine.tn'), 'https://www.instagram.com/yasmine.tn/');
    expect(creatorSocialUrl('tiktok', 'yasmine'), 'https://www.tiktok.com/@yasmine');
    expect(creatorSocialUrl('tiktok', 'a/b'), isNull);
    expect(creatorSocialUrl('instagram', null), isNull);
  });

  test('only http links are opened', () {
    expect(safeExternalUri('javascript:alert(1)'), isNull);
    expect(safeExternalUri('https://www.instagram.com/reel/abc/')?.host, 'www.instagram.com');
  });

  test('the storefront reads socials, brand validation and posts', () {
    final c = CreatorModel.fromJson({
      'id': 7, 'handle': 'yasmine', 'name': 'Yasmine', 'bio': '', 'instagram': 'yasmine.tn', 'tiktok': '',
      'posts': [
        {'id': 5, 'video_url': 'https://www.instagram.com/reel/abc/', 'platform': 'instagram', 'brand': {'name': 'Dar Fouta'}, 'product': {'title': 'Fouta'}},
        {'id': 6, 'video_url': ''},
      ],
    });
    expect(c.instagram, 'yasmine.tn');
    expect(c.tiktok, isNull);
    expect(c.validatedProductIds, isEmpty);
    expect(brandValidatedIds([
      {'id': 12, 'brand_validated': true},
      {'id': 13, 'brand_validated': false},
      {'id': '14', 'brand_validated': true},
    ]), {12, 14});
    expect(c.posts.single.brandName, 'Dar Fouta');
  });
}
