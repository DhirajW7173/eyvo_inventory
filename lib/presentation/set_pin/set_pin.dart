import 'package:eyvo_inventory/app/sizes_helper.dart';
import 'package:eyvo_inventory/core/resources/assets_manager.dart';
import 'package:eyvo_inventory/core/resources/color_manager.dart';
import 'package:eyvo_inventory/core/resources/font_manager.dart';
import 'package:eyvo_inventory/core/resources/routes_manager.dart';
import 'package:eyvo_inventory/core/resources/strings_manager.dart';
import 'package:eyvo_inventory/core/resources/styles_manager.dart';
import 'package:eyvo_inventory/core/utils.dart';
import 'package:eyvo_inventory/core/widgets/button.dart';
import 'package:eyvo_inventory/core/widgets/custom_field.dart';
import 'package:eyvo_inventory/core/widgets/title_header.dart';
import 'package:eyvo_inventory/presentation/pin_changed/pin_changed.dart';
import 'package:flutter/material.dart';

class SetPINView extends StatefulWidget {
  const SetPINView({super.key});

  @override
  State<SetPINView> createState() => _SetPINViewState();
}

class _SetPINViewState extends State<SetPINView> {
  bool isValid = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _verifyPIN(String enteredPIN) {}
  void _verifyNewPIN(String enteredPIN) {}

  @override
  Widget build(BuildContext context) {
    double topPadding = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: ColorManager.white,
      body: SingleChildScrollView(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SizedBox(
          width: displayWidth(context),
          child: Column(children: [
            SizedBox(height: topPadding),
            Container(
              height: 30,
              alignment: Alignment.topRight,
              child: CustomImageButton(
                imageString: ImageAssets.closeIcon,
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(context, Routes.loginRoute,
                      (Route<dynamic> route) => false);
                },
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(18.0),
                    child: TitleHeader(
                        titleText: AppStrings.setPINTitle,
                        detailText: AppStrings.setPINSubTitle),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: displayWidth(context),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 18, right: 18),
                      child: Text(
                        textAlign: TextAlign.left,
                        AppStrings.enterNewPIN,
                        style: getRegularStyle(
                            color: ColorManager.grey3,
                            fontSize: FontSize.s22_5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  PINField(onPINComplete: _verifyPIN, isValid: isValid),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: displayWidth(context),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 18, right: 18),
                      child: Text(
                        textAlign: TextAlign.left,
                        AppStrings.confirmNewPIN,
                        style: getRegularStyle(
                            color: ColorManager.grey3,
                            fontSize: FontSize.s22_5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  PINField(onPINComplete: _verifyNewPIN, isValid: isValid),
                  const SizedBox(height: 50),
                  SizedBox(
                    height: 90,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 18, right: 18),
                      child: CustomButton(
                          buttonText: AppStrings.resetPIN,
                          onTap: () {
                            navigateToScreen(context, const PinChangedView());
                          }),
                    ),
                  )
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
