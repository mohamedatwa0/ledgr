import '../../domain/models/app_theme_mode.dart';
import '../../l10n/app_localizations.dart';

extension AppThemeModeL10n on AppThemeMode {
  String localizedLabel(AppLocalizations l10n) {
    switch (this) {
      case AppThemeMode.system:
        return l10n.themeSystem;
      case AppThemeMode.light:
        return l10n.themeLight;
      case AppThemeMode.dark:
        return l10n.themeDark;
    }
  }
}
