// ignore_for_file: use_build_context_synchronously

import 'package:eyvo_inventory/api/api_service/api_service.dart';
import 'package:eyvo_inventory/api/response_models/default_api_response.dart';
import 'package:eyvo_inventory/app/app_prefs.dart';
import 'package:eyvo_inventory/app/sizes_helper.dart';
import 'package:eyvo_inventory/core/resources/assets_manager.dart';
import 'package:eyvo_inventory/core/resources/color_manager.dart';
import 'package:eyvo_inventory/core/resources/constants.dart';
import 'package:eyvo_inventory/core/resources/routes_manager.dart';
import 'package:eyvo_inventory/core/resources/strings_manager.dart';
import 'package:eyvo_inventory/core/utils.dart';
import 'package:eyvo_inventory/core/widgets/button.dart';
import 'package:eyvo_inventory/core/widgets/custom_field.dart';
import 'package:eyvo_inventory/core/widgets/progress_indicator.dart';
import 'package:eyvo_inventory/core/widgets/text_error.dart';
import 'package:eyvo_inventory/core/widgets/title_header.dart';
import 'package:eyvo_inventory/presentation/password_changed/password_changed.dart';
import 'package:flutter/material.dart';

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({super.key});

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isPasswordError = false;
  bool isConfirmPasswordError = false;
  bool isFormValidated = false;
  bool isLoading = false;
  String passwordText = AppStrings.newPassword;
  String confirmPasswordText = AppStrings.confirmPassword;
  String errorText = AppStrings.requiresValue;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();

    passwordController.addListener(_onPasswordTextChange);
    confirmPasswordController.addListener(_onConfirmPasswordTextChange);
  }

  @override
  void dispose() {
    super.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  void changePassword() async {
    setState(() {
      isLoading = true;
    });
    final email = SharedPrefs().userEmail;
    final password = passwordController.text.trim();

    Map<String, dynamic> data = {
      'email': email,
      'password': password,
    };
    final jsonResponse =
        await apiService.postRequest(context, ApiService.resetPassword, data);
    if (jsonResponse != null) {
      final response = DefaultAPIResponse.fromJson(jsonResponse);
      if (response.code == '200') {
        navigateToScreen(context, const PasswordChangedView());
      } else {
        isPasswordError = true;
        errorText = response.message.join(', ');
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  void validateFields() {
    if (isFormValidated) {
      setState(() {
        isPasswordError = passwordController.text.isEmpty;
        isConfirmPasswordError = confirmPasswordController.text.isEmpty;
        errorText = AppStrings.requiresValue;
      });
    }
  }

  void _onPasswordTextChange() {
    if (passwordText != AppStrings.newPassword) {
      setState(() {
        isPasswordError = passwordController.text.trim().isEmpty;
      });
    }
    passwordText = passwordController.text.trim();
    if (passwordText.isNotEmpty &&
        passwordText != AppStrings.newPassword &&
        passwordText.length < AppConstants.minPasswordLength &&
        confirmPasswordText != AppStrings.confirmPassword &&
        confirmPasswordText.length < AppConstants.minPasswordLength) {
      errorText = AppStrings.invalidPassword;
    }
  }

  void _onConfirmPasswordTextChange() {
    if (confirmPasswordText != AppStrings.confirmPassword) {
      setState(() {
        isConfirmPasswordError = confirmPasswordController.text.trim().isEmpty;
      });
    }
    confirmPasswordText = confirmPasswordController.text.trim();
    if (passwordText.isNotEmpty &&
        passwordText != AppStrings.newPassword &&
        passwordText.length < AppConstants.minPasswordLength &&
        confirmPasswordText != AppStrings.confirmPassword &&
        confirmPasswordText.length < AppConstants.minPasswordLength) {
      errorText = AppStrings.invalidPassword;
    }
  }

  bool _validatePassword(String password) {
    errorText = '';
    if (password.isEmpty ||
        password == AppStrings.newPassword ||
        password == AppStrings.confirmPassword ||
        password == AppStrings.password) {
      errorText = AppStrings.requiresValue;
      return false;
    }
    // Password length greater than 6
    if (password.length < AppConstants.minPasswordLength) {
      errorText = AppStrings.invalidPassword;
    }
    // Contains at least one uppercase letter
    if (!password.contains(RegExp(r'[A-Z]'))) {
      errorText = AppStrings.invalidPassword;
    }
    // Contains at least one lowercase letter
    if (!password.contains(RegExp(r'[a-z]'))) {
      errorText = AppStrings.invalidPassword;
    }
    // Contains at least one digit
    if (!password.contains(RegExp(r'[0-9]'))) {
      errorText = AppStrings.invalidPassword;
    }
    return errorText.isEmpty;
  }

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
              Container(
                height: 30,
                alignment: Alignment.topRight,
                width: displayWidth(context),
                child: CustomImageButton(
                    imageString: ImageAssets.closeIcon,
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(context,
                          Routes.loginRoute, (Route<dynamic> route) => false);
                    }),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: screenHeight * 0.3,
                width: screenWidth,
                child: const Image(
                  image: AssetImage(ImageAssets.resetPasswordImage),
                ),
              ),
              const SizedBox(
                child: Padding(
                    padding: EdgeInsets.only(bottom: 18, left: 18, right: 18),
                    child: TitleHeader(
                        titleText: AppStrings.resetPasswordTitle,
                        detailText: AppStrings.resetPasswordSubTitle)),
              ),
              const SizedBox(height: 20),
              SizedBox(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: [
                      SizedBox(
                        child: CustomTextField(
                            iconString: ImageAssets.passwordIcon,
                            hintText: AppStrings.newPassword,
                            controller: passwordController,
                            isValid: !isPasswordError,
                            onTextChanged: validateFields,
                            isObscureText: true),
                      ),
                      isPasswordError
                          ? ErrorTextViewBox(titleString: errorText)
                          : const SizedBox(
                              height: 20,
                            ),
                      isPasswordError
                          ? const SizedBox(height: 20)
                          : const SizedBox(),
                      SizedBox(
                        child: CustomTextField(
                            iconString: ImageAssets.passwordIcon,
                            hintText: AppStrings.confirmPassword,
                            controller: confirmPasswordController,
                            isValid: !isConfirmPasswordError,
                            onTextChanged: validateFields,
                            isObscureText: true),
                      ),
                      isConfirmPasswordError
                          ? ErrorTextViewBox(titleString: errorText)
                          : const SizedBox(
                              height: 40,
                            ),
                      isConfirmPasswordError
                          ? const SizedBox(height: 30)
                          : const SizedBox(),
                      SizedBox(
                        child: isLoading
                            ? const CustomProgressIndicator()
                            : CustomButton(
                                buttonText: AppStrings.resetPassword,
                                onTap: () {
                                  isFormValidated = true;
                                  validateFields();
                                  if (!isPasswordError &&
                                      !isConfirmPasswordError &&
                                      _validatePassword(passwordText) &&
                                      _validatePassword(confirmPasswordText) &&
                                      passwordText == confirmPasswordText) {
                                    changePassword();
                                  } else {
                                    setState(() {
                                      if (!_validatePassword(passwordText)) {
                                        isPasswordError = true;
                                      }
                                      if (!_validatePassword(
                                          confirmPasswordText)) {
                                        isConfirmPasswordError = true;
                                      }
                                      if (!isPasswordError &&
                                          !isConfirmPasswordError &&
                                          passwordText != confirmPasswordText) {
                                        errorText = AppStrings.passwordNotMatch;
                                        isConfirmPasswordError = true;
                                      }
                                    });
                                  }
                                },
                              ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
