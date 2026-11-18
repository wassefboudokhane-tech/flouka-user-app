import 'package:flouka/core/helper_function/navigation.dart';
import 'package:flouka/features/creators/domain/entity/creator_entity.dart';
import 'package:flouka/features/creators/domain/repo/creator_repo.dart';
import 'package:flouka/features/creators/presentation/views/creator_storefront_page.dart';
import 'package:flutter/material.dart';

class CreatorsProvider extends ChangeNotifier {
  final CreatorRepo repo;

  CreatorsProvider(this.repo);

  /// Approved creators from get_creators; empty hides the home row.
  List<CreatorEntity> creators = [];

  CreatorEntity? current;
  bool loadingCurrent = false;

  /// Creators the shopper follows, kept here so the button flips at once.
  final Set<int> followed = {};
  final Map<int, int> followers = {};

  bool isFollowing(CreatorEntity c) => followed.contains(c.id);
  int followersOf(CreatorEntity c) => followers[c.id] ?? c.followersCount;

  /// Guests are sent to sign in first ([signIn]); otherwise the change
  /// shows immediately and is undone if the server refuses it.
  Future<void> toggleFollow(CreatorEntity c, {required bool signedIn, required VoidCallback signIn}) async {
    if (!signedIn) {
      signIn();
      return;
    }
    final was = followed.contains(c.id);
    _setFollow(c, !was);
    final result = await repo.toggleFollow(c.id);
    result.fold((l) => _setFollow(c, was), (now) {
      if (now != !was) _setFollow(c, now);
    });
  }

  void _setFollow(CreatorEntity c, bool on) {
    final count = followersOf(c);
    if (on && followed.add(c.id)) followers[c.id] = count + 1;
    if (!on && followed.remove(c.id)) followers[c.id] = count > 0 ? count - 1 : 0;
    notifyListeners();
  }

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
      if (r != null && current?.id == r.id) {
        current = r;
        r.isFollow ? followed.add(r.id) : followed.remove(r.id);
        followers[r.id] = r.followersCount;
      }
    });
    loadingCurrent = false;
    notifyListeners();
  }
}
