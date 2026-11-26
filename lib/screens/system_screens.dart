import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flouka/core/l10n.dart';
import 'package:flouka/core/tokens.dart';
import 'package:flouka/state/flouka_state.dart';
import 'package:flouka/widgets/fk_widgets.dart';

class ConsentScreen extends StatelessWidget {
  const ConsentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final st = context.watch<FloukaState>();
    final l = st.l;
    return Scaffold(
      backgroundColor: FkTokens.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  TextButton(
                    onPressed: () => st.setLang(AppLang.fr),
                    child: Text(l.french, style: TextStyle(color: st.lang == AppLang.fr ? FkTokens.ink : FkTokens.muted)),
                  ),
                  TextButton(
                    onPressed: () => st.setLang(AppLang.ar),
                    child: Text(l.arabic, style: TextStyle(color: st.lang == AppLang.ar ? FkTokens.ink : FkTokens.muted)),
                  ),
                ],
              ),
              const Spacer(),
              const FkSerif('Flouka', size: 48, center: true),
              const SizedBox(height: 16),
              FkSerif(l.consentTitle, size: 28, center: true),
              const SizedBox(height: 12),
              FkMuted(l.consentBody, size: 14),
              const Spacer(),
              FkBtn(
                label: l.consentAccept,
                onTap: () async {
                  await st.setConsent(ConsentChoice.accepted);
                  if (context.mounted) context.go('/');
                },
              ),
              const SizedBox(height: 10),
              FkBtn(
                label: l.consentRefuse,
                outline: true,
                onTap: () async {
                  await st.setConsent(ConsentChoice.refused);
                  if (context.mounted) context.go('/');
                },
              ),
              TextButton(onPressed: () => context.push('/legal/privacy'), child: Text(l.privacy)),
            ],
          ),
        ),
      ),
    );
  }
}

class DeleteAccountScreen extends StatelessWidget {
  const DeleteAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final st = context.watch<FloukaState>();
    final l = st.l;
    return Scaffold(
      backgroundColor: FkTokens.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const FkTopBar(trailing: null),
              FkSerif(l.deleteAccount, size: 32),
              const SizedBox(height: 12),
              FkMuted(l.deleteConfirm, size: 14),
              const Spacer(),
              FkBtn(
                label: l.deleteNow,
                onTap: () async {
                  await st.deleteAccount();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.deleted)));
                    context.go('/');
                  }
                },
              ),
              TextButton(onPressed: () => Navigator.maybePop(context), child: Text(l.cancel)),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final st = context.watch<FloukaState>();
    final l = st.l;
    return Scaffold(
      backgroundColor: FkTokens.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const FkTopBar(trailing: null),
            FkSerif(l.menu, size: 30),
            FkListRow(
              title: l.language,
              sub: st.rtl ? l.arabic : l.french,
              onTap: () => st.setLang(st.rtl ? AppLang.fr : AppLang.ar),
            ),
            FkListRow(title: l.createShop, onTap: () => context.push('/auth')),
            FkListRow(title: l.iAmBrand, onTap: () => context.push('/auth?role=brand')),
            FkListRow(title: l.howItWorks, onTap: () => context.push('/legal/how')),
            FkListRow(title: l.privacy, onTap: () => context.push('/legal/privacy')),
            FkListRow(title: l.terms, onTap: () => context.push('/legal/terms')),
            FkListRow(title: l.consentTitle, onTap: () => context.go('/consent')),
            if (st.signedIn) FkListRow(title: l.deleteAccount, onTap: () => context.push('/account/delete')),
          ],
        ),
      ),
    );
  }
}

class LegalScreen extends StatelessWidget {
  const LegalScreen({super.key, required this.kind});
  final String kind;

  @override
  Widget build(BuildContext context) {
    final st = context.watch<FloukaState>();
    final l = st.l;
    final title = switch (kind) {
      'privacy' => l.privacy,
      'terms' => l.terms,
      _ => l.howItWorks,
    };
    final body = st.rtl ? _ar[kind] ?? _ar['how']! : _fr[kind] ?? _fr['how']!;
    return Scaffold(
      backgroundColor: FkTokens.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const FkTopBar(trailing: null),
            FkSerif(title, size: 32),
            const SizedBox(height: 16),
            Text(body, style: const TextStyle(fontSize: 14, height: 1.5, color: FkTokens.ink)),
          ],
        ),
      ),
    );
  }

  static const _fr = {
    'how':
        'Flouka montre les sélections de créateurs. Un clic ouvre le site de la marque dans le navigateur. Flouka n’a pas de panier, n’encaisse pas et n’offre pas d’achat in-app. Le paiement se fait chez la marque, souvent à la livraison.\n\nLes liens portent utm_source=flouka. Le créateur peut toucher une commission si la marque est partenaire et déclare la vente.',
    'privacy':
        'Responsable : Flouka. Données : langue, consentement, compte (téléphone / e-mail / Apple / Google) si tu t’inscris, favoris locaux, clics vers les marques.\n\nMesure (Clarity, PostHog UE, Firebase/GA4) uniquement après accord. Pas d’IDFA, pas d’ATT. Tu peux refuser la mesure et supprimer ton compte dans l’app.\n\nLoi tunisienne 2004-63 / INPDP. Hébergement analytics UE pour PostHog.',
    'terms':
        'Contenu de démonstration fictif. Interdiction de copier des marques ou visuels tiers. Flouka n’est pas vendeur des produits. Les contrats créateur–marque se règlent hors plateforme pour le versement.',
  };

  static const _ar = {
    'how':
        'فلوكة تعرض اختيارات صنّاع المحتوى. النقرة تفتح موقع العلامة في المتصفح. لا توجد سلة فلوكة ولا شراء داخل التطبيق. الدفع يتم لدى العلامة، غالباً عند التسليم.',
    'privacy':
        'المسؤول: فلوكة. البيانات: اللغة، الموافقة، الحساب إن أنشأته، المفضّلات المحلية، النقرات نحو العلامات. أدوات القياس لا تعمل إلا بعد الموافقة. يمكنك رفض القياس وحذف الحساب من التطبيق.',
    'terms':
        'محتوى تجريبي وهمي. فلوكة ليست بائع المنتجات. التحويلات المالية خارج المنصة.',
  };
}
