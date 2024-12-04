// ignore_for_file: use_build_context_synchronously

import 'package:eyvo_inventory/api/api_service/api_service.dart';
import 'package:eyvo_inventory/api/api_service/bloc.dart';
import 'package:eyvo_inventory/api/response_models/default_api_response.dart';
import 'package:eyvo_inventory/app/app_prefs.dart';
import 'package:eyvo_inventory/app/sizes_helper.dart';
import 'package:eyvo_inventory/core/resources/assets_manager.dart';
import 'package:eyvo_inventory/core/resources/color_manager.dart';
import 'package:eyvo_inventory/core/resources/constants.dart';
import 'package:eyvo_inventory/core/resources/font_manager.dart';
import 'package:eyvo_inventory/core/resources/strings_manager.dart';
import 'package:eyvo_inventory/core/resources/styles_manager.dart';
import 'package:eyvo_inventory/core/utils.dart';
import 'package:eyvo_inventory/core/widgets/button.dart';
import 'package:eyvo_inventory/core/widgets/custom_field.dart';
import 'package:eyvo_inventory/core/widgets/progress_indicator.dart';
import 'package:eyvo_inventory/core/widgets/text_error.dart';
import 'package:flutter/material.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isOldPasswordError = false;
  bool isPasswordError = false;
  bool isConfirmPasswordError = false;
  bool isFormValidated = false;
  bool isLoading = false;
  String oldPasswordText = AppStrings.oldPassword;
  String passwordText = AppStrings.newPassword;
  String confirmPasswordText = AppStrings.confirmPassword;
  String errorText = AppStrings.requiresValue;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();

    oldPasswordController.addListener(_onOldPasswordTextChange);
    newPasswordController.addListener(_onPasswordTextChange);
    confirmPasswordController.addListener(_onConfirmPasswordTextChange);
  }

  @override
  void dispose() {
    super.dispose();
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
  }

  void changePassword() async {
    setState(() {
      isLoading = true;
    });
    final uID = SharedPrefs().uID;
    final oldPassword = oldPasswordController.text.trim();
    final password = newPasswordController.text.trim();
    final userSession = SharedPrefs().userSession;
    // Map<String, dynamic> data = {
    //   'uid': uID,
    //   'oldpassword': oldPassword,
    //   'password': password,
    //   'usersession': userSession
    // };
    // final jsonResponse =
    //     await apiService.postRequest(context, ApiService.changePassword, data);
    // if (jsonResponse != null) {
    //   final response = DefaultAPIResponse.fromJson(jsonResponse);
    //   if (response.code == '200') {
    //     setState(() {
    //       showSuccessDialog(
    //           context,
    //           ImageAssets.passwordChangedImage,
    //           AppStrings.passwordChangedTitle,
    //           AppStrings.passwordChangedSubTitle,
    //           false);
    //     });
    //   } else {
    //     isConfirmPasswordError = true;
    //     errorText = response.message.join(', ');
    //   }
    // }
    var res = await globalBloc.doChangeUserPassword(context,
        uID: uID,
        oldPassword: oldPassword,
        password: password,
        userSession: userSession);
    if (res.code == '200') {
      setState(() {
        showSuccessDialog(
            context,
            ImageAssets.passwordChangedImage,
            AppStrings.passwordChangedTitle,
            AppStrings.passwordChangedSubTitle,
            false);
      });
    } else {
      isConfirmPasswordError = true;
      errorText = res.message.join(', ');
    }

    setState(() {
      isLoading = false;
    });
  }

  void validateFields() {
    if (isFormValidated) {
      setState(() {
        isPasswordError = newPasswordController.text.isEmpty;
        isConfirmPasswordError = confirmPasswordController.text.isEmpty;
        errorText = AppStrings.requiresValue;
      });
    }
  }

  void _onOldPasswordTextChange() {
    if (oldPasswordText != AppStrings.oldPassword) {
      setState(() {
        isOldPasswordError = oldPasswordController.text.trim().isEmpty;
      });
    }
    oldPasswordText = oldPasswordController.text.trim();
    if (oldPasswordText.isNotEmpty &&
        oldPasswordText != AppStrings.oldPassword &&
        oldPasswordText.length < AppConstants.minPasswordLength) {
      errorText = AppStrings.invalidPassword;
    }
  }

  void _onPasswordTextChange() {
    if (passwordText != AppStrings.newPassword) {
      setState(() {
        isPasswordError = newPasswordController.text.trim().isEmpty;
      });
    }
    passwordText = newPasswordController.text.trim();
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
        password == AppStrings.oldPassword) {
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

    return Scaffold(
      backgroundColor: ColorManager.primary,
      appBar: AppBar(
        backgroundColor: ColorManager.darkBlue,
        title: Text(AppStrings.changePassword,
            style: getBoldStyle(
                color: ColorManager.white, fontSize: FontSize.s27)),
        leading: IconButton(
          icon: Image.asset(ImageAssets.backButton),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Container(
                decoration: BoxDecoration(
                    color: ColorManager.white,
                    border: Border.all(color: ColorManager.grey4, width: 1.0),
                    borderRadius: BorderRadius.circular(8)),
                width: screenWidth,
                child: Column(
                  children: [
                    SizedBox(
                      height: screenHeight * 0.25,
                      width: screenWidth,
                      child: const Image(
                        image: AssetImage(ImageAssets.resetPasswordImage),
                      ),
                    ),
                    SizedBox(
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          children: [
                            SizedBox(
                              child: CustomTextField(
                                  iconString: ImageAssets.passwordIcon,
                                  hintText: AppStrings.oldPassword,
                                  controller: oldPasswordController,
                                  isValid: true,
                                  onTextChanged: () {},
                                  isObscureText: true),
                            ),
                            isOldPasswordError
                                ? ErrorTextViewBox(titleString: errorText)
                                : const SizedBox(
                                    height: 20,
                                  ),
                            isOldPasswordError
                                ? const SizedBox(height: 20)
                                : const SizedBox(),
                            SizedBox(
                              child: CustomTextField(
                                  iconString: ImageAssets.passwordIcon,
                                  hintText: AppStrings.newPassword,
                                  controller: newPasswordController,
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
                                    height: 10,
                                  ),
                            isConfirmPasswordError
                                ? const SizedBox(height: 30)
                                : const SizedBox(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: ColorManager.white,
              width: screenWidth,
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: SizedBox(
                      child: isLoading
                          ? const CustomProgressIndicator()
                          : CustomButton(
                              buttonText: AppStrings.changePassword,
                              onTap: () {
                                isFormValidated = true;
                                validateFields();
                                if (!isOldPasswordError &&
                                    !isPasswordError &&
                                    !isConfirmPasswordError &&
                                    _validatePassword(oldPasswordText) &&
                                    _validatePassword(passwordText) &&
                                    _validatePassword(confirmPasswordText) &&
                                    passwordText == confirmPasswordText) {
                                  changePassword();
                                } else {
                                  setState(() {
                                    if (!_validatePassword(oldPasswordText)) {
                                      isOldPasswordError = true;
                                    }
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
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
