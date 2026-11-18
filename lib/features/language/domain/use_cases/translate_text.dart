import '../../../../../core/constants/constants.dart';
import '../../../../../core/helper_function/api.dart';
import '../entities/app_localizations.dart';

class Translate{
  static String translate(String key,String value){
    final localizations =
        AppLocalizations.of(Constants.globalContext())!;
    return localizations.translate(
      key,
      value,
      remoteLanguages: ApiHandel.getInstance.languages,
      languageCode: localizations.locale.languageCode,
    );
  }
}