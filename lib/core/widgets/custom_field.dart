import 'package:eyvo_inventory/app/sizes_helper.dart';
import 'package:eyvo_inventory/core/resources/assets_manager.dart';
import 'package:eyvo_inventory/core/resources/color_manager.dart';
import 'package:eyvo_inventory/core/resources/constants.dart';
import 'package:eyvo_inventory/core/resources/font_manager.dart';
import 'package:eyvo_inventory/core/resources/styles_manager.dart';
import 'package:eyvo_inventory/core/resources/values_manager.dart';
import 'package:eyvo_inventory/core/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomSearchField extends StatefulWidget {
  final TextEditingController controller;
  final String placeholderText;
  final TextInputType inputType;
  const CustomSearchField({
    super.key,
    required this.controller,
    required this.placeholderText,
    this.inputType = TextInputType.number,
  });

  @override
  State<CustomSearchField> createState() => _CustomSearchFieldState();
}

class _CustomSearchFieldState extends State<CustomSearchField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75,
      child: TextField(
        maxLines: 1,
        style: TextStyle(
            overflow: TextOverflow.ellipsis,
            fontSize: 15,
            fontFamily: FontConstants.fontFamily,
            fontWeight: FontWeightManager.regular,
            color: ColorManager.black),
        controller: widget.controller,
        textInputAction: TextInputAction.search,
        keyboardType: widget.inputType,
        inputFormatters: [
          LengthLimitingTextInputFormatter(AppConstants.maxCharacters),
        ],
        decoration: InputDecoration(
          // hint style
          hintStyle: getRegularStyle(
              color: ColorManager.lightGrey3,
              fontSize: widget.placeholderText.length >= 12
                  ? FontSize.s18
                  : FontSize.s23_25),

          // label style
          labelStyle: getRegularStyle(
              color: ColorManager.lightGrey3,
              fontSize: widget.placeholderText.length >= 12
                  ? FontSize.s18
                  : FontSize.s23_25),
          fillColor: ColorManager.white,
          filled: true,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          labelText: widget.placeholderText,
          border: OutlineInputBorder(
              borderSide:
                  BorderSide(color: ColorManager.light2, width: AppSize.s1)),
          // enabled border
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: ColorManager.light2, width: AppSize.s1),
            borderRadius: const BorderRadius.all(Radius.circular(AppSize.s8)),
          ),

          // focused border
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: ColorManager.light2, width: AppSize.s1),
            borderRadius: const BorderRadius.all(Radius.circular(AppSize.s8)),
          ),
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 25),
            child: Image.asset(ImageAssets.searchIcon, width: 30, height: 30),
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String iconString;
  final String hintText;
  final TextEditingController controller;
  final bool isObscureText;
  final bool isValid;
  final TextInputType inputType;
  final VoidCallback onTextChanged;
  const CustomTextField(
      {super.key,
      required this.iconString,
      required this.hintText,
      required this.controller,
      this.isObscureText = false,
      required this.isValid,
      this.inputType = TextInputType.text,
      required this.onTextChanged});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: TextField(
        controller: controller,
        obscureText: isObscureText,
        obscuringCharacter: "*",
        keyboardType: inputType,
        autocorrect: false,
        inputFormatters: [
          LengthLimitingTextInputFormatter(AppConstants.maxCharacters),
        ],
        spellCheckConfiguration: const SpellCheckConfiguration.disabled(),
        textCapitalization: TextCapitalization.none,
        style: getRegularStyle(
            color: ColorManager.grey1, fontSize: FontSize.s22_5),
        decoration: InputDecoration(
          prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 15, right: 5),
              child: CustomIconButton(imageString: iconString)),
          labelText: hintText,
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: isValid ? ColorManager.grey2 : ColorManager.darkRed,
              width: AppSize.s1_5,
            ),
            borderRadius: BorderRadius.circular(AppSize.s15),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: isValid ? ColorManager.blue : ColorManager.darkRed,
              width: AppSize.s1_5,
            ),
            borderRadius: BorderRadius.circular(AppSize.s15),
          ),
          floatingLabelAlignment: FloatingLabelAlignment.start,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          // floating label style
          floatingLabelStyle: getRegularStyle(
              color: ColorManager.light1, fontSize: FontSize.s18),
          // hint style
          hintStyle: getRegularStyle(
              color: ColorManager.grey1, fontSize: FontSize.s18),
          // label style
          labelStyle: getRegularStyle(
              color: ColorManager.light1, fontSize: FontSize.s14),
          // error style
          errorStyle: const TextStyle(height: 0, color: Colors.transparent),
        ),
        onChanged: (text) => onTextChanged,
        onTapOutside: (event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
      ),
    );
  }
}

class OTPField extends StatefulWidget {
  final Function(String) onOTPComplete;
  final bool isValid;
  const OTPField(
      {super.key, required this.onOTPComplete, required this.isValid});

  @override
  OTPFieldState createState() => OTPFieldState();
}

class OTPFieldState extends State<OTPField> {
  final int fieldLength = 4;
  final List<TextEditingController> _controllers = [];
  final List<FocusNode> _focusNodes = [];
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < fieldLength; i++) {
      _controllers.add(TextEditingController());
      _focusNodes.add(FocusNode());
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _handleSubmit() {
    String otp = _controllers.map((controller) => controller.text).join();
    widget.onOTPComplete(otp);
    FocusScope.of(context).unfocus();
  }

  void _clearFields() {
    for (var controller in _controllers) {
      controller.clear();
    }
    setState(() {
      currentIndex = 0;
    });
  }

  Widget _buildTextField(int index) {
    return SizedBox(
      width: displayWidth(context) * 0.23,
      height: 80,
      child: Padding(
        padding: const EdgeInsets.only(top: 0, left: 8, right: 8, bottom: 0),
        child: TextField(
          style: getSemiBoldStyle(
              color: ColorManager.darkBlue, fontSize: FontSize.s25_5),
          autofocus: true,
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          textAlign: TextAlign.center,
          textAlignVertical: TextAlignVertical.top,
          maxLength: 1,
          decoration: const InputDecoration(
            counterText: "",
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            if (value.isNotEmpty) {
              if (index + 1 != fieldLength) {
                FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
              } else {
                _handleSubmit();
              }
            } else if (value.isEmpty && index != 0) {
              FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
            }
          },
          onSubmitted: (value) {
            if (index + 1 == fieldLength) {
              _handleSubmit();
            }
          },
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(OTPField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.isValid && oldWidget.isValid) {
      _clearFields();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:
              List.generate(fieldLength, (index) => _buildTextField(index)),
        ),
      ],
    );
  }
}

class PINField extends StatefulWidget {
  final Function(String) onPINComplete;
  final bool isValid;
  final bool isEnabled;
  const PINField(
      {super.key,
      required this.onPINComplete,
      required this.isValid,
      this.isEnabled = true});

  @override
  PINFieldState createState() => PINFieldState();
}

class PINFieldState extends State<PINField> {
  final int fieldLength = 4;
  final List<TextEditingController> _controllers = [];
  final List<FocusNode> _focusNodes = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < fieldLength; i++) {
      _controllers.add(TextEditingController());
      _focusNodes.add(FocusNode());
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _handleSubmit() {
    String pin = _controllers.map((controller) => controller.text).join();
    widget.onPINComplete(pin);
    FocusScope.of(context).unfocus();
  }

  void _clearFields() {
    for (var controller in _controllers) {
      controller.clear();
    }
    _focusNodes[0].requestFocus();
  }

  Widget _buildTextField(int index) {
    return SizedBox(
      width: 95,
      height: 80,
      child: Padding(
        padding: const EdgeInsets.only(top: 0, left: 8, right: 8, bottom: 0),
        child: TextField(
          enabled: widget.isEnabled,
          obscureText: true,
          obscuringCharacter: '*',
          style: getSemiBoldStyle(
              color: ColorManager.darkBlue, fontSize: FontSize.s25_5),
          autofocus: true,
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          textAlign: TextAlign.center,
          textAlignVertical: TextAlignVertical.top,
          maxLength: 1,
          decoration: InputDecoration(
            errorText: widget.isValid ? null : '',
            errorStyle: const TextStyle(height: 0),
            counterText: "",
            border: const OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSize.s15),
              borderSide: BorderSide(
                color:
                    widget.isValid ? ColorManager.blue : ColorManager.darkRed,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSize.s15),
              borderSide: BorderSide(
                color:
                    widget.isValid ? ColorManager.grey2 : ColorManager.darkRed,
              ),
            ),
          ),
          onChanged: (value) {
            if (value.isNotEmpty) {
              if (index + 1 != fieldLength) {
                FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
              } else {
                _handleSubmit();
              }
            } else if (value.isEmpty && index != 0) {
              FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
            }
          },
          onSubmitted: (value) {
            if (index + 1 == fieldLength) {
              _handleSubmit();
            }
          },
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(PINField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.isValid && oldWidget.isValid) {
      _clearFields();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(fieldLength, (index) => _buildTextField(index)),
    );
  }
}
