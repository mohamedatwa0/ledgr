import 'package:flutter/widgets.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

import '../widgets/category_choices.dart';

/// Resolves a stored category code point to a constant Tabler [IconData].
///
/// Release builds tree-shake icon fonts and reject non-constant [IconData].
IconData tablerIcon(int codePoint) {
  for (final choice in categoryIconChoices) {
    if (choice.icon.codePoint == codePoint) return choice.icon;
  }
  return TablerIcons.dots;
}
