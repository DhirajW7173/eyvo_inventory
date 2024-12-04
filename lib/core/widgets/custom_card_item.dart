import 'package:eyvo_inventory/app/sizes_helper.dart';
import 'package:eyvo_inventory/core/resources/assets_manager.dart';
import 'package:eyvo_inventory/core/resources/color_manager.dart';
import 'package:eyvo_inventory/core/resources/font_manager.dart';
import 'package:eyvo_inventory/core/resources/styles_manager.dart';
import 'package:flutter/material.dart';

class CustomItemCard extends StatelessWidget {
  final String imageString;
  final String title;
  final Color backgroundColor;
  final double cornerRadius;
  final VoidCallback onTap;
  const CustomItemCard(
      {super.key,
      required this.imageString,
      required this.title,
      required this.backgroundColor,
      required this.cornerRadius,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: (displayWidth(context) * 0.5) - 30,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(cornerRadius),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              imageString,
            ),
            const SizedBox(height: 8.0),
            Text(
              title,
              style: getSemiBoldStyle(
                  color: ColorManager.lightGrey1, fontSize: FontSize.s18),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomItemCardWithEdit extends StatelessWidget {
  final String imageString;
  final String title;
  final String subtitle;
  final VoidCallback onEdit;
  final Color backgroundColor;
  final double cornerRadius;
  final bool isEditable;
  const CustomItemCardWithEdit(
      {super.key,
      required this.imageString,
      required this.title,
      required this.subtitle,
      required this.onEdit,
      required this.backgroundColor,
      required this.cornerRadius,
      this.isEditable = true});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onEdit,
      child: Stack(
        children: [
          Container(
            height: 106,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(cornerRadius),
            ),
            padding: const EdgeInsets.all(18.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(cornerRadius),
                  child: Image.asset(
                    imageString,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: getSemiBoldStyle(
                            color: ColorManager.lightGrey1,
                            fontSize: FontSize.s23_25),
                      ),
                      Text(subtitle,
                          style: getRegularStyle(
                              color: ColorManager.lightGrey2,
                              fontSize: FontSize.s22_5)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          isEditable
              ? Positioned(
                  top: 0.0,
                  right: 3.0,
                  child: IconButton(
                    icon: Image.asset(ImageAssets.editIcon,
                        width: 30, height: 30),
                    onPressed: onEdit,
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
