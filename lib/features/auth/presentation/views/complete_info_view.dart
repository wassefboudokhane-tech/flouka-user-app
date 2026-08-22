import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/core/widgets/flouka_primary_button.dart';
import 'package:flouka/core/widgets/flouka_screen_header.dart';
import 'package:flouka/features/auth/presentation/widgets/auth_phone_field.dart';
import 'package:flouka/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/complete_info_provider.dart';

class CompleteInfoView extends StatelessWidget {
  const CompleteInfoView({super.key, required this.isEdit});

  final bool isEdit;

  @override
  Widget build(BuildContext context) {
    final completeInfoProvider = Provider.of<CompleteInfoProvider>(context);
    completeInfoProvider.isEdit = isEdit;

    final fields = completeInfoProvider.completeInfoTextFieldList;
    final nameField = fields.firstWhere((e) => e.key == 'name');
    final emailField = fields.firstWhere((e) => e.key == 'email');
    final phoneField =
        fields.where((e) => e.key == 'phone').toList();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColor.canvasColor,
      body: SafeArea(
        child: Form(
          key: completeInfoProvider.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FloukaScreenHeader(
                title: LanguageProvider.translate(
                  'auth',
                  isEdit ? 'edit_profile' : 'complete_profile',
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.pageGutter,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        LanguageProvider.translate('auth', 'profile_hint'),
                        style: TextStyleClass.normalStyle(
                          color: AppColor.mutedColor,
                        ).copyWith(fontSize: 15, height: 1.45),
                      ),
                      const SizedBox(height: 20),
                      AuthTextField(
                        field: nameField,
                        labelKey: 'Name',
                      ),
                      const SizedBox(height: 14),
                      AuthTextField(
                        field: emailField,
                        labelKey: 'Email',
                      ),
                      if (phoneField.isNotEmpty) ...[
                        const SizedBox(height: 14),
                        AuthPhoneField(field: phoneField.first),
                      ],
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.pageGutter,
                  8,
                  AppSpacing.pageGutter,
                  16,
                ),
                child: FloukaPrimaryButton(
                  onTap: completeInfoProvider.updateProfileButton,
                  text: isEdit ? 'save' : 'sign_up',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
