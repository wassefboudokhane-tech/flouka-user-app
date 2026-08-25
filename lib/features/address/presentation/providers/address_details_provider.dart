import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flouka/core/pending_address_store.dart';
import 'package:flouka/features/address/presentation/providers/neighborhood_provider.dart';
import 'package:flouka/features/cart/presentation/providers/cart_operation_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../../../../core/constants/constants.dart';
import '../../../../../core/dialog/snack_bar.dart';
import '../../../../../core/dialog/success_dialog.dart';
import '../../../../../core/helper_function/loading.dart';
import '../../../../../core/helper_function/location.dart';
import '../../../../../core/helper_function/navigation.dart';
import '../../../../../core/helper_function/text_form_field_validation.dart';
import '../../../../../core/models/text_field_model.dart';
import '../../../../../injection_container.dart';
import '../../../../core/constants/app_lotties.dart';
import '../../../../core/dialog/new_success_dialog.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/widgets/country_widget.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../../language/presentation/provider/language_provider.dart';
import '../../../navbar/presentation/provider/nav_bar_provider.dart';
import '../../domain/entities/address_entity.dart';
import '../../domain/usecase/address_usecase.dart';
import '../../domain/usecase/city_usecase.dart';
import '../views/address_form_page.dart';
import '../views/select_address_map_page.dart';
import 'address_provider.dart';
import 'area_provider.dart';
import 'city_provider.dart';

class AddressDetailsProvider extends ChangeNotifier {
  final CityUseCases cityUseCases = CityUseCases(sl());
  final AddressUseCases addressUseCases;
  AddressDetailsProvider(this.addressUseCases);
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isMakeDefault = false;
  void changeIsMakeDefault() {
    isMakeDefault = !isMakeDefault;
    notifyListeners();
  }

  String addressName = 'home';
  TextEditingController addressNameController = TextEditingController();
  String title = 'add_address';
  CameraPosition? currentPos;
  GoogleMapController? controller;
  late double lat, lng;
  AddressEntity? addressEntity;
  String description = '';
  String? otpPhoneCode = '';
  List<TextFieldModel> inputs = [
    TextFieldModel(
      controller: TextEditingController(),
      key: 'name',
      label: 'address_name',
      validator: (value) => validateAddressName(value),
    ),
    TextFieldModel(
      controller: TextEditingController(),
      key: 'address',
      label: 'address_details',
      validator: (value) => validateAddressDetails(value),
    ),
    TextFieldModel(
      controller: TextEditingController(),
      key: 'phone',
      length: 8,
      label: 'phone',
      textInputType: TextInputType.phone,
      validator: (value) => validatePhone(value),
    ),
    // TextFieldModel(
    //   controller: TextEditingController(),
    //   key: 'notes',
    //   label: 'notes',
    //   max: 5,
    //   validator: (value) => null,
    // ),
  ];

  void resetData() {
    currentPos = null;
    controller = null;
    firstAddress = false;
    description = '';
    addressEntity = null;
    for (var i in inputs) {
      i.controller.clear();
    }
  }

  Future getDescription() async {
    // description = await getStreetText(
    //   LatLng(lat, lng),
    // );
  }

  void setDataController(GoogleMapController controller) {
    this.controller = controller;
  }

  void setData(double lat, double lng) {
    this.lat = lat;
    this.lng = lng;
    setMarker();
  }

  CityProvider cityProvider = Provider.of(
    Constants.globalContext(),
    listen: false,
  );
  AreaProvider areaProvider = Provider.of(
    Constants.globalContext(),
    listen: false,
  );
  NeighborhoodProvider neighborhoodProvider = Provider.of(
    Constants.globalContext(),
    listen: false,
  );
  // PartsProvider partsProvider = Provider.of(
  //   Constants.globalContext(),
  //   listen: false,
  // );

  void submitAddressForm() {
    String nameError = '';
    if (cityProvider.cityEntity == null) {
      nameError += '${validateCity()}\n';
    }

    if (areaProvider.areaEntity == null) {
      nameError += '${validateArea()}\n';
    }
    if (neighborhoodProvider.neighborhood == null) {
      nameError += '${validateNeighborhood()}\n';
    }

    for (var element in inputs) {
      if (element.controller.text.isEmpty && element.validator != null) {
        String? error = element.validator!(element.controller.text);
        if (error != null && error.isNotEmpty) {
          nameError += '$error\n';
        }
      }
    }

    if (nameError.isEmpty) {
    } else {
      showToast(nameError.trim());
    }
  }

  void addAddress() async {
    Map<String, dynamic> data = addressData();
    loading();
    Either<DioException, AddressEntity> value = await addressUseCases
        .createAddress(data);
    dismissLoading();
    await value.fold(
      (l) async {
        final msg = l.message ?? '';
        if (_isAuthError(msg)) {
          await _startOtpThenSave(
            data,
            operation: PendingAddressOperation.create,
          );
          return;
        }
        showToast(msg);
      },
      (r) async {
        await _onAddressCreated(r);
      },
    );
  }

  bool _isAuthError(String message) {
    final text = message.toLowerCase();
    return text.contains('identifiant') ||
        text.contains('credential') ||
        text.contains('unauthenticated') ||
        text.contains('unauthorized') ||
        text.contains('token') ||
        text.contains('401');
  }

  Future<void> _startOtpThenSave(
    Map<String, dynamic> data, {
    required PendingAddressOperation operation,
  }) async {
    final auth = Provider.of<AuthProvider>(
      Constants.globalContext(),
      listen: false,
    );
    auth.clearSessionLocal();
    final phone = (data['phone'] ?? '').toString().trim();
    final phoneError = validatePhone(phone);
    if (phoneError != null) {
      showToast(phoneError);
      return;
    }
    if (data['phone_code'] != null) {
      defaultCountry = '+${data['phone_code']}';
    }
    PendingAddressStore.save(data, forOperation: operation);
    showToast(
      LanguageProvider.translate('address', 'verify_phone_to_save'),
      isSnack: true,
    );
    await auth.sendOtpForPhone(phone);
  }

  Future<void> flushPendingAddress() async {
    final data = PendingAddressStore.data;
    if (data == null) return;
    final operation = PendingAddressStore.operation;
    loading();
    final value = operation == PendingAddressOperation.update
        ? await addressUseCases.updateAddress(data)
        : await addressUseCases.createAddress(data);
    dismissLoading();
    await value.fold(
      (l) async {
        showToast(l.message ?? LanguageProvider.translate('error', 'error'));
      },
      (r) async {
        PendingAddressStore.clear();
        if (operation == PendingAddressOperation.update) {
          final addressProvider = Provider.of<AddressProvider>(
            Constants.globalContext(),
            listen: false,
          );
          addressProvider.updateAddress(r);
          await Provider.of<AuthProvider>(
            Constants.globalContext(),
            listen: false,
          ).getProfile(fromAddress: true);
          Provider.of<NavBarProvider>(
            Constants.globalContext(),
            listen: false,
          ).goToNavView();
        } else {
          await _onAddressCreated(r, fromPendingOtp: true);
        }
      },
    );
  }

  Future<void> _onAddressCreated(
    AddressEntity r, {
    bool fromPendingOtp = false,
  }) async {
    final addressProvider = Provider.of<AddressProvider>(
      Constants.globalContext(),
      listen: false,
    );
    addressProvider.addAddress(r);
    final auth = Provider.of<AuthProvider>(
      Constants.globalContext(),
      listen: false,
    );
    if (auth.userEntity != null) {
      auth.userEntity!.addressEntity = r;
      auth.rebuild();
    }
    final shouldPopTwice = !firstAddress && !fromPendingOtp;
    newSuccessDialog(
      lottie: Lotties.address,
      then: () {
        clear();
        if (fromPendingOtp) {
          Provider.of<NavBarProvider>(
            Constants.globalContext(),
            listen: false,
          ).goToNavView();
          return;
        }
        if (!shouldPopTwice) return;
        _safePopRoutes(2);
      },
    );
  }

  void clear() {
    for (var i in inputs) {
      i.controller.clear();
    }
    areaProvider.areaEntity = null;
    neighborhoodProvider.neighborhood = null;
    cityProvider.cityEntity = null;
    // partsProvider.selectedPart = null;
  }

  void updateAddress() async {
    Map<String, dynamic> data = addressData();
    data['address_id'] = addressEntity?.id;
    loading();
    Either<DioException, AddressEntity> value = await addressUseCases
        .updateAddress(data);
    dismissLoading();
    value.fold(
      (l) {
        final msg = l.message ?? '';
        if (_isAuthError(msg)) {
          _startOtpThenSave(data, operation: PendingAddressOperation.update);
          return;
        }
        showToast(msg);
      },
      (r) {
        AddressProvider addressProvider = Provider.of(
          Constants.globalContext(),
          listen: false,
        );
        addressProvider.updateAddress(r);
        Provider.of<AuthProvider>(
          Constants.globalContext(),
          listen: false,
        ).getProfile(fromAddress: true);
        if (r.isDefault == true) {
          addressProvider.changeDefault(id: r.id!);
          CartProvider cartProvider = Provider.of(
            Constants.globalContext(),
            listen: false,
          );
          cartProvider.deleteCart();
        }
        // playSuccessSound(path: 'success.mp4');
        successDialog(
          then: () {
            clear();
            _safePopRoutes(2);
          },
        );
      },
    );
  }

  bool isSaveWidget = false;
  void isSaveToggle() {
    isSaveWidget = !isSaveWidget;
    notifyListeners();
  }

  void addressButtonAction() {
    if (addressEntity == null) {
      _saveNewAddress();
    } else {
      updateAddress();
    }
  }

  Future<void> _saveNewAddress() async {
    if (!AuthProvider.isLogin()) {
      await _startOtpThenSave(
        addressData(),
        operation: PendingAddressOperation.create,
      );
      return;
    }
    addAddress();
  }

  void _safePopRoutes(int count) {
    final ctx = Constants.globalContext();
    if (!ctx.mounted) return;
    for (var i = 0; i < count; i++) {
      if (!Navigator.of(ctx).canPop()) break;
      Navigator.of(ctx).pop();
    }
  }

  Map<String, dynamic> addressData() {
    Map<String, dynamic> data = {};
    //
    for (var i in inputs) {
      data[i.key] = i.controller.text;
    }
    data['area_id'] = areaProvider.areaEntity!.id;
    data['neighborhood_id'] = neighborhoodProvider.neighborhood!.id;
    data['lat'] = lat;
    data['lng'] = lng;
    if (isMakeDefault != false) {
      data['default'] = isMakeDefault;
    }
    if (addressEntity != null) {
      data['id'] = addressEntity!.id;
    }
    data['phone_code'] = defaultCountry.toString().replaceFirst('+', "");
    return data;
  }

  void setMarker() async {
    LatLng latLng = LatLng(lat, lng);
    controller?.moveCamera(CameraUpdate.newLatLng(latLng));
    notifyListeners();
  }

  bool firstAddress = false;

  /// Opens the compact address form (GPS in background — no map step).
  Future<String?> goToAddressDetailsPage({
    AddressEntity? addressEntity,
    bool firstAddress = false,
  }) async {
    try {
      isMakeDefault = addressEntity?.isDefault ?? false;
      if (isMakeDefault) {
        this.firstAddress = true;
      }
      final authProvider = Provider.of<AuthProvider>(
        Constants.globalContext(),
        listen: false,
      );
      defaultCountry = addressEntity?.phoneCode == null
          ? (authProvider.userEntity?.phoneCode == null
                ? '+216'
                : '+${authProvider.userEntity!.phoneCode!}')
          : '+${addressEntity!.phoneCode!}';
      final length = CountryWidget.getLength;
      inputs.firstWhere((element) => element.key == 'phone').length = length;
      otpPhoneCode = defaultCountry;
      inputs.firstWhere((element) => element.key == 'phone').controller.text =
          addressEntity?.phone ?? (authProvider.userEntity?.phone ?? '');
      if (addressEntity != null) {
        otpPhoneCode = addressEntity.phoneCode;
        title = 'edit_address';
        this.addressEntity = addressEntity;
        setData(addressEntity.lat!, addressEntity.lng!);
        setInputsData();
      } else {
        title = 'add_address';
        clear();
        if (firstAddress) {
          isMakeDefault = true;
          this.firstAddress = true;
        }
        // Prefill for faster signup
        final phone = authProvider.userEntity?.phone ?? '';
        inputs.firstWhere((e) => e.key == 'phone').controller.text = phone;
        inputs.firstWhere((e) => e.key == 'name').controller.text =
            LanguageProvider.translate('address', 'default_address_name');

        loading();
        try {
          final position = await determinePosition();
          if (position == null) {
            dismissLoading();
            return null;
          }
          setData(position.latitude, position.longitude);
        } catch (_) {
          dismissLoading();
          return null;
        }
        navPop();
      }

      await Provider.of<CityProvider>(
        Constants.globalContext(),
        listen: false,
      ).getCities();

      navP(
        const AddressFormPage(),
        then: (val) async {
          resetData();
        },
      );
    } catch (e) {
      showToast(LanguageProvider.translate('error', 'error'));
    }
    return null;
  }

  /// Optional map picker (mobile) — kept for advanced edit flows.
  Future<void> goToMapPicker() async {
    navP(const SelectAddressMapPage());
  }

  void setInputsData() async {
    final authProvider = Provider.of<AuthProvider>(
      Constants.globalContext(),
      listen: false,
    );

    // final partsProvider = Provider.of<PartsProvider>(Constants.globalContext(), listen: false,);

    if (addressEntity!.areaEntity != null) {
      print(addressEntity!.areaId);
      print(addressEntity!.areaEntity);
      cityProvider.cityEntity = cityProvider.cities.firstWhere(
        (element) => element.id == addressEntity!.areaEntity!.cityId,
      );
      await areaProvider.getArea(
        id: cityProvider.cityEntity!.id,
        fromAddress: true,
      );
      areaProvider.areaEntity = areaProvider.areas.firstWhere(
        (element) => element.id == addressEntity!.areaEntity!.id,
      );
      await neighborhoodProvider.getNeighborhood(
        id: areaProvider.areaEntity!.id,
        fromAddress: true,
      );
      neighborhoodProvider.neighborhood = neighborhoodProvider.neighborhoods
          .firstWhere(
            (element) => element.id == addressEntity!.neighborhoodEntity!.id,
          );
    }

    // partsProvider.selectedPart = partsProvider.parts.firstWhere(
    //   (element) => element == addressEntity!.partNumber,
    // );

    inputs.firstWhere((element) => element.key == 'phone').controller.text =
        addressEntity!.phone ?? (authProvider.userEntity?.phone ?? "");
    inputs.firstWhere((element) => element.key == 'name').controller.text =
        addressEntity!.addressName ?? "";
    inputs.firstWhere((element) => element.key == 'address').controller.text =
        addressEntity!.address ?? "";
  }

  void animateToMyLocation() async {
    final latLng = await determinePosition();
    if (latLng == null) return;
    moveCameraTo(latLng);
  }

  Future<void> moveCameraTo(LatLng target, {double? zoom}) async {
    if (controller == null) return;
    await controller!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: target, zoom: zoom ?? 18),
      ),
    );
    notifyListeners();
  }
}
