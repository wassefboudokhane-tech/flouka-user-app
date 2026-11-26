import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flouka/core/tokens.dart';
import 'package:flouka/data/catalog.dart';
import 'package:flouka/state/flouka_state.dart';
import 'package:flouka/widgets/fk_widgets.dart';

class BrandOnboardingScreen extends StatefulWidget {
  const BrandOnboardingScreen({super.key});

  @override
  State<BrandOnboardingScreen> createState() => _BrandOnboardingScreenState();
}

class _BrandOnboardingScreenState extends State<BrandOnboardingScreen> {
  int step = 2;

  @override
  Widget build(BuildContext context) {
    final st = context.watch<FloukaState>();
    final l = st.l;
    return Scaffold(
      backgroundColor: FkTokens.white,
      body: SafeArea(
        child: ListView(
          children: [
            FkTopBar(title: l.brandOnboard, trailing: null),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      for (final e in [
                        (0, l.stepInfo),
                        (1, l.stepSite),
                        (2, l.stepRate),
                        (3, l.stepReview),
                      ])
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsetsDirectional.only(end: 6),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(height: 3, color: e.$1 <= step ? FkTokens.ink : FkTokens.line),
                                const SizedBox(height: 6),
                                FkCap('${e.$1 + 1}. ${e.$2}', color: e.$1 == step ? FkTokens.ink : FkTokens.muted, size: 9),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  FkSerif(l.commissionRate, size: 32),
                  const SizedBox(height: 8),
                  FkMuted(l.commissionHelp, size: 13),
                  const SizedBox(height: 8),
                  Center(child: FkSerif('${st.brandCommission.round()} %', size: 64)),
                  Slider(
                    value: st.brandCommission,
                    min: 5,
                    max: 20,
                    activeColor: FkTokens.ink,
                    onChanged: (v) => setState(() => st.brandCommission = v),
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('5 %', style: TextStyle(fontSize: 10, color: FkTokens.muted)),
                      Text('20 %', style: TextStyle(fontSize: 10, color: FkTokens.muted)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    color: FkTokens.surface,
                    padding: const EdgeInsets.all(12),
                    child: Text(l.commissionExample, style: const TextStyle(fontSize: 13)),
                  ),
                  const SizedBox(height: 16),
                  FkBtn(label: l.continueLabel, onTap: () => context.go('/marque-studio')),
                  const SizedBox(height: 12),
                  Center(child: FkCap(l.previous, color: FkTokens.muted, size: 10)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BrandDashboardScreen extends StatelessWidget {
  const BrandDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final st = context.watch<FloukaState>();
    final l = st.l;
    final recos = DemoCatalog.creators.take(3).toList();
    return FkScaffold(
      shell: FkShellKind.brand,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              const FkAvatar(letter: 'M', size: 40),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FkSerif(DemoCatalog.brands.first.name(st.rtl), size: 24, maxLines: 1),
                    FkMuted('${l.validatedShop} · 30'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1.2,
            children: [
              FkStat(label: l.clicksToSite, value: '3 410', sub: '+24 %'),
              FkStat(label: l.activeCreators, value: '9'),
              FkStat(label: l.liveProducts, value: '24'),
              FkStat(label: l.commissionsDue, value: '412 DT'),
            ],
          ),
          const SizedBox(height: 14),
          FkCap(l.topCreators, color: FkTokens.muted, size: 10),
          for (final c in recos)
            FkListRow(
              lead: FkAvatar(asset: c.photo, size: 36),
              title: c.name(st.rtl),
              trailing: const Text('—', style: TextStyle(fontSize: 12)),
            ),
          const SizedBox(height: 12),
          FkBtn(label: l.declareSales, onTap: () {}),
        ],
      ),
    );
  }
}
