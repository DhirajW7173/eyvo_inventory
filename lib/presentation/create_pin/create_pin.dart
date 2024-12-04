import 'package:eyvo_inventory/app/app_prefs.dart';
import 'package:eyvo_inventory/app/sizes_helper.dart';
import 'package:eyvo_inventory/core/resources/assets_manager.dart';
import 'package:eyvo_inventory/core/resources/color_manager.dart';
import 'package:eyvo_inventory/core/resources/routes_manager.dart';
import 'package:eyvo_inventory/core/resources/strings_manager.dart';
import 'package:eyvo_inventory/core/utils.dart';
import 'package:eyvo_inventory/core/widgets/button.dart';
import 'package:eyvo_inventory/core/widgets/custom_field.dart';
import 'package:eyvo_inventory/core/widgets/title_header.dart';
import 'package:eyvo_inventory/presentation/enter_pin/enter_pin.dart';
import 'package:flutter/material.dart';

class CreatePINView extends StatefulWidget {
  const CreatePINView({super.key});

  @override
  State<CreatePINView> createState() => _CreatePINViewState();
}

class _CreatePINViewState extends State<CreatePINView> {
  bool isValid = true;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  void _savePIN(String enteredPIN) {
    SharedPrefs().appPIN = enteredPIN;
  }

  @override
  Widget build(BuildContext context) {
    double topPadding = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: ColorManager.white,
      body: Column(
        children: [
          SizedBox(height: topPadding),
          Container(
            alignment: Alignment.topRight,
            width: displayWidth(context),
            child: CustomImageButton(
                imageString: ImageAssets.closeIcon,
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(context, Routes.loginRoute,
                      (Route<dynamic> route) => false);
                }),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 0, left: 18, right: 18, bottom: 0),
            child: SizedBox(
              child: Column(
                children: [
                  const TitleHeader(
                      titleText: AppStrings.createPINTitle,
                      detailText: AppStrings.createPINSubtTitle),
                  const SizedBox(height: 50),
                  SizedBox(
                      child:
                          PINField(onPINComplete: _savePIN, isValid: isValid)),
                  const SizedBox(height: 30),
                  SizedBox(
                    height: 100,
                    child: CustomButton(
                        buttonText: AppStrings.proceed,
                        onTap: () {
                          navigateToScreen(context, const EnterPINView());
                        }),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
