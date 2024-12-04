import 'package:flutter/material.dart';

class DashedLineText extends StatelessWidget {
  final String titleString;
  final TextStyle titleStyle;

  const DashedLineText(
      {super.key, required this.titleString, required this.titleStyle});

  @override
  Widget build(BuildContext context) {
    return Text(titleString, style: titleStyle);
  }
}
