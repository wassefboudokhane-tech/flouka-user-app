

import 'package:flouka/features/auth/presentation/widgets/country_widget.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

import '../../features/language/presentation/provider/language_provider.dart';

final RegExp emailValid = RegExp(
  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
);

bool validEnglish(String value) {
  RegExp regex = RegExp(r'/^[A-Za-z0-9]*$');
  return (regex.hasMatch(value));
}

/// Login field for Tunisia: 8 digits, no leading zero.
bool isTunisiaLoginNumber(String digits) {
  return RegExp(r'^[1-9]\d{7}$').hasMatch(digits.trim());
}

String? validatePhone(String? value) {
  if (value!.isEmpty) {
    return LanguageProvider.translate("validation", "phone_required");
  }
  // if (value.length < 5) {
  //   return LanguageProvider.translate("validation", "phone_invalid");
  // }
  if (validEnglish(value)) {
    return LanguageProvider.translate("validation", "english_phone");
  }
  String country = defaultCountry;
  if(!country.startsWith('+')){
    defaultCountry = '+'+defaultCountry;
  }
  final digits = value.trim();
  // The login field asks for 8 digits without a leading 0. Tunisia (+216)
  // matches that shape; phone_numbers_parser rejects some of those numbers
  // (for example 12345678) even though the form accepts them.
  final dial = defaultCountry.replaceAll('+', '');
  if (dial == '216') {
    if (isTunisiaLoginNumber(digits)) {
      return null;
    }
    return LanguageProvider.translate("validation", "phone_invalid");
  }

  final phone = PhoneNumber.parse(
    defaultCountry+digits,
  );

  final isValid = phone.isValid();
  if(!isValid){
    return LanguageProvider.translate("validation", "phone_invalid");
  }

  return null;
}

String? validateName(String? value) {
  if (value!.isEmpty) {
    return LanguageProvider.translate("validation", "name_required");
  }
  return null;
}

String? validateEmail(String? value) {
  if (!emailValid.hasMatch(value!)) {
    if (value.isEmpty) {
      return LanguageProvider.translate("validation", "empty_email");
    } else {
      return LanguageProvider.translate("validation", "incorrect_email");
    }
  }
  return null;
}

String? validateOtp(String? value) {
  if (value!.isEmpty) {
    return LanguageProvider.translate("validation", "otp_required");
  }
  return null;
}

String? validatePassword(String? value) {
  if (value!.isEmpty) {
    return LanguageProvider.translate("validation", "password_required");
  }
  return null;
}

String validateCity() {
  return LanguageProvider.translate("validation", "government");
}

String validateAddress() {
  return LanguageProvider.translate("validation", "address");
}

String validateArea() {
  return LanguageProvider.translate("validation", "area");
}
String validateNeighborhood() {
  return LanguageProvider.translate("validation", "select_neighborhood_first");
}

String? validatePart() {
  return LanguageProvider.translate("validation", "part");
}

String? validateFirstName(String? value) {
  if (value!.isEmpty) {
    return LanguageProvider.translate("validation", "first_name");
  }
  return null;
}

String? validateLastName(String? value) {
  if (value!.isEmpty) {
    return LanguageProvider.translate("validation", "last_name");
  }
  return null;
}

String? validateApartment(String? value) {
  if (value!.isEmpty) {
    return LanguageProvider.translate("validation", "apartment");
  }
  return null;
}

String? validateBuilding(String? value) {
  if (value!.isEmpty) {
    return LanguageProvider.translate("validation", "building");
  }
  return null;
}

String? validateAddressName(String? value) {
  if (value == null || value.trim().isEmpty) {
    return LanguageProvider.translate("validation", "address_name");
  }
  return null;
}

String? validateAddressDetails(String? value) {
  if (value == null || value.trim().isEmpty) {
    return LanguageProvider.translate("validation", "address");
  }
  return null;
}

String? validateStreetName(String? value) {
  if (value!.isEmpty) {
    return LanguageProvider.translate("validation", "street_name");
  }
  return null;
}

String? validateConfirmPassword(String? value, String? confirmPassword) {
  if (value == null || value.isEmpty) {
    return LanguageProvider.translate("validation", "please_retype_password");
  }
  if (value != confirmPassword) {
    return LanguageProvider.translate("validation", "confirm_password");
  }
  return null;
}
