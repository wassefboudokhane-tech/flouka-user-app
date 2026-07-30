import 'package:flouka/core/config/app_color.dart';
import 'package:flutter/material.dart';

import 'map_screen.dart';

class SelectAddressMapPage extends StatelessWidget {
  const SelectAddressMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.canvasColor,
      appBar: AppBar(
        backgroundColor: AppColor.deepColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: const MapScreen(),
    );
  }
}
