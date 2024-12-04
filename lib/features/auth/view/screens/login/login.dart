// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:eyvo_inventory/api/api_service/api_service.dart';
import 'package:eyvo_inventory/api/api_service/bloc.dart';
import 'package:eyvo_inventory/api/response_models/load_login_response.dart';
import 'package:eyvo_inventory/api/response_models/login_response.dart';

import 'package:eyvo_inventory/app/app_prefs.dart';
import 'package:eyvo_inventory/app/sizes_helper.dart';
import 'package:eyvo_inventory/core/resources/assets_manager.dart';
import 'package:eyvo_inventory/core/resources/color_manager.dart';
import 'package:eyvo_inventory/core/resources/font_manager.dart';
import 'package:eyvo_inventory/core/resources/routes_manager.dart';
import 'package:eyvo_inventory/core/resources/strings_manager.dart';
import 'package:eyvo_inventory/core/resources/styles_manager.dart';
import 'package:eyvo_inventory/core/utils.dart';
import 'package:eyvo_inventory/core/widgets/alert.dart';
import 'package:eyvo_inventory/core/widgets/button.dart';
import 'package:eyvo_inventory/core/widgets/checkbox_list_tile.dart';
import 'package:eyvo_inventory/core/widgets/custom_field.dart';
import 'package:eyvo_inventory/core/widgets/dashed_line_text.dart';
import 'package:eyvo_inventory/core/widgets/header_logo.dart';
import 'package:eyvo_inventory/core/widgets/or_divider.dart';
import 'package:eyvo_inventory/core/widgets/progress_indicator.dart';
import 'package:eyvo_inventory/core/widgets/text_error.dart';
import 'package:eyvo_inventory/presentation/forgot_password/forgot_password.dart';
import 'package:eyvo_inventory/presentation/forgot_user_id/forgot_user_id.dart';
import 'package:eyvo_inventory/presentation/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginViewPage extends StatefulWidget {
  const LoginViewPage({super.key});

  @override
  State<LoginViewPage> createState() => _LoginViewPageState();
}

class _LoginViewPageState extends State<LoginViewPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool checkedValue = false;
  bool isUserNameError = false;
  bool isPasswordError = false;
  bool isFormValidated = false;
  bool isLoading = false;
  bool isLoadingForScan = false;
  bool isLoginWithScan = false;
  String userNameText = AppStrings.userID;
  String passwordText = AppStrings.password;
  String errorText = AppStrings.requiresValue;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    fetchLoginDetails();

    usernameController.addListener(_onUserNameTextChange);
    passwordController.addListener(_onPasswordTextChange);

    usernameController.text = SharedPrefs().username;
    passwordController.text = SharedPrefs().password;
    checkedValue = SharedPrefs().isRememberMeSelected;
    if (usernameController.text.isEmpty && passwordController.text.isEmpty) {
      checkedValue = false;
    }

    SharedPrefs().userEmail = '';
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
    formKey.currentState?.validate();
  }

  void fetchLoginDetails() async {
    Map<String, dynamic> data = {
      'uid': SharedPrefs().uID,
    };
    final jsonResponse =
        await apiService.postRequest(context, ApiService.loadLogin, data);
    if (jsonResponse != null) {
      final response = LoadLoginResponse.fromJson(jsonResponse);
      if (response.code == '200') {
        setState(() {
          isLoginWithScan = response.data.isLoginWithScan;
        });
      } else {
        isLoginWithScan = false;
      }
    }
    // var res = await globalBloc.doFetchLoginUserData(context, SharedPrefs().uID);
    // if (res != null) {
    //   var response = LoadLoginResponse.fromJson(res);
    //   if (response.code == '200') {
    //     setState(() {
    //       isLoginWithScan = response.data.isLoginWithScan;
    //     });
    //   } else {
    //     isLoginWithScan = false;
    //   }
    //}
  }

  void validateFields() {
    if (isFormValidated) {
      setState(() {
        isUserNameError = usernameController.text.isEmpty;
        isPasswordError = passwordController.text.isEmpty;
        errorText = AppStrings.requiresValue;
      });
    }
  }

  void loginUser() async {
    setState(() {
      isLoading = true;
    });
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (checkedValue) {
      SharedPrefs().username = username;
      SharedPrefs().password = password;
    } else {
      SharedPrefs().username = '';
      SharedPrefs().password = '';
    }

    Map<String, dynamic> data = {
      'userid': username,
      'password': password,
    };

    final jsonResponse =
        await apiService.postRequest(context, ApiService.login, data);

    if (jsonResponse != null) {
      final response = LoginResponse.fromJson(jsonResponse);
      if (response.code == '200') {
        SharedPrefs().uID = response.data.uid;
        SharedPrefs().jwtToken = response.data.jwttoken;
        SharedPrefs().refreshToken = response.data.jwtrefreshtoken;
        SharedPrefs().userSession = response.data.userSession;
        navigateToScreen(context, const HomeView());
      } else {
        isPasswordError = true;
        errorText = response.message.join(', ');
      }
    }

    // var res = await globalBloc.doSignInUser(context,
    //     userName: username, password: password);
    // if (res.code == '200') {
    //   SharedPrefs().uID = res.data.uid;
    //   SharedPrefs().jwtToken = res.data.jwttoken;
    //   SharedPrefs().refreshToken = res.data.jwtrefreshtoken;
    //   SharedPrefs().userSession = res.data.userSession;
    //   navigateToScreen(context, const HomeView());
    // } else {
    //   isPasswordError = true;
    //   errorText = res.message.join(', ');
    // }

    setState(() {
      isLoading = false;
    });
  }

  void clearCompanyCode() {
    SharedPrefs().companyCode = '';
    SharedPrefs().username = '';
    SharedPrefs().password = '';
    Navigator.pushNamedAndRemoveUntil(
        context, Routes.companyCodeRoute, (Route<dynamic> route) => false);
  }

  void showClearCompanyCodeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomImageActionAlert(
            iconString: '',
            imageString: ImageAssets.clearCompanyCodeImage,
            titleString: AppStrings.clearCompanyCodeTitle,
            subTitleString: AppStrings.clearCompanyCodeSubTitle,
            destructiveActionString: AppStrings.yes,
            normalActionString: AppStrings.no,
            onDestructiveActionTap: () {
              clearCompanyCode();
            },
            onNormalActionTap: () {
              Navigator.pop(context);
            });
      },
    );
  }

  void _onUserNameTextChange() {
    if (userNameText != AppStrings.userID) {
      setState(() {
        isUserNameError = usernameController.text.trim().isEmpty;
      });
    }
    userNameText = usernameController.text.trim();
  }

  void _onPasswordTextChange() {
    if (passwordText != AppStrings.password) {
      setState(() {
        isPasswordError = passwordController.text.trim().isEmpty;
      });
    }
    passwordText = passwordController.text.trim();
    errorText = AppStrings.requiresValue;
  }

  Future<void> scanBarcode() async {
    try {
      ScanResult barcodeScanResult = await BarcodeScanner.scan();
      String resultString = barcodeScanResult.rawContent;
      if (resultString.isNotEmpty && resultString != "-1") {
        Map<String, dynamic> jsonDict = jsonDecode(resultString);
        loginWithScan(jsonDict['uid']);
      }
    } catch (e) {
      setState(() {
        errorText = "Failed to scan";
      });
    }
  }

  void loginWithScan(int userId) async {
    SharedPrefs().username = '';
    SharedPrefs().password = '';
    setState(() {
      isLoadingForScan = true;
    });

    Map<String, dynamic> data = {
      'uid': '$userId',
      'mode': 'scan',
    };
    final jsonResponse =
        await apiService.postRequest(context, ApiService.externalLogin, data);

    if (jsonResponse != null) {
      final response = LoginResponse.fromJson(jsonResponse);
      setState(() {
        if (response.code == '200') {
          SharedPrefs().uID = response.data.uid;
          SharedPrefs().jwtToken = response.data.jwttoken;
          SharedPrefs().refreshToken = response.data.jwtrefreshtoken;
          SharedPrefs().userSession = response.data.userSession;
          navigateToScreen(context, const HomeView());
        } else {
          isPasswordError = true;
          errorText = response.message.join(', ');
        }
      });
    }

    // var res = await globalBloc.doSignInUserWithBarcode(context,
    //     userId: '$userId', mode: 'scan');

    // setState(() {
    //   if (res.code == '200') {
    //     SharedPrefs().uID = res.data.uid;
    //     SharedPrefs().jwtToken = res.data.jwttoken;
    //     SharedPrefs().refreshToken = res.data.jwtrefreshtoken;
    //     SharedPrefs().userSession = res.data.userSession;
    //     navigateToScreen(context, const HomeView());
    //   } else {
    //     isPasswordError = true;
    //     errorText = res.message.join(', ');
    //   }
    // });

    setState(() {
      isLoadingForScan = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) => {SystemNavigator.pop()},
        child: SingleChildScrollView(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            children: [
              const HeaderLogo(),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: SizedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 15),
                      SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppStrings.companyCodeDetail,
                              style: getRegularStyle(
                                  color: ColorManager.black,
                                  fontSize: FontSize.s20),
                            ),
                            GestureDetector(
                              onTap: () {
                                showClearCompanyCodeDialog(context);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: DashedLineText(
                                    titleString: SharedPrefs().companyCode,
                                    titleStyle: getDottedUnderlineSemiBoldStyle(
                                        color: ColorManager.orange,
                                        lineColor: ColorManager.lightGrey1)),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: displayWidth(context),
                        child: Row(
                          children: [
                            const Spacer(),
                            CustomTextButton(
                              buttonText: AppStrings.forgotUserID,
                              onTap: () {
                                navigateToScreen(
                                    context, const ForgotUserIDView());
                              },
                            ),
                          ],
                        ),
                      ),
                      CustomTextField(
                          iconString: ImageAssets.userIdIcon,
                          hintText: AppStrings.userID,
                          controller: usernameController,
                          isValid: !isUserNameError,
                          onTextChanged: validateFields),
                      isUserNameError
                          ? const ErrorTextViewBox()
                          : const SizedBox(),
                      isUserNameError
                          ? const SizedBox(height: 20)
                          : const SizedBox(),
                      SizedBox(
                        width: displayWidth(context),
                        child: Row(
                          children: [
                            const Spacer(),
                            CustomTextButton(
                              buttonText: AppStrings.forgotPassword,
                              onTap: () {
                                navigateToScreen(
                                    context, const ForgotPasswordView());
                              },
                            ),
                          ],
                        ),
                      ),
                      CustomTextField(
                          iconString: ImageAssets.passwordIcon,
                          hintText: AppStrings.password,
                          controller: passwordController,
                          isObscureText: true,
                          isValid: !isPasswordError,
                          onTextChanged: validateFields),
                      isPasswordError
                          ? ErrorTextViewBox(titleString: errorText)
                          : const SizedBox(),
                      isPasswordError
                          ? const SizedBox(height: 20)
                          : const SizedBox(),
                      CustomCheckboxListTile(
                        title: Text(
                          AppStrings.rememberMe,
                          style: getRegularStyle(
                              color: ColorManager.lightGrey1,
                              fontSize: FontSize.s18),
                        ),
                        value: checkedValue,
                        onChanged: (value) {
                          setState(() {
                            checkedValue = value!;
                            SharedPrefs().isRememberMeSelected = checkedValue;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      isLoading
                          ? const CustomProgressIndicator()
                          : CustomButton(
                              buttonText: AppStrings.signIn,
                              onTap: () {
                                isFormValidated = true;
                                validateFields();
                                if (!isUserNameError && !isPasswordError) {
                                  loginUser();
                                }
                              },
                            ),
                      const SizedBox(height: 30),
                      isLoginWithScan
                          ? const SizedBox(height: 10)
                          : const SizedBox(),
                      isLoginWithScan
                          ? Column(
                              children: [
                                const OrDivider(),
                                const SizedBox(height: 20),
                                isLoadingForScan
                                    ? const CustomProgressIndicator()
                                    : CustomButton(
                                        buttonText: AppStrings.loginWithBarcode,
                                        onTap: () {
                                          scanBarcode();
                                        },
                                        isDefault: true),
                                const SizedBox(height: 30),
                              ],
                            )
                          : const SizedBox()
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
