import 'package:eyvo_inventory/core/resources/assets_manager.dart';
import 'package:eyvo_inventory/core/resources/color_manager.dart';
import 'package:eyvo_inventory/core/resources/font_manager.dart';
import 'package:eyvo_inventory/core/resources/strings_manager.dart';
import 'package:eyvo_inventory/core/resources/styles_manager.dart';
import 'package:flutter/material.dart';

class ErrorTextViewBox extends StatelessWidget {
  final String iconString;
  final String titleString;
  const ErrorTextViewBox(
      {super.key,
      this.iconString = ImageAssets.errorIcon,
      this.titleString = AppStrings.requiresValue});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: titleString.length >= 25
          ? 80
          : titleString.length >= 15
              ? 60
              : 40,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          color: ColorManager.lightRed,
          border: Border.all(color: ColorManager.lightRed2),
          borderRadius: const BorderRadius.all(Radius.circular(8))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image(image: AssetImage(iconString), width: 20, height: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              overflow: TextOverflow.ellipsis,
              maxLines: titleString.length >= 25 ? 3 : 2,
              titleString,
              style: getRegularStyle(
                  color: ColorManager.red, fontSize: FontSize.s14),
            ),
          )
        ],
      ),
    );
  }
}
