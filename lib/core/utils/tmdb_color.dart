/// Deterministically generate a hex color from an int id.
///
/// Why deterministic?
/// • No image-decoding cost.
/// • Same movie → same color (consistent UX).
/// • Netflix-style curated feel — colors "look chosen".
///
/// Algorithm: hash the id → modulo over a small curated palette of 12
/// vivid, dark-friendly hues. Then format as `#RRGGBB` with no trailing
/// alpha (Vidsync's `?theme` param rejects `#`).
library;

/// A small, theme-friendly palette of 12 hex colors (no `#` prefix).
/// These read well on dark backgrounds and span the spectrum.
const List<String> _palette = <String>[
  'E50914', // cinematic red (Netflix brand)
  '1F49FF', // deep cobalt
  '16A0B5', // teal
  'F5C518', // IMDb yellow
  '7B61FF', // ultraviolet
  'FF6F61', // coral
  '00A86B', // emerald
  'FF8C42', // mango
  '7A8B99', // slate
  'C2185B', // magenta
  '00897B', // pine
  'D81B60', // raspberry
];

/// Convert an integer id → hex (e.g. `1F49FF`).
String hexColorForMovieId(int id) {
  // Hash by bit-mixing (Knuth's multiplicative hash, simplified).
  var h = id & 0xFFFFFFFF;
  h = ((h >> 16) ^ h) * 0x45D9F3B;
  h = ((h >> 16) ^ h) & 0xFFFFFFFF;
  return _palette[h % _palette.length];
}

/// Same as [hexColorForMovieId] but produces `'#1F49FF'` (with `#`).
String cssColorForMovieId(int id) => '#${hexColorForMovieId(id)}';
