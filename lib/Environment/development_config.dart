import 'package:eyvo_inventory/Environment/base_configuration.dart';

class DevelopmentConfiguration implements BaseConfig {
  @override
  String get apiHost => 'https://service.eyvo.net/eBA API 2.0';

  @override
  String get domainHost => '';
}
