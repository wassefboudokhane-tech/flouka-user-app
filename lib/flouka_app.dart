import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:toastification/toastification.dart';

import 'core/config/app_theme.dart';
import 'core/constants/constants.dart';
import 'core/network/connectivity_status_provider.dart';
import 'core/widgets/offline_banner_widget.dart';
import 'core/widgets/session_expired_recovery_widget.dart';
import 'features/chatbot/presentation/providers/chat_provider.dart';
import 'features/chatbot/presentation/widgets/floating_chat_bubble.dart';
import 'features/language/domain/entities/app_localizations.dart';
import 'features/language/presentation/provider/language_provider.dart';
import 'features/splash/views/splash_view.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, lang, _) {
        return ToastificationWrapper(
          child: Sizer(
            builder: (context, orientation, deviceType) {
              Constants.isTablet = (deviceType == ScreenType.tablet);
              return AnnotatedRegion(
                value: lightBarColor(),
                child: MaterialApp(
                  title: 'Flouka',
                  debugShowCheckedModeBanner: false,
                  navigatorObservers: [routeObserver],
                  navigatorKey: Constants.navState,
                  locale: lang.appLocal,
                  supportedLocales: LanguageProvider.languages,
                  localizationsDelegates: [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  theme: defaultTheme,
                  home: const SplashView(),
                  builder: (context, child) {
                    return Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                          },
                          child: MediaQuery(
                            data: MediaQuery.of(
                              context,
                            ).copyWith(textScaler: const TextScaler.linear(1.0)),
                            child: Container(
                              color: Colors.white,
                              width: 100.w,
                              height: 100.h,
                              child: child!,
                            ),
                          ),
                        ),
                        Consumer<ChatBotProvider>(
                            builder: (context,chat,_) {
                              if((!chat.insidePage&&chat.insideApp)){
                                return const Stack(
                                  children: [
                                    FloatingChatBubble(),
                                  ],
                                );
                              }
                              return SizedBox.shrink();


                            }
                        ),
                        Consumer<ConnectivityStatusProvider>(
                          builder: (context, connectivity, _) {
                            return Stack(
                              children: [
                                if (connectivity.isOffline)
                                  Positioned(
                                    top: 0,
                                    left: 0,
                                    right: 0,
                                    child: OfflineBannerWidget(
                                      onRetry: () =>
                                          connectivity.retryLastAction(),
                                    ),
                                  ),
                                if (connectivity.sessionExpired)
                                  Positioned.fill(
                                    child: const ColoredBox(
                                      color: Colors.black54,
                                      child: Center(
                                        child: SingleChildScrollView(
                                          padding: EdgeInsets.all(16),
                                          child: SessionExpiredRecoveryWidget(),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}

RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
