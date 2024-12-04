// ignore_for_file: use_build_context_synchronously

import 'package:eyvo_inventory/api/api_service/api_service.dart';
import 'package:eyvo_inventory/api/api_service/bloc.dart';
import 'package:eyvo_inventory/api/response_models/company_code_response.dart';
import 'package:eyvo_inventory/app/app_prefs.dart';
import 'package:eyvo_inventory/app/sizes_helper.dart';
import 'package:eyvo_inventory/core/resources/assets_manager.dart';
import 'package:eyvo_inventory/core/resources/font_manager.dart';
import 'package:eyvo_inventory/core/resources/routes_manager.dart';
import 'package:eyvo_inventory/core/resources/styles_manager.dart';
import 'package:eyvo_inventory/core/widgets/button.dart';
import 'package:eyvo_inventory/core/widgets/custom_field.dart';
import 'package:eyvo_inventory/core/widgets/header_logo.dart';
import 'package:eyvo_inventory/core/widgets/progress_indicator.dart';
import 'package:eyvo_inventory/core/widgets/text_error.dart';
import 'package:flutter/material.dart';
import 'package:eyvo_inventory/core/resources/color_manager.dart';
import 'package:eyvo_inventory/core/resources/strings_manager.dart';
import 'package:flutter/services.dart';

class CompanyCodeView extends StatefulWidget {
  const CompanyCodeView({super.key});

  @override
  State<CompanyCodeView> createState() => _CompanyCodeViewState();
}

class _CompanyCodeViewState extends State<CompanyCodeView> {
  final codeController = TextEditingController();
  bool isFormValidated = false;
  bool isError = false;
  bool isLoading = false;
  String codeText = AppStrings.enterCompanyCode;
  String errorText = AppStrings.companyCodeCannotBeBlank;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    codeController.addListener(_onTextChange);
    codeController.text = SharedPrefs().companyCode;
  }

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  void _onTextChange() {
    if (codeText != AppStrings.enterCompanyCode) {
      setState(() {
        isError = codeController.text.trim().isEmpty;
      });
    }
    codeText = codeController.text.trim();
  }

  void validateFields() {
    if (isFormValidated) {
      setState(() {
        isError = codeController.text.isEmpty;
      });
    }
  }

  void validateCompanyCode() async {
    setState(() {
      isLoading = true;
    });

    final clientCode = codeController.text.trim();

    Map<String, dynamic> data = {'clientcode': clientCode};
    final jsonResponse =
        await apiService.postRequest(context, ApiService.clientCode, data);
    if (jsonResponse != null) {
      final response = CompanyCodeResponse.fromJson(jsonResponse);

      if (response.code == '200') {
        SharedPrefs().companyCode = response.data.clientCode;
        SharedPrefs().accessKey = response.data.accessKey;
        codeController.text = '';
        Navigator.pushNamed(context, Routes.loginRoute);
      } else {
        isError = true;
        errorText = response.message.join(', ');
      }
    }

    // var res = await globalBloc.afterFillCompanyCodeApi(context, clientCode);

    // if (res.code == '200') {
    //   SharedPrefs().companyCode = res.data.clientCode;
    //   SharedPrefs().accessKey = res.data.accessKey;
    //   codeController.text = '';
    //   Navigator.pushNamed(context, Routes.loginRoute);
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
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) => {SystemNavigator.pop()},
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
              backgroundColor: ColorManager.white,
              body: SingleChildScrollView(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                  children: [
                    const HeaderLogo(),
                    Padding(
                      padding: const EdgeInsets.only(left: 30, right: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 50),
                            child: Text(AppStrings.companyCodeTitle,
                                style: getRegularStyle(
                                    color: ColorManager.black,
                                    fontSize: FontSize.s25_5)),
                          ),
                          const SizedBox(height: 50),
                          SizedBox(
                            width: displayWidth(context),
                            child: CustomTextField(
                                iconString: ImageAssets.companyCodeIcon,
                                hintText: AppStrings.enterCompanyCode,
                                controller: codeController,
                                isValid: !isError,
                                onTextChanged: validateFields),
                          ),
                          isError
                              ? ErrorTextViewBox(titleString: errorText)
                              : const SizedBox(),
                          isError
                              ? const SizedBox(height: 20)
                              : const SizedBox(),
                          isLoading
                              ? const CustomProgressIndicator()
                              : CustomButton(
                                  buttonText: AppStrings.submit,
                                  onTap: () {
                                    isFormValidated = true;
                                    validateFields();
                                    if (!isError) {
                                      validateCompanyCode();
                                    } else {
                                      setState(() {
                                        isError = true;
                                      });
                                    }
                                  },
                                )
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
