import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/widgets/flouka_primary_button.dart';
import 'package:flouka/core/widgets/loading_widget.dart';
import 'package:flouka/features/address/presentation/providers/address_details_provider.dart';
import 'package:flouka/features/address/presentation/providers/map_provider.dart';
import 'package:flouka/features/address/presentation/widgets/address_bottomsheet_widget.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  void _confirmLocation(BuildContext context) {
    final mapProvider = Provider.of<MapProvider>(context, listen: false);
    final lat = mapProvider.center?.latitude;
    final lng = mapProvider.center?.longitude;

    if (lat == null || lng == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            LanguageProvider.translate('global', 'please_select_location'),
          ),
        ),
      );
      return;
    }

    Provider.of<AddressDetailsProvider>(context, listen: false)
        .setData(lat, lng);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddressBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mapProv = Provider.of<MapProvider>(context);

    if (mapProv.center == null) {
      return const Center(child: LoadingWidget());
    }

    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: mapProv.center!,
            zoom: mapProv.zoom,
          ),
          onMapCreated: mapProv.onMapCreated,
          myLocationEnabled: false,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: !kIsWeb,
          markers: mapProv.markers,
          onCameraMove: mapProv.onCameraMove,
          mapType: MapType.normal,
        ),
        const IgnorePointer(
          child: Center(
            child: Icon(Icons.location_on, size: 40, color: Colors.red),
          ),
        ),
        Positioned(
          right: 16,
          top: 16,
          child: Material(
            color: Colors.white,
            shape: const CircleBorder(),
            elevation: 2,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: mapProv.animateToMyLocation,
              child: const SizedBox(
                width: 44,
                height: 44,
                child: Icon(Icons.my_location_rounded, color: Colors.black87),
              ),
            ),
          ),
        ),
        Positioned(
          left: AppSpacing.pageGutter,
          right: AppSpacing.pageGutter,
          bottom: 24,
          child: FloukaPrimaryButton(
            onTap: () => _confirmLocation(context),
            text: 'confirm_location',
          ),
        ),
      ],
    );
  }
}
