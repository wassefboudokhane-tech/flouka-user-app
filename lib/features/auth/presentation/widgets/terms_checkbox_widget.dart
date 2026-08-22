import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/core/helper_function/navigation.dart';
import 'package:flouka/core/widgets/checkbox_widget.dart';
import 'package:flouka/features/auth/presentation/providers/auth_provider.dart';
import 'package:flouka/features/settings/domain/entities/settings_entity.dart';
import 'package:flouka/features/settings/presentation/provider/settings_provider.dart';
import 'package:flouka/features/settings/presentation/views/web_view.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../../features/language/presentation/provider/language_provider.dart';

class TermsCheckboxWidget extends StatelessWidget {
  const TermsCheckboxWidget({super.key});

  void _openLink(BuildContext context, {required String title, required String link}) {
    navP(WebViewPage(title: title, link: link));
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final SettingsEntity? settings =
        context.watch<SettingsProvider>().settingsEntity;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CheckBoxWidget(
                check: authProvider.termsAccepted,
                onChange: authProvider.toggleTermsAccepted,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    style: TextStyleClass.normalStyle(),
                    children: [
                      TextSpan(
                        text: LanguageProvider.translate("auth", "agree_terms_prefix"),
                      ),
                      TextSpan(
                        text: LanguageProvider.translate("auth", "terms_of_use"),
                        style: TextStyleClass.normalStyle().copyWith(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w600,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            if (settings == null) return;
                            _openLink(
                              context,
                              title: 'terms',
                              link: settings.termsLink,
                            );
                          },
                      ),
                      TextSpan(
                        text: LanguageProvider.translate("auth", "agree_terms_and"),
                      ),
                      TextSpan(
                        text: LanguageProvider.translate("auth", "privacy_policy"),
                        style: TextStyleClass.normalStyle().copyWith(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w600,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            if (settings == null) return;
                            _openLink(
                              context,
                              title: 'privacy_policy',
                              link: settings.privacyLink,
                            );
                          },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
