import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flouka/screens/brand_screens.dart';
import 'package:flouka/screens/creator_screens.dart';
import 'package:flouka/screens/public_screens.dart';
import 'package:flouka/screens/system_screens.dart';
import 'package:flouka/state/flouka_state.dart';

GoRouter createRouter(FloukaState state, {String initialLocation = '/'}) {
  return GoRouter(
    initialLocation: initialLocation,
    refreshListenable: state,
    redirect: (context, routerState) {
      final loc = routerState.matchedLocation;
      if (state.consent == ConsentChoice.unknown && loc != '/consent') {
        return '/consent';
      }
      return null;
    },
    routes: [
      GoRoute(path: '/consent', builder: (_, __) => const ConsentScreen()),
      GoRoute(path: '/', builder: (_, __) => const HomeScreen()),
      GoRoute(path: '/favorites', builder: (_, __) => const FavoritesScreen()),
      GoRoute(path: '/gifts', builder: (_, __) => const GiftsScreen()),
      GoRoute(
        path: '/search',
        builder: (_, s) => SearchScreen(initial: s.uri.queryParameters['q'] ?? ''),
      ),
      GoRoute(
        path: '/shop/:handle',
        builder: (_, s) => CreatorScreen(handle: s.pathParameters['handle']!),
        routes: [
          GoRoute(
            path: ':slug',
            builder: (_, s) => CollectionScreen(
              handle: s.pathParameters['handle']!,
              slug: s.pathParameters['slug']!,
            ),
          ),
        ],
      ),
      GoRoute(path: '/p/:slug', builder: (_, s) => ProductScreen(slug: s.pathParameters['slug']!)),
      GoRoute(path: '/marque/:slug', builder: (_, s) => BrandScreen(slug: s.pathParameters['slug']!)),
      GoRoute(
        path: '/auth',
        builder: (_, s) => AuthScreen(brand: s.uri.queryParameters['role'] == 'brand'),
      ),
      GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingScreen()),
      GoRoute(path: '/studio', builder: (_, __) => const StudioScreen()),
      GoRoute(path: '/studio/add', builder: (_, __) => const AddProductScreen()),
      GoRoute(path: '/studio/stats', builder: (_, __) => const StatsScreen()),
      GoRoute(path: '/studio/profile', builder: (_, __) => const ProfileScreen()),
      GoRoute(path: '/brand/onboarding', builder: (_, __) => const BrandOnboardingScreen()),
      GoRoute(path: '/marque-studio', builder: (_, __) => const BrandDashboardScreen()),
      GoRoute(path: '/marque-studio/produits', builder: (_, __) => const BrandDashboardScreen()),
      GoRoute(path: '/marque-studio/createurs', builder: (_, __) => const BrandDashboardScreen()),
      GoRoute(path: '/menu', builder: (_, __) => const MenuScreen()),
      GoRoute(path: '/account/delete', builder: (_, __) => const DeleteAccountScreen()),
      GoRoute(path: '/legal/:kind', builder: (_, s) => LegalScreen(kind: s.pathParameters['kind']!)),
      GoRoute(
        path: '/404',
        builder: (_, __) => const Scaffold(body: Center(child: Text('404'))),
      ),
    ],
  );
}
