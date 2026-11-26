import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flouka/core/brand_link.dart';
import 'package:flouka/core/env.dart';
import 'package:flouka/core/tokens.dart';
import 'package:flouka/data/catalog.dart';
import 'package:flouka/data/models.dart';
import 'package:flouka/state/flouka_state.dart';
import 'package:flouka/widgets/fk_icons.dart';
import 'package:flouka/widgets/fk_widgets.dart';

const _heroTextShadows = <Shadow>[
  Shadow(color: Color(0x8C000000), blurRadius: 12, offset: Offset(0, 1)),
];

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final st = context.watch<FloukaState>();
    final l = st.l;
    return FkScaffold(
      header: const FkHeader(),
      body: ListView(
        children: [
          FkPhoto(DemoCatalog.creators[2].photo, ratio: 4 / 5),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FkSerif(l.tagline, size: 34),
                const SizedBox(height: 8),
                FkMuted(l.taglineHint, size: 11),
                const SizedBox(height: 12),
                FkBtn(label: l.createShop, onTap: () => context.push('/auth')),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => context.push('/auth?role=brand'),
                  child: Text(
                    l.iAmBrand,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                      decoration: TextDecoration.underline,
                      decorationColor: FkTokens.ink,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: FkCap(l.creatorsToFollow, weight: FontWeight.w700),
          ),
          const _CreatorRail(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FkCap(l.collectionsNow, weight: FontWeight.w700),
                const SizedBox(height: 12),
                FkCollectionCard(collection: DemoCatalog.collections.first),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CreatorRail extends StatelessWidget {
  const _CreatorRail();

  @override
  Widget build(BuildContext context) {
    final st = context.watch<FloukaState>();
    final l = st.l;
    return SizedBox(
      height: 310,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        itemCount: DemoCatalog.creators.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, i) {
          final c = DemoCatalog.creators[i];
          final on = st.following.contains(c.handle);
          return SizedBox(
            width: 128,
            child: GestureDetector(
              onTap: () => context.push('/shop/${c.handle}'),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FkPhoto(c.photo, ratio: 3 / 4),
                  const SizedBox(height: 5),
                  FkSerif(c.name(st.rtl), size: 17, maxLines: 1),
                  FkMuted('${c.productCount}'),
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: () => st.toggleFollow(c.handle),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        border: Border.all(color: FkTokens.ink),
                        borderRadius: BorderRadius.circular(999),
                        color: on ? FkTokens.ink : FkTokens.white,
                      ),
                      child: Text(
                        on ? l.following : l.follow,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                          color: on ? FkTokens.white : FkTokens.ink,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class CreatorScreen extends StatefulWidget {
  const CreatorScreen({super.key, required this.handle});
  final String handle;

  @override
  State<CreatorScreen> createState() => _CreatorScreenState();
}

class _CreatorScreenState extends State<CreatorScreen> {
  int tab = 0;

  @override
  Widget build(BuildContext context) {
    final st = context.watch<FloukaState>();
    final l = st.l;
    final creator = DemoCatalog.creator(widget.handle);
    if (creator == null) return const _NotFound();
    final colls = DemoCatalog.forCreator(creator.handle);
    final products = DemoCatalog.products;
    st.analytics.event('vue_boutique', {'handle': creator.handle});
    final tabs = st.rtl ? DemoCatalog.nourTabsAr : DemoCatalog.nourTabsFr;
    return FkScaffold(
      showBar: true,
      body: ListView(
        children: [
          Stack(
            children: [
              FkPhoto(creator.photo, ratio: 3 / 4),
              const Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: FractionallySizedBox(
                    heightFactor: 0.46,
                    widthFactor: 1,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0x00000000),
                            Color(0x8C000000),
                            Color(0xC7000000),
                          ],
                          stops: [0, 0.42, 1],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const Positioned(
                left: 0,
                right: 0,
                top: 0,
                height: 88,
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0x6B000000), Color(0x00000000)],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
                  child: Column(
                    children: [
                      FkSerif(
                        l.selectedBy,
                        size: 16,
                        italic: true,
                        color: FkTokens.white,
                        center: true,
                        shadows: _heroTextShadows,
                      ),
                      FkSerif(
                        creator.name(st.rtl),
                        size: 34,
                        color: FkTokens.white,
                        center: true,
                        shadows: _heroTextShadows,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        creator.tagline(st.rtl),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 11,
                          color: FkTokens.white,
                          shadows: _heroTextShadows,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FkIcon(FkIconKind.ig, color: FkTokens.white, size: 19),
                          SizedBox(width: 28),
                          FkIcon(FkIconKind.tt, color: FkTokens.white, size: 19),
                          SizedBox(width: 28),
                          FkIcon(FkIconKind.yt, color: FkTokens.white, size: 19),
                          SizedBox(width: 28),
                          FkIcon(FkIconKind.link, color: FkTokens.white, size: 19),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: FkTopBar(
                  overlay: true,
                  onTrailing: () => SharePlus.instance.share(
                    ShareParams(text: '${FkEnv.instance.siteUrl}/shop/${creator.handle}'),
                  ),
                ),
              ),
            ],
          ),
          FkTabs(items: tabs, active: tab, onSelect: (i) => setState(() => tab = i)),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
            child: Column(
              children: [
                if (colls.isNotEmpty) FkCollectionCard(collection: colls.first),
                const SizedBox(height: 12),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 2,
                  crossAxisSpacing: 2,
                  childAspectRatio: 0.62,
                  children: [for (final p in products.take(2)) FkProductCard(product: p)],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CollectionScreen extends StatelessWidget {
  const CollectionScreen({super.key, required this.handle, required this.slug});
  final String handle;
  final String slug;

  @override
  Widget build(BuildContext context) {
    final st = context.watch<FloukaState>();
    final l = st.l;
    final col = DemoCatalog.collection(handle, slug);
    final creator = DemoCatalog.creator(handle);
    if (col == null || creator == null) return const _NotFound();
    st.analytics.event('vue_collection', {'slug': slug});
    final products = DemoCatalog.productsFor(col.productSlugs);
    final site = FkEnv.instance.siteUrl;
    return FkScaffold(
      showBar: false,
      body: ListView(
        children: [
          FkTopBar(
            title: l.collection,
            onTrailing: () => SharePlus.instance.share(
              ShareParams(text: '$site/shop/$handle/${col.slug}'),
            ),
          ),
          Row(
            children: [
              Expanded(flex: 2, child: FkPhoto(col.tileImages.first, ratio: 1)),
              const SizedBox(width: 2),
              Expanded(
                child: Column(
                  children: [
                    FkPhoto(col.tileImages[1], ratio: 1),
                    const SizedBox(height: 2),
                    FkPhoto(col.tileImages[2], ratio: 1),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FkSerif(col.title(st.rtl), size: 34),
                const SizedBox(height: 8),
                Row(
                  children: [
                    FkAvatar(asset: creator.photo, size: 28),
                    const SizedBox(width: 8),
                    Expanded(child: FkMuted('${creator.name(st.rtl)} • ${col.productSlugs.length}')),
                  ],
                ),
                const SizedBox(height: 10),
                Text(col.blurb(st.rtl), style: const TextStyle(fontSize: 14, height: 1.5)),
                const SizedBox(height: 14),
                FkBtn(
                  label: l.shareCollection,
                  outline: true,
                  onTap: () => SharePlus.instance.share(
                    ShareParams(text: '$site/shop/$handle/${col.slug}'),
                  ),
                ),
                const SizedBox(height: 14),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 2,
                  crossAxisSpacing: 2,
                  childAspectRatio: 0.62,
                  children: [for (final p in products) FkProductCard(product: p)],
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => context.push('/shop/$handle'),
                  child: Center(child: FkCap('${l.seeCreatorShop} ${creator.name(st.rtl)}', weight: FontWeight.w700)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key, required this.slug});
  final String slug;

  @override
  Widget build(BuildContext context) {
    final st = context.watch<FloukaState>();
    final l = st.l;
    final product = DemoCatalog.product(slug);
    if (product == null) return const _NotFound();
    st.analytics.event('vue_produit', {'slug': slug});
    final brand = DemoCatalog.brand(product.brandSlug)!;
    final creator = DemoCatalog.creators.first;
    return FkScaffold(
      body: ListView(
        children: [
          FkTopBar(
            onTrailing: () => SharePlus.instance.share(
              ShareParams(text: '${FkEnv.instance.siteUrl}/p/${product.slug}'),
            ),
          ),
          AspectRatio(
            aspectRatio: 1,
            child: Stack(
              fit: StackFit.expand,
              children: [
                FkPhoto(product.image),
                if (product.recoCount >= 3)
                  PositionedDirectional(start: 8, bottom: 8, child: FkProofBadge(product.recoCount)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FkCap(brand.name(st.rtl).toUpperCase(), color: FkTokens.muted, size: 10),
                const SizedBox(height: 6),
                Text(product.priceDt.isEmpty ? l.priceOnSite : l.price(product.priceDt), style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 6),
                FkSerif(product.title(st.rtl), size: 30),
                const SizedBox(height: 12),
                FkBtn(
                  label: l.seeAt(brand.name(st.rtl)),
                  violet: st.useVioletCta,
                  enabled: product.available,
                  onTap: () => _openBrand(context, product, brand, creator.handle),
                ),
                const SizedBox(height: 8),
                FkMuted(l.commissionNote, size: 11),
                const SizedBox(height: 4),
                Center(child: FkMuted(l.payAtBrand, size: 11)),
                const SizedBox(height: 12),
                if (product.note(st.rtl).isNotEmpty)
                  Container(
                    color: FkTokens.surface,
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FkAvatar(asset: creator.photo, size: 32),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FkCap(st.rtl ? 'رأي ${creator.nameAr}' : 'L’avis de ${creator.nameFr}', size: 10, weight: FontWeight.w700),
                              const SizedBox(height: 4),
                              FkSerif(product.note(st.rtl), size: 15, italic: true),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 12),
                const Divider(color: FkTokens.line, height: 1),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          FkCap(l.description, weight: FontWeight.w700),
                          const Spacer(),
                          const Text('−'),
                        ],
                      ),
                      const SizedBox(height: 8),
                      FkMuted(product.desc(st.rtl), size: 13),
                    ],
                  ),
                ),
                const Divider(color: FkTokens.line, height: 1),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () => st.toggleFavorite(product.slug),
                  child: FkCap(st.favorites.contains(product.slug) ? l.navFav : '+ ${l.navFav}', weight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openBrand(BuildContext context, Product product, Brand brand, String handle) async {
    final st = context.read<FloukaState>();
    final l = st.l;
    final ok = await showModalBottomSheet<bool>(
      context: context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FkSerif(l.leavingFlouka, size: 26),
            const SizedBox(height: 8),
            FkMuted(l.leavingBody),
            const SizedBox(height: 16),
            FkBtn(label: l.openSite, onTap: () => Navigator.pop(ctx, true)),
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.cancel)),
          ],
        ),
      ),
    );
    if (ok != true) return;
    await st.analytics.event('clic_marque', {'product': product.slug, 'brand': brand.slug, 'creator': handle});
    await BrandLink.open(product.sourceUrl, creatorHandle: handle, productSlug: product.slug);
  }
}

class BrandScreen extends StatelessWidget {
  const BrandScreen({super.key, required this.slug});
  final String slug;

  @override
  Widget build(BuildContext context) {
    final st = context.watch<FloukaState>();
    final l = st.l;
    final brand = DemoCatalog.brand(slug);
    if (brand == null) return const _NotFound();
    final products = DemoCatalog.byBrand(slug);
    final recos = DemoCatalog.recommending(slug);
    return FkScaffold(
      body: ListView(
        children: [
          FkTopBar(title: l.brand),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      color: FkTokens.surface,
                      alignment: Alignment.center,
                      child: FkSerif(brand.letter, size: 40),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FkSerif(brand.name(st.rtl), size: 30),
                          FkMuted('${brand.category(st.rtl)} · ${brand.city}'),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(l.recommendedBy(recos.length), style: const TextStyle(fontFamily: FkTokens.italic, fontStyle: FontStyle.italic, fontSize: 15)),
                const SizedBox(height: 12),
                if (brand.partner)
                  FkBtn(
                    label: l.visitBrandSite,
                    outline: true,
                    onTap: () async {
                      await st.analytics.event('clic_marque', {'brand': brand.slug});
                      await BrandLink.open(brand.site);
                    },
                  )
                else
                  FkMuted(l.notPartner),
              ],
            ),
          ),
          FkTabs(items: ['${l.tabProducts} (${products.length})', '${l.tabCreators} (${recos.length})', l.collections]),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 2,
                  crossAxisSpacing: 2,
                  childAspectRatio: 0.62,
                  children: [for (final p in products.take(4)) FkProductCard(product: p)],
                ),
                const SizedBox(height: 16),
                FkCap(l.navCreators, weight: FontWeight.w700),
                for (final c in recos)
                  FkListRow(
                    lead: FkAvatar(asset: c.photo, size: 36),
                    title: c.name(st.rtl),
                    trailing: const FkIcon(FkIconKind.chev, color: FkTokens.muted),
                    onTap: () => context.push('/shop/${c.handle}'),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, this.initial = ''});
  final String initial;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final TextEditingController c;
  int tab = 0;

  @override
  void initState() {
    super.initState();
    c = TextEditingController(text: widget.initial);
  }

  @override
  void dispose() {
    c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final st = context.watch<FloukaState>();
    final l = st.l;
    final hit = DemoCatalog.search(c.text);
    st.analytics.event('recherche', {'q': c.text, 'empty': hit.isEmpty});
    return FkScaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(border: Border.all(color: FkTokens.ink), borderRadius: BorderRadius.circular(2)),
              child: Row(
                children: [
                  const FkIcon(FkIconKind.search, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: c,
                      decoration: InputDecoration(hintText: l.searchHint, border: InputBorder.none, isDense: true),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  if (c.text.isNotEmpty)
                    GestureDetector(
                      onTap: () => setState(c.clear),
                      child: const FkIcon(FkIconKind.close, size: 16, color: FkTokens.muted),
                    ),
                ],
              ),
            ),
          ),
          FkTabs(
            items: [l.tabAll, l.tabProducts, l.tabCreators, l.tabBrands],
            active: tab,
            onSelect: (i) => setState(() => tab = i),
          ),
          Expanded(
            child: hit.isEmpty && c.text.isNotEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FkMuted(l.noResults),
                        TextButton(onPressed: () {}, child: Text(l.suggestBrand)),
                      ],
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    children: [
                      if (tab == 0 || tab == 2) ...[
                        FkCap(l.tabCreators, color: FkTokens.muted, size: 10),
                        for (final cr in hit.creators)
                          FkListRow(
                            lead: FkAvatar(asset: cr.photo, size: 40),
                            title: cr.name(st.rtl),
                            sub: cr.instagram,
                            onTap: () => context.push('/shop/${cr.handle}'),
                          ),
                      ],
                      if (tab == 0 || tab == 3) ...[
                        const SizedBox(height: 10),
                        FkCap(l.tabBrands, color: FkTokens.muted, size: 10),
                        for (final b in hit.brands)
                          FkListRow(
                            lead: FkAvatar(letter: b.letter, size: 40),
                            title: b.name(st.rtl),
                            onTap: () => context.push('/marque/${b.slug}'),
                          ),
                      ],
                      if (tab == 0 || tab == 1) ...[
                        const SizedBox(height: 10),
                        FkCap(l.tabProducts, color: FkTokens.muted, size: 10),
                        for (final p in hit.products)
                          FkListRow(
                            lead: SizedBox(width: 48, child: FkPhoto(p.image)),
                            title: p.title(st.rtl),
                            sub: l.price(p.priceDt),
                            onTap: () => context.push('/p/${p.slug}'),
                          ),
                      ],
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final st = context.watch<FloukaState>();
    final items = st.favoriteProducts;
    return FkScaffold(
      active: 1,
      header: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: FkSerif(st.l.favorites, size: 30),
      ),
      body: items.isEmpty
          ? Center(child: FkMuted(st.l.emptyFav))
          : GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 2,
              crossAxisSpacing: 2,
              childAspectRatio: 0.62,
              children: [for (final p in items) FkProductCard(product: p)],
            ),
    );
  }
}

class GiftsScreen extends StatelessWidget {
  const GiftsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final st = context.watch<FloukaState>();
    final gifts = DemoCatalog.products.where((p) => p.gift).toList();
    return FkScaffold(
      active: 2,
      header: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: FkSerif(st.l.gifts, size: 30),
      ),
      body: gifts.isEmpty
          ? Center(child: FkMuted(st.l.emptyGifts))
          : GridView.count(
              padding: const EdgeInsets.only(top: 12),
              crossAxisCount: 2,
              mainAxisSpacing: 2,
              crossAxisSpacing: 2,
              childAspectRatio: 0.62,
              children: [for (final p in gifts) FkProductCard(product: p)],
            ),
    );
  }
}

class _NotFound extends StatelessWidget {
  const _NotFound();

  @override
  Widget build(BuildContext context) {
    final l = l10nOf(context);
    return FkScaffold(
      showBar: false,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FkSerif(l.handleUnknown, size: 28, center: true),
              const SizedBox(height: 12),
              FkBtn(label: l.goHome, onTap: () => context.go('/')),
            ],
          ),
        ),
      ),
    );
  }
}
