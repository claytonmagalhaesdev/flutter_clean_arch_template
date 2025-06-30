# Roteamento com Flutter

## Preparando o aplicativo para trabalhar com rotas nomeadas, respeitando Clean Architecture, desacoplado e testável

---

### Descrição

Neste capítulo, vamos explorar as práticas implementadas no projeto para gerenciar navegação e roteamento, começando pela abordagem tradicional ― centralizada e acoplada ― e evoluindo até uma solução desacoplada, flexível e altamente testável baseada em Clean Architecture e princípios SOLID.

A ideia aqui é como tornar os presenters/viewmodels independentes de detalhes da infraestrutura de navegação. Além disso, utilizar o Navigator (nativo do Flutter) e organizar as dependências por meio de um Service Locator customizado.
Mesmo sem usar um package externo, o projeto prevê futuras implementações com um package externo com mínima refatoração.

---

## 1. Abordagem tradicional: rotas fixas no runApp()

A forma mais comum em projetos Flutter é definir todas as rotas diretamente no `MaterialApp`:

```dart
void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => LoginPage(),
      '/users': (context) => UsersPage(),
      // ...outras rotas
    },
  ));
}
```

Esse padrão é simples, porém:

- Toda navegação depende do **context** (por exemplo, `Navigator.pushNamed(context, '/users')`)
- Toda construção das telas fica **acoplada ao MaterialApp**
- Dificulta modularização, testes e o uso de injeção de dependências
- Qualquer alteração na navegação exige mudar a configuração central

---

## 2. O problema do acoplamento

- As telas ficam acopladas ao framework (dependem do `BuildContext`)
- O presenter ou viewmodel não pode navegar (precisa passar pelo widget)
- Testar fluxos de navegação exige usar o Flutter completo, e não apenas mocks

> **Exemplo clássico de acoplamento:**

```dart
ElevatedButton(
  onPressed: () {
    Navigator.of(context).pushNamed('/users');
  },
  child: Text('Entrar'),
)
```

---

## 3. Desacoplando a navegação com Clean Architecture

### 3.1. Princípios aplicados

- **Single Responsibility:** cada camada tem sua função: UI apenas exibe, presenter apenas orquestra, etc.
- **Dependency Inversion:** camadas superiores dependem de abstrações, não de implementações concretas (exemplo: presenter depende de um `NavigationService`, não do `Navigator`)
- **Open/Closed:** podemos adicionar novas telas e rotas sem mexer na configuração global

---

### 3.2. Introduzindo o NavigationService (Service Abstraction)

Dentro da pasta "core" criamos uma pasta "navigation".
Após isso, criamos uma interface abstrata para navegação:

Ex.:
```dart
abstract class NavigationService {
  Future<void> navigateTo(String routeName, {Object? arguments});
  void goBack();
}
```

---

### 3.3. Implementando o NavigationService desacoplado

obs.: a implementação foi colocada no mesmo arquivo (2 classes) mas poderia tranquilamente ser dividida em 2 arquivos distintos, algo como "navigation_service_impl.dart". 

A implementação concreta recebe/usa dois parâmetros por injeção de dependência:
o `Navigator` e um **GlobalKey** (em seguida veremos onde/como usamos essa chave global):

Os dois métodos são implementados herdados da interface. O "navigateTo" basicamente irá buscar a page por meio da string URL para poder efetuar a navegação.
Para isso é usado o "pageFactories" que será mostrado em seguida no tópico 3.4.
O método "goBack()" apenas faz um "pop" que desempilha a página atual (global key controla isso), simples assim.

```dart
class NavigationServiceImpl implements NavigationService {
  final GlobalKey<NavigatorState> navigatorKey;
  final Map<String, PageFactory> pageFactories;

  NavigationServiceImpl(this.navigatorKey, this.pageFactories);

  @override
  Future<void> navigateTo(String routeName, {Object? arguments}) {
    final pageFactory = pageFactories[routeName];
    if (pageFactory == null) throw Exception('Rota não encontrada');
    final page = pageFactory(arguments);
    return navigatorKey.currentState!.push(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  @override
  void goBack() => navigatorKey.currentState!.pop();
}
```

Arquivo completo implementado -> [lib/core/navigation/navigation_service.dart](https://github.com/claytonmagalhaesdev/flutter_clean_arch_template/blob/main/lib/core/navigation/navigation_service.dart)


> **Nota de Arquitetura:**  
> Uma das grandes vantagens desse padrão é que toda a lógica de navegação do seu aplicativo depende apenas da abstração `NavigationService`, e **não** da implementação concreta.  
> Se, futuramente, você quiser adotar uma solução diferente — como o pacote [`go_router`](https://pub.dev/packages/go_router) —, basta criar uma nova classe que implemente a interface `NavigationService` utilizando o novo mecanismo de navegação, e registrar essa nova implementação no seu Service Locator.  
> Todo o restante do seu app (presenters, viewmodels, UI) continuará funcionando **sem precisar de ajustes**.  
> Assim, você garante um sistema realmente desacoplado e preparado para evolução tecnológica, além de facilitar testes e manutenção.

Veja abaixo o exemplo que não está no projeto em questão.

```dart
import 'package:go_router/go_router.dart';

class GoRouterNavigationService implements NavigationService {
  final GoRouter goRouter;

  GoRouterNavigationService(this.goRouter);

  @override
  Future<void> navigateTo(String routeName, {Object? arguments}) async {
    goRouter.go(routeName, extra: arguments);
  }

  @override
  void goBack() {
    goRouter.pop();
  }
}
```
---

### 3.4. O padrão Factory para criar páginas (PageFactory)

Ainda dentro da mesma pasta "navigation" criamos um arquivo chamado "page_factory.dart"

Para cada tela, criamos uma "fábrica" que instancia a página:

```dart
typedef PageFactory = Widget Function([Object? arguments]);
```

**O que é PageFactory?**

É um tipo/interface criado (usando `typedef`) apenas para padronizar as funções que constroem as telas do app, de acordo com o mapeamento em `pageFactories`.
Assim, toda vez que definirmos uma nova rota, basta criar uma função nesse formato para gerar a página. Ou seja, o typedef `PageFactory` serve só para dizer:  
**"Aqui vai uma função que recebe argumentos opcionais e devolve um Widget (uma tela do app)"**

Isso permite que a criação da tela não dependa do MaterialApp e, inclusive, receba presenters já injetados pelo Service Locator.

Em seguida, no mesmo arquivo, definir o mapeamento de cada sring URL devolvendo um page (widget)

**Exemplo visual (como fica o mapeamento):**

```dart
final pageFactories = <String, PageFactory>{
  '/login': ([args]) => LoginPage(presenter: ServiceLocator.get<LoginPresenter>(),
            localizationService: ServiceLocator.get<LocalizationService>()),
  '/users': ([args]) => UsersPage(presenter: ServiceLocator.get<UsersPresenter>()),
};
```

Arquivo completo implementado -> [lib/core/navigation/page_factory.dart](https://github.com/claytonmagalhaesdev/flutter_clean_arch_template/blob/main/lib/core/navigation/page_factory.dart)

---

## 4. Composição das dependências (setupDependencies)

O Service Locator (nosso caso, abstração de Get_it implementação) gerencia todas as dependências e rotas:

Abrir o arquivo -> [lib/core/di/setup_dependencies.dart](https://github.com/claytonmagalhaesdev/flutter_clean_arch_template/blob/main/lib/core/di/setup_dependencies.dart)
e alterar adicionando o que precisamos gerenciar de dependências para esses novos serviços criados para navegação.


```dart
void setupDependencies(DependencyInjector di) {
  
  //global key 
  final navigatorKey = GlobalKey<NavigatorState>();
  di.registerSingleton<GlobalKey<NavigatorState>>(navigatorKey);

  //fabrica de rotas/pages
  di.registerSingleton<Map<String, PageFactory>>(buildPageFactories());

  //navigation service
  di.registerSingleton<NavigationService>(
    NavigationServiceImpl(navigatorKey, di.get<Map<String, PageFactory>>()),
  );

  //Exemplo para o presenter de login receber e usar rotas
  di.registerFactory<LoginPresenter>(
    () => LoginChangeNotifierPresenter(di.get<NavigationService>()),
  );
  
  // ...demais dependências
}
```

> ***Para que serve o navigatorKey?***
    É uma chave global que permite acessar o `NavigatorState` fora do contexto de widgets, viabilizando navegação a partir de serviços, presenters ou qualquer outra camada desacoplada da UI.  
    Ao registrar a chave no Service Locator, garantimos que toda a aplicação compartilhe a mesma referência, mantendo a navegação centralizada e testável.
    Como vimos anteriormente, iremos sempre passar ela como dependência para o nosso "NavigationService" usá-la.

---

## 5. AppWidget totalmente desacoplado de rotas

no arquivo do App inicial em [lib/app.dart](https://github.com/claytonmagalhaesdev/flutter_clean_arch_template/blob/main/lib/app.dart) apenas adicionamos:

```dart
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final navigatorKey = ServiceLocator.get<GlobalKey<NavigatorState>>();
    final pageFactories = ServiceLocator.get<Map<String, PageFactory>>();

    return MaterialApp(
      navigatorKey: navigatorKey,
      home: pageFactories['/login']!(),
      // Sem routes! Toda navegação por serviço.
    );
  }
}
```

Vemos que o `MaterialApp` só conhece o `navigatorKey` e não a implementação toda por trás da navegação.
Mesmo que ambos (MaterialApp e o Navigator) estando na camada de infraestrutura (infra) na Clean Arch, um não precisa conhecer a implementação do outro. Neste caso o MaterialApp só passa a referência (navigatorKey), injetando como parâmetro para quem vai usá-la (neste caso o NavigationService).

---

## 6. Navegação desacoplada na prática

### No Presenter:

```dart
class LoginPresenter {
  final NavigationService navigationService;

  LoginPresenter(this.navigationService);

  void onLoginSuccess() {
    navigationService.navigateTo('/users');
  }
}
```

### Na UI:

```dart
ElevatedButton(
  onPressed: () => presenter.loginCommand.execute(),
  child: Text('Entrar'),
)
```
A UI **não sabe** nada sobre rotas e nem o que vem depois, apenas dispara o comando. 
O Presenter não conhece a implementação do NavigationService, apenas utiliza sua interface passando a url como String.
A UI não conhece nem as rotas nem o serviço de navegação
Tudo pode ser testado/mudado isoladamente.

---

## 7. Padrão Command + Testabilidade

Como já vimos, comandos permitem acionar lógicas no Presenter de forma controlada/testável:

```dart
class LoginChangeNotifierPresenter extends ChangeNotifier implements LoginPresenter {
  final NavigationService navigationService;
  late final Command0<void> loginCommand;

  LoginChangeNotifierPresenter(this.navigationService) {
    loginCommand = Command0<void>(_login);
  }

  Future<void> _login() async {
    // Lógica...
    navigationService.navigateTo('/users');
  }
}
```

---

## 8. Benefícios

- **Desacoplamento:** UI, lógica de negócio e navegação estão em camadas separadas.
- **Testabilidade:** Basta mockar o NavigationService para testar presenters.
- **Modularidade:** Rotas e telas podem ser adicionadas/removidas sem alterar o app principal.
- **SOLID aplicado:** especialmente Single Responsibility e Dependency Inversion.

---

## Visualização do fluxo resumido

```text
UI Widget dispara evento ->
Presenter/Command efetua a navegação ->
NavigationService e PageFactory criam a página ->
Navigator faz push/pop
     
```

---

## 9. Testes

Com essa estrutura podemos testar de diversas formas a navegação, seja de forma isolada ou por feature. Sejam testes de widget, unitários ou integração.

**Teste do NavigationService:**
Objetivo: garantir que as chamadas chegam ao Navigator/GoRouter/Outro.

Exemplo de teste de navegação:
"should push the correct page when navigateTo is called"

Garante que ao chamar navigationService.navigateTo('/mock'), o app navega para a rota esperada e o widget de destino (ex: Placeholder) aparece na tela.

Completo em [test/core/navigation/navigation_service_impl_test.dart](https://github.com/claytonmagalhaesdev/flutter_clean_arch_template/blob/main/test/core/navigation/navigation_service_impl_test.dart) apenas adicionamos:


**Teste presenter/unitário:**

O que testa?
Testa o Presenter isoladamente, simulando o NavigationService (mock). Confirma que, ao executar comandos como login/logout, o Presenter chama os métodos corretos do NavigationService.

Exemplo de teste de navegação:

'should navigate to /users when loginCommand is executed'
Garante que o Presenter chama navigationService.navigateTo('/users') ao executar login.

Completo: [test/features/auth/presentation/login_presenter_test.dart](https://github.com/claytonmagalhaesdev/flutter_clean_arch_template/blob/main/test/features/auth/presentation/login_presenter_test.dart) apenas adicionamos:


**Teste de widget:**
Testa a UI isoladamente, mockando presenter.
Verifica a interação entre a UI (LoginPage), o Presenter e o NavigationService/Command. Confirma que, ao clicar no botão de login, o Presenter executa o comando de login, que por sua vez pode disparar navegação.

Exemplo de testede navegação:
'should trigger loginCommand.execute when "login_button" button is tapped'
Assegura que, ao clicar no botão de login, o comando do Presenter é chamado (que pode acionar navegação via service).

Completo em [test/features/auth/presentation/login_page_test.dart](https://github.com/claytonmagalhaesdev/flutter_clean_arch_template/blob/main/test/features/auth/presentation/login_page_test.dart) apenas adicionamos:

