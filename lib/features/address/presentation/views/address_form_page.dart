import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_radius.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/core/widgets/checkbox_widget.dart';
import 'package:flouka/core/widgets/drop_down_widget.dart';
import 'package:flouka/core/widgets/flouka_primary_button.dart';
import 'package:flouka/core/widgets/flouka_screen_header.dart';
import 'package:flouka/core/models/text_field_model.dart';
import 'package:flouka/features/address/presentation/providers/address_details_provider.dart';
import 'package:flouka/features/address/presentation/providers/area_provider.dart';
import 'package:flouka/features/address/presentation/providers/city_provider.dart';
import 'package:flouka/features/address/presentation/providers/neighborhood_provider.dart';
import 'package:flouka/features/auth/presentation/widgets/auth_phone_field.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flouka/features/navbar/presentation/provider/nav_bar_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Compact address form — delivery zone + details, no map step.
class AddressFormPage extends StatefulWidget {
  const AddressFormPage({super.key});

  @override
  State<AddressFormPage> createState() => _AddressFormPageState();
}

class _AddressFormPageState extends State<AddressFormPage> {
  bool _loadingCities = true;
  String? _labelChip; // home | work | other

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  Future<void> _bootstrap() async {
    final cityProvider = context.read<CityProvider>();
    final addressDetails = context.read<AddressDetailsProvider>();
    if (cityProvider.cities.isEmpty) {
      await cityProvider.getCities();
    }
    final name = _field(addressDetails, 'name').controller.text.trim();
    final home = LanguageProvider.translate('address', 'label_home');
    final work = LanguageProvider.translate('address', 'label_work');
    if (name.isEmpty || name == home) {
      _labelChip = 'home';
      if (name.isEmpty) {
        _field(addressDetails, 'name').controller.text = home;
      }
    } else if (name == work) {
      _labelChip = 'work';
    } else {
      _labelChip = 'other';
    }
    if (mounted) setState(() => _loadingCities = false);
  }

  TextFieldModel _field(AddressDetailsProvider p, String key) {
    return p.inputs.firstWhere((e) => e.key == key);
  }

  void _selectChip(AddressDetailsProvider p, String chip) {
    setState(() => _labelChip = chip);
    final nameField = _field(p, 'name');
    if (chip == 'home') {
      nameField.controller.text =
          LanguageProvider.translate('address', 'label_home');
    } else if (chip == 'work') {
      nameField.controller.text =
          LanguageProvider.translate('address', 'label_work');
    } else if (nameField.controller.text ==
            LanguageProvider.translate('address', 'label_home') ||
        nameField.controller.text ==
            LanguageProvider.translate('address', 'label_work')) {
      nameField.controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final addressDetails = context.watch<AddressDetailsProvider>();
    final cityProvider = context.watch<CityProvider>();
    final areaProvider = context.watch<AreaProvider>();
    final neighborhood = context.watch<NeighborhoodProvider>();
    final isEdit = addressDetails.addressEntity != null;
    final zoneReady = cityProvider.cityEntity != null &&
        areaProvider.areaEntity != null &&
        neighborhood.neighborhood != null;

    return Scaffold(
      backgroundColor: AppColor.canvasColor,
      body: SafeArea(
        child: Form(
          key: addressDetails.formKey,
          child: Column(
            children: [
              FloukaScreenHeader(
                title: LanguageProvider.translate(
                  'address',
                  isEdit ? 'edit_address' : 'add_address',
                ),
                trailing: addressDetails.firstAddress
                    ? TextButton(
                        onPressed: () {
                          context.read<NavBarProvider>().goToNavView();
                        },
                        child: Text(
                          LanguageProvider.translate(
                            'address',
                            'skip_for_now',
                          ),
                          style: TextStyleClass.captionStyle(
                            color: AppColor.primaryColor,
                          ).copyWith(fontWeight: FontWeight.w700, fontSize: 12),
                        ),
                      )
                    : null,
              ),
              Expanded(
                child: _loadingCities
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.pageGutter,
                          4,
                          AppSpacing.pageGutter,
                          24,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _FieldLabel(
                              LanguageProvider.translate(
                                'inputs',
                                'address_name',
                              ),
                            ),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                _LabelChip(
                                  label: LanguageProvider.translate(
                                    'address',
                                    'label_home',
                                  ),
                                  selected: _labelChip == 'home',
                                  onTap: () =>
                                      _selectChip(addressDetails, 'home'),
                                ),
                                _LabelChip(
                                  label: LanguageProvider.translate(
                                    'address',
                                    'label_work',
                                  ),
                                  selected: _labelChip == 'work',
                                  onTap: () =>
                                      _selectChip(addressDetails, 'work'),
                                ),
                                _LabelChip(
                                  label: LanguageProvider.translate(
                                    'address',
                                    'label_other',
                                  ),
                                  selected: _labelChip == 'other',
                                  onTap: () =>
                                      _selectChip(addressDetails, 'other'),
                                ),
                              ],
                            ),
                            if (_labelChip == 'other') ...[
                              const SizedBox(height: 12),
                              _AddressTextField(
                                field: _field(addressDetails, 'name'),
                                labelKey: 'address_name',
                                hintKey: 'address_name_hint',
                                showLabel: false,
                              ),
                            ],
                            const SizedBox(height: 16),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      _FieldLabel(
                                        LanguageProvider.translate(
                                          'inputs',
                                          'government',
                                        ),
                                      ),
                                      DropDownWidget(
                                        dropDownClass: cityProvider,
                                        color: Colors.white,
                                        borderColor: AppColor.borderColor,
                                        borderRadius: 14,
                                        padding: 14,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      _FieldLabel(
                                        LanguageProvider.translate(
                                          'inputs',
                                          'city',
                                        ),
                                      ),
                                      DropDownWidget(
                                        dropDownClass: areaProvider,
                                        color: Colors.white,
                                        borderColor: AppColor.borderColor,
                                        borderRadius: 14,
                                        padding: 14,
                                        canPress:
                                            cityProvider.cityEntity != null,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            if (cityProvider.cities.isEmpty)
                              _HintText(
                                LanguageProvider.translate(
                                  'address',
                                  'cities_unavailable',
                                ),
                                alert: true,
                              ),
                            const SizedBox(height: 12),
                            _FieldLabel(
                              LanguageProvider.translate(
                                'inputs',
                                'neighborhood',
                              ),
                            ),
                            DropDownWidget(
                              dropDownClass: neighborhood,
                              color: Colors.white,
                              borderColor: AppColor.borderColor,
                              borderRadius: 14,
                              padding: 14,
                              canPress: areaProvider.areaEntity != null,
                            ),
                            if (areaProvider.areaEntity == null)
                              _HintText(
                                LanguageProvider.translate(
                                  'address',
                                  cityProvider.cityEntity == null
                                      ? 'select_governorate_first'
                                      : 'select_city_first',
                                ),
                              ),
                            const SizedBox(height: 14),
                            _AddressTextField(
                              field: _field(addressDetails, 'address'),
                              labelKey: 'address_details',
                              hintKey: 'address_details_hint',
                              maxLines: 2,
                            ),
                            const SizedBox(height: 12),
                            AuthPhoneField(
                              field: _field(addressDetails, 'phone'),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CheckBoxWidget(
                                  check: addressDetails.isMakeDefault,
                                  onChange: (_) {
                                    if (!addressDetails.firstAddress) {
                                      addressDetails.changeIsMakeDefault();
                                    }
                                  },
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    LanguageProvider.translate(
                                      'address',
                                      'make_default',
                                    ),
                                    style: TextStyleClass.normalStyle(
                                      color: AppColor.inkColor,
                                    ).copyWith(height: 1.4, fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (zoneReady)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            Container(
                              width: 7,
                              height: 7,
                              decoration: BoxDecoration(
                                color: const Color(0xFF2F9E44),
                                borderRadius: BorderRadius.circular(99),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                LanguageProvider.translate(
                                  'address',
                                  'zone_covered',
                                ),
                                style: TextStyleClass.captionStyle(
                                  color: const Color(0xFF2F9E44),
                                ).copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    FloukaPrimaryButton(
                      onTap: () {
                        if (_labelChip != null && _labelChip != 'other') {
                          final key = _labelChip == 'home'
                              ? 'label_home'
                              : 'label_work';
                          _field(addressDetails, 'name').controller.text =
                              LanguageProvider.translate('address', key);
                        }
                        if (addressDetails.formKey.currentState!.validate() &&
                            cityProvider.cityEntity != null &&
                            areaProvider.areaEntity != null &&
                            neighborhood.neighborhood != null) {
                          addressDetails.addressButtonAction();
                        } else {
                          addressDetails.submitAddressForm();
                        }
                      },
                      text: LanguageProvider.translate(
                        'address',
                        'save_address',
                      ),
                      translateKey: false,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LabelChip extends StatelessWidget {
  const _LabelChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColor.deepColor : AppColor.backgroundColor,
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: Border.all(
              color: selected ? AppColor.deepColor : AppColor.borderColor,
            ),
          ),
          child: Text(
            label,
            style: TextStyleClass.captionStyle(
              color: selected ? Colors.white : AppColor.deepColor,
            ).copyWith(fontWeight: FontWeight.w700, fontSize: 12.5),
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyleClass.normalStyle(color: AppColor.inkColor)
            .copyWith(fontWeight: FontWeight.w600, fontSize: 14),
      ),
    );
  }
}

class _HintText extends StatelessWidget {
  const _HintText(this.text, {this.alert = false});

  final String text;
  final bool alert;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Text(
        text,
        style: TextStyleClass.captionStyle(
          color: alert ? AppColor.alertColor : AppColor.mutedColor,
        ),
      ),
    );
  }
}

class _AddressTextField extends StatelessWidget {
  const _AddressTextField({
    required this.field,
    required this.labelKey,
    this.hintKey,
    this.maxLines = 1,
    this.showLabel = true,
  });

  final TextFieldModel field;
  final String labelKey;
  final String? hintKey;
  final int maxLines;
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    final hint = hintKey != null
        ? LanguageProvider.translate('inputs', hintKey!)
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel)
          _FieldLabel(LanguageProvider.translate('inputs', labelKey)),
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
            maxLines: maxLines,
            minLines: maxLines > 1 ? maxLines : 1,
            keyboardType:
                maxLines > 1 ? TextInputType.multiline : TextInputType.text,
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

