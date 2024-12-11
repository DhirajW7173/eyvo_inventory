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
import 'package:eyvo_inventory/presentation/email_sent/email_sent.dart';
import 'package:flutter/material.dart';

class ForgotUserIDView extends StatefulWidget {
  const ForgotUserIDView({super.key});

  @override
  State<ForgotUserIDView> createState() => _ForgotUserIDViewState();
}

class _ForgotUserIDViewState extends State<ForgotUserIDView> {
  final emailController = TextEditingController();
  bool isError = false;
  bool isFormValidated = false;
  bool isLoading = false;
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

  void _onTextChange() {
    if (emailText != AppStrings.emailID) {
      setState(() {
        isError = emailController.text.trim().isEmpty;
      });
    }
    emailText = emailController.text.trim();
  }

  void validateFields() {
    if (isFormValidated) {
      setState(() {
        isError = emailController.text.isEmpty;
      });
    }
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

  void requestForgotUserID() async {
    setState(() {
      isLoading = true;
    });
    final email = emailController.text.trim();
    SharedPrefs().userEmail = email;
    Map<String, dynamic> data = {
      'email': email,
    };
    final jsonResponse =
        await apiService.postRequest(context, ApiService.forgotUserID, data);
    if (jsonResponse != null) {
      final response = DefaultAPIResponse.fromJson(jsonResponse);
      if (response.code == '200') {
        navigateToScreen(context, const EmailSentView());
      } else {
        isError = true;
        errorText = response.message.join(', ');
      }
    }

    // var res = await globalBloc.forgotUserId(context, email);

    // if (res.code == '200') {
    //   navigateToScreen(context, const EmailSentView());
    // } else {
    //   isError = true;
    //   errorText = res.message.join(', ');
    // }

    setState(() {
      isLoading = false;
    });
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
                          titleText: AppStrings.forgotUserIDTitle,
                          detailText: AppStrings.forgotUserIDSubTitle)),
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
                                        requestForgotUserID();
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
