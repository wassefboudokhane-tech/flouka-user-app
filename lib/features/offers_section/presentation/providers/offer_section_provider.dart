import 'package:flouka/features/offers_section/domain/entity/offer_section_entity.dart';
import 'package:flouka/features/offers_section/domain/use_case/offer_section_usecase.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/helper_function/location.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class OfferSectionProvider extends ChangeNotifier {
  final OfferSectionUseCase offerSectionUseCase;
  OfferSectionProvider(this.offerSectionUseCase);
  List<OfferSectionEntity>? data;

  Future<void> getData() async {
    AuthProvider authProvider = Provider.of<AuthProvider>(Constants.globalContext(), listen: false);
    Map<String,dynamic>dataToApi = {};
    final place = cataloguePlace(authProvider.currentLocation);
    dataToApi['lat'] = place.latitude;
    dataToApi['lng'] = place.longitude;
    var response = await offerSectionUseCase.getOfferSections(dataToApi);
    response.fold((l) {
      data = [];
    }, (r) {
      data = r;
      notifyListeners();
    });
  }
}
