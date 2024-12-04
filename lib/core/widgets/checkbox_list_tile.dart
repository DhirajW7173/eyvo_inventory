import 'package:eyvo_inventory/core/resources/color_manager.dart';
import 'package:flutter/material.dart';

class CustomCheckboxListTile extends StatelessWidget {
  final bool? value;

  final ValueChanged<bool?>? onChanged;

  final Widget? title;
  const CustomCheckboxListTile(
      {super.key, required this.value, required this.onChanged, this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged?.call(value),
      child: Row(
        children: [
          Transform.scale(
            scale: 1.5,
            child: Checkbox(
              value: value,
              onChanged: onChanged,
              checkColor: ColorManager.white,
              activeColor: ColorManager.lightBlue1,
              side: BorderSide(color: ColorManager.lightBlue1, width: 1),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
            ),
          ),
          Expanded(
              child: Container(
            padding: const EdgeInsets.only(left: 8.0),
            child: title,
          )),
        ],
      ),
    );
  }
}
