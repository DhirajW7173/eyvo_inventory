import 'dart:developer';

class LoggerData {
  static String environment = "DEV";

  static void dataLog(String msg) {
    if (environment == "DEV" || environment == "STAGING") {
      log(msg);
    } else {}
  }

  static void dataPrint(String msg) {
    if (environment == "DEV" || environment == "STAGING") {
      print(msg);
    } else {}
  }
}
