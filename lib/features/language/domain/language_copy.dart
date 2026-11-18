import 'dart:convert';

import 'package:flutter/services.dart';

/// A translated string from the remote language file, or the bundled copy
/// when that file is missing (the language host does not send CORS headers).
String languageCopy({
  required Map remoteLanguages,
  required String languageCode,
  required Map<String, dynamic> bundled,
  required String parent,
  required String key,
}) {
  final remote = remoteLanguages[languageCode];
  final fromRemote = lookupLanguageCopy(remote, parent, key);
  if (fromRemote != null) return fromRemote;
  return lookupLanguageCopy(bundled, parent, key) ?? key;
}

String? lookupLanguageCopy(Object? source, String parent, String key) {
  if (source is! Map) return null;
  final section = source[parent];
  if (section is! Map || section[key] == null) return null;
  final text = section[key].toString();
  if (text.isEmpty) return null;
  return text;
}

/// Bundled `assets/languages/{code}.json`, used when the remote fetch fails.
Future<Map<String, dynamic>> loadBundledLanguageFiles(
  Iterable<String> codes,
) async {
  final data = <String, dynamic>{};
  for (final code in codes) {
    try {
      final raw = await rootBundle.loadString('assets/languages/$code.json');
      final decoded = json.decode(raw);
      if (decoded is Map<String, dynamic>) {
        data[code] = decoded;
      } else if (decoded is Map) {
        data[code] = Map<String, dynamic>.from(decoded);
      }
    } catch (_) {}
  }
  return data;
}
