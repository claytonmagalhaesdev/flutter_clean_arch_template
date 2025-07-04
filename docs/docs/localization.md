# Internacionalização (i18n)

A internacionalização (i18n) é essencial pra quem visa alcançar públicos diversos e que precisam oferecer a interface adaptada ao idioma do usuário, o que proporciona maior inclusão, acessibilidade e experiência de uso. 

Neste projeto, optou-se por implementar um serviço de tradução desacoplado, alinhado à Clean Architecture e pronto para ser expandido para qualquer idioma.

Atualmente, o template suporta três idiomas: português brasileiro, inglês e japonês, mas o padrão permite adicionar facilmente qualquer outro idioma.

---

## Benefícios de uma solução desacoplada

- **Reutilização e manutenção:** As traduções estão centralizadas, facilitando a atualização ou expansão.
- **Testabilidade:** O serviço de localização pode ser mockado nos testes, facilitando validação de interface.
- **Escalabilidade:** Suporte a múltiplos idiomas e adaptação futura sem afetar o restante do app.
- **Aderência ao Clean Architecture:** Não há dependência direta de bibliotecas externas nos widgets e features.

---

## Estrutura e Código

### 1. Serviço de Tradução

[lib/core/config/l10n/localization_service.dart](https://github.com/claytonmagalhaesdev/flutter_clean_arch_template/blob/main/lib/core/config/l10n/localization_service.dart)

initialize()
Responsável por toda a configuração inicial do serviço de tradução. Aguarda a inicialização da biblioteca de localização, registra todos os idiomas suportados e carrega o mapa de traduções do idioma ativo. Deve ser chamada antes do uso do serviço.

_initLocalization()
Registra os idiomas disponíveis e associa cada código de idioma ao seu respectivo mapa de traduções. É nesse método que o app fica pronto para oferecer múltiplos idiomas.

_loadTranslations()
Identifica o idioma atualmente ativo no sistema e carrega as traduções correspondentes para um mapa interno, facilitando consultas rápidas às traduções.

_getTranslationsForLocale(languageCode)
Realiza a busca (lookup) pelo mapa de traduções correspondente ao código do idioma fornecido, retornando sempre o conjunto correto de traduções.

getString(key)
Método utilizado na UI e em qualquer parte do app para buscar a tradução da chave informada, de acordo com o idioma ativo. Retorna a própria chave caso não exista tradução.

```dart
import 'dart:async';
import 'dart:ui';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_clean_arch_template/core/common/types/enums.dart';
import 'package:flutter_clean_arch_template/core/config/l10n/app_translations.dart';

abstract class LocalizationService {
  Future<void> initialize();
  String getString(String key);
  FlutterLocalization get instanceLocalization;
}

class LocalizationServiceImpl implements LocalizationService {
  late Map<String, String> _translations;
  static final LocalizationServiceImpl instance = LocalizationServiceImpl._();
  final FlutterLocalization _localization = FlutterLocalization.instance;
  LocalizationServiceImpl._();

  Future<void> initialize() async {
    await _localization.ensureInitialized();
    _initLocalization();
    _loadTranslations();
  }

  void _initLocalization() {
    final Locale systemLocale = PlatformDispatcher.instance.locale;
    _localization.init(
      mapLocales: [
        MapLocale(EnumLanguage.english.code, AppTranslations.en),
        MapLocale(EnumLanguage.portuguese.code, AppTranslations.pt),
        MapLocale(EnumLanguage.japanese.code, AppTranslations.ja),
      ],
      initLanguageCode: systemLocale.languageCode,
    );
  }

  void _loadTranslations() {
    final currentLocale = _localization.currentLocale?.languageCode ?? 'en';
    _translations = _getTranslationsForLocale(currentLocale);
  }

  Map<String, String> _getTranslationsForLocale(String languageCode) {
    switch (languageCode) {
      case 'pt':
        return Map<String, String>.from(AppTranslations.pt);
      case 'ja':
        return Map<String, String>.from(AppTranslations.ja);
      default:
        return Map<String, String>.from(AppTranslations.en);
    }
  }

  @override
  String getString(String key) {
    return _translations[key] ?? key;
  }

}
```

### 2. Arquivo de Traduções

[lib/core/config/l10n/app_translations.dart](https://github.com/claytonmagalhaesdev/flutter_clean_arch_template/blob/main/lib/core/config/l10n/app_translations.dart)

Aqui somente o arquivo com as strings e sua chave para cada idioma.. é o dicionário em si.
abstract class pois é só para organização, não pode ser instanciado.

```dart
abstract class AppTranslations {
  static const String welcome = 'Welcome';
  // ... outros campos ...

  static const Map<String, dynamic> en = {
    welcome: 'Welcome',
    // ...
  };

  static const Map<String, dynamic> pt = {
    welcome: 'Bem-vindo',
    // ...
  };

  static const Map<String, dynamic> ja = {
    welcome: 'ようこそ',
    // ...
  };
}
```

### 3. Configurar para o app todo no widget raíz...
```dart
MaterialApp(
    supportedLocales:
          localizationService.instanceLocalization.supportedLocales,
      localizationsDelegates:
          localizationService.instanceLocalization.localizationsDelegates,
    //outras configs
)
```


### 4. Injetando no Service Locator

[lib/core/di/setup_dependencies.dart](https://github.com/claytonmagalhaesdev/flutter_clean_arch_template/blob/main/lib/core/di/setup_dependencies.dart)

```dart
final localizationService = LocalizationService.instance;
di.registerSingleton<LocalizationService>(localizationService);
await localizationService.initialize();
```

### 5. Usando na UI

[lib/features/auth/presentation/login_page.dart](https://github.com/claytonmagalhaesdev/flutter_clean_arch_template/blob/main/lib/features/auth/presentation/login_page.dart)

```dart
Text(
  key: Key('welcome_text'),
  widget.localizationService.getString(AppTranslations.welcome),
  style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
)
```

### 6. Teste

Este teste garante que a tela de login exibe corretamente o texto traduzido de acordo com o idioma selecionado no serviço de localização.
Em resumo, garante que a camada e serviço de tradutor está funcionando usando um texto como exemplo da tela de login.

A seguir, está a explicação dos principais pontos do teste:

```dart
class MockLoginPresenter extends Mock implements LoginPresenter {}
class MockLocalizationService extends Mock implements LocalizationService {}
```

- **Mocks:** São criados mocks para o `LoginPresenter` e para o `LocalizationService`. Assim, o teste não depende de lógica real, apenas simula comportamentos.

Obs.: foi mockado o SharedPreferences pois o Localization package usa ele indiretamente pra gravar as chaves e valores das traduções.

```dart
setUp(() {
  presenter = MockLoginPresenter();
  localizationService = MockLocalizationService();

  when(() => presenter.stateStream)
      .thenAnswer((_) => const Stream<LoginState>.empty());

  when(() => localizationService.getString(any())).thenReturn('Bem vindo');
});
```

- **Preparação do teste:** No setup, os mocks são instanciados e configurados. O presenter retorna um `Stream` vazio (simulando que não há mudanças de estado), e o serviço de localização retorna `'Bem-vindo'` para qualquer chave requisitada.

```dart
testWidgets('show welcome text translate', (tester) async {
  await tester.pumpWidget(MaterialApp(
    home: LoginPage(
      presenter: presenter,
      localizationService: localizationService,
    ),
  ));

  expect(find.byKey(Key('welcome_text')), findsOneWidget);
  expect(find.text(localizationService.getString(AppTranslations.welcome)),
      findsWidgets);
});
```

- **Execução do teste:** O widget `LoginPage` é carregado usando os mocks criados.
- **Verificação 1:** Garante que há um widget com a chave `'welcome_text'` (garante que o texto de boas-vindas está presente na árvore de widgets).
- **Verificação 2:** Garante que o texto exibido corresponde ao valor traduzido, neste caso, `'Bem-vindo'`.

Outros testes com getString() apenas testam se a string é retornada corretamente se for chamada sua chave.

---

## Manutenção Futura

Basta adicionar um novo idioma no `AppTranslations` e configurar o `LocalizationService` para expandir o suporte. Como toda a aplicação utiliza a interface do serviço, mudanças internas ou troca de bibliotecas (ex: sair do flutter\_localization) impactariam apenas o serviço, e não toda a base de código.

