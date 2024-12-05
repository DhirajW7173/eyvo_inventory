import 'package:eyvo_inventory/core/resources/color_manager.dart';
import 'package:eyvo_inventory/core/resources/font_manager.dart';
import 'package:eyvo_inventory/core/resources/styles_manager.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onTap;
  final bool isEnabled;
  final bool isDefault;
  const CustomButton(
      {super.key,
      required this.buttonText,
      required this.onTap,
      this.isEnabled = true,
      this.isDefault = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 40,
      decoration: BoxDecoration(
        color: isDefault
            ? ColorManager.white
            : isEnabled
                ? ColorManager.darkBlue
                : ColorManager.grey5,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
            color: isDefault ? ColorManager.darkBlue : Colors.transparent,
            width: 2.0),
      ),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: Text(
          buttonText,
          style: getBoldStyle(
              color: isDefault
                  ? ColorManager.darkBlue
                  : isEnabled
                      ? ColorManager.white
                      : ColorManager.darkGrey2,
              fontSize: FontSize.s16),
        ),
      ),
    );
  }
}

class CustomTextButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onTap;
  const CustomTextButton(
      {super.key, required this.buttonText, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 30,
      child: Row(
        children: [
          const Spacer(),
          ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
            ),
            child: Text(
              textAlign: TextAlign.right,
              buttonText,
              style: getRegularStyle(
                  color: ColorManager.lightBlue, fontSize: FontSize.s14),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomImageButton extends StatelessWidget {
  final String imageString;
  final VoidCallback onTap;
  const CustomImageButton(
      {super.key, required this.imageString, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ElevatedButton.icon(
        icon: Image(
          image: AssetImage(imageString),
          height: 24,
          width: 24,
        ),
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        label: const Text(''),
      ),
    );
  }
}

class CustomIconButton extends StatelessWidget {
  final String imageString;
  const CustomIconButton({super.key, required this.imageString});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: IconButton(
        icon: Image(image: AssetImage(imageString), width: 34, height: 34),
        onPressed: () {},
      ),
    );
  }
}

class CustomTextActionButton extends StatelessWidget {
  final String buttonText;
  final Color backgroundColor;
  final Color fontColor;
  final Color borderColor;
  final double buttonWidth;
  final double buttonHeight;
  final bool isBoldFont;
  final double fontSize;
  final VoidCallback onTap;
  const CustomTextActionButton(
      {super.key,
      required this.buttonText,
      required this.backgroundColor,
      required this.borderColor,
      required this.fontColor,
      this.buttonWidth = 120,
      this.buttonHeight = 50,
      this.isBoldFont = false,
      this.fontSize = FontSize.s22_5,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: buttonWidth,
      height: buttonHeight,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            backgroundColor: backgroundColor,
            shadowColor: Colors.transparent,
            side: BorderSide(color: borderColor)),
        child: Text(
          buttonText,
          style: isBoldFont
              ? getBoldStyle(color: fontColor, fontSize: fontSize)
              : getSemiBoldStyle(color: fontColor, fontSize: fontSize),
        ),
      ),
    );
  }
}
