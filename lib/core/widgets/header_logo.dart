import 'package:eyvo_inventory/core/resources/assets_manager.dart';
import 'package:flutter/material.dart';

class HeaderLogo extends StatelessWidget {
  const HeaderLogo({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return SizedBox(
      height: screenHeight * 0.27,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.elliptical(screenWidth * 0.5, 55.0),
            bottomRight: Radius.elliptical(screenWidth * 0.5, 55.0),
          ),
          image: const DecorationImage(
              image: AssetImage(ImageAssets.roundBackground),
              fit: BoxFit.cover),
        ),
        child: const Center(
            child: Padding(
          padding: EdgeInsets.only(top: 10),
          child: Image(
              image: AssetImage(ImageAssets.splashIcon),
              width: 170,
              height: 137),
        )),
      ),
    );
  }
}
