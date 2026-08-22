import 'package:cached_network_image/cached_network_image.dart';
import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_radius.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/features/auth/presentation/providers/auth_provider.dart';
import 'package:flouka/features/cart/presentation/providers/cart_operation_provider.dart';
import 'package:flouka/features/cart/presentation/providers/cart_provider.dart';
import 'package:flouka/features/favorite/presentation/providers/favorite_provider.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flouka/features/navbar/presentation/provider/nav_bar_provider.dart';
import 'package:flouka/features/products/domain/entity/product_entity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartEmptyRecoveryWidget extends StatefulWidget {
  const CartEmptyRecoveryWidget({super.key});

  @override
  State<CartEmptyRecoveryWidget> createState() =>
      _CartEmptyRecoveryWidgetState();
}

class _CartEmptyRecoveryWidgetState extends State<CartEmptyRecoveryWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (AuthProvider.isLogin()) {
        final favorites = context.read<FavoriteProvider>();
        if (favorites.data == null) {
          favorites.getData();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoriteProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 28),
          decoration: BoxDecoration(
            color: AppColor.backgroundColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColor.borderColor),
          ),
          child: Column(
            children: [
              SizedBox(
                width: 88,
                height: 88,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColor.softColor,
                        borderRadius: BorderRadius.circular(26),
                        border: Border.all(color: AppColor.borderColor),
                      ),
                    ),
                    _CartIcon(),
                    Positioned(
                      right: 12,
                      bottom: 12,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: AppColor.limeColor,
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: Center(
                          child: Text(
                            '+',
                            style: TextStyleClass.captionStyle(
                              color: AppColor.deepColor,
                            ).copyWith(
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                LanguageProvider.translate('recovery', 'cart_empty_title'),
                textAlign: TextAlign.center,
                style: TextStyleClass.headStyle(color: AppColor.deepColor)
                    .copyWith(fontSize: 22, height: 1.15),
              ),
              const SizedBox(height: 9),
              Text(
                LanguageProvider.translate('recovery', 'cart_empty_body'),
                textAlign: TextAlign.center,
                style: TextStyleClass.normalStyle(color: AppColor.mutedColor)
                    .copyWith(fontSize: 14, height: 1.5),
              ),
              const SizedBox(height: 20),
              Material(
                color: AppColor.limeColor,
                borderRadius: BorderRadius.circular(AppRadius.pill),
                child: InkWell(
                  onTap: () {
                    context.read<NavBarProvider>().changeIndex(0);
                  },
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Center(
                      child: Text(
                        LanguageProvider.translate(
                          'recovery',
                          'cart_empty_explore',
                        ),
                        style: TextStyleClass.buttonStyle(
                          color: AppColor.deepColor,
                        ).copyWith(fontWeight: FontWeight.w800, fontSize: 14.5),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (favorites.data != null && favorites.data!.isNotEmpty) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 4,
                height: 18,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  gradient: LinearGradient(
                    colors: [AppColor.limeColor, AppColor.primaryColor],
                  ),
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  LanguageProvider.translate('settings', 'favourite'),
                  style: TextStyleClass.railTitleStyle().copyWith(fontSize: 16),
                ),
              ),
              InkWell(
                onTap: () =>
                    context.read<FavoriteProvider>().goToPage(),
                child: Text(
                  LanguageProvider.translate('global', 'see_all'),
                  style: TextStyleClass.captionStyle(
                    color: AppColor.primaryColor,
                  ).copyWith(fontWeight: FontWeight.w700, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...favorites.data!.take(3).map((product) => _FavoriteRow(product)),
        ],
      ],
    );
  }
}

class _CartIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 34,
      height: 28,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 11,
            child: Container(
              width: 34,
              height: 17,
              decoration: BoxDecoration(
                border: Border.all(color: AppColor.deepColor, width: 2.5),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(9),
                  bottomRight: Radius.circular(9),
                  topLeft: Radius.circular(3),
                  topRight: Radius.circular(3),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 6,
            child: Container(
              width: 20,
              height: 12,
              decoration: BoxDecoration(
                border: Border.all(color: AppColor.deepColor, width: 2.5),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FavoriteRow extends StatelessWidget {
  const _FavoriteRow(this.product);

  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    final price = product.offerPrice ?? product.price;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: AppColor.backgroundColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColor.borderColor),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(13),
            child: Container(
              width: 58,
              height: 58,
              color: AppColor.softColor,
              child: product.image != null
                  ? CachedNetworkImage(
                      imageUrl: product.image!,
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.store?.name ?? '',
                  style: TextStyleClass.vendorStyle().copyWith(fontSize: 10.5),
                ),
                Text(
                  product.title ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyleClass.smallStyle(color: AppColor.inkColor)
                      .copyWith(fontSize: 12.5, height: 1.25),
                ),
                Text(
                  '$price',
                  style: TextStyleClass.priceStyle().copyWith(fontSize: 16),
                ),
              ],
            ),
          ),
          Material(
            color: AppColor.limeColor,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () {
                context.read<CartProvider>().addToCart(
                      productId: product.id,
                      storeId: product.store!.id,
                      storeProductStockId: product.stock!.id,
                      quantity: 1,
                      title: product.title,
                      vendorName: product.store?.name,
                      price: price,
                      image: product.image,
                    );
              },
              child: SizedBox(
                width: 36,
                height: 36,
                child: Icon(Icons.add, color: AppColor.deepColor, size: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
