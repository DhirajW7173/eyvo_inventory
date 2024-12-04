import 'package:eyvo_inventory/app/sizes_helper.dart';
import 'package:eyvo_inventory/core/resources/assets_manager.dart';
import 'package:eyvo_inventory/core/resources/color_manager.dart';
import 'package:eyvo_inventory/core/resources/routes_manager.dart';
import 'package:eyvo_inventory/core/resources/strings_manager.dart';
import 'package:eyvo_inventory/core/widgets/button.dart';
import 'package:eyvo_inventory/core/widgets/title_header.dart';
import 'package:flutter/material.dart';

class EmailSentView extends StatefulWidget {
  const EmailSentView({super.key});

  @override
  State<EmailSentView> createState() => _EmailSentViewState();
}

class _EmailSentViewState extends State<EmailSentView> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = displayWidth(context);
    double screenHeight = displayHeight(context);
    double topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: ColorManager.light,
      body: SingleChildScrollView(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SizedBox(
            width: screenWidth,
            child: Column(
              children: [
                SizedBox(height: topPadding),
                const SizedBox(height: 40),
                SizedBox(
                  height: screenHeight * 0.3,
                  width: screenWidth,
                  child: const Image(
                    image: AssetImage(ImageAssets.emailSendSuccessfullyImage),
                  ),
                ),
                const SizedBox(
                  child: Padding(
                      padding: EdgeInsets.only(bottom: 18, left: 18, right: 18),
                      child: CenterTitleHeader(
                          titleText: '',
                          detailText: AppStrings.emailSentSubTitle)),
                ),
                const SizedBox(height: 20),
                Container(
                    width: screenWidth * 0.7,
                    alignment: Alignment.center,
                    child: CustomButton(
                        buttonText: AppStrings.login,
                        onTap: () {
                          Navigator.pushNamedAndRemoveUntil(
                              context,
                              Routes.loginRoute,
                              (Route<dynamic> route) => false);
                        }))
              ],
            ),
          )),
    );
  }
}
