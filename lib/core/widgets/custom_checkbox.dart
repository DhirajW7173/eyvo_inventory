import 'package:eyvo_inventory/core/resources/color_manager.dart';
import 'package:eyvo_inventory/core/resources/font_manager.dart';
import 'package:eyvo_inventory/core/resources/styles_manager.dart';
import 'package:flutter/material.dart';

class CustomCheckBox extends StatefulWidget {
  final String imageString;
  final String titleString;
  final bool isSelected;
  final VoidCallback onTap;
  const CustomCheckBox(
      {super.key,
      required this.imageString,
      required this.titleString,
      required this.isSelected,
      required this.onTap});

  @override
  State<CustomCheckBox> createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: Row(
      children: [
        IconButton(
            icon: Image(image: AssetImage(widget.imageString)),
            onPressed: widget.onTap),
        Text(widget.titleString,
            style: getSemiBoldStyle(
                color: ColorManager.black, fontSize: FontSize.s21))
      ],
    ));
  }
}
