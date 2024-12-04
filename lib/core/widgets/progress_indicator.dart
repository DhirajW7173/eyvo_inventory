import 'package:eyvo_inventory/core/resources/color_manager.dart';
import 'package:flutter/material.dart';

class CustomProgressIndicator extends StatelessWidget {
  const CustomProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(ColorManager.darkBlue),
    );
  }
}
