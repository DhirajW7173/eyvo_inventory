import 'package:eyvo_inventory/app/sizes_helper.dart';
import 'package:eyvo_inventory/core/resources/assets_manager.dart';
import 'package:eyvo_inventory/core/resources/color_manager.dart';
import 'package:eyvo_inventory/core/resources/font_manager.dart';
import 'package:eyvo_inventory/core/resources/strings_manager.dart';
import 'package:eyvo_inventory/core/resources/styles_manager.dart';
import 'package:eyvo_inventory/core/utils.dart';
import 'package:flutter/material.dart';

class OrderItemListTile extends StatefulWidget {
  final int itemID;
  final String title;
  final String subtitle;
  final String imageString;
  final double totalQuantity;
  final double receivedQuantity;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onEdit;

  const OrderItemListTile(
      {super.key,
      required this.itemID,
      required this.title,
      required this.subtitle,
      required this.imageString,
      required this.totalQuantity,
      required this.receivedQuantity,
      required this.isSelected,
      required this.onTap,
      required this.onEdit});

  @override
  State<OrderItemListTile> createState() => _OrderItemListTileState();
}

class _OrderItemListTileState extends State<OrderItemListTile> {
  late double selectedQuantity;

  @override
  void initState() {
    super.initState();
    selectedQuantity = widget.receivedQuantity;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Card(
          color: widget.isSelected ? ColorManager.darkBlue : ColorManager.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('${AppStrings.itemIDDetails}${widget.itemID}',
                            textAlign: TextAlign.left,
                            maxLines: 1,
                            style: getSemiBoldStyle(
                                color: widget.isSelected
                                    ? ColorManager.white
                                    : ColorManager.lightGrey1,
                                fontSize: FontSize.s14)),
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                              color: ColorManager.white,
                              border: Border.all(
                                  color: ColorManager.grey4, width: 1.0),
                              borderRadius: BorderRadius.circular(8)),
                          child: Image.network(
                            widget.imageString,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          widget.title.isNotEmpty
                              ? Text(widget.title,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: getBoldStyle(
                                      color: widget.isSelected
                                          ? ColorManager.white
                                          : ColorManager.darkBlue,
                                      fontSize: FontSize.s14))
                              : const SizedBox(),
                          Text(widget.subtitle,
                              overflow: TextOverflow.ellipsis,
                              maxLines: widget.title.isEmpty ? 4 : 3,
                              style: getRegularStyle(
                                  color: widget.isSelected
                                      ? ColorManager.white
                                      : ColorManager.lightGrey2,
                                  fontSize: FontSize.s12))
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      '${AppStrings.quantityDetail}${getFormattedString(widget.totalQuantity)}',
                      style: getBoldStyle(
                          color: widget.isSelected
                              ? ColorManager.white
                              : ColorManager.lightGrey2,
                          fontSize: FontSize.s20),
                    ),
                    const Spacer(),
                    Stack(
                      children: [
                        SizedBox(
                            child: Container(
                          alignment: Alignment.topLeft,
                          width: 170,
                          height: 80,
                          // color: ColorManager.green,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              GestureDetector(
                                onTap: widget.onEdit,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 0),
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: 170,
                                    height: 60,
                                    decoration: BoxDecoration(
                                        color: widget.isSelected
                                            ? ColorManager.white
                                            : Colors.transparent,
                                        border: Border.all(
                                            color: ColorManager.grey4,
                                            width: 1.0),
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const Spacer(),
                                        Text(
                                            getFormattedString(
                                                widget.receivedQuantity),
                                            style: getSemiBoldStyle(
                                                color: ColorManager.lightGrey1,
                                                fontSize: FontSize.s21)),
                                        const Spacer(),
                                        IconButton(
                                            onPressed: widget.onEdit,
                                            icon: Image.asset(
                                                ImageAssets.dropDownIcon)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                        Positioned(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12, top: 0),
                            child: Container(
                                width: 110,
                                decoration: BoxDecoration(
                                    color: ColorManager.white,
                                    borderRadius: BorderRadius.circular(4)),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8, right: 8),
                                  child: Text(AppStrings.receiveQuantity,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: getSemiBoldStyle(
                                          color: ColorManager.lightGrey1,
                                          fontSize: FontSize.s14)),
                                )),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MenuItemListTile extends StatelessWidget {
  final String title;
  final String imageString;
  final VoidCallback onTap;
  const MenuItemListTile(
      {super.key,
      required this.title,
      required this.imageString,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          height: 80,
          width: displayWidth(context),
          decoration: BoxDecoration(
              color: ColorManager.white,
              borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: ListTile(
              tileColor: ColorManager.blue,
              title: Row(
                children: [
                  const SizedBox(width: 5),
                  Image.asset(imageString),
                  const SizedBox(width: 15),
                  Text(title,
                      style: getRegularStyle(
                          color: ColorManager.lightGrey1,
                          fontSize: FontSize.s20))
                ],
              ),
            ),
          )),
    );
  }
}

class ItemListTile extends StatelessWidget {
  final String title;
  final String subtitle1;
  final String subtitle2;
  final String subtitle3;
  final String imageString;
  const ItemListTile(
      {super.key,
      required this.title,
      required this.subtitle1,
      required this.subtitle2,
      required this.subtitle3,
      required this.imageString});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: displayWidth(context),
      decoration: BoxDecoration(
          color: ColorManager.white, borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                  color: ColorManager.white,
                  border: Border.all(color: ColorManager.grey4, width: 1.0),
                  borderRadius: BorderRadius.circular(8)),
              child: Image.network(
                imageString,
                fit: BoxFit.contain,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: getBoldStyle(
                            color: ColorManager.darkBlue,
                            fontSize: FontSize.s14)),
                    RichText(
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        text: TextSpan(
                            text: AppStrings.itemCodeDetails,
                            style: getSemiBoldStyle(
                                color: ColorManager.black,
                                fontSize: FontSize.s12),
                            children: [
                              TextSpan(
                                  text: subtitle1,
                                  style: getRegularStyle(
                                      color: ColorManager.black,
                                      fontSize: FontSize.s12))
                            ])),
                    RichText(
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        text: TextSpan(
                            text: AppStrings.categoryCodeDetails,
                            style: getSemiBoldStyle(
                                color: ColorManager.black,
                                fontSize: FontSize.s12),
                            children: [
                              TextSpan(
                                  text: subtitle2,
                                  style: getRegularStyle(
                                      color: ColorManager.black,
                                      fontSize: FontSize.s12))
                            ])),
                    RichText(
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        text: TextSpan(
                            text: AppStrings.stockDetails,
                            style: getSemiBoldStyle(
                                color: ColorManager.black,
                                fontSize: FontSize.s12),
                            children: [
                              TextSpan(
                                  text: subtitle3,
                                  style: getRegularStyle(
                                      color: ColorManager.black,
                                      fontSize: FontSize.s12))
                            ])),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ItemGridTile extends StatelessWidget {
  final String title;
  final String subtitle1;
  final String subtitle2;
  final String subtitle3;
  final String imageString;

  const ItemGridTile(
      {super.key,
      required this.title,
      required this.subtitle1,
      required this.subtitle2,
      required this.subtitle3,
      required this.imageString});

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 440,
      decoration: BoxDecoration(
          color: ColorManager.white, borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.all(18.0),
      child: IntrinsicHeight(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 100,
              width: double.infinity,
              child: Image.network(
                imageString,
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(height: 10),
            Text(title,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: getBoldStyle(
                    color: ColorManager.darkBlue, fontSize: FontSize.s14)),
            RichText(
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              text: TextSpan(
                text: AppStrings.itemCodeDetails,
                style: getSemiBoldStyle(
                    color: ColorManager.black, fontSize: FontSize.s12),
                children: [
                  TextSpan(
                      text: subtitle1,
                      style: getRegularStyle(
                          color: ColorManager.black, fontSize: FontSize.s12))
                ],
              ),
            ),
            RichText(
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              text: TextSpan(
                text: AppStrings.categoryCodeDetails,
                style: getSemiBoldStyle(
                    color: ColorManager.black, fontSize: FontSize.s12),
                children: [
                  TextSpan(
                      text: subtitle2,
                      style: getRegularStyle(
                          color: ColorManager.black, fontSize: FontSize.s12))
                ],
              ),
            ),
            RichText(
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              text: TextSpan(
                text: AppStrings.stockDetails,
                style: getSemiBoldStyle(
                    color: ColorManager.black, fontSize: FontSize.s12),
                children: [
                  TextSpan(
                      text: subtitle3,
                      style: getRegularStyle(
                          color: ColorManager.black, fontSize: FontSize.s12))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
