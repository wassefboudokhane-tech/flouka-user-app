import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/core/models/text_field_model.dart';
import 'package:flouka/features/auth/presentation/widgets/country_widget.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Phone input — fixed +216 (Tunisia), mockup hi-fi.
class AuthPhoneField extends StatelessWidget {
  const AuthPhoneField({super.key, required this.field});

  final TextFieldModel field;

  @override
  Widget build(BuildContext context) {
    CountryWidget.getLength;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LanguageProvider.translate('inputs', field.label ?? 'Number'),
          style: TextStyleClass.normalStyle(color: AppColor.inkColor).copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColor.backgroundColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColor.borderColor),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            children: [
              Text('🇹🇳', style: const TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Text(
                defaultCountry,
                style: TextStyleClass.smallStyle(color: AppColor.deepColor)
                    .copyWith(fontWeight: FontWeight.w700),
              ),
              Container(
                width: 1,
                height: 28,
                margin: const EdgeInsets.symmetric(horizontal: 12),
                color: AppColor.borderColor,
              ),
              Expanded(
                child: TextFormField(
                  controller: field.controller,
                  keyboardType: TextInputType.phone,
                  readOnly: field.readOnly,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(phoneLength),
                  ],
                  validator: field.validator,
                  style: TextStyleClass.textFieldStyle().copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                  decoration: InputDecoration(
                    hintText:
                        LanguageProvider.translate('inputs', 'phone_hint'),
                    hintStyle: TextStyleClass.textFieldStyle(
                      color: AppColor.mutedColor,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          LanguageProvider.translate('inputs', 'phone_hint'),
          style: TextStyleClass.captionStyle(color: AppColor.mutedColor)
              .copyWith(fontSize: 11.5),
        ),
      ],
    );
  }
}
