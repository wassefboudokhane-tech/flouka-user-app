import 'dart:convert';

import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/core/helper_function/api_timeouts.dart';
import 'package:flouka/core/helper_function/text_form_field_validation.dart';
import 'package:flouka/core/widgets/flouka_network_image.dart';
import 'package:flouka/features/cart/domain/checkout_entry.dart';
import 'package:flouka/features/cart/presentation/widgets/custom_cart_button_widget.dart';
import 'package:flouka/features/language/domain/language_copy.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flouka/features/products/presentation/providers/categories_product_search_provider.dart';
import 'package:flouka/features/products/presentation/widgets/hot_deals_home_container_widget.dart';
import 'package:flutter/material.dart';

/// True when the web address asks for the guest sanity screen.
bool openBuyerSanityPage() {
  final uri = Uri.base;
  return uri.path.contains('sanity') ||
      uri.fragment.contains('sanity') ||
      uri.queryParameters.containsKey('sanity');
}

class BuyerSanityPage extends StatefulWidget {
  const BuyerSanityPage({super.key});

  @override
  State<BuyerSanityPage> createState() => _BuyerSanityPageState();
}

class _BuyerSanityPageState extends State<BuyerSanityPage> {
  final _probeKey = GlobalKey();
  final _bubbleKey = GlobalKey();
  late final List<_SanityRow> _rows = _syncRows();
  bool _cartMeasured = false;
  bool _hintStarted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _measureCart());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_hintStarted) return;
    _hintStarted = true;
    _loadFrenchHint(DefaultAssetBundle.of(context));
  }

  List<_SanityRow> _syncRows() {
    final timeouts = ApiTimeouts.forPlatform(isWeb: true);
    final webTimeoutsOk = timeouts.connectTimeout == null &&
        timeouts.sendTimeout == null &&
        timeouts.receiveTimeout > Duration.zero;

    final productImage = floukaImageProvider(
      'https://floka.zeroonez.com/images/products/rose.jpg',
      web: true,
    );
    final shopperImages = {
      'catégorie': 'https://floka.zeroonez.com/images/categories/roses.jpg',
      'bannière': 'https://floka.zeroonez.com/images/banners/home.jpg',
      'boutique': 'https://floka.zeroonez.com/images/stores/logo.jpg',
      'story': 'https://floka.zeroonez.com/images/stories/logo.jpg',
    }.entries.every(
      (entry) =>
          floukaImageProvider(entry.value, web: true) is NetworkImage,
    );

    final search = <String, dynamic>{'page': 1};
    applySearchTerm(search, ' rose ');
    final kept = search['search'] == 'rose';
    applySearchTerm(search, '   ');

    final codes = LanguageProvider.languages
        .map((locale) => locale.languageCode)
        .toSet();

    return [
      _SanityRow(
        'Délais web',
        webTimeoutsOk,
        'Connexion et envoi non armés sur le web.',
      ),
      _SanityRow(
        'Image produit',
        productImage is NetworkImage,
        'Le web utilise NetworkImage.',
      ),
      _SanityRow(
        'Terme de recherche',
        kept && search['search'] == 'rose',
        '« rose » reste dans la requête.',
      ),
      _SanityRow(
        'Paiement invité',
        !checkoutEntryBlockedForGuest(isLoggedIn: false),
        'Un invité ouvre la caisse.',
      ),
      _SanityRow(
        'Téléphone tunisien 12345678',
        isTunisiaLoginNumber('12345678') && validatePhone('12345678') == null,
        '8 chiffres, sans zéro initial.',
      ),
      _SanityRow(
        'Langues ar/en/fr',
        codes.containsAll(['ar', 'en', 'fr']),
        codes.join(', '),
      ),
      _SanityRow(
        'Hauteur du rail d’accueil',
        HotDealsHomeContainerWidget.estimatedHeight(
              AppSpacing.productCardWidth,
            ) >=
            AppSpacing.productCardImageHeight + 176,
        'Le rail couvre le débordement de 2 px.',
      ),
      _SanityRow(
        'Images catégorie, bannière, boutique et story',
        shopperImages,
        'Même chemin web que la carte produit.',
      ),
      _SanityRow(
        'Indice de recherche « Rechercher... »',
        null,
        'Chargement du français embarqué…',
      ),
      _SanityRow(
        'Total du panier à gauche du chatbot',
        null,
        'Mesure en cours…',
      ),
    ];
  }

  Future<void> _loadFrenchHint(AssetBundle bundle) async {
    var pass = false;
    var detail = 'Fichier français indisponible.';
    try {
      final raw = await bundle.loadString('assets/languages/fr.json');
      final bundled = json.decode(raw) as Map<String, dynamic>;
      final hint = languageCopy(
        remoteLanguages: const {},
        languageCode: 'fr',
        bundled: bundled,
        parent: 'global',
        key: 'search',
      );
      pass = hint == 'Rechercher...';
      detail = pass ? '« $hint »' : 'Obtenu : « $hint »';
    } catch (error) {
      detail = '$error';
    }
    if (!mounted) return;
    setState(() {
      _rows[8] = _SanityRow(_rows[8].label, pass, detail);
    });
  }

  void _measureCart() {
    final probe = _probeKey.currentContext;
    final totalBox = _amountBox(probe);
    final bubbleBox =
        _bubbleKey.currentContext?.findRenderObject() as RenderBox?;
    if (totalBox == null || bubbleBox == null || !totalBox.hasSize) {
      if (!_cartMeasured) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _measureCart());
      }
      return;
    }
    final totalRight = totalBox.localToGlobal(Offset(totalBox.size.width, 0)).dx;
    final bubbleLeft = bubbleBox.localToGlobal(Offset.zero).dx;
    final pass = totalRight <= bubbleLeft;
    _cartMeasured = true;
    if (!mounted) return;
    setState(() {
      _rows[9] = _SanityRow(
        _rows[9].label,
        pass,
        pass
            ? 'Le total s’arrête avant la bulle.'
            : 'Le total dépasse la bulle.',
      );
    });
  }

  RenderBox? _amountBox(BuildContext? probe) {
    if (probe == null) return null;
    RenderBox? box;
    void walk(Element element) {
      if (element.widget.key == const Key('cart-total-amount')) {
        final render = element.renderObject;
        if (render is RenderBox) box = render;
      }
      element.visitChildElements(walk);
    }

    (probe as Element).visitChildElements(walk);
    return box;
  }

  @override
  Widget build(BuildContext context) {
    final done = _rows.where((row) => row.pass != null).length;
    final passed = _rows.where((row) => row.pass == true).length;
    return Scaffold(
      backgroundColor: AppColor.canvasColor,
      appBar: AppBar(
        backgroundColor: AppColor.deepColor,
        foregroundColor: Colors.white,
        title: const Text('Contrôle de bon fonctionnement'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          Text(
            'Vérifications acheteur, sans connexion.',
            style: TextStyleClass.normalStyle(color: AppColor.mutedColor),
          ),
          const SizedBox(height: 8),
          Text(
            '$passed / $done réussis',
            style: TextStyleClass.headStyle(color: AppColor.inkColor),
          ),
          const SizedBox(height: 16),
          for (final row in _rows) ...[
            _SanityTile(row: row),
            const SizedBox(height: 8),
          ],
          const SizedBox(height: 8),
          Text(
            'Mesure du total',
            style: TextStyleClass.smallStyle(color: AppColor.mutedColor),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              key: _probeKey,
              width: 400,
              height: 48,
              child: Stack(
                children: [
                  const CartSummaryTotal(label: 'Total', amount: '156.16 TND'),
                  Positioned(
                    right: 8,
                    bottom: 0,
                    child: SizedBox(
                      key: _bubbleKey,
                      width: 60,
                      height: 40,
                      child: const DecoratedBox(
                        decoration: BoxDecoration(color: Color(0x33116B3A)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SanityRow {
  const _SanityRow(this.label, this.pass, this.detail);
  final String label;
  final bool? pass;
  final String detail;
}

class _SanityTile extends StatelessWidget {
  const _SanityTile({required this.row});
  final _SanityRow row;

  @override
  Widget build(BuildContext context) {
    final pass = row.pass;
    final color = pass == null
        ? AppColor.mutedColor
        : pass
            ? const Color(0xff116B3A)
            : const Color(0xffB42318);
    final mark = pass == null
        ? '…'
        : pass
            ? 'Réussi'
            : 'Échec';
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  row.label,
                  style: TextStyleClass.normalStyle()
                      .copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  row.detail,
                  style: TextStyleClass.captionStyle(color: AppColor.mutedColor),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            mark,
            style: TextStyleClass.smallStyle(color: color)
                .copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
