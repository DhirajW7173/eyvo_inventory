import 'package:eyvo_inventory/api/api_service/api_service.dart';
import 'package:eyvo_inventory/api/api_service/bloc.dart';
import 'package:eyvo_inventory/api/response_models/default_api_response.dart';
import 'package:eyvo_inventory/api/response_models/item_details_response.dart';
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
import 'package:eyvo_inventory/core/widgets/progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class ItemDetailsView extends StatefulWidget {
  final int itemId;
  const ItemDetailsView({super.key, required this.itemId});

  @override
  State<ItemDetailsView> createState() => _ItemDetailsViewState();
}

class _ItemDetailsViewState extends State<ItemDetailsView> {
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _commmentsController = TextEditingController();
  late List<ItemDetails> items = [];
  bool isItemEditable = false;
  bool isLoading = false;
  bool isError = false;
  String errorText = AppStrings.somethingWentWrong;
  final ApiService apiService = ApiService();
  DateTime selectedDate = DateTime.now();
  final FocusNode priceFocusNode = FocusNode();
  final FocusNode quantityFocusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    _quantityController.text = getFormattedString(1.0);
    _dateController.text = DateFormat('dd-MMM-yyyy').format(selectedDate);
    _priceController.text = getFormattedString(0.0);
    fetchItemDetails();
    priceFocusNode.addListener(() {
      if (!priceFocusNode.hasFocus) {
        _performPriceActionOnFocusChanged();
      }
    });
    quantityFocusNode.addListener(() {
      if (!quantityFocusNode.hasFocus) {
        _performQuantityActionOnFocusChanged();
      }
    });
  }

  @override
  void dispose() {
    priceFocusNode.dispose();
    quantityFocusNode.dispose();
    _quantityController.dispose();
    _dateController.dispose();
    _priceController.dispose();
    _commmentsController.dispose();
    SharedPrefs().isItemScanned = false;
    super.dispose();
  }

  void _performPriceActionOnFocusChanged() {
    if (_priceController.text.isNotEmpty) {
      _priceController.text = getDefaultString(_priceController.text);
      _priceController.text =
          getFormattedPriceString(double.parse(_priceController.text));
    } else {
      _priceController.text = getFormattedPriceString(0);
    }
  }

  void _performQuantityActionOnFocusChanged() {
    if (_quantityController.text.isNotEmpty) {
      _quantityController.text = getDefaultString(_quantityController.text);
      _quantityController.text =
          getFormattedString(double.parse(_quantityController.text));
    } else {
      _quantityController.text = getFormattedString(1);
    }
  }

  void fetchItemDetails() async {
    setState(() {
      isLoading = true;
    });

    Map<String, dynamic> data = {
      "itemid": widget.itemId,
      "locationid": SharedPrefs().isItemScanned
          ? SharedPrefs().scannedLocationID
          : SharedPrefs().selectedLocationID,
      'regionid': SharedPrefs().isItemScanned
          ? SharedPrefs().scannedRegionID
          : SharedPrefs().selectedRegionID,
      "uid": SharedPrefs().uID,
    };

    final jsonResponse =
        await apiService.postRequest(context, ApiService.itemDetails, data);
    if (jsonResponse != null) {
      final response = ItemDetailsResponse.fromJson(jsonResponse);
      setState(() {
        if (response.code == '200') {
          items = response.data;
          _priceController.text = getFormattedPriceString(items[0].basePrice);
          isItemEditable = items[0].itemEdit;
        } else {
          isError = true;
          errorText = response.message.join(', ');
        }
      });
    }

    // var response = await globalBloc.doFetchItemDetails(
    //   context,
    //   itemId: '${widget.itemId}',
    //   locationId: SharedPrefs().isItemScanned
    //       ? SharedPrefs().scannedLocationID
    //       : SharedPrefs().selectedLocationID,
    //   regionId: SharedPrefs().isItemScanned
    //       ? SharedPrefs().scannedRegionID
    //       : SharedPrefs().selectedRegionID,
    //   uID: SharedPrefs().uID,
    // );
    // setState(() {
    //   if (response.code == '200') {
    //     items = response.data;
    //     _priceController.text = getFormattedPriceString(items[0].basePrice);
    //     isItemEditable = items[0].itemEdit;
    //   } else {
    //     isError = true;
    //     errorText = response.message.join(', ');
    //   }
    // });

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(0),
          content: SizedBox(
            width: displayWidth(context),
            child: CalendarDatePicker(
              initialDate: selectedDate,
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
              onDateChanged: (DateTime date) {
                setState(() {
                  selectedDate = date;
                  _dateController.text =
                      DateFormat('dd-MMM-yyyy').format(selectedDate);
                });
                Navigator.of(context).pop();
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog without selection
              },
              child: const Text(AppStrings.cancel),
            ),
          ],
        );
      },
    );
  }

  void validateItemsIN() {
    var price = getDefaultString(_priceController.text);
    var quantity = getDefaultString(_quantityController.text);
    if (quantity.isEmpty) {
      showErrorDialog(context, AppStrings.quantityNotValid, false);
    } else if (double.parse(quantity) <= 0) {
      showErrorDialog(context, AppStrings.quantityNotValid, false);
    } else if (price.isEmpty) {
      showErrorDialog(context, AppStrings.priceNotValid, false);
    } else if (items[0].basePrice <= 0 && double.parse(price) <= 0) {
      showErrorDialog(context, AppStrings.priceNotValid, false);
    } else if (_commmentsController.text.isEmpty) {
      showErrorDialog(context, AppStrings.commentsCannotBeBlank, false);
    } else {
      proceedWithItemsInOut('IN');
    }
  }

  void validateItemsOUT() {
    var quantity = getDefaultString(_quantityController.text);
    if (quantity.isEmpty) {
      showErrorDialog(context, AppStrings.quantityNotValid, false);
    } else if (double.parse(quantity) <= 0) {
      showErrorDialog(context, AppStrings.quantityNotValid, false);
    } else if (double.parse(quantity) > items[0].stockCount) {
      showErrorDialog(
          context, AppStrings.quantityCannotBeGreaterThanStock, false);
    } else if (_commmentsController.text.isEmpty) {
      showErrorDialog(context, AppStrings.commentsCannotBeBlank, false);
    } else {
      proceedWithItemsInOut('OUT');
    }
  }

  void proceedWithItemsInOut(String modeType) async {
    var price = getDefaultString(_priceController.text);
    var quantity = getDefaultString(_quantityController.text);
    setState(() {
      isLoading = true;
    });

    Map<String, dynamic> data = {
      "itemid": widget.itemId,
      "itemtype": items[0].itemType,
      "locationid": SharedPrefs().isItemScanned
          ? SharedPrefs().scannedLocationID
          : SharedPrefs().selectedLocationID,
      "isstock": items[0].isStock,
      "quantity": double.parse(quantity),
      "price": double.parse(price),
      "adjustmentDate": _dateController.text,
      "comments": _commmentsController.text,
      "uid": SharedPrefs().uID,
      "pageMode": modeType
    };
    final jsonResponse =
        await apiService.postRequest(context, ApiService.itemsInOut, data);
    if (jsonResponse != null) {
      final response = DefaultAPIResponse.fromJson(jsonResponse);
      setState(() {
        if (response.code == '200') {
          showSuccessDialog(context, ImageAssets.successfulIcon, '',
              response.message.join(', '), true);
        } else {
          showErrorDialog(context, response.message.join(', '), false);
        }
      });
    }

    // var res = await globalBloc.doFetchItemInOutAPI(
    //   context,
    //   itemId: widget.itemId,
    //   itemType: items[0].itemType,
    //   locationId: SharedPrefs().isItemScanned
    //       ? SharedPrefs().scannedLocationID
    //       : SharedPrefs().selectedLocationID,
    //   isStock: items[0].isStock,
    //   quantity: double.parse(quantity),
    //   price: double.parse(price),
    //   adjustDate: _dateController.text,
    //   comment: _commmentsController.text,
    //   uID: SharedPrefs().uID,
    //   mode: modeType,
    // );

    // setState(() {
    //   if (res.code == '200') {
    //     showSuccessDialog(context, ImageAssets.successfulIcon, '',
    //         res.message.join(', '), true);
    //   } else {
    //     showErrorDialog(context, res.message.join(', '), false);
    //   }
    // });

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = displayWidth(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: ColorManager.primary,
        appBar: AppBar(
          backgroundColor: ColorManager.darkBlue,
          title: Text(AppStrings.itemDetails,
              style: getBoldStyle(
                  color: ColorManager.white, fontSize: FontSize.s27)),
          leading: IconButton(
            icon: Image.asset(ImageAssets.backButton),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: isLoading
            ? const Center(child: CustomProgressIndicator())
            : isError
                ? Column(
                    children: [
                      const SizedBox(height: 60),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Container(
                          height: displayHeight(context) * 0.65,
                          width: displayWidth(context),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: ColorManager.white),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Spacer(),
                                Image.asset(
                                    width: displayWidth(context) * 0.5,
                                    ImageAssets.errorMessageIcon),
                                Text(errorText,
                                    style: getRegularStyle(
                                        color: ColorManager.lightGrey,
                                        fontSize: FontSize.s17)),
                                const Spacer()
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: ColorManager.white,
                                border: Border.all(
                                    color: ColorManager.grey4, width: 1.0),
                                borderRadius: BorderRadius.circular(8)),
                            width: screenWidth,
                            child: Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      const Spacer(),
                                      Column(
                                        children: [
                                          ConstrainedBox(
                                            constraints: const BoxConstraints(
                                                minWidth: 60,
                                                maxWidth: 300,
                                                minHeight: 30),
                                            child: IntrinsicWidth(
                                              child: Container(
                                                color: ColorManager.lightBlue3,
                                                child: Center(
                                                  child: Text(
                                                    getFormattedString(
                                                        items[0].stockCount),
                                                    style: getBoldStyle(
                                                        color: ColorManager
                                                            .darkBlue,
                                                        fontSize: FontSize.s18),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 50,
                                            height: 20,
                                            child: Center(
                                              child: Text(
                                                AppStrings.stock,
                                                style: getBoldStyle(
                                                    color:
                                                        ColorManager.lightGrey2,
                                                    fontSize: FontSize.s12),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(width: 20),
                                    ],
                                  ),
                                  Center(
                                      child: Image.network(items[0].itemImage)),
                                  Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(items[0].outline,
                                            style: getBoldStyle(
                                                color: ColorManager.darkBlue,
                                                fontSize: FontSize.s22_5)),
                                        const SizedBox(height: 5),
                                        RichText(
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          text: TextSpan(
                                            text: AppStrings.itemCodeDetails,
                                            style: getSemiBoldStyle(
                                                color: ColorManager.black,
                                                fontSize: FontSize.s14),
                                            children: [
                                              TextSpan(
                                                  text: items[0].itemCode,
                                                  style: getRegularStyle(
                                                      color: ColorManager.black,
                                                      fontSize: FontSize.s14))
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        RichText(
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          text: TextSpan(
                                            text:
                                                AppStrings.categoryCodeDetails,
                                            style: getSemiBoldStyle(
                                                color: ColorManager.black,
                                                fontSize: FontSize.s14),
                                            children: [
                                              TextSpan(
                                                text: items[0].categoryCode,
                                                style: getRegularStyle(
                                                    color: ColorManager.black,
                                                    fontSize: FontSize.s14),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(items[0].description,
                                            style: getRegularStyle(
                                                color: ColorManager.black,
                                                fontSize: FontSize.s14)),
                                        const SizedBox(height: 20),
                                        Row(
                                          children: [
                                            const Spacer(),
                                            SizedBox(
                                              width: (screenWidth * 0.4) - 45,
                                              height: 60,
                                              child: TextField(
                                                focusNode: quantityFocusNode,
                                                controller: _quantityController,
                                                style: getSemiBoldStyle(
                                                    color: ColorManager.black,
                                                    fontSize: FontSize.s16),
                                                readOnly: isItemEditable
                                                    ? false
                                                    : true,
                                                textInputAction:
                                                    TextInputAction.done,
                                                keyboardType:
                                                    const TextInputType
                                                        .numberWithOptions(
                                                        decimal: true),
                                                inputFormatters: [
                                                  LengthLimitingTextInputFormatter(
                                                      AppConstants
                                                          .maxCharactersForQuantity),
                                                ],
                                                decoration: InputDecoration(
                                                    contentPadding:
                                                        const EdgeInsets.all(
                                                            20),
                                                    labelText:
                                                        AppStrings.quantity,
                                                    floatingLabelBehavior:
                                                        FloatingLabelBehavior
                                                            .always,
                                                    floatingLabelStyle:
                                                        getSemiBoldStyle(
                                                            color: ColorManager
                                                                .lightGrey1,
                                                            fontSize:
                                                                FontSize.s17)),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            SizedBox(
                                              width: (screenWidth * 0.6) - 45,
                                              height: 60,
                                              child: TextField(
                                                controller: _dateController,
                                                style: getSemiBoldStyle(
                                                    color: ColorManager.black,
                                                    fontSize: FontSize.s16),
                                                readOnly: true,
                                                decoration: InputDecoration(
                                                    contentPadding:
                                                        const EdgeInsets.all(
                                                            18),
                                                    suffixIcon: IconButton(
                                                        onPressed:
                                                            isItemEditable
                                                                ? () {
                                                                    _selectDate(
                                                                        context);
                                                                  }
                                                                : () {},
                                                        icon: Image.asset(
                                                            ImageAssets
                                                                .calendarIcon,
                                                            width: 25,
                                                            height: 25)),
                                                    labelText: AppStrings.date,
                                                    labelStyle:
                                                        getSemiBoldStyle(
                                                            color: ColorManager
                                                                .lightGrey1,
                                                            fontSize: 8),
                                                    hintStyle: getSemiBoldStyle(
                                                        color: ColorManager
                                                            .lightGrey1,
                                                        fontSize: FontSize.s12),
                                                    floatingLabelBehavior:
                                                        FloatingLabelBehavior
                                                            .always,
                                                    floatingLabelStyle:
                                                        getSemiBoldStyle(
                                                            color: ColorManager
                                                                .lightGrey1,
                                                            fontSize:
                                                                FontSize.s16)),
                                              ),
                                            ),
                                            const Spacer(),
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        items[0].basePrice <= 0
                                            ? SizedBox(
                                                width: (screenWidth) - 45,
                                                height: 60,
                                                child: TextField(
                                                  focusNode: priceFocusNode,
                                                  controller: _priceController,
                                                  style: getSemiBoldStyle(
                                                      color: ColorManager.black,
                                                      fontSize: FontSize.s16),
                                                  readOnly: isItemEditable
                                                      ? false
                                                      : true,
                                                  keyboardType:
                                                      const TextInputType
                                                          .numberWithOptions(
                                                          decimal: true),
                                                  inputFormatters: [
                                                    LengthLimitingTextInputFormatter(
                                                        AppConstants
                                                            .maxCharactersForPrice),
                                                  ],
                                                  decoration: InputDecoration(
                                                      contentPadding:
                                                          const EdgeInsets.all(
                                                              20),
                                                      labelText:
                                                          AppStrings.price,
                                                      floatingLabelBehavior:
                                                          FloatingLabelBehavior
                                                              .always,
                                                      floatingLabelStyle:
                                                          getSemiBoldStyle(
                                                              color: ColorManager
                                                                  .lightGrey1,
                                                              fontSize: FontSize
                                                                  .s16)),
                                                ),
                                              )
                                            : const SizedBox(),
                                        items[0].basePrice <= 0
                                            ? const SizedBox(height: 20)
                                            : const SizedBox(height: 10),
                                        SizedBox(
                                          width: (screenWidth) - 45,
                                          height: 80,
                                          child: TextField(
                                            controller: _commmentsController,
                                            style: getSemiBoldStyle(
                                                color: ColorManager.black,
                                                fontSize: FontSize.s16),
                                            readOnly:
                                                isItemEditable ? false : true,
                                            maxLines: null,
                                            expands: true,
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(
                                                  AppConstants
                                                      .maxCharactersForComment),
                                            ],
                                            decoration: InputDecoration(
                                                contentPadding:
                                                    const EdgeInsets.all(20),
                                                labelText: AppStrings.comments,
                                                floatingLabelBehavior:
                                                    FloatingLabelBehavior
                                                        .always,
                                                floatingLabelStyle:
                                                    getSemiBoldStyle(
                                                        color: ColorManager
                                                            .lightGrey1,
                                                        fontSize:
                                                            FontSize.s16)),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        items[0].note.isNotEmpty
                                            ? Text(items[0].note,
                                                style: getRegularStyle(
                                                    color:
                                                        ColorManager.lightGrey2,
                                                    fontSize: FontSize.s12))
                                            : const SizedBox(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // const SizedBox(height: 5),
                        isItemEditable
                            ? Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Container(
                                  color: ColorManager.white,
                                  width: screenWidth,
                                  height: 120,
                                  child: Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 5),
                                        Row(
                                          children: [
                                            const Spacer(),
                                            CustomTextActionButton(
                                                buttonText: AppStrings.itemsIn,
                                                backgroundColor:
                                                    ColorManager.green,
                                                borderColor: Colors.transparent,
                                                fontColor: ColorManager.white,
                                                buttonWidth:
                                                    (screenWidth * 0.5) - 23,
                                                buttonHeight: 70,
                                                isBoldFont: true,
                                                fontSize: FontSize.s20,
                                                onTap: () {
                                                  validateItemsIN();
                                                }),
                                            const SizedBox(width: 10),
                                            CustomTextActionButton(
                                                buttonText: AppStrings.itemsOut,
                                                backgroundColor:
                                                    ColorManager.red,
                                                borderColor: Colors.transparent,
                                                fontColor: ColorManager.white,
                                                buttonWidth:
                                                    (screenWidth * 0.5) - 23,
                                                buttonHeight: 70,
                                                isBoldFont: true,
                                                fontSize: FontSize.s20,
                                                onTap: () {
                                                  validateItemsOUT();
                                                }),
                                            const Spacer(),
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox(height: 10),
                        const SizedBox(height: 20)
                      ],
                    ),
                  ),
      ),
    );
  }
}
