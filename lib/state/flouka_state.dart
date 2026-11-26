import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flouka/core/analytics.dart';
import 'package:flouka/core/env.dart';
import 'package:flouka/core/l10n.dart';
import 'package:flouka/data/catalog.dart';
import 'package:flouka/data/models.dart';

enum ConsentChoice { unknown, accepted, refused }

class FloukaState extends ChangeNotifier {
  FloukaState({
    SharedPreferences? prefs,
    FkAnalytics? analytics,
    FkEnv? env,
  })  : _prefs = prefs,
        analytics = analytics ?? FkAnalytics(),
        env = env ?? FkEnv.instance;

  SharedPreferences? _prefs;
  final FkAnalytics analytics;
  final FkEnv env;

  AppLang lang = AppLang.fr;
  ConsentChoice consent = ConsentChoice.unknown;
  Session? session;
  final Set<String> favorites = {};
  final Set<String> following = {};
  final List<String> hiddenSections = [];
  double brandCommission = 10;
  bool useVioletCta = false;
  String pendingOtp = '';
  AccountRole pendingRole = AccountRole.creator;

  L10n get l => L10n(lang);
  bool get rtl => lang == AppLang.ar;
  bool get analyticsAllowed => consent == ConsentChoice.accepted;
  bool get signedIn => session != null;

  Future<void> hydrate() async {
    _prefs ??= await SharedPreferences.getInstance();
    final code = _prefs!.getString('lang') ?? 'fr';
    lang = code == 'ar' ? AppLang.ar : AppLang.fr;
    final c = _prefs!.getString('consent');
    consent = switch (c) {
      'yes' => ConsentChoice.accepted,
      'no' => ConsentChoice.refused,
      _ => ConsentChoice.unknown,
    };
    favorites
      ..clear()
      ..addAll(_prefs!.getStringList('favorites') ?? const []);
    following
      ..clear()
      ..addAll(_prefs!.getStringList('following') ?? const []);
    useVioletCta = env.ctaVariant == 'violet';
    final sid = _prefs!.getString('session_id');
    if (sid != null) {
      session = Session(
        id: sid,
        role: AccountRole.values.firstWhere(
          (r) => r.name == (_prefs!.getString('session_role') ?? 'shopper'),
          orElse: () => AccountRole.shopper,
        ),
        displayName: _prefs!.getString('session_name') ?? '',
        handle: _prefs!.getString('session_handle') ?? '',
        phone: _prefs!.getString('session_phone') ?? '',
        email: _prefs!.getString('session_email') ?? '',
        provider: _prefs!.getString('session_provider') ?? 'demo',
      );
    }
    notifyListeners();
  }

  Future<void> setLang(AppLang value) async {
    lang = value;
    await _prefs?.setString('lang', value == AppLang.ar ? 'ar' : 'fr');
    notifyListeners();
  }

  Future<void> setConsent(ConsentChoice value) async {
    consent = value;
    await _prefs?.setString('consent', value == ConsentChoice.accepted ? 'yes' : 'no');
    notifyListeners();
    if (value == ConsentChoice.accepted) {
      await analytics.start();
      await analytics.event('consent_accepted');
    }
  }

  Future<void> toggleFavorite(String productSlug) async {
    if (favorites.contains(productSlug)) {
      favorites.remove(productSlug);
    } else {
      favorites.add(productSlug);
    }
    await _prefs?.setStringList('favorites', favorites.toList());
    notifyListeners();
  }

  Future<void> toggleFollow(String handle) async {
    if (following.contains(handle)) {
      following.remove(handle);
    } else {
      following.add(handle);
    }
    await _prefs?.setStringList('following', following.toList());
    notifyListeners();
  }

  Future<void> signIn({
    required AccountRole role,
    String name = 'Nour Démo',
    String handle = 'nour.demo',
    String phone = '',
    String email = '',
    String provider = 'demo',
  }) async {
    session = Session(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      role: role,
      displayName: name,
      handle: handle,
      phone: phone,
      email: email,
      provider: provider,
    );
    await _saveSession();
    await analytics.event('inscription_etape', {'step': 'done', 'role': role.name, 'provider': provider});
    notifyListeners();
  }

  Future<void> signOut() async {
    session = null;
    await _prefs?.remove('session_id');
    notifyListeners();
  }

  /// Apple guideline 5.1.1(v) — in-app account deletion.
  Future<void> deleteAccount() async {
    session = null;
    favorites.clear();
    following.clear();
    await _prefs?.remove('session_id');
    await _prefs?.remove('session_role');
    await _prefs?.remove('session_name');
    await _prefs?.remove('session_handle');
    await _prefs?.remove('session_phone');
    await _prefs?.remove('session_email');
    await _prefs?.remove('session_provider');
    await _prefs?.setStringList('favorites', const []);
    await _prefs?.setStringList('following', const []);
    await analytics.event('account_deleted');
    notifyListeners();
  }

  Future<void> _saveSession() async {
    final s = session;
    if (s == null) return;
    await _prefs?.setString('session_id', s.id);
    await _prefs?.setString('session_role', s.role.name);
    await _prefs?.setString('session_name', s.displayName);
    await _prefs?.setString('session_handle', s.handle);
    await _prefs?.setString('session_phone', s.phone);
    await _prefs?.setString('session_email', s.email);
    await _prefs?.setString('session_provider', s.provider);
  }

  List<Product> get favoriteProducts =>
      favorites.map(DemoCatalog.product).whereType<Product>().toList();

  List<Collection> get giftCollections =>
      DemoCatalog.collections.where((c) => c.slug == 'a-offrir' || c.titleFr.toLowerCase().contains('offrir')).toList();
}
