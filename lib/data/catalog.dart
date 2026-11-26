import 'package:flouka/data/models.dart';

/// Fictional year-1 catalog (generated photos). Not ShopMy, not live brands.
class DemoCatalog {
  DemoCatalog._();

  static const img = 'assets/images/demo';

  static const creators = <Creator>[
    Creator(
      handle: 'nour.demo',
      nameFr: 'Nour Démo',
      nameAr: 'نور ديمو',
      taglineFr: 'Maison, bougies et rituels du soir · Tunis',
      taglineAr: 'المنزل والشموع وطقوس المساء · تونس',
      photo: '$img/hero.jpg',
      productCount: 32,
      instagram: '@nour.demo',
      followers: '12,4 k',
      noteFr: '« Je l’allume tous les soirs, l’odeur reste douce. »',
      noteAr: '« أشعلها كل مساء، والرائحة تبقى خفيفة. »',
    ),
    Creator(
      handle: 'sami.demo',
      nameFr: 'Sami Démo',
      nameAr: 'سامي ديمو',
      taglineFr: 'Cuisine et table · Sfax',
      taglineAr: 'المطبخ والمائدة · صفاقس',
      photo: '$img/sami.jpg',
      productCount: 18,
      instagram: '@sami.demo',
    ),
    Creator(
      handle: 'ines.demo',
      nameFr: 'Inès Démo',
      nameAr: 'إيناس ديمو',
      taglineFr: 'Linge et été · La Marsa',
      taglineAr: 'الكتان والصيف · المرسى',
      photo: '$img/ines.jpg',
      productCount: 41,
      instagram: '@ines.demo',
    ),
    Creator(
      handle: 'amira.demo',
      nameFr: 'Amira Démo',
      nameAr: 'أميرة ديمو',
      taglineFr: 'Cadeaux et petit format · Sousse',
      taglineAr: 'هدايا وأحجام صغيرة · سوسة',
      photo: '$img/amira.jpg',
      productCount: 27,
      instagram: '@amira.demo',
    ),
    Creator(
      handle: 'yassine.demo',
      nameFr: 'Yassine Démo',
      nameAr: 'ياسين ديمو',
      taglineFr: 'Bois et atelier · Nabeul',
      taglineAr: 'الخشب والورشة · نابل',
      photo: '$img/yassine.jpg',
      productCount: 15,
      instagram: '@yassine.demo',
    ),
  ];

  static final brands = <Brand>[
    Brand(
      slug: 'maison-demo',
      nameFr: 'Maison Démo',
      nameAr: 'ميزون ديمو',
      categoryFr: 'Bougies et parfums d’intérieur',
      categoryAr: 'شموع وعطور المنزل',
      city: 'Sousse',
      site: Uri.parse('https://maisondemo.tn'),
      partner: true,
      letter: 'M',
    ),
    Brand(
      slug: 'atelier-demo',
      nameFr: 'Atelier Démo',
      nameAr: 'أتيليه ديمو',
      categoryFr: 'Linge de maison',
      categoryAr: 'بياضات المنزل',
      city: 'Tunis',
      site: Uri.parse('https://atelierdemo.tn'),
      partner: true,
      letter: 'A',
    ),
    Brand(
      slug: 'bois-demo',
      nameFr: 'Bois Démo',
      nameAr: 'بوا ديمو',
      categoryFr: 'Cuisine et bois',
      categoryAr: 'مطبخ وخشب',
      city: 'Nabeul',
      site: Uri.parse('https://boisdemo.tn'),
      partner: false,
      letter: 'B',
    ),
  ];

  static final products = <Product>[
    Product(
      slug: 'bougie-jasmin',
      titleFr: 'Bougie parfumée jasmin 180 g',
      titleAr: 'شمعة ياسمين 180 غ',
      image: '$img/candle.jpg',
      brandSlug: 'maison-demo',
      priceDt: '45',
      sourceUrl: Uri.parse('https://maisondemo.tn/bougie-jasmin'),
      noteFr: '« Je l’allume tous les soirs, l’odeur reste douce. »',
      noteAr: '« أشعلها كل مساء، والرائحة تبقى خفيفة. »',
      descFr: 'Cire végétale, mèche en coton, environ 40 heures. Produit et marque fictifs.',
      descAr: 'شمع نباتي، فتيلة قطن، نحو 40 ساعة. منتج وعلامة وهميان.',
      recoCount: 12,
      gift: true,
    ),
    Product(
      slug: 'brume-interieur',
      titleFr: 'Brume d’intérieur 100 ml',
      titleAr: 'رذاذ المنزل 100 مل',
      image: '$img/spray.jpg',
      brandSlug: 'maison-demo',
      priceDt: '38',
      sourceUrl: Uri.parse('https://maisondemo.tn/brume-100'),
      descFr: 'Brume d’intérieur fictive, 100 ml.',
      descAr: 'رذاذ منزل وهمي، 100 مل.',
      recoCount: 6,
      gift: true,
    ),
    Product(
      slug: 'parure-lin',
      titleFr: 'Parure en lin 2 places',
      titleAr: 'طقم كتان لسريرين',
      image: '$img/linen.jpg',
      brandSlug: 'atelier-demo',
      priceDt: '320',
      sourceUrl: Uri.parse('https://atelierdemo.tn/parure-lin'),
      descFr: 'Linge de lit fictif en lin.',
      descAr: 'بياضات سرير وهمية من الكتان.',
      recoCount: 4,
    ),
    Product(
      slug: 'planche-olivier',
      titleFr: 'Planche en olivier',
      titleAr: 'لوح من خشب الزيتون',
      image: '$img/board.jpg',
      brandSlug: 'bois-demo',
      priceDt: '65',
      sourceUrl: Uri.parse('https://boisdemo.tn/planche-olivier'),
      descFr: 'Planche de service fictive.',
      descAr: 'لوح تقديم وهمي.',
      recoCount: 3,
      gift: true,
    ),
    Product(
      slug: 'bougie-oranger',
      titleFr: 'Bougie fleur d’oranger 180 g',
      titleAr: 'شمعة زهر البرتقال 180 غ',
      image: '$img/candle.jpg',
      brandSlug: 'maison-demo',
      priceDt: '45',
      sourceUrl: Uri.parse('https://maisondemo.tn/bougie-oranger'),
      descFr: 'Bougie fictive fleur d’oranger.',
      descAr: 'شمعة زهر البرتقال وهمية.',
      recoCount: 4,
      gift: true,
    ),
  ];

  static const collections = <Collection>[
    Collection(
      slug: 'rituels-du-soir',
      creatorHandle: 'nour.demo',
      titleFr: 'Rituels du soir',
      titleAr: 'طقوس المساء',
      blurbFr:
          'Ce que j’allume, ce que je respire et ce que je pose sur la table de nuit, une fois les enfants couchés.',
      blurbAr: 'ما أشعله، وما أتنشّقه، وما أضعه على طاولة السرير بعد نوم الأطفال.',
      productSlugs: ['bougie-jasmin', 'brume-interieur', 'parure-lin', 'planche-olivier'],
      tileImages: ['$img/candle.jpg', '$img/spray.jpg', '$img/linen.jpg', '$img/board.jpg'],
    ),
    Collection(
      slug: 'ma-chambre-en-lin',
      creatorHandle: 'nour.demo',
      titleFr: 'Ma chambre en lin',
      titleAr: 'غرفتي بالكتان',
      blurbFr: 'Le calme d’une chambre en lin, fictive.',
      blurbAr: 'هدوء غرفة من الكتان، وهمي.',
      productSlugs: ['parure-lin', 'bougie-jasmin'],
      tileImages: ['$img/linen.jpg', '$img/candle.jpg', '$img/spray.jpg', '$img/board.jpg'],
    ),
    Collection(
      slug: 'table-dete',
      creatorHandle: 'ines.demo',
      titleFr: 'Table d’été',
      titleAr: 'مائدة الصيف',
      blurbFr: 'Une table d’été fictive.',
      blurbAr: 'مائدة صيف وهمية.',
      productSlugs: ['planche-olivier', 'brume-interieur'],
      tileImages: ['$img/board.jpg', '$img/spray.jpg', '$img/linen.jpg', '$img/candle.jpg'],
    ),
    Collection(
      slug: 'a-offrir',
      creatorHandle: 'nour.demo',
      titleFr: 'À offrir',
      titleAr: 'للهدية',
      blurbFr: 'Petits formats à offrir.',
      blurbAr: 'أحجام صغيرة للهدية.',
      productSlugs: ['bougie-jasmin', 'brume-interieur', 'bougie-oranger'],
      tileImages: ['$img/candle.jpg', '$img/spray.jpg', '$img/board.jpg', '$img/linen.jpg'],
      draft: true,
    ),
  ];

  static const nourTabsFr = ['NOUVEAUTÉS', 'RITUELS DU SOIR', 'MA CHAMBRE', 'À OFFRIR', 'PAR MARQUE'];
  static const nourTabsAr = ['الجديد', 'طقوس المساء', 'غرفتي', 'للهدية', 'حسب العلامة'];

  static const clicks = [42, 55, 38, 61, 70, 66, 48, 90, 84, 77, 102, 95, 110, 131];

  static Creator? creator(String handle) {
    for (final c in creators) {
      if (c.handle == handle) return c;
    }
    return null;
  }

  static Brand? brand(String slug) {
    for (final b in brands) {
      if (b.slug == slug) return b;
    }
    return null;
  }

  static Product? product(String slug) {
    for (final p in products) {
      if (p.slug == slug) return p;
    }
    return null;
  }

  static Collection? collection(String handle, String slug) {
    for (final c in collections) {
      if (c.creatorHandle == handle && c.slug == slug) return c;
    }
    return null;
  }

  static List<Collection> forCreator(String handle) =>
      collections.where((c) => c.creatorHandle == handle && !c.draft).toList();

  static List<Product> productsFor(Iterable<String> slugs) =>
      slugs.map(product).whereType<Product>().toList();

  static List<Product> byBrand(String slug) =>
      products.where((p) => p.brandSlug == slug).toList();

  static List<Creator> recommending(String brandSlug) {
    final slugs = products.where((p) => p.brandSlug == brandSlug).map((p) => p.slug).toSet();
    return creators.where((c) {
      return collections.any(
        (col) => col.creatorHandle == c.handle && col.productSlugs.any(slugs.contains),
      );
    }).toList();
  }

  static SearchHit search(String q) {
    final needle = q.trim().toLowerCase();
    if (needle.isEmpty) {
      return SearchHit(creators: creators.take(3).toList(), brands: brands.take(2).toList(), products: const []);
    }
    bool has(String s) => s.toLowerCase().contains(needle);
    return SearchHit(
      creators: creators.where((c) => has(c.nameFr) || has(c.nameAr) || has(c.handle) || has(c.taglineFr)).toList(),
      brands: brands.where((b) => has(b.nameFr) || has(b.nameAr) || has(b.slug) || has(b.categoryFr)).toList(),
      products: products.where((p) => has(p.titleFr) || has(p.titleAr) || has(p.slug)).toList(),
    );
  }
}

class SearchHit {
  const SearchHit({required this.creators, required this.brands, required this.products});
  final List<Creator> creators;
  final List<Brand> brands;
  final List<Product> products;
  bool get isEmpty => creators.isEmpty && brands.isEmpty && products.isEmpty;
}
