import 'package:eyvo_inventory/Environment/base_configuration.dart';
import 'package:eyvo_inventory/Environment/development_config.dart';
import 'package:eyvo_inventory/Environment/production_config.dart';
import 'package:eyvo_inventory/Environment/staging_config.dart';

String baseUrl = "";
String domain = "";

class Environment {
  factory Environment() {
    return _singleton;
  }

  Environment._internal();

  static final Environment _singleton = Environment._internal();

  static const String DEV = "DEV";
  static const String STAGING = "STAGING";
  static const String PROD = "PROD";

  BaseConfig? config;

  void initConfig(String environment) {
    config = _getConfig(environment);
    _mapToPreviousEnvs();
  }

  BaseConfig _getConfig(String environment) {
    switch (environment) {
      case Environment.PROD:
        return ProductionConfiguration();
      case Environment.STAGING:
        return StagingConfiguration();
      default:
        return DevelopmentConfiguration();
    }
  }

  void _mapToPreviousEnvs() {
    baseUrl = config!.apiHost;
    domain = config!.domainHost;
  }
}
