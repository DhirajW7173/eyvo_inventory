import 'package:eyvo_inventory/core/resources/color_manager.dart';
import 'package:eyvo_inventory/core/resources/font_manager.dart';
import 'package:eyvo_inventory/core/resources/values_manager.dart';
import 'package:eyvo_inventory/core/resources/styles_manager.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static OutlineInputBorder _border(Color color) => OutlineInputBorder(
        borderSide: BorderSide(
          color: color,
          width: AppSize.s1_5,
        ),
        borderRadius: BorderRadius.circular(AppSize.s15),
      );
  static final lightThemeMode = ThemeData.light().copyWith(
    scaffoldBackgroundColor: ColorManager.primary,
    // App bar theme
    appBarTheme: AppBarTheme(
        centerTitle: false,
        color: ColorManager.darkBlue,
        elevation: AppSize.s4,
        // shadowColor: ColorManager.primaryOpacity70,
        titleTextStyle: getRegularStyle(
            color: ColorManager.white, fontSize: FontSize.s22_5)),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(27),
      focusedBorder: _border(ColorManager.blue),
      enabledBorder: _border(ColorManager.grey2),
      errorBorder: _border(ColorManager.darkRed),
      focusedErrorBorder: _border(ColorManager.darkRed),
      floatingLabelAlignment: FloatingLabelAlignment.start,
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      // floating label style
      floatingLabelStyle:
          getRegularStyle(color: ColorManager.light1, fontSize: FontSize.s18),
      // hint style
      hintStyle:
          getRegularStyle(color: ColorManager.grey1, fontSize: FontSize.s22_5),
      // label style
      labelStyle:
          getRegularStyle(color: ColorManager.light1, fontSize: FontSize.s22_5),
      // error style
      errorStyle: const TextStyle(height: 0, color: Colors.transparent),
    ),
  );
}
