import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/dialog/snack_bar.dart';
import '../../../../core/helper_function/loading.dart';
import '../../../../core/helper_function/navigation.dart';
import '../../../../core/pending_address_store.dart';
import '../../../address/presentation/providers/address_details_provider.dart';
import '../../../language/presentation/provider/language_provider.dart';
import '../../domain/usecases/auth_use_case.dart';
import '../views/otp_view.dart';
import '../widgets/country_widget.dart';
import 'auth_provider.dart';
import 'complete_info_provider.dart';

class OtpProvider extends ChangeNotifier {
  final AuthUseCase authUsceCase;
  Timer? timer;
  int counter = 60;
  late bool isEdit;
  String? otpPhoneCode = '';
  late PinInputController otpController;

  OtpProvider(this.authUsceCase) {
    otpController = PinInputController();
  }

  String _otpValue = '';
  String? lastOtpError;

  bool get isOtpComplete => _otpValue.length == 4;

  void onOtpChanged(String value) {
    _otpValue = value;
    if (lastOtpError != null) lastOtpError = null;
    notifyListeners();
  }

  /// Fresh controller when entering OTP step (unified login screen).
  void prepareOtpStep() {
    otpController = PinInputController();
    _otpValue = '';
    lastOtpError = null;
    startTimer();
  }

  void startTimer() {
    otpController.clear();
    counter = 60;
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (e) {
      if (timer?.isActive ?? false) {
        try {
          counter--;
          notifyListeners();
        } catch (e) {
          debugPrint("$e");
        }
      }
      if (counter == 0) {
        e.cancel();
      }
    });
    notifyListeners();
  }

  void stopTimer() {
    timer?.cancel();
  }

  void goToOTPView() {
    prepareOtpStep();
    navP(const OTPView());
  }

  Future<void> checkCode({bool isRegister = true}) async {
    AuthProvider authProvider = Provider.of<AuthProvider>(
      Constants.globalContext(),
      listen: false,
    );

    Map<String, dynamic> data = {};
    data["otp"] = otpController.text.trim();
    data["phone"] = authProvider.loginTextFieldList[0].controller.text;
    data['phone_code'] = defaultCountry.toString().replaceFirst('+', "");
    loading();
    final result = await authUsceCase.checkCode(data);
    navPop();
    await result.fold(
      (l) async {
        lastOtpError =
            l.message ?? LanguageProvider.translate('error', 'error');
        notifyListeners();
        showToast(lastOtpError!);
      },
      (r) async {
        final pendingAddress = PendingAddressStore.hasData;
        final needsProfile = r.name == null || r.name!.trim().isEmpty;
        await authProvider.loginSuccess(
          r,
          skipHome: pendingAddress || needsProfile,
        );
        if (pendingAddress) {
          // Close OTP sheet/page before creating address.
          if (Navigator.of(Constants.globalContext()).canPop()) {
            navPop();
          }
          await Provider.of<AddressDetailsProvider>(
            Constants.globalContext(),
            listen: false,
          ).flushPendingAddress();
        } else if (needsProfile) {
          Provider.of<CompleteInfoProvider>(
            Constants.globalContext(),
            listen: false,
          ).goToCompleteInfoView();
        }
      },
    );
  }

  String sendCode(value) {
    if (counter == 0) {
      return '';
    } else {
      return "${LanguageProvider.translate("login", "after")} $value ${LanguageProvider.translate("time", "sec")}";
    }
  }

  Future<void> resendCode() async {
    AuthProvider authProvider = Provider.of<AuthProvider>(
      Constants.globalContext(),
      listen: false,
    );

    Map<String, dynamic> data = {};
    data["phone"] = authProvider.loginTextFieldList[0].controller.text;
    if (otpPhoneCode?.isEmpty ?? true) {
      otpPhoneCode = defaultCountry;
    }
    data['phone_code'] = otpPhoneCode.toString().replaceFirst('+', "");
    loading();
    final result = await authUsceCase.sendOtp(data);
    navPop();
    result.fold((l) => showToast(l.message!), (r) {
      startTimer();
    });
  }

  Future<void> updateProfile() async {
    Map<String, dynamic> data = {};
    loading();
    final result = await authUsceCase.updateProfile(data);
    navPop();
    result.fold((l) => showToast(l.message!), (r) {
      AuthProvider authProvider = Provider.of<AuthProvider>(
        Constants.globalContext(),
        listen: false,
      );
      authProvider.loginSuccess(r);
      navPop();
    });
  }
}
