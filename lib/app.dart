import 'package:clarity_flutter/clarity_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flouka/core/env.dart';
import 'package:flouka/core/theme.dart';
import 'package:flouka/state/flouka_state.dart';

class FloukaApp extends StatefulWidget {
  const FloukaApp({super.key, required this.state, required this.router});

  final FloukaState state;
  final GoRouter router;

  @override
  State<FloukaApp> createState() => _FloukaAppState();
}

class _FloukaAppState extends State<FloukaApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.state,
      child: AnimatedBuilder(
        animation: widget.state,
        builder: (context, _) {
          final rtl = widget.state.rtl;
          Widget app = MaterialApp.router(
            title: 'Flouka',
            debugShowCheckedModeBanner: false,
            theme: FkTheme(rtl).data,
            locale: Locale(widget.state.l.code),
            supportedLocales: const [Locale('fr'), Locale('ar')],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            routerConfig: widget.router,
            builder: (context, child) {
              return Directionality(
                textDirection: rtl ? TextDirection.rtl : TextDirection.ltr,
                child: child ?? const SizedBox.shrink(),
              );
            },
          );
          if (widget.state.analyticsAllowed && FkEnv.instance.hasClarity) {
            app = ClarityWidget(
              app: app,
              clarityConfig: ClarityConfig(projectId: FkEnv.instance.clarityId),
            );
          }
          return app;
        },
      ),
    );
  }
}
