class Creator {
  const Creator({
    required this.handle,
    required this.nameFr,
    required this.nameAr,
    required this.taglineFr,
    required this.taglineAr,
    required this.photo,
    required this.productCount,
    this.instagram = '',
    this.tiktok = '',
    this.followers = '',
    this.noteFr = '',
    this.noteAr = '',
  });

  final String handle;
  final String nameFr;
  final String nameAr;
  final String taglineFr;
  final String taglineAr;
  final String photo;
  final int productCount;
  final String instagram;
  final String tiktok;
  final String followers;
  final String noteFr;
  final String noteAr;

  String name(bool ar) => ar ? nameAr : nameFr;
  String tagline(bool ar) => ar ? taglineAr : taglineFr;
  String note(bool ar) => ar ? noteAr : noteFr;
}

class Brand {
  const Brand({
    required this.slug,
    required this.nameFr,
    required this.nameAr,
    required this.categoryFr,
    required this.categoryAr,
    required this.city,
    required this.site,
    required this.partner,
    this.letter = 'M',
  });

  final String slug;
  final String nameFr;
  final String nameAr;
  final String categoryFr;
  final String categoryAr;
  final String city;
  final Uri site;
  final bool partner;
  final String letter;

  String name(bool ar) => ar ? nameAr : nameFr;
  String category(bool ar) => ar ? categoryAr : categoryFr;
}

class Product {
  const Product({
    required this.slug,
    required this.titleFr,
    required this.titleAr,
    required this.image,
    required this.brandSlug,
    required this.priceDt,
    required this.sourceUrl,
    this.noteFr = '',
    this.noteAr = '',
    this.descFr = '',
    this.descAr = '',
    this.recoCount = 0,
    this.available = true,
    this.gift = false,
  });

  final String slug;
  final String titleFr;
  final String titleAr;
  final String image;
  final String brandSlug;
  final String priceDt;
  final Uri sourceUrl;
  final String noteFr;
  final String noteAr;
  final String descFr;
  final String descAr;
  final int recoCount;
  final bool available;
  final bool gift;

  String title(bool ar) => ar ? titleAr : titleFr;
  String note(bool ar) => ar ? noteAr : noteFr;
  String desc(bool ar) => ar ? descAr : descFr;
}

class Collection {
  const Collection({
    required this.slug,
    required this.creatorHandle,
    required this.titleFr,
    required this.titleAr,
    required this.blurbFr,
    required this.blurbAr,
    required this.productSlugs,
    required this.tileImages,
    this.draft = false,
  });

  final String slug;
  final String creatorHandle;
  final String titleFr;
  final String titleAr;
  final String blurbFr;
  final String blurbAr;
  final List<String> productSlugs;
  final List<String> tileImages;
  final bool draft;

  String title(bool ar) => ar ? titleAr : titleFr;
  String blurb(bool ar) => ar ? blurbAr : blurbFr;
}

enum AccountRole { shopper, creator, brand }

class Session {
  const Session({
    required this.id,
    required this.role,
    this.displayName = '',
    this.handle = '',
    this.phone = '',
    this.email = '',
    this.provider = 'demo',
  });

  final String id;
  final AccountRole role;
  final String displayName;
  final String handle;
  final String phone;
  final String email;
  final String provider;
}
