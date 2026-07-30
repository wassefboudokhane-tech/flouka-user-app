/// Parse fashion options (colors / sizes) from free-text product descriptions
/// (Ktita-style Tunisian shop copy). Mirrors flouka-web `parse-product-options.ts`.

class ParsedProductOptions {
  final List<String> colors;
  final List<String> sizes;

  const ParsedProductOptions({
    required this.colors,
    required this.sizes,
  });
}

class OptionCombination {
  final String? color;
  final String? size;
  final String label;

  const OptionCombination({
    this.color,
    this.size,
    required this.label,
  });
}

const Map<String, String> colorAliases = {
  'fushia': 'fushia',
  'fuchsia': 'fushia',
  'orangé': 'orangé',
  'orange': 'orangé',
  'bleu': 'bleu',
  'blue': 'bleu',
  'blanc': 'blanc',
  'white': 'blanc',
  'noir': 'noir',
  'black': 'noir',
  'vert': 'vert',
  'green': 'vert',
  'marron': 'marron',
  'brown': 'marron',
  'bordeaux': 'bordeaux',
  'marine': 'marine',
  'navy': 'marine',
  'rouge': 'rouge',
  'red': 'rouge',
  'rose': 'rose',
  'pink': 'rose',
  'beige': 'beige',
  'gris': 'gris',
  'gray': 'gris',
  'grey': 'gris',
  'jaune': 'jaune',
  'yellow': 'jaune',
  'violet': 'violet',
  'blanc à pois': 'blanc à pois',
};

/// Approximate hex for UI swatches (does not recolor the product photo).
const Map<String, String> colorSwatch = {
  'fushia': '#E0115F',
  'orangé': '#FF7A00',
  'bleu': '#2563EB',
  'blanc': '#F5F5F5',
  'noir': '#1A1A1A',
  'vert': '#16A34A',
  'marron': '#7C4A2D',
  'bordeaux': '#722F37',
  'marine': '#1E3A5F',
  'rouge': '#DC2626',
  'rose': '#F9A8D4',
  'beige': '#E8D5B7',
  'gris': '#9CA3AF',
  'jaune': '#EAB308',
  'violet': '#7C3AED',
  'blanc à pois': '#F8F8F8',
};

List<String> _uniquePreserve(List<String> list) {
  final seen = <String>{};
  final out = <String>[];
  for (final item in list) {
    final key = item.toLowerCase();
    if (seen.contains(key)) continue;
    seen.add(key);
    out.add(item);
  }
  return out;
}

String? _normalizeColorToken(String raw) {
  var s = raw
      .toLowerCase()
      .replaceAll(RegExp(r'[🤍✨️✔️😍🇹🇳]'), '')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
  if (s.isEmpty || s.length > 40) return null;
  s = s.replaceAll(RegExp(r'\s*(tissu|prix|livraison).*$', caseSensitive: false), '').trim();
  if (colorAliases.containsKey(s)) return colorAliases[s];
  final first = s.split(' ').first;
  if (colorAliases.containsKey(first) && s.contains('pois')) {
    return 'blanc à pois';
  }
  if (colorAliases.containsKey(first)) return colorAliases[first];
  if (RegExp(r'^[a-zàâäéèêëïîôùûüç\s-]{3,24}$', caseSensitive: false).hasMatch(s)) {
    return s;
  }
  return null;
}

List<String> _splitColorList(String chunk) {
  return chunk
      .split(RegExp(r'\s*(?:,|/|\bet\b|\band\b)\s*', caseSensitive: false))
      .map(_normalizeColorToken)
      .whereType<String>()
      .toList();
}

List<String> _parseSizes(String chunk) {
  final numeric = RegExp(r'\b(3[4-9]|4[0-8]|5[0-2])\b')
      .allMatches(chunk)
      .map((m) => m.group(0)!)
      .toList();
  final letters = RegExp(r'\b(3XL|2XL|XXXL|XXL|XL|XS|S|M|L)\b', caseSensitive: false)
      .allMatches(chunk)
      .map((m) => m.group(0)!.toUpperCase())
      .toList();
  final groups = RegExp(r'\b(T[123])\s*\(([^)]+)\)', caseSensitive: false)
      .allMatches(chunk)
      .map((m) => m.group(1)!.toUpperCase())
      .toList();
  return _uniquePreserve([...numeric, ...groups, ...letters]);
}

ParsedProductOptions parseProductOptions(String? description) {
  if (description == null || description.trim().isEmpty) {
    return const ParsedProductOptions(colors: [], sizes: []);
  }
  final text = description
      .replaceAll(RegExp(r'[🤍✨️✔️😍🇹🇳*•·]+'), ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();

  var colors = <String>[];
  final colorBlock = RegExp(
        r'(?:les\s+)?couleurs?\s*[:：]\s*(.+?)(?=(?:\s+(?:les\s+)?taill|\s+tissu|\s+prix|\s+livraison|$))',
        caseSensitive: false,
      ).firstMatch(text) ??
      RegExp(
        r'couleur\s*[:：]\s*(.+?)(?=(?:\s+(?:les\s+)?taill|\s+tissu|\s+prix|\s+livraison|$))',
        caseSensitive: false,
      ).firstMatch(text);
  if (colorBlock != null && colorBlock.group(1) != null) {
    colors = _splitColorList(colorBlock.group(1)!);
  }

  var sizes = <String>[];
  final sizeBlock = RegExp(
        r'(?:les\s+)?taill(?:e|es)?\s*[:：]\s*(.+?)(?=(?:\s+(?:les\s+)?couleur|\s+tissu|\s+prix|\s+livraison|$))',
        caseSensitive: false,
      ).firstMatch(text) ??
      RegExp(r'sizes?\s*[:：]\s*(.+)', caseSensitive: false).firstMatch(text);
  if (sizeBlock != null && sizeBlock.group(1) != null) {
    sizes = _parseSizes(sizeBlock.group(1)!);
  }
  if (sizes.isEmpty) sizes = _parseSizes(text);

  return ParsedProductOptions(
    colors: _uniquePreserve(colors),
    sizes: _uniquePreserve(sizes),
  );
}

List<OptionCombination> optionCombinations(ParsedProductOptions options) {
  final colors = options.colors;
  final sizes = options.sizes;
  if (colors.isEmpty && sizes.isEmpty) return [];
  if (colors.isNotEmpty && sizes.isNotEmpty) {
    final out = <OptionCombination>[];
    for (final color in colors) {
      for (final size in sizes) {
        out.add(OptionCombination(
          color: color,
          size: size,
          label: '$color / $size',
        ));
      }
    }
    return out;
  }
  if (colors.isNotEmpty) {
    return colors
        .map((color) => OptionCombination(color: color, label: color))
        .toList();
  }
  return sizes.map((size) => OptionCombination(size: size, label: size)).toList();
}

String? swatchForColor(String label, String? code) {
  if (code != null && code.startsWith('#')) return code;
  return colorSwatch[label.toLowerCase()];
}
