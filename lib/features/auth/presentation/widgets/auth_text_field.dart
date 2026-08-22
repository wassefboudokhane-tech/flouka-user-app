import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/core/models/text_field_model.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Text input matching [AuthPhoneField] shell (radius 14, padding, typo).
class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    required this.field,
    this.labelKey,
    this.hintKey,
    this.maxLines = 1,
    this.readOnly = false,
    this.inputFormatters,
  });

  final TextFieldModel field;
  final String? labelKey;
  final String? hintKey;
  final int maxLines;
  final bool readOnly;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    final label = labelKey ?? field.label ?? field.key;
    final hint = hintKey != null
        ? LanguageProvider.translate('inputs', hintKey!)
        : (field.hint != null
            ? LanguageProvider.translate('inputs', field.hint!)
            : null);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LanguageProvider.translate('inputs', label),
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
          child: TextFormField(
            controller: field.controller,
            validator: field.validator,
            readOnly: readOnly || field.readOnly,
            maxLines: maxLines,
            minLines: maxLines > 1 ? maxLines : 1,
            keyboardType: field.textInputType ?? TextInputType.text,
            inputFormatters: inputFormatters,
            style: TextStyleClass.textFieldStyle().copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyleClass.textFieldStyle(
                color: AppColor.mutedColor,
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
              isDense: true,
            ),
          ),
        ),
      ],
    );
  }
}
