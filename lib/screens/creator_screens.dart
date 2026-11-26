import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flouka/core/env.dart';
import 'package:flouka/core/tokens.dart';
import 'package:flouka/data/catalog.dart';
import 'package:flouka/data/models.dart';
import 'package:flouka/state/flouka_state.dart';
import 'package:flouka/widgets/fk_icons.dart';
import 'package:flouka/widgets/fk_widgets.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, this.brand = false});
  final bool brand;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late int role; // 0 creator, 1 brand
  final phone = TextEditingController();
  final email = TextEditingController();
  final otp = List.generate(6, (_) => TextEditingController());
  String? otpError;
  bool emailMode = false;

  @override
  void initState() {
    super.initState();
    role = widget.brand ? 1 : 0;
  }

  @override
  void dispose() {
    phone.dispose();
    email.dispose();
    for (final c in otp) {
      c.dispose();
    }
    super.dispose();
  }

  AccountRole get _role => role == 1 ? AccountRole.brand : AccountRole.creator;

  Future<void> _finish({String provider = 'sms'}) async {
    final st = context.read<FloukaState>();
    await st.signIn(role: _role, provider: provider, phone: phone.text, email: email.text);
    if (!mounted) return;
    if (_role == AccountRole.brand) {
      context.go('/brand/onboarding');
    } else {
      context.go('/onboarding');
    }
  }

  Future<void> _google() async {
    try {
      final g = GoogleSignIn.instance;
      await g.initialize();
      await g.authenticate();
      await _finish(provider: 'google');
    } catch (_) {
      await _finish(provider: 'google-demo');
    }
  }

  Future<void> _apple() async {
    try {
      await SignInWithApple.getAppleIDCredential(scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName]);
      await _finish(provider: 'apple');
    } catch (_) {
      await _finish(provider: 'apple-demo');
    }
  }

  void _checkOtp() {
    final code = otp.map((c) => c.text).join();
    if (code.length < 6) return;
    // Demo: any 6 digits. Real SMS is a human/API step.
    if (!RegExp(r'^\d{6}$').hasMatch(code)) {
      setState(() => otpError = context.read<FloukaState>().l.otpWrong);
      return;
    }
    _finish();
  }

  @override
  Widget build(BuildContext context) {
    final st = context.watch<FloukaState>();
    final l = st.l;
    // Guideline 4.8: Sign in with Apple whenever another social login is offered.
    const showApple = true;
    return Scaffold(
      backgroundColor: FkTokens.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(height: 36),
            const Center(child: FkSerif('Flouka', size: 56)),
            const SizedBox(height: 8),
            Center(child: FkMuted(l.loginTitle, size: 14)),
            const SizedBox(height: 16),
            FkChips(
              items: [l.roleCreator, l.roleBrand],
              active: role,
              onSelect: (i) => setState(() => role = i),
            ),
            const SizedBox(height: 16),
            if (!emailMode) FkField(label: l.phone, controller: phone),
            if (emailMode) FkField(label: l.email, controller: email),
            const SizedBox(height: 12),
            FkBtn(label: l.sendSms, onTap: () => setState(() => otpError = null)),
            const SizedBox(height: 16),
            Row(
              children: [
                const Expanded(child: Divider(color: FkTokens.line)),
                Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: FkMuted(l.or)),
                const Expanded(child: Divider(color: FkTokens.line)),
              ],
            ),
            const SizedBox(height: 12),
            if (showApple) ...[
              FkBtn(label: l.continueApple, outline: true, onTap: _apple),
              const SizedBox(height: 8),
            ],
            FkBtn(label: l.continueGoogle, outline: true, onTap: _google),
            const SizedBox(height: 8),
            FkBtn(label: l.continueEmail, outline: true, onTap: () => setState(() => emailMode = true)),
            const SizedBox(height: 16),
            FkCap(l.nextOtp, color: FkTokens.muted, size: 9),
            const SizedBox(height: 8),
            Row(
              children: [
                for (var i = 0; i < 6; i++) ...[
                  if (i > 0) const SizedBox(width: 6),
                  Expanded(
                    child: TextField(
                      controller: otp[i],
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(fontFamily: FkTokens.serif, fontSize: 24),
                      decoration: InputDecoration(
                        counterText: '',
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: i == 0 ? FkTokens.ink : FkTokens.line)),
                        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: FkTokens.ink)),
                      ),
                      onChanged: (_) => _checkOtp(),
                    ),
                  ),
                ],
              ],
            ),
            if (otpError != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(otpError!, style: const TextStyle(color: FkTokens.err, fontSize: 12)),
              ),
            const SizedBox(height: 16),
            FkMuted(l.legalContinue, size: 11),
            TextButton(onPressed: () => context.push('/legal/privacy'), child: Text(l.privacy)),
          ],
        ),
      ),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final handle = TextEditingController(text: '@nour.demo');
  final link = TextEditingController(text: 'flouka.app/shop/nour.demo');

  @override
  void dispose() {
    handle.dispose();
    link.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = l10nOf(context);
    final nour = DemoCatalog.creators.first;
    return Scaffold(
      backgroundColor: FkTokens.white,
      body: SafeArea(
        child: ListView(
          children: [
            const FkTopBar(trailing: null),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _Stepper(steps: [l.stepIg, l.stepPage, l.stepProduct], at: 0),
                  const SizedBox(height: 16),
                  FkSerif(l.igTitle, size: 32),
                  const SizedBox(height: 8),
                  FkMuted(l.igBody, size: 13),
                  const SizedBox(height: 16),
                  FkField(label: l.igHandle, controller: handle, ok: true, hint: l.found),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(border: Border.all(color: FkTokens.line)),
                    child: Row(
                      children: [
                        FkAvatar(asset: nour.photo, size: 64),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FkSerif(nour.nameFr, size: 22),
                              FkMuted('${nour.followers} · 318', size: 11),
                              FkMuted(nour.taglineFr, size: 11),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  FkField(label: l.floukaLink, controller: link, ok: true, hint: l.available),
                  const SizedBox(height: 16),
                  FkBtn(label: l.continueLabel, onTap: () => context.go('/studio/add')),
                  const SizedBox(height: 12),
                  Center(child: FkCap(l.noInstagram, color: FkTokens.muted, size: 10)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Stepper extends StatelessWidget {
  const _Stepper({required this.steps, required this.at});
  final List<String> steps;
  final int at;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < steps.length; i++)
          Expanded(
            child: Padding(
              padding: EdgeInsetsDirectional.only(end: i == steps.length - 1 ? 0 : 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(height: 3, color: i <= at ? FkTokens.ink : FkTokens.line),
                  const SizedBox(height: 6),
                  FkCap('${i + 1}. ${steps[i]}', color: i == at ? FkTokens.ink : FkTokens.muted, size: 9, weight: i == at ? FontWeight.w700 : FontWeight.w500),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final url = TextEditingController(text: 'maisondemo.tn/bougie-jasmin');
  final note = TextEditingController();
  bool recognized = true;

  @override
  void dispose() {
    url.dispose();
    note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = l10nOf(context);
    final p = DemoCatalog.products.first;
    final brand = DemoCatalog.brand(p.brandSlug)!;
    return Scaffold(
      backgroundColor: FkTokens.white,
      body: SafeArea(
        child: ListView(
          children: [
            FkTopBar(title: l.addProduct, trailing: FkIconKind.close, onTrailing: () => Navigator.maybePop(context)),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FkField(
                    label: l.productUrl,
                    controller: url,
                    ok: recognized,
                    hint: recognized ? l.recognized : null,
                    error: recognized ? null : l.parseError,
                  ),
                  const SizedBox(height: 12),
                  if (recognized)
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(border: Border.all(color: FkTokens.line)),
                      child: Row(
                        children: [
                          SizedBox(width: 96, child: FkPhoto(p.image)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FkCap(brand.nameFr, color: FkTokens.muted, size: 9),
                                Text(p.titleFr, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                                FkMuted(l10nOf(context).price(p.priceDt)),
                                Text(l.partnerCommission, style: const TextStyle(fontSize: 11, color: FkTokens.ok)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 12),
                  FkField(label: l.yourNote, controller: note),
                  const SizedBox(height: 16),
                  FkBtn(
                    label: l.addToShop,
                    onTap: () {
                      context.read<FloukaState>().analytics.event('produit_ajoute', {'url': url.text});
                      context.go('/studio');
                    },
                  ),
                  const SizedBox(height: 12),
                  Container(
                    color: FkTokens.surface,
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FkCap(l.parseError, color: FkTokens.err, size: 9, weight: FontWeight.w700),
                        const SizedBox(height: 4),
                        FkMuted(l.parseError, size: 11),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StudioScreen extends StatelessWidget {
  const StudioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = l10nOf(context);
    final rows = [
      [l.tabNew, '6', true],
      ['Rituels du soir', '12', true],
      ['Ma chambre', '8', true],
      [l.tabGifts, '3', false],
      [l.tabByBrand, '—', true],
    ];
    return FkScaffold(
      shell: FkShellKind.creator,
      active: 0,
      header: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: Row(
          children: [
            Expanded(child: FkSerif(l.myShop, size: 28, maxLines: 1)),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () => context.push('/shop/nour.demo'),
              child: FkCap(l.preview, weight: FontWeight.w700),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          FkTabs(items: [l.sections, l.collections, l.products]),
          for (final r in rows)
            FkListRow(
              lead: const FkIcon(FkIconKind.drag, color: FkTokens.muted),
              title: r[0] as String,
              sub: r[1] as String,
              trailing: FkIcon(FkIconKind.eye, color: (r[2] as bool) ? FkTokens.ink : const Color(0xFFC4C4C4)),
            ),
          const SizedBox(height: 14),
          FkBtn(label: l.newSection, outline: true, onTap: () {}),
          const SizedBox(height: 10),
          FkMuted(l.reorderHint, size: 11),
        ],
      ),
    );
  }
}

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = l10nOf(context);
    return FkScaffold(
      shell: FkShellKind.creator,
      active: 1,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          FkSerif(l.dashboard, size: 30),
          const SizedBox(height: 12),
          FkChips(items: const ['7 J', '30 J', 'TOUT'], active: 1),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1.2,
            children: [
              FkStat(label: l.clicksToBrands, value: '1 248', sub: '+18 %'),
              FkStat(label: l.shopViews, value: '4 020'),
              FkStat(label: l.clickRate, value: '31 %'),
              FkStat(label: l.commissions, value: '186 DT'),
            ],
          ),
          const SizedBox(height: 14),
          FkCap(l.clicksPerDay, color: FkTokens.muted, size: 10),
          FkSpark(values: DemoCatalog.clicks),
          const SizedBox(height: 12),
          FkCap(l.topClicked, color: FkTokens.muted, size: 10),
          FkListRow(
            lead: SizedBox(width: 48, child: FkPhoto(DemoCatalog.products.first.image)),
            title: 'Bougie jasmin',
            sub: 'Maison Démo',
            trailing: const Text('412', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final st = context.watch<FloukaState>();
    final l = st.l;
    final nour = DemoCatalog.creators.first;
    final link = '${FkEnv.instance.siteUrl.replaceFirst('https://', '')}/shop/${nour.handle}';
    return FkScaffold(
      shell: FkShellKind.creator,
      active: 2,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Column(
            children: [
              FkAvatar(asset: nour.photo, size: 88),
              const SizedBox(height: 8),
              FkSerif(nour.name(st.rtl), size: 28),
              FkCap(l.changePhoto, color: FkTokens.muted, size: 10),
            ],
          ),
          FkListRow(title: l.displayName, sub: nour.name(st.rtl), trailing: const FkIcon(FkIconKind.chev, color: FkTokens.muted)),
          FkListRow(title: l.bio, sub: nour.tagline(st.rtl), trailing: const FkIcon(FkIconKind.chev, color: FkTokens.muted)),
          FkListRow(
            title: l.myShopLink,
            sub: link,
            trailing: const FkIcon(FkIconKind.copy),
            onTap: () async {
              await Clipboard.setData(ClipboardData(text: 'https://$link'));
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.copied)));
              }
            },
          ),
          FkListRow(title: l.socials, sub: 'Instagram, TikTok', trailing: const FkIcon(FkIconKind.chev, color: FkTokens.muted)),
          FkListRow(title: l.shopLanguage, sub: 'Français · العربية', trailing: const FkIcon(FkIconKind.chev, color: FkTokens.muted)),
          FkListRow(title: l.payout, sub: l.payoutHint, trailing: const FkIcon(FkIconKind.chev, color: FkTokens.muted)),
          FkListRow(title: l.notifications, trailing: const FkIcon(FkIconKind.chev, color: FkTokens.muted)),
          FkListRow(title: l.help, sub: 'FAQ', trailing: const FkIcon(FkIconKind.chev, color: FkTokens.muted), onTap: () => context.push('/legal/how')),
          const SizedBox(height: 14),
          GestureDetector(onTap: st.signOut, child: FkCap(l.logout, color: FkTokens.err, weight: FontWeight.w700)),
          const SizedBox(height: 16),
          GestureDetector(onTap: () => context.push('/account/delete'), child: FkCap(l.deleteAccount, color: FkTokens.err)),
        ],
      ),
    );
  }
}
