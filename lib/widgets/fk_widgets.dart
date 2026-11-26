import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flouka/core/l10n.dart';
import 'package:flouka/core/theme.dart';
import 'package:flouka/core/tokens.dart';
import 'package:flouka/data/catalog.dart';
import 'package:flouka/data/models.dart';
import 'package:flouka/state/flouka_state.dart';
import 'package:flouka/widgets/fk_icons.dart';

FkTheme fkThemeOf(BuildContext context) => FkTheme(context.watch<FloukaState>().rtl);

L10n l10nOf(BuildContext context) => context.watch<FloukaState>().l;

class FkSerif extends StatelessWidget {
  const FkSerif(
    this.text, {
    super.key,
    this.size = 24,
    this.color = FkTokens.ink,
    this.italic = false,
    this.center = false,
    this.maxLines,
  });
  final String text;
  final double size;
  final Color color;
  final bool italic;
  final bool center;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    final rtl = context.watch<FloukaState>().rtl;
    return Text(
      text,
      textAlign: center ? TextAlign.center : TextAlign.start,
      maxLines: maxLines,
      overflow: maxLines == null ? TextOverflow.clip : TextOverflow.ellipsis,
      style: TextStyle(
        fontFamily: italic || rtl ? FkTokens.italic : FkTokens.serif,
        fontStyle: italic ? FontStyle.italic : FontStyle.normal,
        fontSize: size,
        height: 1.1,
        color: color,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}

class FkCap extends StatelessWidget {
  const FkCap(this.text, {super.key, this.color = FkTokens.ink, this.size = 11, this.weight = FontWeight.w500, this.maxLines});
  final String text;
  final Color color;
  final double size;
  final FontWeight weight;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    final rtl = context.watch<FloukaState>().rtl;
    return Text(
      text,
      maxLines: maxLines,
      overflow: maxLines == null ? TextOverflow.clip : TextOverflow.ellipsis,
      style: TextStyle(
        fontFamily: rtl ? FkTokens.sansAr : FkTokens.sans,
        fontSize: size,
        letterSpacing: rtl ? 0 : 1.4,
        fontWeight: weight,
        color: color,
        height: 1.2,
      ),
    );
  }
}

class FkMuted extends StatelessWidget {
  const FkMuted(this.text, {super.key, this.size = 12});
  final String text;
  final double size;

  @override
  Widget build(BuildContext context) {
    final rtl = context.watch<FloukaState>().rtl;
    return Text(
      text,
      style: TextStyle(
        fontFamily: rtl ? FkTokens.sansAr : FkTokens.sans,
        fontSize: size,
        color: FkTokens.muted,
        height: 1.45,
      ),
    );
  }
}

class FkBtn extends StatelessWidget {
  const FkBtn({
    super.key,
    required this.label,
    this.onTap,
    this.outline = false,
    this.small = false,
    this.violet = false,
    this.enabled = true,
  });

  final String label;
  final VoidCallback? onTap;
  final bool outline;
  final bool small;
  final bool violet;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final fill = !enabled
        ? FkTokens.line
        : outline
            ? FkTokens.white
            : (violet ? FkTokens.abViolet : FkTokens.ink);
    final fg = outline ? FkTokens.ink : FkTokens.white;
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: small ? 9 : 14, horizontal: 12),
        decoration: BoxDecoration(
          color: fill,
          border: Border.all(color: enabled ? (violet && !outline ? FkTokens.abViolet : FkTokens.ink) : FkTokens.line),
          borderRadius: BorderRadius.circular(FkTokens.radius),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: context.watch<FloukaState>().rtl ? FkTokens.sansAr : FkTokens.sans,
            fontSize: small ? 11 : 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.0,
            color: enabled ? fg : FkTokens.muted,
          ),
        ),
      ),
    );
  }
}

class FkPhoto extends StatelessWidget {
  const FkPhoto(this.asset, {super.key, this.ratio = 1, this.fit = BoxFit.cover});
  final String asset;
  final double ratio;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: ratio,
      child: ColoredBox(
        color: FkTokens.surface,
        child: Image.asset(asset, fit: fit, errorBuilder: (_, __, ___) => const ColoredBox(color: FkTokens.surface)),
      ),
    );
  }
}

class FkAvatar extends StatelessWidget {
  const FkAvatar({super.key, this.asset, this.letter, this.size = 40});
  final String? asset;
  final String? letter;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: SizedBox(
        width: size,
        height: size,
        child: asset != null
            ? Image.asset(asset!, fit: BoxFit.cover)
            : ColoredBox(
                color: FkTokens.ink,
                child: Center(
                  child: Text(
                    letter ?? '',
                    style: TextStyle(fontFamily: FkTokens.serif, fontSize: size * 0.5, color: FkTokens.white),
                  ),
                ),
              ),
      ),
    );
  }
}

class FkProofBadge extends StatelessWidget {
  const FkProofBadge(this.count, {super.key});
  final int count;

  @override
  Widget build(BuildContext context) {
    final l = l10nOf(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(4, 3, 8, 3),
      decoration: BoxDecoration(color: FkTokens.white, borderRadius: BorderRadius.circular(999)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 38,
            height: 14,
            child: Stack(
              children: [
                for (var i = 0; i < 3; i++)
                  PositionedDirectional(
                    start: i * 9.0,
                    child: FkAvatar(asset: DemoCatalog.creators[i].photo, size: 14),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 5),
          Text(l.creatorsCount(count), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class FkProductCard extends StatelessWidget {
  const FkProductCard({super.key, required this.product, this.onTap});
  final Product product;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final st = context.watch<FloukaState>();
    final l = st.l;
    final brand = DemoCatalog.brand(product.brandSlug);
    return InkWell(
      onTap: onTap ?? () => context.push('/p/${product.slug}'),
      child: ColoredBox(
        color: FkTokens.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  FkPhoto(product.image),
                  if (product.recoCount >= 3)
                    PositionedDirectional(
                      start: 8,
                      bottom: 8,
                      child: FkProofBadge(product.recoCount),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FkCap(brand?.name(st.rtl).toUpperCase() ?? '', color: FkTokens.muted, size: 9),
                  const SizedBox(height: 3),
                  Text(
                    product.title(st.rtl),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, height: 1.3),
                  ),
                  const SizedBox(height: 3),
                  FkMuted(product.priceDt.isEmpty ? l.priceOnSite : l.price(product.priceDt)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FkCollectionCard extends StatelessWidget {
  const FkCollectionCard({super.key, required this.collection, this.onTap});
  final Collection collection;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final st = context.watch<FloukaState>();
    final creator = DemoCatalog.creator(collection.creatorHandle);
    return InkWell(
      onTap: onTap ?? () => context.push('/shop/${collection.creatorHandle}/${collection.slug}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: ColoredBox(
              color: FkTokens.gutter,
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 2,
                crossAxisSpacing: 2,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  for (final img in collection.tileImages.take(4)) FkPhoto(img),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          FkSerif(collection.title(st.rtl), size: 20),
          FkMuted('${creator?.name(st.rtl) ?? ''} • ${collection.productSlugs.length}'),
        ],
      ),
    );
  }
}

class FkTopBar extends StatelessWidget {
  const FkTopBar({super.key, this.title, this.dark = false, this.trailing = FkIconKind.share, this.onTrailing});
  final String? title;
  final bool dark;
  final FkIconKind? trailing;
  final VoidCallback? onTrailing;

  @override
  Widget build(BuildContext context) {
    final c = dark ? FkTokens.white : FkTokens.ink;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: dark ? Colors.black.withValues(alpha: 0.28) : FkTokens.white,
        border: dark ? null : const Border(bottom: BorderSide(color: FkTokens.line)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: FkIcon(FkIconKind.back, color: c),
          ),
          Expanded(
            child: Text(
              title ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: c, letterSpacing: 0.4),
            ),
          ),
          if (trailing == null)
            const SizedBox(width: 20)
          else
            GestureDetector(onTap: onTrailing, child: FkIcon(trailing!, color: c)),
        ],
      ),
    );
  }
}

class FkHeader extends StatelessWidget {
  const FkHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: FkTokens.headerH,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            const FkSerif('Flouka', size: 28),
            const Spacer(),
            GestureDetector(onTap: () => context.push('/search'), child: const FkIcon(FkIconKind.search)),
            const SizedBox(width: 18),
            GestureDetector(onTap: () => context.push('/menu'), child: const FkIcon(FkIconKind.menu)),
          ],
        ),
      ),
    );
  }
}

class FkField extends StatelessWidget {
  const FkField({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.ok = false,
    this.error,
  });
  final String label;
  final TextEditingController controller;
  final String? hint;
  final bool ok;
  final String? error;

  @override
  Widget build(BuildContext context) {
    final border = error != null ? FkTokens.err : FkTokens.ink;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FkCap(label, color: FkTokens.muted, size: 10),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          decoration: BoxDecoration(
            border: Border.all(color: border),
            borderRadius: BorderRadius.circular(FkTokens.radius),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: const InputDecoration(isDense: true, border: InputBorder.none, contentPadding: EdgeInsets.zero),
                ),
              ),
              if (ok) const FkIcon(FkIconKind.check, color: FkTokens.ok, size: 18),
            ],
          ),
        ),
        if (hint != null || error != null)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(error ?? hint!, style: TextStyle(fontSize: 11, color: error != null ? FkTokens.err : FkTokens.ok)),
          ),
      ],
    );
  }
}

class FkListRow extends StatelessWidget {
  const FkListRow({super.key, this.lead, required this.title, this.sub, this.trailing, this.onTap});
  final Widget? lead;
  final String title;
  final String? sub;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: FkTokens.line))),
        child: Row(
          children: [
            if (lead != null) ...[lead!, const SizedBox(width: 12)],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 14, color: FkTokens.ink)),
                  if (sub != null) ...[const SizedBox(height: 2), FkMuted(sub!)],
                ],
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}

class FkStat extends StatelessWidget {
  const FkStat({super.key, required this.label, required this.value, this.sub});
  final String label;
  final String value;
  final String? sub;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(border: Border.all(color: FkTokens.line)),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            FkCap(label, color: FkTokens.muted, size: 9, maxLines: 1),
            FkSerif(value, size: 28, maxLines: 1),
            if (sub != null) FkMuted(sub!, size: 11),
          ],
        ),
      ),
    );
  }
}

class FkSpark extends StatelessWidget {
  const FkSpark({super.key, required this.values});
  final List<int> values;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: CustomPaint(painter: _SparkPainter(values), size: const Size(double.infinity, 90)),
    );
  }
}

class _SparkPainter extends CustomPainter {
  _SparkPainter(this.values);
  final List<int> values;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;
    final max = values.reduce((a, b) => a > b ? a : b).toDouble();
    final bw = size.width / values.length;
    final h = size.height - 16;
    for (var i = 0; i < values.length; i++) {
      final barH = (values[i] / max) * h;
      final paint = Paint()..color = i == values.length - 1 ? FkTokens.ink : const Color(0xFFBDBDBD);
      canvas.drawRect(Rect.fromLTWH(i * bw + 2, h - barH, bw - 4, barH), paint);
    }
    canvas.drawLine(Offset(0, h), Offset(size.width, h), Paint()..color = FkTokens.line);
  }

  @override
  bool shouldRepaint(covariant _SparkPainter old) => old.values != values;
}

class FkTabs extends StatelessWidget {
  const FkTabs({super.key, required this.items, this.active = 0, this.onSelect});
  final List<String> items;
  final int active;
  final ValueChanged<int>? onSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 20),
        itemBuilder: (context, i) {
          final on = i == active;
          return GestureDetector(
            onTap: () => onSelect?.call(i),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: on ? FkTokens.ink : Colors.transparent, width: 1.5)),
              ),
              child: FkCap(items[i], color: on ? FkTokens.ink : FkTokens.muted, weight: on ? FontWeight.w700 : FontWeight.w500),
            ),
          );
        },
      ),
    );
  }
}

class FkChips extends StatelessWidget {
  const FkChips({super.key, required this.items, required this.active, this.onSelect});
  final List<String> items;
  final int active;
  final ValueChanged<int>? onSelect;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        for (var i = 0; i < items.length; i++)
          GestureDetector(
            onTap: () => onSelect?.call(i),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: i == active ? FkTokens.ink : FkTokens.white,
                border: Border.all(color: i == active ? FkTokens.ink : FkTokens.line),
                borderRadius: BorderRadius.circular(FkTokens.radius),
              ),
              child: Text(
                items[i],
                style: TextStyle(
                  fontSize: 11,
                  letterSpacing: 0.8,
                  color: i == active ? FkTokens.white : FkTokens.ink,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

enum FkShellKind { shopper, creator, brand }

class FkPillBar extends StatelessWidget {
  const FkPillBar({super.key, required this.kind, required this.active});
  final FkShellKind kind;
  final int active;

  @override
  Widget build(BuildContext context) {
    final l = l10nOf(context);
    late final List<FkIconKind> icons;
    late final List<String> labels;
    late final List<String> routes;
    var round = FkIconKind.search;
    var roundRoute = '/search';
    var roundFilled = false;
    switch (kind) {
      case FkShellKind.shopper:
        icons = [FkIconKind.home, FkIconKind.heart, FkIconKind.gift];
        labels = [l.navHome, l.navFav, l.navGifts];
        routes = ['/', '/favorites', '/gifts'];
      case FkShellKind.creator:
        icons = [FkIconKind.shop, FkIconKind.chart, FkIconKind.user];
        labels = [l.navShop, l.navStats, l.navProfile];
        routes = ['/studio', '/studio/stats', '/studio/profile'];
        round = FkIconKind.plus;
        roundRoute = '/studio/add';
        roundFilled = true;
      case FkShellKind.brand:
        icons = [FkIconKind.home, FkIconKind.shop, FkIconKind.user];
        labels = [l.navHome, l.navProducts, l.navCreators];
        routes = ['/marque-studio', '/marque-studio/produits', '/marque-studio/createurs'];
        round = FkIconKind.plus;
        roundRoute = '/brand/onboarding';
        roundFilled = true;
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 9),
            decoration: BoxDecoration(
              color: FkTokens.white.withValues(alpha: 0.94),
              border: Border.all(color: FkTokens.line),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              children: [
                for (var i = 0; i < icons.length; i++) ...[
                  if (i > 0) const SizedBox(width: 22),
                  GestureDetector(
                    onTap: () => context.go(routes[i]),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FkIcon(icons[i], color: i == active ? FkTokens.ink : FkTokens.muted),
                        const SizedBox(height: 2),
                        Text(labels[i], style: TextStyle(fontSize: 9, color: i == active ? FkTokens.ink : FkTokens.muted)),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => context.push(roundRoute),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: roundFilled ? FkTokens.ink : FkTokens.white.withValues(alpha: 0.94),
                border: Border.all(color: roundFilled ? FkTokens.ink : FkTokens.line),
                shape: BoxShape.circle,
              ),
              child: Center(child: FkIcon(round, color: roundFilled ? FkTokens.white : FkTokens.ink)),
            ),
          ),
        ],
      ),
    );
  }
}

class FkScaffold extends StatelessWidget {
  const FkScaffold({
    super.key,
    required this.body,
    this.shell = FkShellKind.shopper,
    this.active = 0,
    this.header,
    this.showBar = true,
  });

  final Widget body;
  final FkShellKind shell;
  final int active;
  final Widget? header;
  final bool showBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FkTokens.white,
      body: SafeArea(
        child: Column(
          children: [
            if (header != null) header!,
            Expanded(child: body),
            if (showBar) FkPillBar(kind: shell, active: active),
          ],
        ),
      ),
    );
  }
}
