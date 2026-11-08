import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/constants/constants.dart';
import 'package:flouka/core/helper_function/api_timeouts.dart';
import 'package:flouka/core/helper_function/text_form_field_validation.dart';
import 'package:flouka/core/widgets/flouka_network_image.dart';
import 'package:flouka/features/cart/domain/checkout_entry.dart';
import 'package:flouka/features/cart/presentation/widgets/custom_cart_button_widget.dart';
import 'package:flouka/features/favorite/presentation/providers/favorite_provider.dart';
import 'package:flouka/features/language/domain/entities/app_localizations.dart';
import 'package:flouka/features/language/domain/language_copy.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flouka/features/products/domain/entity/product_entity.dart';
import 'package:flouka/features/products/domain/entity/product_review_entity.dart';
import 'package:flouka/features/products/domain/repo/product_repo.dart';
import 'package:flouka/features/products/domain/user_case/product_use_case.dart';
import 'package:flouka/features/products/presentation/providers/categories_product_search_provider.dart';
import 'package:flouka/features/products/presentation/widgets/hot_deals_home_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  test('home load does not arm web connect or send timeouts', () {
    final timeouts = ApiTimeouts.forPlatform(isWeb: true);
    expect(timeouts.connectTimeout, isNull);
    expect(timeouts.sendTimeout, isNull);
    expect(timeouts.receiveTimeout, greaterThan(Duration.zero));
  });

  test('mobile requests keep connect and send timeouts', () {
    final timeouts = ApiTimeouts.forPlatform(isWeb: false);
    expect(timeouts.connectTimeout, ApiTimeouts.connect);
    expect(timeouts.sendTimeout, ApiTimeouts.receive);
  });

  test('product photos on web skip the CORS byte fetch', () {
    final provider = floukaImageProvider(
      'https://floka.zeroonez.com/images/products/rose.jpg',
      web: true,
    );
    expect(provider, isA<NetworkImage>());
  });

  test('browse and search keep the shopper query', () {
    final data = <String, dynamic>{'page': 1};
    applySearchTerm(data, ' rose ');
    expect(data['search'], 'rose');
    applySearchTerm(data, '   ');
    expect(data['search'], 'rose');
  });

  test('guest checkout does not stop on the login dialog', () {
    expect(
      checkoutEntryBlockedForGuest(isLoggedIn: false),
      isFalse,
    );
  });

  test('login accepts 12345678 as 8 digits without a leading zero', () {
    expect(isTunisiaLoginNumber('12345678'), isTrue);
    expect(isTunisiaLoginNumber('01234567'), isFalse);
    expect(validatePhone('12345678'), isNull);
  });

  test('language picker offers Arabic, English, and French', () {
    final codes = LanguageProvider.languages.map((locale) => locale.languageCode);
    expect(codes, containsAll(['ar', 'en', 'fr']));
  });

  test('product rail is tall enough for the card that overflowed by 2px', () {
    expect(
      HotDealsHomeContainerWidget.estimatedHeight(AppSpacing.productCardWidth),
      greaterThanOrEqualTo(AppSpacing.productCardImageHeight + 176),
    );
  });

  testWidgets('product card fits the home rail without overflowing', (tester) async {
    final errors = <FlutterErrorDetails>[];
    final previous = FlutterError.onError;
    FlutterError.onError = errors.add;
    addTearDown(() => FlutterError.onError = previous);

    await tester.pumpWidget(_cardHarness());
    await tester.pump();

    final overflow = errors.where(
      (details) => details.exceptionAsString().contains('overflowed'),
    );
    expect(overflow, isEmpty);
  });

  test('category, banner, store, and story photos use the web image path', () {
    const sources = [
      'lib/features/categories/presentation/widgets/category_image_container_widget.dart',
      'lib/features/categories/presentation/widgets/popular_category_container_widget.dart',
      'lib/features/categories/presentation/widgets/subcategory_tiles.dart',
      'lib/features/banners/presentation/widgets/carousel_slider_widget.dart',
      'lib/features/stores/presentation/widgets/stores_container_home_widget.dart',
      'lib/features/stores/presentation/widgets/stores_home_section.dart',
      'lib/features/stores/presentation/widgets/store_details_hero_widget.dart',
      'lib/features/home/presentation/widgets/home_stories_row_widget.dart',
      'lib/features/stories/presentation/widgets/story_item_widget.dart',
    ];
    for (final path in sources) {
      final source = File(path).readAsStringSync();
      expect(source, isNot(contains('CachedNetworkImage')), reason: path);
      expect(
        source.contains('FloukaNetworkImage') ||
            source.contains('floukaImageProvider'),
        isTrue,
        reason: path,
      );
    }
    expect(
      floukaImageProvider(
        'https://floka.zeroonez.com/images/categories/roses.jpg',
        web: true,
      ),
      isA<NetworkImage>(),
    );
  });

  test('french search hint falls back to the bundled string', () async {
    final raw = await File('assets/languages/fr.json').readAsString();
    final bundled = json.decode(raw) as Map<String, dynamic>;
    final hint = languageCopy(
      remoteLanguages: const {},
      languageCode: 'fr',
      bundled: bundled,
      parent: 'global',
      key: 'search',
    );
    expect(hint, 'Rechercher...');
    expect(hint, isNot('search'));
  });

  testWidgets('cart total stays left of the chat bubble', (tester) async {
    const bubbleKey = Key('chat-bubble');
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 400,
            height: 80,
            child: Stack(
              children: [
                CartSummaryTotal(label: 'Total', amount: '156.16 TND'),
                Positioned(
                  right: 8,
                  bottom: 4,
                  child: SizedBox(
                    key: bubbleKey,
                    width: 60,
                    height: 60,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    final total = tester.getRect(find.byKey(const Key('cart-total-amount')));
    final bubble = tester.getRect(find.byKey(bubbleKey));
    expect(total.right, lessThanOrEqualTo(bubble.left));
  });
}

Widget _cardHarness() {
  final height = HotDealsHomeContainerWidget.estimatedHeight(
    AppSpacing.productCardWidth,
  );
  return MediaQuery(
    data: const MediaQueryData(size: Size(1200, 900)),
    child: Sizer(
      builder: (context, orientation, deviceType) {
        return ChangeNotifierProvider(
          create: (_) => FavoriteProvider(ProductUseCase(_UnusedRepo())),
          child: MaterialApp(
            navigatorKey: Constants.navState,
            locale: const Locale('en'),
            supportedLocales: LanguageProvider.languages,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: Scaffold(
              body: Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  width: AppSpacing.productCardWidth,
                  height: height,
                  child: HotDealsHomeContainerWidget(
                    product: _sampleProduct(),
                    width: AppSpacing.productCardWidth,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}

ProductEntity _sampleProduct() {
  return ProductEntity(
    id: 22,
    title: 'Handcrafted Paper Rose That Lasts a Lifetime',
    haveVariant: false,
    recommended: const [],
    description: 'A paper rose',
    price: 40,
    canRate: false,
    store: const StoreEntity(
      id: 1,
      name: 'Bloom & Beyond',
      logo: '',
      vendor: null,
      vendorId: 1,
      lat: 0,
      lng: 0,
      rate: 0,
      address: '',
      productsCount: 1,
      customersCount: 1,
      distance: 0,
    ),
    reviews: const [],
    related: const [],
    reviewImages: const [],
    offerPrice: 32,
    image: null,
    discountPercentage: 20,
    images: const [],
    rate: 5,
    isFavorite: false,
    stock: null,
    attributes: const [],
    variants: const [],
  );
}

class _UnusedRepo implements ProductRepo {
  @override
  Future<Either<DioException, bool>> createReport(Map<String, dynamic> data) {
    throw UnimplementedError();
  }

  @override
  Future<Either<DioException, bool>> createReview(Map<String, dynamic> data) {
    throw UnimplementedError();
  }

  @override
  Future<Either<DioException, List<ProductEntity>>> getFavorites(
    Map<String, dynamic> data,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<Either<DioException, List<ProductEntity>>> getFeatureProducts(
    Map<String, dynamic> data,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<Either<DioException, List<ProductEntity>>> getFeatures() {
    throw UnimplementedError();
  }

  @override
  Future<Either<DioException, ProductEntity>> getProductDetails(
    Map<String, dynamic> data,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<Either<DioException, List<ProductReviewEntity>>> getProductReviews(
    Map<String, dynamic> data,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<Either<DioException, List<ProductEntity>>> getProducts(
    Map<String, dynamic> data,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<Either<DioException, List<ProductEntity>>> getRecommended(
    Map<String, dynamic> data,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<Either<DioException, List<ProductEntity>>> getSuggestedProducts(
    Map<String, dynamic> data,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<Either<DioException, bool>> updateFavorite(Map<String, dynamic> data) {
    throw UnimplementedError();
  }
}
