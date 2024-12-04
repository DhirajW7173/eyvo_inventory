// ignore_for_file: use_build_context_synchronously

import 'package:eyvo_inventory/api/api_service/api_service.dart';
import 'package:eyvo_inventory/api/api_service/bloc.dart';
import 'package:eyvo_inventory/api/response_models/default_api_response.dart';
import 'package:eyvo_inventory/app/app_prefs.dart';
import 'package:eyvo_inventory/app/sizes_helper.dart';
import 'package:eyvo_inventory/core/resources/assets_manager.dart';
import 'package:eyvo_inventory/core/resources/color_manager.dart';
import 'package:eyvo_inventory/core/resources/strings_manager.dart';
import 'package:eyvo_inventory/core/widgets/button.dart';
import 'package:eyvo_inventory/core/widgets/progress_indicator.dart';
import 'package:eyvo_inventory/core/widgets/text_error.dart';
import 'package:eyvo_inventory/core/widgets/title_header.dart';
import 'package:eyvo_inventory/presentation/enter_user_id/enter_user_id.dart';
import 'package:eyvo_inventory/presentation/verify_email/verify_email.dart';
import 'package:flutter/material.dart';
import 'package:eyvo_inventory/core/widgets/custom_field.dart';

import '../../core/utils.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final emailController = TextEditingController();
  bool isError = false;
  bool isLoading = false;
  bool isFormValidated = false;
  String emailText = AppStrings.emailID;
  String errorText = AppStrings.requiresValue;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    emailController.addListener(_onTextChange);
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void validateFields() {
    if (isFormValidated) {
      setState(() {
        isError = emailController.text.isEmpty;
      });
    }
  }

  void requestForgotPassword() async {
    setState(() {
      isLoading = true;
    });
    final email = emailController.text.trim();
    SharedPrefs().userEmail = email;
    Map<String, dynamic> data = {'email': email, 'resend': false, 'userid': ''};
    final jsonResponse =
        await apiService.postRequest(context, ApiService.forgotPassword, data);
    if (jsonResponse != null) {
      final response = DefaultAPIResponse.fromJson(jsonResponse);
      final message = response.message.join(', ');
      if (response.code == '200') {
        if (message == AppStrings.multipleEmailIDFound) {
          navigateToScreen(context, const EnterUserIDView());
        } else {
          navigateToScreen(context, const VerifyEmailView(userName: ''));
        }
      } else {
        isError = true;
        errorText = message;
      }
    }
    // var res =
    //     await globalBloc.forgotUserPassword(context, email: email, userID: '');
    // final message = res.message.join(', ');
    // if (res.code == '200') {
    //   if (message == AppStrings.multipleEmailIDFound) {
    //     navigateToScreen(context, const EnterUserIDView());
    //   } else {
    //     navigateToScreen(context, const VerifyEmailView(userName: ''));
    //   }
    // } else {
    //   isError = true;
    //   errorText = message;
    // }
    setState(() {
      isLoading = false;
    });
  }

  void _onTextChange() {
    if (emailText != AppStrings.emailID) {
      setState(() {
        isError = emailController.text.trim().isEmpty;
      });
    }
    emailText = emailController.text.trim();
  }

  bool _validateEmail() {
    bool isValidEmail = RegExp(
            r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
            r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
            r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
            r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
            r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
            r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
            r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])')
        .hasMatch(emailController.text.trim());
    errorText =
        isValidEmail ? AppStrings.requiresValue : AppStrings.invalidEmail;
    return isValidEmail;
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
                          titleText: AppStrings.forgotPasswordTitle,
                          detailText: AppStrings.forgotPasswordSubTitle)),
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
                              hintText: AppStrings.emailID,
                              controller: emailController,
                              isValid: !isError,
                              onTextChanged: validateFields),
                        ),
                        isError && emailController.text.trim().isNotEmpty
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
                                    if (emailController.text.isNotEmpty) {
                                      isFormValidated = true;
                                      if (_validateEmail()) {
                                        requestForgotPassword();
                                      } else {
                                        setState(() {
                                          isError = true;
                                        });
                                      }
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
