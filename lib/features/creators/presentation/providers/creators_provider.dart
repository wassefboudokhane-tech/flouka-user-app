import 'package:flouka/core/creator_attribution.dart';
import 'package:flouka/core/helper_function/navigation.dart';
import 'package:flouka/features/creators/domain/entity/creator_entity.dart';
import 'package:flouka/features/creators/domain/repo/creator_repo.dart';
import 'package:flouka/features/creators/presentation/views/creator_storefront_page.dart';
import 'package:flutter/foundation.dart';

/// Sample creators shown only in debug builds while the backend endpoints
/// are not live, so the screens can be reviewed. Never used in release.
const List<CreatorEntity> demoCreators = [
  CreatorEntity(
    id: -1,
    handle: 'yasmine',
    name: 'Yasmine B.',
    avatar: null,
    bio: 'Je teste tout sur ma peau avant d\'en parler.',
    niche: 'Soin et beauté',
    isFollowed: false,
  ),
  CreatorEntity(
    id: -2,
    handle: 'mehdi',
    name: 'Mehdi K.',
    avatar: null,
    bio: 'Maison, déco et artisanat tunisien.',
    niche: 'Maison',
    isFollowed: false,
  ),
  CreatorEntity(
    id: -3,
    handle: 'salma',
    name: 'Salma L.',
    avatar: null,
    bio: 'Mode locale à petit prix.',
    niche: 'Mode',
    isFollowed: false,
  ),
];

class CreatorsProvider extends ChangeNotifier {
  final CreatorRepo repo;
  final bool allowDemoData;

  CreatorsProvider(this.repo, {bool? allowDemoData})
      : allowDemoData = allowDemoData ?? kDebugMode;

  List<CreatorEntity> creators = [];

  /// True when [creators] holds sample data instead of backend data.
  bool isDemo = false;

  CreatorEntity? current;
  bool loadingCurrent = false;

  Future<void> load() async {
    final result = await repo.getCreators();
    final loaded = result.fold((l) => <CreatorEntity>[], (r) => r);
    if (loaded.isEmpty && allowDemoData) {
      creators = demoCreators;
      isDemo = true;
    } else {
      creators = loaded;
      isDemo = false;
    }
    notifyListeners();
  }

  /// Opens a creator storefront and credits them for the visit.
  Future<void> openStorefront(CreatorEntity creator) async {
    CreatorAttributionStore.capture(creator.handle);
    current = creator;
    loadingCurrent = creator.id > 0;
    notifyListeners();
    navP(const CreatorStorefrontPage());
    if (creator.id <= 0) return;

    final result = await repo.getCreator(creator.id);
    result.fold((l) {}, (r) {
      if (r != null && current?.id == r.id) current = r;
    });
    loadingCurrent = false;
    notifyListeners();
  }
}
