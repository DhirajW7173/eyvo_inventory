import 'package:eyvo_inventory/Environment/environment.dart';
import 'package:eyvo_inventory/app/app_prefs.dart';
import 'package:eyvo_inventory/log_data.dart/logger_data.dart';
import 'package:flutter/material.dart';

import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Enviroment SetUP
  const String environment = String.fromEnvironment(
    "ENVIRONMENT",
    defaultValue: Environment.DEV,
  );

  //initialize enviroment in Logger
  LoggerData.environment = environment;

  Environment().initConfig(environment);

  //Shared Prefs for Store user Data
  await SharedPrefs().init();

  runApp(
    MyApp(),
  );
}
