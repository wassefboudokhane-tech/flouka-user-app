import 'package:flouka/core/helper_function/navigation.dart';
import 'package:flouka/features/creators/domain/entity/creator_entity.dart';
import 'package:flouka/features/creators/domain/repo/creator_repo.dart';
import 'package:flouka/features/creators/presentation/views/creator_storefront_page.dart';
import 'package:flutter/foundation.dart';

class CreatorsProvider extends ChangeNotifier {
  final CreatorRepo repo;

  CreatorsProvider(this.repo);

  /// Approved creators from get_creators; empty hides the home row.
  List<CreatorEntity> creators = [];

  CreatorEntity? current;
  bool loadingCurrent = false;

  Future<void> load() async {
    final result = await repo.getCreators();
    creators = result.fold((l) => <CreatorEntity>[], (r) => r);
    notifyListeners();
  }

  /// Opens a creator's shop. The credit starts when a product is opened from
  /// it, like a `?creator=` link on the web.
  Future<void> openStorefront(CreatorEntity creator) async {
    current = creator;
    loadingCurrent = true;
    notifyListeners();
    navP(const CreatorStorefrontPage());

    final result = await repo.getCreator(creator.id);
    result.fold((l) {}, (r) {
      if (r != null && current?.id == r.id) current = r;
    });
    loadingCurrent = false;
    notifyListeners();
  }
}
