import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/features/categories/presentation/view/categories_tab_content.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flutter/material.dart';

/// Shop-first categories tab — search + Mode/Maison pills + category tiles.
class CategoriesView extends StatelessWidget {
  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.canvasColor,
      appBar: AppBar(
        title: Text(LanguageProvider.translate('navbar', 'categories')),
      ),
      body: const CategoriesTabContent(),
    );
  }
}
