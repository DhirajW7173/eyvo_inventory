// ignore_for_file: constant_identifier_names

import "package:shared_preferences/shared_preferences.dart";

const String PREFS_GENERIC_ACCESS_KEY = "PREFS_GENERIC_ACCESS_KEY";
const String PREFS_ACCESS_KEY = "PREFS_ACCESS_KEY";
const String PREFS_KEY_COMPANYCODE = "PREFS_KEY_COMPANYCODE";
const String PREFS_KEY_USERNAME = "PREFS_KEY_USERNAME";
const String PREFS_KEY_UID = "PREFS_KEY_UID";
const String PREFS_KEY_PASSWORD = "PREFS_KEY_PASSWORD";
const String PREFS_KEY_IS_REMEMBER_ME = "PREFS_KEY_IS_REMEMBER_ME";
const String PREFS_KEY_TOKEN = "PREFS_KEY_TOKEN";
const String PREFS_KEY_REFRESH_TOKEN = "PREFS_KEY_REFRESH_TOKEN";
const String PREFS_KEY_COMPANYCODE_SCREEN = "PREFS_KEY_COMPANYCODE_SCREEN";
const String PREFS_KEY_IS_USER_LOGGED_IN = "PREFS_KEY_IS_USER_LOGGED_IN";
const String PREFS_KEY_APP_PIN = "PREFS_KEY_APP_PIN";
const String PREFS_KEY_EMAIL = "PREFS_KEY_EMAIL";
const String PREFS_KEY_SELECTED_REGION = "PREFS_KEY_SELECTED_REGION";
const String PREFS_KEY_SELECTED_REGION_ID = "PREFS_KEY_SELECTED_REGION_ID";
const String PREFS_KEY_SELECTED_LOCATION = "PREFS_KEY_SELECTED_LOCATION";
const String PREFS_KEY_SELECTED_LOCATION_ID = "PREFS_KEY_SELECTED_LOCATION_ID";
const String PREFS_KEY_USER_SESSION = "PREFS_KEY_USER_SESSION";
const String PREFS_KEY_DECIMAL_PLACES = "PREFS_KEY_DECIMAL_PLACES";
const String PREFS_KEY_IS_ITEM_SCANNED = "PREFS_KEY_IS_ITEM_SCANNED";
const String PREFS_KEY_SCANNED_REGION_ID = "PREFS_KEY_SCANNED_REGION_ID";
const String PREFS_KEY_SCANNED_LOCATION_ID = "PREFS_KEY_SCANNED_LOCATION_ID";

const String PREFS_KEY_IS_DEVELOPER_MODE = "PREFS_KEY_IS_DEVELOPER_MODE";

class SharedPrefs {
  late final SharedPreferences _sharedPrefs;

  static final SharedPrefs _instance = SharedPrefs._internal();
  factory SharedPrefs() => _instance;
  SharedPrefs._internal();
  Future<void> init() async {
    _sharedPrefs = await SharedPreferences.getInstance();
  }

  String get genericAccessKey =>
      _sharedPrefs.getString(PREFS_GENERIC_ACCESS_KEY) ?? "123456";

  String get accessKey => _sharedPrefs.getString(PREFS_ACCESS_KEY) ?? "";

  set accessKey(String value) {
    _sharedPrefs.setString(PREFS_ACCESS_KEY, value);
  }

  String get companyCode => _sharedPrefs.getString(PREFS_KEY_COMPANYCODE) ?? "";

  set companyCode(String value) {
    _sharedPrefs.setString(PREFS_KEY_COMPANYCODE, value);
  }

  String get username => _sharedPrefs.getString(PREFS_KEY_USERNAME) ?? "";

  set username(String value) {
    _sharedPrefs.setString(PREFS_KEY_USERNAME, value);
  }

  String get uID => _sharedPrefs.getString(PREFS_KEY_UID) ?? "";

  set uID(String value) {
    _sharedPrefs.setString(PREFS_KEY_UID, value);
  }

  String get password => _sharedPrefs.getString(PREFS_KEY_PASSWORD) ?? "";

  set password(String value) {
    _sharedPrefs.setString(PREFS_KEY_PASSWORD, value);
  }

  String get jwtToken => _sharedPrefs.getString(PREFS_KEY_TOKEN) ?? "";

  set jwtToken(String value) {
    _sharedPrefs.setString(PREFS_KEY_TOKEN, value);
  }

  String get refreshToken =>
      _sharedPrefs.getString(PREFS_KEY_REFRESH_TOKEN) ?? "";

  set refreshToken(String value) {
    _sharedPrefs.setString(PREFS_KEY_REFRESH_TOKEN, value);
  }

  String get appPIN => _sharedPrefs.getString(PREFS_KEY_APP_PIN) ?? "";

  set appPIN(String value) {
    _sharedPrefs.setString(PREFS_KEY_APP_PIN, value);
  }

  bool get isCompanyCodeScreenViewed =>
      _sharedPrefs.getBool(PREFS_KEY_COMPANYCODE_SCREEN) ?? false;

  set isCompanyCodeScreenViewed(bool value) {
    _sharedPrefs.setBool(PREFS_KEY_COMPANYCODE_SCREEN, value);
  }

  bool get isRememberMeSelected =>
      _sharedPrefs.getBool(PREFS_KEY_IS_REMEMBER_ME) ?? false;

  set isRememberMeSelected(bool value) {
    _sharedPrefs.setBool(PREFS_KEY_IS_REMEMBER_ME, value);
  }

  String get userEmail => _sharedPrefs.getString(PREFS_KEY_EMAIL) ?? "";

  set userEmail(String value) {
    _sharedPrefs.setString(PREFS_KEY_EMAIL, value);
  }

  String get selectedRegion =>
      _sharedPrefs.getString(PREFS_KEY_SELECTED_REGION) ?? "";

  set selectedRegion(String value) {
    _sharedPrefs.setString(PREFS_KEY_SELECTED_REGION, value);
  }

  int get selectedRegionID =>
      _sharedPrefs.getInt(PREFS_KEY_SELECTED_REGION_ID) ?? 0;

  set selectedRegionID(int value) {
    _sharedPrefs.setInt(PREFS_KEY_SELECTED_REGION_ID, value);
  }

  String get selectedLocation =>
      _sharedPrefs.getString(PREFS_KEY_SELECTED_LOCATION) ?? "";

  set selectedLocation(String value) {
    _sharedPrefs.setString(PREFS_KEY_SELECTED_LOCATION, value);
  }

  int get selectedLocationID =>
      _sharedPrefs.getInt(PREFS_KEY_SELECTED_LOCATION_ID) ?? 0;

  set selectedLocationID(int value) {
    _sharedPrefs.setInt(PREFS_KEY_SELECTED_LOCATION_ID, value);
  }

  int get decimalPlaces => _sharedPrefs.getInt(PREFS_KEY_DECIMAL_PLACES) ?? 0;

  set decimalPlaces(int value) {
    _sharedPrefs.setInt(PREFS_KEY_DECIMAL_PLACES, value);
  }

  String get userSession =>
      _sharedPrefs.getString(PREFS_KEY_USER_SESSION) ?? "";

  set userSession(String value) {
    _sharedPrefs.setString(PREFS_KEY_USER_SESSION, value);
  }

  bool get isItemScanned =>
      _sharedPrefs.getBool(PREFS_KEY_IS_ITEM_SCANNED) ?? false;

  set isItemScanned(bool value) {
    _sharedPrefs.setBool(PREFS_KEY_IS_ITEM_SCANNED, value);
  }

  int get scannedRegionID =>
      _sharedPrefs.getInt(PREFS_KEY_SCANNED_REGION_ID) ?? 0;

  set scannedRegionID(int value) {
    _sharedPrefs.setInt(PREFS_KEY_SCANNED_REGION_ID, value);
  }

  int get scannedLocationID =>
      _sharedPrefs.getInt(PREFS_KEY_SCANNED_LOCATION_ID) ?? 0;

  set scannedLocationID(int value) {
    _sharedPrefs.setInt(PREFS_KEY_SCANNED_LOCATION_ID, value);
  }
}
