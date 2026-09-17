import 'package:flutter/material.dart';

import 'colors.dart';

const sourceSerif4 = 'SourceSerif4';
const spaceGrotesk = 'SpaceGrotesk';

const tabularFigures = <FontFeature>[
  FontFeature.tabularFigures(),
  FontFeature.liningFigures(),
];

TextStyle amountStyle({
  double fontSize = 14,
  Color color = inkNavy,
  FontWeight fontWeight = FontWeight.w600,
}) {
  return TextStyle(
    fontFamily: sourceSerif4,
    fontWeight: fontWeight,
    fontSize: fontSize,
    color: color,
    fontFeatures: tabularFigures,
    height: 1.15,
  );
}

TextStyle uiStyle({
  double fontSize = 14,
  Color color = inkNavy,
  FontWeight fontWeight = FontWeight.w400,
  double height = 1.3,
}) {
  return TextStyle(
    fontFamily: spaceGrotesk,
    fontWeight: fontWeight,
    fontSize: fontSize,
    color: color,
    height: height,
  );
}
