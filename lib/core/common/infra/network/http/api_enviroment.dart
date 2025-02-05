class ApiEnvironment {
  static const String environment = String.fromEnvironment(
    'FLUTTER_ENV',
    defaultValue: 'development',
  );

  static final Map<String, Map<String, String>> _environments = {
    'development': {
      'jsonplaceholder': 'https://jsonplaceholder.typicode.com',
      'api2': 'https://dev-api2.example.com',
    },
    'staging': {
      'jsonplaceholder': 'https://jsonplaceholder.typicode.com',
      'api2': 'https://staging-api2.example.com',
    },
    'production': {
      'jsonplaceholder': 'https://jsonplaceholder.typicode.com',
      'api2': 'https://api2.example.com',
    },
  };

  static String getBaseUrl(String apiKey) {
    return _environments[environment]?[apiKey] ??
        (throw Exception('API Key inválida: $apiKey'));
  }
}
