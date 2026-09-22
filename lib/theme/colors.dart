import 'package:flutter/material.dart';

@immutable
class LedgrColors extends ThemeExtension<LedgrColors> {
  const LedgrColors({
    required this.surface,
    required this.paperLight,
    required this.onSurface,
    required this.secondary,
    required this.rule,
    required this.primary,
    required this.primaryContainer,
    required this.onPrimary,
    required this.ledgerRed,
    required this.ledgerGreen,
    required this.outline,
    required this.surfaceContainer,
    required this.surfaceContainerLow,
    required this.surfaceContainerHigh,
    required this.surfaceContainerHighest,
    required this.surfaceContainerLowest,
    required this.categoryCircleFill,
    required this.secondaryContainer,
    required this.errorContainer,
  });

  final Color surface;
  final Color paperLight;
  final Color onSurface;
  final Color secondary;
  final Color rule;
  final Color primary;
  final Color primaryContainer;
  final Color onPrimary;
  final Color ledgerRed;
  final Color ledgerGreen;
  final Color outline;
  final Color surfaceContainer;
  final Color surfaceContainerLow;
  final Color surfaceContainerHigh;
  final Color surfaceContainerHighest;
  final Color surfaceContainerLowest;
  final Color categoryCircleFill;
  final Color secondaryContainer;
  final Color errorContainer;

  static const light = LedgrColors(
    surface: Color(0xFFFBF9F2),
    paperLight: Color(0xFFFAF9F5),
    onSurface: Color(0xFF1B1C18),
    secondary: Color(0xFF516071),
    rule: Color(0xFFDDD8C9),
    primary: Color(0xFF055666),
    primaryContainer: Color(0xFF2C6E7F),
    onPrimary: Color(0xFFE9F3F5),
    ledgerRed: Color(0xFF9C2B2B),
    ledgerGreen: Color(0xFF2F5233),
    outline: Color(0xFF70787C),
    surfaceContainer: Color(0xFFF0EEE7),
    surfaceContainerLow: Color(0xFFF6F4ED),
    surfaceContainerHigh: Color(0xFFEAE8E1),
    surfaceContainerHighest: Color(0xFFE4E2DC),
    surfaceContainerLowest: Color(0xFFFFFFFF),
    categoryCircleFill: Color(0xFFECE8DA),
    secondaryContainer: Color(0xFFD1E1F5),
    errorContainer: Color(0xFFFFDAD6),
  );

  static const dark = LedgrColors(
    surface: Color(0xFF081420),
    paperLight: Color(0xFF101D28),
    onSurface: Color(0xFFF0EDE6),
    secondary: Color(0xFF8699A8),
    rule: Color(0xFF1E2E3E),
    primary: Color(0xFF82D3E2),
    primaryContainer: Color(0xFF2C7A8B),
    onPrimary: Color(0xFF00363D),
    ledgerRed: Color(0xFFEF5350),
    ledgerGreen: Color(0xFF48BB78),
    outline: Color(0xFF334559),
    surfaceContainer: Color(0xFF15212D),
    surfaceContainerLow: Color(0xFF101D28),
    surfaceContainerHigh: Color(0xFF1A2735),
    surfaceContainerHighest: Color(0xFF243547),
    surfaceContainerLowest: Color(0xFF040F1B),
    categoryCircleFill: Color(0xFF192A3A),
    secondaryContainer: Color(0xFF1E3346),
    errorContainer: Color(0xFF5C1A1A),
  );

  static LedgrColors of(BuildContext context) {
    return Theme.of(context).extension<LedgrColors>() ?? LedgrColors.light;
  }

  @override
  LedgrColors copyWith({
    Color? surface,
    Color? paperLight,
    Color? onSurface,
    Color? secondary,
    Color? rule,
    Color? primary,
    Color? primaryContainer,
    Color? onPrimary,
    Color? ledgerRed,
    Color? ledgerGreen,
    Color? outline,
    Color? surfaceContainer,
    Color? surfaceContainerLow,
    Color? surfaceContainerHigh,
    Color? surfaceContainerHighest,
    Color? surfaceContainerLowest,
    Color? categoryCircleFill,
    Color? secondaryContainer,
    Color? errorContainer,
  }) {
    return LedgrColors(
      surface: surface ?? this.surface,
      paperLight: paperLight ?? this.paperLight,
      onSurface: onSurface ?? this.onSurface,
      secondary: secondary ?? this.secondary,
      rule: rule ?? this.rule,
      primary: primary ?? this.primary,
      primaryContainer: primaryContainer ?? this.primaryContainer,
      onPrimary: onPrimary ?? this.onPrimary,
      ledgerRed: ledgerRed ?? this.ledgerRed,
      ledgerGreen: ledgerGreen ?? this.ledgerGreen,
      outline: outline ?? this.outline,
      surfaceContainer: surfaceContainer ?? this.surfaceContainer,
      surfaceContainerLow: surfaceContainerLow ?? this.surfaceContainerLow,
      surfaceContainerHigh: surfaceContainerHigh ?? this.surfaceContainerHigh,
      surfaceContainerHighest:
          surfaceContainerHighest ?? this.surfaceContainerHighest,
      surfaceContainerLowest:
          surfaceContainerLowest ?? this.surfaceContainerLowest,
      categoryCircleFill: categoryCircleFill ?? this.categoryCircleFill,
      secondaryContainer: secondaryContainer ?? this.secondaryContainer,
      errorContainer: errorContainer ?? this.errorContainer,
    );
  }

  @override
  LedgrColors lerp(ThemeExtension<LedgrColors>? other, double t) {
    if (other is! LedgrColors) return this;
    return LedgrColors(
      surface: Color.lerp(surface, other.surface, t)!,
      paperLight: Color.lerp(paperLight, other.paperLight, t)!,
      onSurface: Color.lerp(onSurface, other.onSurface, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      rule: Color.lerp(rule, other.rule, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      primaryContainer:
          Color.lerp(primaryContainer, other.primaryContainer, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      ledgerRed: Color.lerp(ledgerRed, other.ledgerRed, t)!,
      ledgerGreen: Color.lerp(ledgerGreen, other.ledgerGreen, t)!,
      outline: Color.lerp(outline, other.outline, t)!,
      surfaceContainer:
          Color.lerp(surfaceContainer, other.surfaceContainer, t)!,
      surfaceContainerLow:
          Color.lerp(surfaceContainerLow, other.surfaceContainerLow, t)!,
      surfaceContainerHigh:
          Color.lerp(surfaceContainerHigh, other.surfaceContainerHigh, t)!,
      surfaceContainerHighest: Color.lerp(
        surfaceContainerHighest,
        other.surfaceContainerHighest,
        t,
      )!,
      surfaceContainerLowest: Color.lerp(
        surfaceContainerLowest,
        other.surfaceContainerLowest,
        t,
      )!,
      categoryCircleFill:
          Color.lerp(categoryCircleFill, other.categoryCircleFill, t)!,
      secondaryContainer:
          Color.lerp(secondaryContainer, other.secondaryContainer, t)!,
      errorContainer: Color.lerp(errorContainer, other.errorContainer, t)!,
    );
  }
}

extension LedgrColorsX on BuildContext {
  LedgrColors get colors => LedgrColors.of(this);
}
