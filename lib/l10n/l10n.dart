import 'package:flutter/widgets.dart';

import 'app_localizations.dart';

export 'app_localizations.dart';

extension LedgrL10n on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

double? ltrLetterSpacing(BuildContext context, double value) {
  return Directionality.of(context) == TextDirection.ltr ? value : null;
}
