import 'package:flutter/material.dart';

const sourceSerif4 = 'SourceSerif4';
const spaceGrotesk = 'SpaceGrotesk';

const uiFontFallback = <String>[
  'Geeza Pro',
  'Noto Sans Arabic',
  'Noto Naskh Arabic',
  'Arial',
  'sans-serif',
];

const tabularFigures = <FontFeature>[
  FontFeature.tabularFigures(),
  FontFeature.liningFigures(),
];

TextStyle amountStyle({
  double fontSize = 14,
  Color? color,
  FontWeight fontWeight = FontWeight.w600,
  double height = 1.15,
}) {
  return TextStyle(
    fontFamily: sourceSerif4,
    fontFamilyFallback: uiFontFallback,
    fontWeight: fontWeight,
    fontSize: fontSize,
    color: color,
    fontFeatures: tabularFigures,
    height: height,
  );
}

TextStyle uiStyle({
  double fontSize = 14,
  Color? color,
  FontWeight fontWeight = FontWeight.w400,
  double height = 1.3,
  double? letterSpacing,
}) {
  return TextStyle(
    fontFamily: spaceGrotesk,
    fontFamilyFallback: uiFontFallback,
    fontWeight: fontWeight,
    fontSize: fontSize,
    color: color,
    height: height,
    letterSpacing: letterSpacing,
  );
}
