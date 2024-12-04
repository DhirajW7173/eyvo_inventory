// ignore_for_file: use_build_context_synchronously

import 'package:eyvo_inventory/api/api_service/api_service.dart';
import 'package:eyvo_inventory/api/api_service/bloc.dart';
import 'package:eyvo_inventory/api/response_models/default_api_response.dart';
import 'package:eyvo_inventory/app/app_prefs.dart';
import 'package:eyvo_inventory/app/sizes_helper.dart';
import 'package:eyvo_inventory/core/resources/assets_manager.dart';
import 'package:eyvo_inventory/core/resources/color_manager.dart';
import 'package:eyvo_inventory/core/resources/strings_manager.dart';
import 'package:eyvo_inventory/core/utils.dart';
import 'package:eyvo_inventory/core/widgets/button.dart';
import 'package:eyvo_inventory/core/widgets/custom_field.dart';
import 'package:eyvo_inventory/core/widgets/progress_indicator.dart';
import 'package:eyvo_inventory/core/widgets/text_error.dart';
import 'package:eyvo_inventory/core/widgets/title_header.dart';
import 'package:eyvo_inventory/presentation/verify_email/verify_email.dart';
import 'package:flutter/material.dart';

class EnterUserIDView extends StatefulWidget {
  const EnterUserIDView({super.key});

  @override
  State<EnterUserIDView> createState() => _EnterUserIDViewState();
}

class _EnterUserIDViewState extends State<EnterUserIDView> {
  final userNameController = TextEditingController();
  bool isError = true;
  bool isLoading = false;
  bool isFormValidated = false;
  String userIDText = AppStrings.userID;
  String errorText = AppStrings.multipleUserIDFound;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    userNameController.addListener(_onTextChange);
  }

  @override
  void dispose() {
    userNameController.dispose();
    super.dispose();
  }

  void validateFields() {
    if (isFormValidated) {
      setState(() {
        isError = userNameController.text.isEmpty;
      });
    }
  }

  void requestForgotPassword() async {
    setState(() {
      isLoading = true;
    });
    final userID = userNameController.text.trim();
    Map<String, dynamic> data = {
      'email': SharedPrefs().userEmail,
      'resend': false,
      'userid': userID
    };
    final jsonResponse =
        await apiService.postRequest(context, ApiService.forgotPassword, data);
    if (jsonResponse != null) {
      final response = DefaultAPIResponse.fromJson(jsonResponse);
      if (response.code == '200') {
        navigateToScreen(context, VerifyEmailView(userName: userID));
      } else {
        isError = true;
        errorText = response.message.join(', ');
      }
    }

    //   var res = await globalBloc.forgotUserPassword(context,
    //       email: SharedPrefs().userEmail, userID: userID);
    //   if (res.code == '200') {
    //     navigateToScreen(context, VerifyEmailView(userName: userID));
    //   } else {
    //     isError = true;
    //     errorText = res.message.join(', ');
    //   }

    //   setState(() {
    //     isLoading = false;
    //   });
  }

  void _onTextChange() {
    if (userIDText != AppStrings.userID) {
      setState(() {
        isError = userNameController.text.trim().isEmpty;
      });
    }
    userIDText = userNameController.text.trim();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = displayWidth(context);
    double screenHeight = displayHeight(context);
    double topPadding = MediaQuery.of(context).padding.top;
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        backgroundColor: ColorManager.light,
        body: SingleChildScrollView(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SizedBox(
            width: screenWidth,
            child: Column(
              children: [
                SizedBox(height: topPadding),
                Container(
                  height: 30,
                  alignment: Alignment.topRight,
                  width: displayWidth(context),
                  child: CustomImageButton(
                      imageString: ImageAssets.closeIcon,
                      onTap: () {
                        Navigator.pop(context);
                      }),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: screenHeight * 0.3,
                  width: screenWidth,
                  child: const Image(
                    image: AssetImage(ImageAssets.forgotPasswordImage),
                  ),
                ),
                const SizedBox(
                  child: Padding(
                      padding: EdgeInsets.only(bottom: 18, left: 18, right: 18),
                      child: TitleHeader(
                          titleText: AppStrings.enterUserIDTitle,
                          detailText: AppStrings.enterUserIDSubTitle)),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      children: [
                        SizedBox(
                          child: CustomTextField(
                              iconString: ImageAssets.emailIDIcon,
                              hintText: AppStrings.userID,
                              controller: userNameController,
                              isValid: !isError,
                              onTextChanged: validateFields),
                        ),
                        isError && userNameController.text.trim().isNotEmpty
                            ? const SizedBox(height: 20)
                            : const SizedBox(),
                        isError
                            ? ErrorTextViewBox(titleString: errorText)
                            : const SizedBox(
                                height: 60,
                              ),
                        isError ? const SizedBox(height: 20) : const SizedBox(),
                        isLoading
                            ? const CustomProgressIndicator()
                            : SizedBox(
                                child: CustomButton(
                                  buttonText: AppStrings.send,
                                  onTap: () {
                                    if (userNameController.text.isNotEmpty) {
                                      isFormValidated = true;
                                      requestForgotPassword();
                                    } else {
                                      setState(() {
                                        isError = true;
                                      });
                                    }
                                  },
                                ),
                              )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
