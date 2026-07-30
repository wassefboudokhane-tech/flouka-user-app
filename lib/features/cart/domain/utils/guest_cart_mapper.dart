import 'package:flouka/features/cart/data/data_source/guest_cart_local_data_source.dart';
import 'package:flouka/features/cart/domain/entity/cart_entity.dart';
import 'package:flouka/features/products/domain/entity/product_entity.dart';

CartEntity cartEntityFromGuest(GuestCartItem item) {
  final product = ProductEntity(
    id: item.productId,
    title: item.title,
    description: '',
    recommended: const [],
    image: item.image,
    canRate: false,
    stock: null,
    price: item.price,
    offerPrice: null,
    images: const [],
    rate: null,
    reviews: const [],
    isFavorite: false,
    store: StoreEntity(
      id: item.storeId,
      name: item.vendorName,
      logo: '',
      vendor: null,
      vendorId: 0,
      lat: 0,
      lng: 0,
      rate: 0,
      address: '',
      productsCount: 0,
      customersCount: 0,
      distance: 0,
    ),
    related: const [],
    reviewImages: const [],
    discountTitle: '',
    discountPercentage: 0,
    attributes: const [],
    variants: const [],
  );

  CartVariantEntity? variant;
  if (item.variantLabel != null && item.variantLabel!.isNotEmpty) {
    variant = CartVariantEntity(
      name: '${item.title} (${item.variantLabel})',
      attributeValues: [
        CartVariantAttributeEntity(
          attributeName: 'Options',
          valueName: item.variantLabel,
        ),
      ],
    );
  }

  return CartEntity(
    id: -item.stockId,
    quantity: item.qty,
    storeId: item.storeId,
    unitPrice: item.price,
    storeProductStockId: item.stockId,
    product: product,
    variant: variant,
  );
}

List<CartEntity> cartEntitiesFromGuest(List<GuestCartItem> items) {
  return items.map(cartEntityFromGuest).toList();
}
