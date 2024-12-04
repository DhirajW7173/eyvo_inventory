import 'package:eyvo_inventory/app/app_prefs.dart';
import 'package:eyvo_inventory/core/resources/assets_manager.dart';
import 'package:eyvo_inventory/core/resources/color_manager.dart';
import 'package:eyvo_inventory/core/resources/font_manager.dart';
import 'package:eyvo_inventory/core/resources/strings_manager.dart';
import 'package:eyvo_inventory/core/resources/styles_manager.dart';
import 'package:eyvo_inventory/core/widgets/alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

void showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        backgroundColor: ColorManager.green,
        content: Text(
          content,
          style: getRegularStyle(
              color: ColorManager.white, fontSize: FontSize.s16),
        ),
      ),
    );
}

void showAlertDialog(BuildContext context, String title, String content) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            child: Text(AppStrings.ok,
                style: getBoldStyle(
                    color: ColorManager.black, fontSize: FontSize.s20)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void showSuccessDialog(BuildContext context, String imageString,
    String titleString, String messageString, bool isNeedToPopBack) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CustomImageActionAlert(
          iconString: '',
          imageString: imageString,
          titleString: titleString,
          subTitleString: messageString,
          destructiveActionString: '',
          normalActionString: AppStrings.ok,
          onDestructiveActionTap: () {},
          onNormalActionTap: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
          isNormalAlert: true);
    },
  );
}

void showErrorDialog(
    BuildContext context, String message, bool isNeedToPopBack) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CustomImageActionAlert(
          iconString: '',
          imageString: ImageAssets.errorMessageIcon,
          titleString: '',
          subTitleString: message,
          destructiveActionString: '',
          normalActionString: AppStrings.ok,
          onDestructiveActionTap: () {},
          onNormalActionTap: () {
            Navigator.pop(context);
            if (isNeedToPopBack) {
              Navigator.pop(context);
            }
          },
          isNormalAlert: true);
    },
  );
}

String getFormattedPriceString(double price) {
  var priceFormatter = NumberFormat.currency(
      locale: 'en_US', symbol: '', decimalDigits: SharedPrefs().decimalPlaces);
  String formattedPrice = priceFormatter.format(price);
  return formattedPrice;
}

String getFormattedString(double number) {
  return number.toStringAsFixed(SharedPrefs().decimalPlaces);
}

String getDefaultString(String formattedString) {
  return formattedString.replaceAll(',', '');
}

void navigateToScreen(BuildContext context, Widget screen) {
  Navigator.of(context).push(
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return child;
      },
    ),
  );
}

class DecimalTextInputFormatter extends TextInputFormatter {
  final int decimalPlaces;
  final double minValue;
  final double maxValue;

  DecimalTextInputFormatter({
    required this.decimalPlaces,
    required this.minValue,
    required this.maxValue,
  });

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;

    // Allow empty input
    if (text.isEmpty) {
      return newValue;
    }

    // Allow input that matches the regex pattern
    final regExp = RegExp(r'^\d*\.?\d{0,' + decimalPlaces.toString() + r'}$');
    if (regExp.hasMatch(text)) {
      // Parse the text to a double and check if it's within the range, only if it's a complete number
      final double? value = double.tryParse(text);
      if (value != null) {
        if (value >= minValue && value <= maxValue) {
          return newValue;
        } else if (newValue.text != '0.0' && value <= maxValue) {
          return newValue; // Allow intermediate inputs like "0" or "0."
        } else {
          return oldValue;
        }
      }
    }

    // If the input doesn't match the pattern or is out of range, keep the old value
    return oldValue;
  }
}
