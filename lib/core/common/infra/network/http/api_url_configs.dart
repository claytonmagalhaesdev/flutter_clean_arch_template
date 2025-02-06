import 'package:flutter_clean_arch_template/core/common/infra/network/http/api_enviroment.dart';

//interface to get the base url to access on classes
abstract class ApiUrlConfigs {
  String getBaseUrl(String apiKey);
}

class ApiConfigRepositoryImpl implements ApiUrlConfigs {
  @override
  String getBaseUrl(String apiKey) {
    return ApiEnvironment.getBaseUrl(apiKey);
  }
}
