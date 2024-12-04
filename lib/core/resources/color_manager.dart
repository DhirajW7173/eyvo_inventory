import 'package:flutter/material.dart';

class ColorManager {
  static Color primary = HexColor.fromHex("#f4f6fd");
  static Color white = HexColor.fromHex("#FFFFFF");
  static Color error = HexColor.fromHex("#E61F34");
  static Color black = HexColor.fromHex("#000000");
  static Color blackOpacity50 = HexColor.fromHex("#80000000");
  static Color blue = HexColor.fromHex("#334994");
  static Color lightBlue = HexColor.fromHex("#0d47ee");
  static Color lightBlue1 = HexColor.fromHex("#719fea");
  static Color lightBlue2 = HexColor.fromHex("#c7d2f9");
  static Color lightBlue3 = HexColor.fromHex("#f8f8f8");
  static Color darkBlue = HexColor.fromHex("#23367c");
  static Color orange = HexColor.fromHex("#ff5c12");
  static Color orange2 = HexColor.fromHex("#ee6002");
  static Color darkGrey = HexColor.fromHex("#525252");
  static Color darkGrey2 = HexColor.fromHex("#999999");
  static Color grey = HexColor.fromHex("#737477");
  static Color grey1 = HexColor.fromHex("#4d4d4d");
  static Color grey2 = HexColor.fromHex("#d1dff6");
  static Color grey3 = HexColor.fromHex("#4d4c4c");
  static Color grey4 = HexColor.fromHex("#e7e6e6");
  static Color grey5 = HexColor.fromHex("#e9e9e9");
  static Color grey6 = HexColor.fromHex("#ededed");
  static Color primaryOpacity70 = HexColor.fromHex("#B3ED9728");
  static Color darkPrimary = HexColor.fromHex("#D17D11");
  static Color light = HexColor.fromHex("#ffffff");
  static Color light1 = HexColor.fromHex("#707070");
  static Color light2 = HexColor.fromHex("#adc2cc");
  static Color light3 = HexColor.fromHex("#f9f9f9");
  static Color lightGrey = HexColor.fromHex("5d5d5d");
  static Color lightGrey1 = HexColor.fromHex("#424242");
  static Color lightGrey2 = HexColor.fromHex("#212121");
  static Color lightGrey3 = HexColor.fromHex("#afafaf");
  static Color lightGrey4 = HexColor.fromHex("#e1e1e1");
  static Color darkRed = HexColor.fromHex("#b71b1c");
  static Color lightRed = HexColor.fromHex("#fff1f3");
  static Color lightRed2 = HexColor.fromHex("#ffcdd2");
  static Color red = HexColor.fromHex("#b71c1c");
  static Color red2 = HexColor.fromHex("#c62827");
  static Color green = HexColor.fromHex('09af00');
}

extension HexColor on Color {
  static Color fromHex(String hexColorString) {
    hexColorString = hexColorString.replaceAll('#', '');
    if (hexColorString.length == 6) {
      hexColorString = "FF$hexColorString"; // 8 char with 100% opacity
    }
    return Color(int.parse(hexColorString, radix: 16));
  }
}
