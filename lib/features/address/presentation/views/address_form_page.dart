import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_radius.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/core/widgets/checkbox_widget.dart';
import 'package:flouka/core/widgets/drop_down_widget.dart';
import 'package:flouka/core/widgets/flouka_primary_button.dart';
import 'package:flouka/core/widgets/list_text_field_widget.dart';
import 'package:flouka/features/address/presentation/providers/address_details_provider.dart';
import 'package:flouka/features/address/presentation/providers/area_provider.dart';
import 'package:flouka/features/address/presentation/providers/city_provider.dart';
import 'package:flouka/features/address/presentation/providers/neighborhood_provider.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flouka/features/navbar/presentation/provider/nav_bar_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Compact address form — no map step (GPS captured in the background).
class AddressFormPage extends StatefulWidget {
  const AddressFormPage({super.key});

  @override
  State<AddressFormPage> createState() => _AddressFormPageState();
}

class _AddressFormPageState extends State<AddressFormPage> {
  bool _loadingCities = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  Future<void> _bootstrap() async {
    final cityProvider = context.read<CityProvider>();
    if (cityProvider.cities.isEmpty) {
      await cityProvider.getCities();
    }
    if (mounted) setState(() => _loadingCities = false);
  }

  @override
  Widget build(BuildContext context) {
    final addressDetails = context.watch<AddressDetailsProvider>();
    final cityProvider = context.watch<CityProvider>();
    final areaProvider = context.watch<AreaProvider>();
    final neighborhood = context.watch<NeighborhoodProvider>();

    return Scaffold(
      backgroundColor: AppColor.canvasColor,
      appBar: AppBar(
        title: Text(
          LanguageProvider.translate(
            'address',
            addressDetails.addressEntity == null ? 'add_address' : 'edit_address',
          ),
        ),
        actions: [
          if (addressDetails.firstAddress)
            TextButton(
              onPressed: () {
                Provider.of<NavBarProvider>(context, listen: false).goToNavView();
              },
              child: Text(
                LanguageProvider.translate('address', 'skip_for_now'),
                style: TextStyleClass.captionStyle(color: Colors.white)
                    .copyWith(fontWeight: FontWeight.w600),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: addressDetails.formKey,
          child: Column(
            children: [
              Expanded(
                child: _loadingCities
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.pageGutter,
                          16,
                          AppSpacing.pageGutter,
                          24,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              LanguageProvider.translate(
                                'address',
                                'ask_address_short',
                              ),
                              style: TextStyleClass.normalStyle(
                                color: AppColor.mutedColor,
                              ).copyWith(fontSize: 14, height: 1.4),
                            ),
                            const SizedBox(height: 20),
                            _Label(
                              LanguageProvider.translate('inputs', 'government'),
                            ),
                            DropDownWidget(
                              dropDownClass: cityProvider,
                              color: Colors.white,
                              borderColor: AppColor.borderColor,
                              borderRadius: AppRadius.btn,
                            ),
                            if (cityProvider.cities.isEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Text(
                                  LanguageProvider.translate(
                                    'address',
                                    'cities_unavailable',
                                  ),
                                  style: TextStyleClass.captionStyle(
                                    color: AppColor.alertColor,
                                  ),
                                ),
                              ),
                            const SizedBox(height: 14),
                            _Label(
                              LanguageProvider.translate('inputs', 'city'),
                            ),
                            DropDownWidget(
                              dropDownClass: areaProvider,
                              color: Colors.white,
                              borderColor: AppColor.borderColor,
                              borderRadius: AppRadius.btn,
                              canPress: cityProvider.cityEntity != null,
                            ),
                            const SizedBox(height: 14),
                            _Label(
                              LanguageProvider.translate(
                                'inputs',
                                'neighborhood',
                              ),
                            ),
                            DropDownWidget(
                              dropDownClass: neighborhood,
                              color: Colors.white,
                              borderColor: AppColor.borderColor,
                              borderRadius: AppRadius.btn,
                              canPress: areaProvider.areaEntity != null,
                            ),
                            const SizedBox(height: 8),
                            ListTextFieldWidget(inputs: addressDetails.inputs),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                CheckBoxWidget(
                                  check: addressDetails.isMakeDefault,
                                  onChange: (_) {
                                    if (!addressDetails.firstAddress) {
                                      addressDetails.changeIsMakeDefault();
                                    }
                                  },
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    LanguageProvider.translate(
                                      'address',
                                      'make_default',
                                    ),
                                    style: TextStyleClass.normalStyle(),
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
                child: FloukaPrimaryButton(
                  onTap: () {
                    if (addressDetails.formKey.currentState!.validate() &&
                        cityProvider.cityEntity != null &&
                        areaProvider.areaEntity != null &&
                        neighborhood.neighborhood != null) {
                      addressDetails.addressButtonAction();
                    } else {
                      addressDetails.submitAddressForm();
                    }
                  },
                  text: 'save_and_continue',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);

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
