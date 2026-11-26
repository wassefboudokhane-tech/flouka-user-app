import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await _loadFamily('MarkaziText', ['assets/fonts/MarkaziText-Regular.ttf']);
  await _loadFamily('Amiri', ['assets/fonts/Amiri-Regular.ttf', 'assets/fonts/Amiri-Italic.ttf']);
  await _loadFamily('DMSans', ['assets/fonts/DMSans-Regular.ttf', 'assets/fonts/DMSans-Bold.ttf']);
  await _loadFamily('IBMPlexSansArabic', [
    'assets/fonts/IBMPlexSansArabic-Regular.ttf',
    'assets/fonts/IBMPlexSansArabic-Medium.ttf',
    'assets/fonts/IBMPlexSansArabic-Bold.ttf',
  ]);
  await testMain();
}

Future<void> _loadFamily(String family, List<String> assets) async {
  final loader = FontLoader(family);
  for (final asset in assets) {
    loader.addFont(rootBundle.load(asset));
  }
  try {
    await loader.load();
  } catch (_) {
    // Family may already be registered from pubspec.
  }
}
