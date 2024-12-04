// ignore_for_file: unrelated_type_equality_checks

import 'package:eyvo_inventory/api/api_service/api_service.dart';
import 'package:eyvo_inventory/api/api_service/bloc.dart';
import 'package:eyvo_inventory/api/response_models/received_items_response.dart';
import 'package:eyvo_inventory/api/response_models/update_good_receive_response.dart';
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
import 'package:eyvo_inventory/core/widgets/alert.dart';
import 'package:eyvo_inventory/core/widgets/button.dart';
import 'package:eyvo_inventory/core/widgets/custom_checkbox.dart';
import 'package:eyvo_inventory/core/widgets/custom_list_tile.dart';
import 'package:eyvo_inventory/core/widgets/progress_indicator.dart';
import 'package:eyvo_inventory/presentation/pdf_view/pdf_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ReceivedItemListView extends StatefulWidget {
  final String orderNumber;
  final int orderId;
  const ReceivedItemListView(
      {super.key, required this.orderNumber, required this.orderId});

  @override
  State<ReceivedItemListView> createState() => _ReceivedItemListViewState();
}

class _ReceivedItemListViewState extends State<ReceivedItemListView>
    with RouteAware {
  final TextEditingController editQuantityController = TextEditingController();
  bool isPrintEnabled = false;
  String searchText = '';
  late List<OrderData> orderItems = [];
  late List selectedOrderItems = [];
  bool isGoodsReceived = false;
  bool isGenerateLabelEnabled = false;
  String receivedGoodsSuccessMessage = '';
  String receivedGoodsNumber = '';
  bool isAllSelected = false;
  bool isReceiveGoodsEnabled = false;
  bool isLoading = false;
  bool isError = false;
  String errorText = AppStrings.somethingWentWrong;
  final ApiService apiService = ApiService();
  bool isEditingQuantity = false;
  final Duration duration = const Duration(milliseconds: 300);
  final double editBoxHeight = 205;
  late double maxQuantity;
  int selectedIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void didPopNext() {
    fetchOrderItems();
  }

  @override
  void initState() {
    super.initState();
    fetchOrderItems();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    editQuantityController.dispose();
    super.dispose();
  }

  void fetchOrderItems() async {
    setState(() {
      isLoading = true;
    });

    Map<String, dynamic> data = {
      'orderid': widget.orderId.toString(),
    };
    final jsonResponse = await apiService.postRequest(
        context, ApiService.goodReceiveItemList, data);
    if (jsonResponse != null) {
      final response = ReceivedItemsResponse.fromJson(jsonResponse);
      if (response.code == '200') {
        setState(() {
          orderItems = response.data;
          isPrintEnabled = response.print;
        });
      } else {
        isError = true;
        errorText = response.message.join(', ');
        isPrintEnabled = response.print;
      }
    }

    // var res =
    //     await globalBloc.doFetchOrderItem(context, widget.orderId.toString());
    // if (res.code == '200') {
    //   setState(() {
    //     orderItems = res.data;
    //     isPrintEnabled = res.print;
    //   });
    // } else {
    //   isError = true;
    //   errorText = res.message.join(', ');
    //   isPrintEnabled = res.print;
    // }

    setState(() {
      isLoading = false;
    });
  }

  void didTappedOnSelectAll() {
    setState(() {
      isAllSelected = !isAllSelected;
      for (var item in orderItems) {
        item.isSelected = isAllSelected;
      }
      checkIsAnyItemSelected();
    });
  }

  void editReceivedQuantity(BuildContext context, double bookInQuantity,
      double totalQuantity, int editingIndex) {
    setState(() {
      isEditingQuantity = true;
      maxQuantity = bookInQuantity;
      editQuantityController.text = getFormattedString(bookInQuantity);
      selectedIndex = editingIndex;
    });
  }

  void updateReceivedQuantity() {
    var updatedQuantityString = '';
    var updatedQuantity = 0.0;
    if (editQuantityController.text.isNotEmpty) {
      updatedQuantityString =
          getFormattedString(double.parse(editQuantityController.text));
      updatedQuantity = double.parse(updatedQuantityString);
    }
    if (updatedQuantity <= 0) {
      showErrorDialog(context, AppStrings.quantityNotValid, false);
    } else {
      setState(() {
        isEditingQuantity = false;
        orderItems[selectedIndex].updatedQuantity = updatedQuantity;
        if (orderItems[selectedIndex].bookInQuantity != updatedQuantity) {
          orderItems[selectedIndex].isEdited = true;
        } else {
          orderItems[selectedIndex].isEdited = false;
        }
        orderItems[selectedIndex].isSelected = true;
        checkIsAnyItemSelected();
      });
    }
  }

  void updateQuantity(double updatedQuantity) {
    editQuantityController.text = getFormattedString(updatedQuantity);
  }

  void increaseReceivedQuantity() {
    var updatedQuantity = double.parse(editQuantityController.text) + 1.0;
    if (updatedQuantity <= orderItems[selectedIndex].bookInQuantity) {
      updateQuantity(updatedQuantity);
    }
  }

  void decreaseReceivedQuantity() {
    var updatedQuantity = double.parse(editQuantityController.text) - 1.0;
    if (updatedQuantity > 0) {
      updateQuantity(updatedQuantity);
    }
  }

  void receiveGoods() {
    if (isReceiveGoodsEnabled) {
      selectedOrderItems = [];
      for (var item in orderItems) {
        if (item.isSelected) {
          Map<String, dynamic> data = {
            "orderlineid": item.orderLineId,
            "itemorder": item.itemOrder,
            "receivedquantity": item.updatedQuantity,
            "itemtype": item.itemType,
            "isstock": item.isStock,
            "isupdated": true
          };
          selectedOrderItems.add(data);
        }
      }
      showReceiveGoodsDialog(context);
    }
  }

  void onConfirmReceiveGoods() async {
    setState(() {
      isLoading = true;
    });

    Map<String, dynamic> data = {
      "orderid": widget.orderId,
      "ordernumber": widget.orderNumber,
      "uid": SharedPrefs().uID,
      "locationid": SharedPrefs().selectedLocationID,
      "regionid": SharedPrefs().selectedRegionID,
      "usersession": SharedPrefs().userSession,
      "items": selectedOrderItems,
    };
    final jsonResponse = await apiService.postRequest(
        context, ApiService.goodReceiveUpdate, data);
    if (jsonResponse != null) {
      final response = UpdateGoodReceiveResponse.fromJson(jsonResponse);
      setState(() {
        if (response.code == '200') {
          isGoodsReceived = true;
          receivedGoodsNumber = response.data.grNumber;
          isGenerateLabelEnabled = response.data.print;
          receivedGoodsSuccessMessage = response.message.join(', ');
        } else {
          showErrorDialog(context, response.message.join(', '), false);
        }
      });
    }
    // var res = await globalBloc.doFetchConfirmReceiveGoods(
    //   context,
    //   orderId: widget.orderId,
    //   orderNumber: widget.orderNumber,
    //   uID: SharedPrefs().uID,
    //   selectedLocationID: SharedPrefs().selectedLocationID,
    //   selectedRegionID: SharedPrefs().selectedRegionID,
    //   userSession: SharedPrefs().userSession,
    //   itemList: selectedOrderItems,
    // );
    // setState(() {
    //   if (res.code == '200') {
    //     isGoodsReceived = true;
    //     receivedGoodsNumber = res.data.grNumber;
    //     isGenerateLabelEnabled = res.data.print;
    //     receivedGoodsSuccessMessage = res.message.join(', ');
    //   } else {
    //     showErrorDialog(context, res.message.join(', '), false);
    //   }
    // });

    setState(() {
      isLoading = false;
    });
  }

  void showReceiveGoodsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomImageActionAlert(
            iconString: "",
            imageString: ImageAssets.receiveGoodsImage,
            titleString: AppStrings.receiveGoodsTitle,
            subTitleString: AppStrings.receiveGoodsSubTitle
                .replaceAll("{count}", selectedOrderItems.length.toString()),
            destructiveActionString: AppStrings.yes,
            normalActionString: AppStrings.no,
            onDestructiveActionTap: () {
              Navigator.pop(context);
              onConfirmReceiveGoods();
            },
            onNormalActionTap: () {
              Navigator.pop(context);
            },
            isNormalAlert: true,
            isConfirmationAlert: true);
      },
    );
  }

  void checkIsAnyItemSelected() {
    isReceiveGoodsEnabled = false;
    for (var item in orderItems) {
      if (item.isSelected) {
        isReceiveGoodsEnabled = true;
      } else {
        isAllSelected = false;
      }
    }
  }

  void printReceiveGoods(int orderId, int itemId, String grNo) {
    isGoodsReceived = false;
    isReceiveGoodsEnabled = false;
    navigateToScreen(
        context,
        PDFViewScreen(
          orderNumber: widget.orderNumber,
          orderId: orderId,
          itemId: itemId,
          grNo: grNo,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: ColorManager.primary,
        appBar: AppBar(
          backgroundColor: ColorManager.darkBlue,
          title: Text(AppStrings.grItemListing,
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
            : Stack(
                children: [
                  isError
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
                                        ImageAssets.noRecordFoundIcon),
                                    Text(errorText,
                                        style: getRegularStyle(
                                            color: ColorManager.lightGrey,
                                            fontSize: FontSize.s17)),
                                    const Spacer()
                                  ],
                                )),
                              ),
                            ),
                          ],
                        )
                      : isGoodsReceived
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        // const Spacer(),
                                        Image.asset(
                                            width: displayWidth(context) * 0.6,
                                            ImageAssets
                                                .successfulReceivedImage),
                                        Text(receivedGoodsSuccessMessage,
                                            textAlign: TextAlign.center,
                                            style: getRegularStyle(
                                                color: ColorManager.lightGrey,
                                                fontSize: FontSize.s17)),
                                        // const Spacer()
                                      ],
                                    )),
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 60),
                                        SizedBox(
                                          width: displayWidth(context),
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 18),
                                            child: CustomCheckBox(
                                                imageString: isAllSelected
                                                    ? ImageAssets
                                                        .selectedCheckBoxIcon
                                                    : ImageAssets.checkBoxIcon,
                                                titleString:
                                                    AppStrings.selectAll,
                                                isSelected: isAllSelected,
                                                onTap: () {
                                                  didTappedOnSelectAll();
                                                }),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 0,
                                              bottom: 8,
                                              left: 18,
                                              right: 18),
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount: orderItems.length,
                                            itemBuilder: (context, index) {
                                              return OrderItemListTile(
                                                  itemID: orderItems[index]
                                                      .itemOrder,
                                                  title: orderItems[index]
                                                          .itemCode ??
                                                      '',
                                                  subtitle: orderItems[index]
                                                      .description,
                                                  imageString: orderItems[index]
                                                      .itemImage,
                                                  totalQuantity:
                                                      orderItems[index]
                                                          .quantity,
                                                  receivedQuantity:
                                                      orderItems[index].isEdited
                                                          ? orderItems[index]
                                                              .updatedQuantity
                                                          : orderItems[index]
                                                              .receivedQuantity,
                                                  isSelected: orderItems[index]
                                                      .isSelected,
                                                  onTap: () {
                                                    setState(() {
                                                      orderItems[index]
                                                              .isSelected =
                                                          !orderItems[index]
                                                              .isSelected;
                                                      checkIsAnyItemSelected();
                                                    });
                                                  },
                                                  onEdit: () {
                                                    editReceivedQuantity(
                                                        context,
                                                        orderItems[index]
                                                                .isEdited
                                                            ? orderItems[index]
                                                                .updatedQuantity
                                                            : orderItems[index]
                                                                .receivedQuantity,
                                                        orderItems[index]
                                                            .quantity,
                                                        index);
                                                  });
                                            },
                                          ),
                                        ),
                                        const SizedBox(height: 50),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 80),
                              ],
                            ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: ColorManager.white,
                      alignment: Alignment.topLeft,
                      height: 60,
                      width: displayWidth(context),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 8, left: 18, right: 18, bottom: 8),
                            child: Text(
                              AppStrings.orderNumberDetail + widget.orderNumber,
                              style: getBoldStyle(
                                  color: ColorManager.darkBlue,
                                  fontSize: FontSize.s27),
                            ),
                          ),
                          const Spacer(),
                          isGoodsReceived
                              ? const SizedBox()
                              : isPrintEnabled
                                  ? Padding(
                                      padding: const EdgeInsets.only(right: 18),
                                      child: IconButton(
                                          onPressed: () {
                                            printReceiveGoods(
                                                widget.orderId, 0, "");
                                          },
                                          icon: Image.asset(
                                              ImageAssets.printIcon)),
                                    )
                                  : const SizedBox()
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      width: displayWidth(context),
                      height: 120,
                      color: isGoodsReceived
                          ? isGenerateLabelEnabled
                              ? ColorManager.white
                              : Colors.transparent
                          : Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: isGoodsReceived
                            ? isGenerateLabelEnabled
                                ? CustomButton(
                                    buttonText: AppStrings.generateLabels,
                                    onTap: () {
                                      printReceiveGoods(widget.orderId, 0,
                                          receivedGoodsNumber);
                                    },
                                    isEnabled: isReceiveGoodsEnabled)
                                : const SizedBox()
                            : CustomButton(
                                buttonText: AppStrings.receiveGoods,
                                onTap: () {
                                  isReceiveGoodsEnabled ? receiveGoods() : null;
                                },
                                isEnabled: isReceiveGoodsEnabled),
                      ),
                    ),
                  ),
                  isEditingQuantity
                      ? AnimatedPositioned(
                          duration: duration,
                          curve: Curves.easeInOut,
                          bottom: isEditingQuantity ? 0 : -editBoxHeight,
                          left: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () => {
                              setState(() {
                                isEditingQuantity = false;
                              })
                            },
                            child: AnimatedContainer(
                              color: ColorManager.blackOpacity50,
                              duration: duration,
                              height: isEditingQuantity
                                  ? displayHeight(context)
                                  : 0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Spacer(),
                                  Container(
                                      padding: const EdgeInsets.all(20.0),
                                      height: editBoxHeight,
                                      width: displayWidth(context),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 20),
                                          SizedBox(
                                            width: displayWidth(context),
                                            child: Text(
                                                AppStrings.editReceiveQuantity,
                                                style: getBoldStyle(
                                                    color:
                                                        ColorManager.lightGrey2,
                                                    fontSize: FontSize.s25_5)),
                                          ),
                                          const SizedBox(height: 20),
                                          Row(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    color:
                                                        ColorManager.darkBlue,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4)),
                                                width: 70,
                                                height: 50,
                                                child: IconButton(
                                                    // iconSize: 40,
                                                    onPressed: () {
                                                      decreaseReceivedQuantity();
                                                    },
                                                    icon: Image.asset(
                                                        width: 30,
                                                        height: 30,
                                                        ImageAssets.minusIcon)),
                                              ),
                                              const Spacer(),
                                              Container(
                                                  alignment: Alignment.center,
                                                  width: 150,
                                                  height: 60,
                                                  child: TextField(
                                                    controller:
                                                        editQuantityController,
                                                    style: getBoldStyle(
                                                        color: ColorManager
                                                            .lightGrey2,
                                                        fontSize:
                                                            FontSize.s23_25),
                                                    textInputAction:
                                                        TextInputAction.done,
                                                    keyboardType:
                                                        const TextInputType
                                                            .numberWithOptions(
                                                            decimal: true),
                                                    inputFormatters: [
                                                      DecimalTextInputFormatter(
                                                          decimalPlaces:
                                                              SharedPrefs()
                                                                  .decimalPlaces,
                                                          minValue: 0.1,
                                                          maxValue: orderItems[
                                                                  selectedIndex]
                                                              .bookInQuantity),
                                                      LengthLimitingTextInputFormatter(
                                                          AppConstants
                                                              .maxCharactersForQuantity),
                                                    ],
                                                    decoration:
                                                        const InputDecoration(
                                                            // isDense: true,
                                                            contentPadding:
                                                                EdgeInsets.all(
                                                                    0)),
                                                    textAlign: TextAlign.center,
                                                  )),
                                              const Spacer(),
                                              Container(
                                                width: 70,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                    color:
                                                        ColorManager.darkBlue,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4)),
                                                child: IconButton(
                                                    // iconSize: 40,
                                                    onPressed: () {
                                                      increaseReceivedQuantity();
                                                    },
                                                    icon: Image.asset(
                                                        width: 30,
                                                        height: 30,
                                                        ImageAssets.plusIcon)),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 18),
                                        ],
                                      )),
                                ],
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(),
                  isEditingQuantity
                      ? Positioned(
                          bottom: editBoxHeight - 60,
                          child: Container(
                            width: displayWidth(context),
                            height: 90,
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: IconButton(
                                  onPressed: () {
                                    if (editQuantityController
                                        .text.isNotEmpty) {
                                      updateReceivedQuantity();
                                    } else {
                                      showErrorDialog(
                                          context,
                                          AppStrings.quantityCannotBeBlank,
                                          false);
                                    }
                                  },
                                  icon: Image.asset(ImageAssets.tickIcon)),
                            ),
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
      ),
    );
  }
}
