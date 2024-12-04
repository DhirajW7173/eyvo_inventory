import 'package:eyvo_inventory/core/resources/color_manager.dart';
import 'package:eyvo_inventory/core/resources/font_manager.dart';
import 'package:eyvo_inventory/core/resources/strings_manager.dart';
import 'package:eyvo_inventory/core/resources/styles_manager.dart';
import 'package:flutter/material.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, right: 18),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Divider(
              thickness: 1.0,
              color: ColorManager.lightGrey4,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Container(
              height: 50,
              padding:
                  const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
              decoration: BoxDecoration(
                border:
                    Border.all(color: ColorManager.lightGrey4), // Border color
                borderRadius: BorderRadius.circular(25.0), // Rounded border
              ),
              child: Center(
                child: Text(
                  AppStrings.or,
                  style: getRegularStyle(
                      color: ColorManager.lightGrey1, fontSize: FontSize.s22_5),
                ),
              ),
            ),
          ),
          Expanded(
            child: Divider(
              thickness: 1.0,
              color: ColorManager.lightGrey4,
            ),
          ),
        ],
      ),
    );
  }
}
