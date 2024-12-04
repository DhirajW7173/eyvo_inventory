import 'package:eyvo_inventory/core/resources/font_manager.dart';
import 'package:flutter/material.dart';

TextStyle _getTextStyle(
    double fontSize, String fontFamily, Color color, FontWeight fontWeight) {
  return TextStyle(
      fontSize: fontSize,
      fontFamily: fontFamily,
      color: color,
      fontWeight: fontWeight);
}

TextStyle _getDottedUnderlineStyle(double fontSize, String fontFamily,
    Color color, FontWeight fontWeight, Color lineColor) {
  return TextStyle(
      shadows: [Shadow(color: color, offset: const Offset(0, -5))],
      decoration: TextDecoration.underline,
      decorationColor: lineColor,
      decorationStyle: TextDecorationStyle.dashed,
      decorationThickness: 2.0,
      fontSize: fontSize,
      fontFamily: fontFamily,
      color: Colors.transparent,
      fontWeight: fontWeight);
}

// regular style
TextStyle getRegularStyle(
    {double fontSize = FontSize.s12, required Color color}) {
  return _getTextStyle(
      fontSize, FontConstants.fontFamily, color, FontWeightManager.regular);
}

// light
TextStyle getLightStyle(
    {double fontSize = FontSize.s12, required Color color}) {
  return _getTextStyle(
      fontSize, FontConstants.fontFamily, color, FontWeightManager.light);
}

// semi bold style
TextStyle getSemiBoldStyle(
    {double fontSize = FontSize.s12, required Color color}) {
  return _getTextStyle(
      fontSize, FontConstants.fontFamily, color, FontWeightManager.semiBold);
}

// medium
TextStyle getMediumStyle(
    {double fontSize = FontSize.s12, required Color color}) {
  return _getTextStyle(
      fontSize, FontConstants.fontFamily, color, FontWeightManager.medium);
}

// bold
TextStyle getBoldStyle({double fontSize = FontSize.s12, required Color color}) {
  return _getTextStyle(
      fontSize, FontConstants.fontFamily, color, FontWeightManager.bold);
}

// dotted underline semibold style
TextStyle getDottedUnderlineSemiBoldStyle(
    {double fontSize = FontSize.s25_5,
    required Color color,
    required Color lineColor}) {
  return _getDottedUnderlineStyle(fontSize, FontConstants.fontFamily, color,
      FontWeightManager.semiBold, lineColor);
}

// dotted underline semibold style
TextStyle getDottedUnderlineStyle(
    {double fontSize = FontSize.s25_5,
    required Color color,
    required Color lineColor}) {
  return _getDottedUnderlineStyle(fontSize, FontConstants.fontFamily, color,
      FontWeightManager.regular, lineColor);
}
