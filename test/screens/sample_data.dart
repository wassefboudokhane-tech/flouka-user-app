import 'package:flouka/features/auth/presentation/views/login_view.dart';
import 'package:flouka/features/favorite/presentation/views/favorite_view.dart';
import 'package:flouka/features/navbar/presentation/views/explore_view.dart';
import 'package:flouka/features/orders/presentation/views/orders_view.dart';
import 'package:flouka/features/products/presentation/pages/shop_products_page.dart';
import 'package:flouka/features/products/presentation/providers/categories_product_search_provider.dart';
import 'package:flouka/features/settings/presentation/views/settings_view.dart';
import 'package:flouka/features/cart/domain/entity/cart_entity.dart';
import 'package:flouka/features/cart/presentation/providers/cart_provider.dart';
import 'package:flouka/features/cart/presentation/views/cart_view.dart';
import 'package:flouka/features/creators/domain/entity/creator_entity.dart';
import 'package:flouka/features/products/presentation/pages/products_details_view.dart';
import 'package:flouka/features/products/presentation/providers/products_details_provider.dart';
import 'package:flouka/features/creators/presentation/providers/creators_provider.dart';
import 'package:flouka/features/creators/presentation/views/creator_storefront_page.dart';
import 'package:flouka/features/home/presentation/pages/home_page.dart';
import 'package:flouka/features/products/domain/entity/product_entity.dart';
import 'package:flouka/features/products/presentation/providers/home_products_provider.dart';
import 'package:flouka/features/settings/domain/entities/settings_entity.dart';
import 'package:flouka/features/settings/presentation/provider/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SampleScreen {
  final String name;
  final Widget Function() build;
  final void Function(BuildContext context)? seed;
  const SampleScreen(this.name, this.build, [this.seed]);
}

StoreEntity _store(int id, String name) => StoreEntity(
      id: id,
      name: name,
      logo: '',
      vendor: null,
      vendorId: id,
      lat: 0,
      lng: 0,
      rate: 4.7,
      address: 'Tunis',
      productsCount: 12,
      customersCount: 40,
      distance: 2,
    );

ProductEntity sampleProduct(int id, String title, double price, String store, {double? offer}) => ProductEntity(
      id: id,
      title: title,
      haveVariant: false,
      recommended: const [],
      description: 'Fabriqué en Tunisie.',
      price: price,
      canRate: false,
      store: _store(id, store),
      reviews: const [],
      related: const [],
      reviewImages: const [],
      offerPrice: offer,
      image: null,
      discountPercentage: offer == null ? null : ((1 - offer / price) * 100).round(),
      images: const [],
      rate: 4.7,
      isFavorite: false,
      stock: null,
      attributes: const [],
      variants: const [],
    );

final List<ProductEntity> sampleProducts = [
  sampleProduct(1, 'Sérum figue de barbarie 30 ml', 40, 'Atelier Zitouna'),
  sampleProduct(2, 'Fouta nid d’abeille XL', 45, 'Dar Fouta'),
  sampleProduct(3, 'Savon noir à l’huile d’olive', 12, 'Savonnerie du Cap'),
  sampleProduct(4, 'Tasse artisanale, lot de 2', 58, 'Poterie Sejnane', offer: 46),
];

final sampleCreator = CreatorEntity(
  id: 7,
  handle: 'yasmine',
  name: 'Yasmine B.',
  avatar: null,
  bio: 'Je teste tout sur ma peau avant d’en parler. Ici, uniquement ce que je rachète.',
  niche: 'Soin et beauté',
  products: sampleProducts,
  instagram: 'yasmine.tn',
  tiktok: 'yasmine',
  validatedProductIds: const {1, 2},
  posts: const [
    CreatorPostEntity(id: 5, videoUrl: 'https://www.instagram.com/reel/abc/', platform: 'instagram', brandName: 'Dar Fouta', productTitle: 'Fouta'),
    CreatorPostEntity(id: 6, videoUrl: 'https://www.tiktok.com/@yasmine/video/1', platform: 'tiktok', brandName: 'Atelier Zitouna', productTitle: 'Sérum'),
  ],
);

final sampleScreens = <SampleScreen>[
  SampleScreen('home', () => const HomePage(), (c) {
    Provider.of<HomeProductsProvider>(c, listen: false).productsList = sampleProducts;
    Provider.of<CreatorsProvider>(c, listen: false).creators = [sampleCreator];
  }),
  SampleScreen('creator', () => const CreatorStorefrontPage(), (c) {
    Provider.of<CreatorsProvider>(c, listen: false).current = sampleCreator;
  }),
  SampleScreen('product', () => const ProductsDetailsView(showAppBar: true), (c) {
    final details = Provider.of<ProductDetailsProvider>(c, listen: false);
    details.data = sampleProducts.first;
    details.recommendedBy = sampleCreator;
  }),
  SampleScreen('cart', () => const CartView(), (c) {
    Provider.of<SettingsProvider>(c, listen: false).settingsEntity = SettingsEntity(
      id: 1, tax: 0, deliveryPrice: 7, minFreeDelivery: 90, termsLink: '', aboutLink: '', email: null,
      phone: null, whatsapp: null, version: 1, privacyLink: '', mustUpdate: false, packageName: null, appId: null,
      creatorsEnabled: true,
    );
    Provider.of<CartProvider>(c, listen: false).data = [
      CartEntity(id: 1, quantity: 1, product: sampleProducts[0], unitPrice: 40, storeId: 1, stock: 5),
      CartEntity(id: 2, quantity: 2, product: sampleProducts[2], unitPrice: 12, storeId: 3, stock: 5),
    ];
  }),
  SampleScreen('explore', () => const ExploreView()),
  SampleScreen('shop', () => const ShopProductsPage(), (c) {
    Provider.of<CategoriesProductSearchProvider>(c, listen: false).data = sampleProducts;
  }),
  SampleScreen('orders', () => const OrdersView()),
  SampleScreen('favorites', () => const FavoriteView()),
  SampleScreen('settings', () => const SettingsView()),
  SampleScreen('login', () => const LoginView()),
];
