import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class GlobalUtils {
  showPositiveSnackBar({
    VoidCallback? onVisible,
    String? message,
    int? seconds,
    BuildContext? context,
  }) {
    return ScaffoldMessenger.of(context!).showSnackBar(
      SnackBar(
        content: Text(message!),
        backgroundColor: Colors.green,
        duration: Duration(seconds: seconds!),
        onVisible: onVisible,
      ),
    );
  }

  showNegativeSnackBar({
    VoidCallback? onVisible,
    String? message,
    int? seconds,
    BuildContext? context,
  }) {
    return ScaffoldMessenger.of(context!).showSnackBar(
      SnackBar(
        content: Text(message!),
        backgroundColor: Colors.red,
        duration: Duration(seconds: seconds!),
        onVisible: onVisible,
      ),
    );
  }

  void flutterToastMessage(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}

GlobalUtils globalUtils = GlobalUtils();
