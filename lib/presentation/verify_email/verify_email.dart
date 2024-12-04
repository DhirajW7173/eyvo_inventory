// ignore_for_file: use_build_context_synchronously

import 'package:eyvo_inventory/api/api_service/api_service.dart';
import 'package:eyvo_inventory/api/response_models/default_api_response.dart';
import 'package:eyvo_inventory/app/app_prefs.dart';
import 'package:eyvo_inventory/app/sizes_helper.dart';
import 'package:eyvo_inventory/core/resources/assets_manager.dart';
import 'package:eyvo_inventory/core/resources/color_manager.dart';
import 'package:eyvo_inventory/core/resources/constants.dart';
import 'package:eyvo_inventory/core/resources/font_manager.dart';
import 'package:eyvo_inventory/core/resources/routes_manager.dart';
import 'package:eyvo_inventory/core/resources/strings_manager.dart';
import 'package:eyvo_inventory/core/resources/styles_manager.dart';
import 'package:eyvo_inventory/core/utils.dart';
import 'package:eyvo_inventory/core/widgets/button.dart';
import 'package:eyvo_inventory/core/widgets/custom_field.dart';
import 'package:eyvo_inventory/core/widgets/dashed_line_text.dart';
import 'package:eyvo_inventory/core/widgets/progress_indicator.dart';
import 'package:eyvo_inventory/core/widgets/text_error.dart';
import 'package:eyvo_inventory/core/widgets/title_header.dart';
import 'package:eyvo_inventory/presentation/reset_password/reset_password.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class VerifyEmailView extends StatefulWidget {
  final String userName;
  const VerifyEmailView({super.key, required this.userName});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  int _start = AppConstants.resentCodeTimer;
  bool _isButtonDisabled = true;
  Timer? _timer;
  String otp = '';
  bool isValid = true;
  bool isLoading = false;
  final ApiService apiService = ApiService();
  bool isError = false;
  String errorText = AppStrings.requiresValue;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _isButtonDisabled = true;
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            _isButtonDisabled = false;
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void resendOtp() async {
    setState(() {
      _start = AppConstants.resentCodeTimer;
      _isButtonDisabled = true;
      isLoading = true;
    });
    startTimer();

    Map<String, dynamic> data = {
      'email': SharedPrefs().userEmail,
      'resend': true,
      'userid': widget.userName
    };
    final jsonResponse =
        await apiService.postRequest(context, ApiService.forgotPassword, data);
    if (jsonResponse != null) {
      final response = DefaultAPIResponse.fromJson(jsonResponse);
      if (response.code == '200') {
      } else {
        isError = true;
        errorText = response.message.join(', ');
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  void _verifyOTP(String enteredOTP) {
    otp = enteredOTP;
  }

  void verifyEmail() async {
    if (otp.isEmpty) {
      isError = true;
      errorText = AppStrings.otpEmpty;
    } else {
      setState(() {
        isLoading = true;
        isError = false;
      });
      Map<String, dynamic> data = {
        'email': SharedPrefs().userEmail,
        'otp': otp
      };
      final jsonResponse =
          await apiService.postRequest(context, ApiService.verifyOTP, data);
      if (jsonResponse != null) {
        final response = DefaultAPIResponse.fromJson(jsonResponse);

        if (response.code == '200') {
          navigateToScreen(context, const ResetPasswordView());
        } else {
          isError = true;
          errorText = response.message.join(', ');
        }
      }

      setState(() {
        isLoading = false;
      });
    }
  }

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
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: SizedBox(
                  child: Column(
                    children: [
                      const TitleHeader(
                          titleText: AppStrings.verifyEmailIDTitle,
                          detailText: AppStrings.verifyEmailIDSubTitle),
                      const SizedBox(height: 20),
                      OTPField(
                        onOTPComplete: _verifyOTP,
                        isValid: isValid,
                      ),
                      const SizedBox(height: 30),
                      Container(
                        alignment: Alignment.center,
                        width: displayWidth(context),
                        child: _isButtonDisabled
                            ? Text(
                                _isButtonDisabled
                                    ? '${AppStrings.expiresIn}$_start ${AppStrings.sec}'
                                    : AppStrings.otpExpired,
                                style: getRegularStyle(
                                    color: ColorManager.lightGrey2,
                                    fontSize: FontSize.s14))
                            : SizedBox(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      AppStrings.notReceivedCode,
                                      style: getRegularStyle(
                                          color: ColorManager.lightGrey2,
                                          fontSize: FontSize.s14),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        resendOtp();
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: DashedLineText(
                                            titleString: AppStrings.resend,
                                            titleStyle: getDottedUnderlineStyle(
                                                color: ColorManager.lightGrey2,
                                                lineColor:
                                                    ColorManager.lightGrey2,
                                                fontSize: FontSize.s18)),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                      ),
                      const SizedBox(height: 30),
                      isLoading
                          ? const CustomProgressIndicator()
                          : SizedBox(
                              height: 90,
                              child: CustomButton(
                                  buttonText: AppStrings.verifyEmailID,
                                  onTap: () {
                                    verifyEmail();
                                  }),
                            ),
                      isError ? const SizedBox(height: 30) : const SizedBox(),
                      isError
                          ? ErrorTextViewBox(titleString: errorText)
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
