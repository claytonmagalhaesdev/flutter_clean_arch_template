# Injeção de Dependência no Clean Architecture Template

## 1. Visão Geral

A injeção de dependência é um dos pilares fundamentais para garantir desacoplamento, modularidade e testabilidade em projetos de software. No contexto do Clean Architecture Template, adotamos uma abordagem customizada para abstrair a injeção de dependências, evitando o acoplamento direto a bibliotecas externas, promovendo assim maior flexibilidade e longevidade para o projeto.

## Observe o código abaixo e o problema 

```dart
// Interface do repositório
interface UserRepository {
    User findUserById(String id)
}

// Implementação concreta do repositório
class UserRepositoryImpl implements UserRepository {
    User findUserById(String id) {
        // Busca usuário no banco de dados
    }
}

// UseCase que instancia o repositório diretamente (forma errada)
class FindUserUseCase {
    private UserRepository userRepository

    FindUserUseCase() {
        this.userRepository = new UserRepositoryImpl()
    }

    User execute(String id) {
        return userRepository.findUserById(id)
    }
}

// UI/widget/Screen que instancia o UseCase diretamente
class UserScreen {
    private FindUserUseCase findUserUseCase

    UserScreen() {
        // Aqui precisa instanciar o UseCase, que por sua vez instancia o repositório
        this.findUserUseCase = new FindUserUseCase()
    }

    void render() {
        User user = findUserUseCase.execute("123")
        // Renderiza UI com os dados do usuário
    }
}

function main() {
    UserScreen screen = new UserScreen()
    screen.render()
}
```

Essa forma de implementar resolve, mas é quase impossível de testar com código.
Além disso, com o passar dos anos do projeto, em algum momento talvez precisamos mudar as implementações das classes e elas estão todas acopladas entre si.

## 2. Por que usar injeção de dependência?

Ao projetar sistemas escaláveis, é importante garantir que os módulos, como repositórios, use cases, serviços e controladores, possam ser facilmente substituídos, testados e reutilizados. A injeção de dependência resolve o problema de acoplamento rígido entre classes, pois as dependências são "injetadas" de fora, ao invés de serem criadas internamente. Isso permite:

- Substituir implementações facilmente (exemplo: trocar um repositório fake por um real).
- Facilitar a escrita de testes, permitindo o uso de mocks/stubs.
- Promover a separação de responsabilidades, mantendo cada módulo focado em seu propósito.


### Problemas de injetar dependências diretamente (sem abstração)

Utilizar uma biblioteca de injeção de dependência diretamente no código (como GetIt, Provider, Riverpod, etc) pode gerar um problema de acoplamento. 
Quando o framework de DI está espalhado pelo projeto, qualquer troca futura (ou remoção) exigirá a alteração de múltiplos arquivos, gerando manutenção trabalhosa, difícil e sujeita a erros. 
Além disso, fere o princípio da Clean Architecture pois você está acoplando sua lógica de negócio, repositórios, etc a detalhes de infraestrutura (DI).
A solução ideal é abstrair o mecanismo de injeção por meio de interfaces e criar um Service Locator para permitir trocar o motor de DI de forma transparente, sem afetar o restante da aplicação.

## 3. Implementação no Projeto

No projeto, a injeção de dependências foi desenhada para ser agnóstica à biblioteca concreta utilizada. Os principais componentes são:

- **[DependencyInjector](https://github.com/claytonmagalhaesdev/flutter_clean_arch_template/blob/main/lib/core/di/dependency_injector.dart)**: interface abstrata que define métodos para registrar e obter dependências.
- **[GetItDependencyInjector](https://github.com/claytonmagalhaesdev/flutter_clean_arch_template/blob/main/lib/core/di/get_it_dependency_injector.dart)**: implementação da interface usando o GetIt como backend, mas podendo ser facilmente substituída.
- **[ServiceLocator](https://github.com/claytonmagalhaesdev/flutter_clean_arch_template/blob/main/lib/core/di/service_locator.dart)**: classe estática que armazena o injector e provê acesso global (mas controlado) às dependências.
- **[setupDependencies](https://github.com/claytonmagalhaesdev/flutter_clean_arch_template/blob/main/lib/core/di/setup_dependencies.dart)**: função responsável pelo registro dos módulos (repositories, use cases, serviços etc.) durante o bootstrap da aplicação (`main`).

### Exemplo de Código

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final injector = GetItDependencyInjector();
  setupDependencies(injector);
  ServiceLocator.setup(injector);
  runApp(App());
}
```
Mesmo criando uma abstração em "DependencyInjector" e isolando o GetIt, ainda assim nas classes internas da aplicação para recuperar a instância de uma classe teríamos código de GetIt (ou outra lib) fixo. Por exemplo:

```dart
// ERRADO: classe interna conhecendo GetIt diretamente
class UserUseCase {
  final UserRepository repo = GetIt.I.get<UserRepository>();

  Future<User> fetchUser(int id) => repo.getUser(id);
}
```
Mesmo que usemos uma interface, o problema persiste:

```dart
// AINDA ERRADO: classe interna conhece DependencyInjector
class UserUseCase {
  final UserRepository repo = injector.get<UserRepository>();

  Future<User> fetchUser(int id) => repo.getUser(id);
}
```

Neste cenário, a classe depende de um detalhe de infraestrutura para funcionar — e isso a torna difícil de testar, migrar ou evoluir.

Por isso criamos o "ServiceLocator"
Para evitar esse acoplamento, criamos o ServiceLocator apenas no nível mais externo da aplicação (por exemplo, no main ou em widgets de inicialização), e nunca nas camadas internas (como use cases, entidades ou repositórios). Assim, as dependências são injetadas nas classes via construtor ou via métodos, ao invés de serem recuperadas diretamente por elas.

Exemplo correto:
```dart
// AINDA ERRADO: classe interna conhece DependencyInjector
class UserUseCase {
  final UserRepository repo;
  UserUseCase(this.repo);

  Future<User> fetchUser(int id) => repo.getUser(id);
}

// E na camada externa (main ou widget raiz):
final userRepo = ServiceLocator.get<UserRepository>();
final userUseCase = UserUseCase(userRepo);
```
Dessa forma, se você trocar de biblioteca de DI, ou de implementação, nenhuma classe interna precisa ser alterada, mantendo o código limpo, testável e flexível.

Resumo:
- O projeto nunca depende diretamente do GetIt fora do adaptador de injeção.
- As dependências são recuperadas por meio do ServiceLocator, que chama o injector.

### Benefícios dessa abordagem
- **Desacoplamento**: qualquer DI pode ser trocado (ou removido) sem alterar o domínio e camadas de aplicação.
- **Escalabilidade**: adicionar novos módulos/funções não gera dependência de framework.
- **Testabilidade**: fácil substituição por mocks nos testes.
- **Longevidade**: o projeto permanece sustentável frente à evolução do ecossistema Flutter/Dart.

## 4. Exemplo de testabilidade
Veja esse trecho nos testes do [repositório de Users](https://github.com/claytonmagalhaesdev/flutter_clean_arch_template/blob/main/test/features/users/infra/user_repository_impl_test.dart):

```dart
setUp(() {
  mockDio = MockDio(); // <-- criamos um mock da dependência externa
  // ... (outros setups)
  userRepository = UserRepositoryImpl(
      httpClient: mockDio, // <-- INJETAMOS o mock aqui
      apiConfig: apiUrlConfigs,
      mapper: userDtoMapper,
      userEntityMapper: userEntityMapper);
});
```
No construtor de UserRepositoryImpl, passamos como parâmetro (injetamos) o mockDio, que é um mock (falso) do seu cliente HTTP. Ou seja, o repositório não instancia seu próprio httpClient; ele recebe (é injetado) de fora.

O que isso significa para testabilidade?
No teste, controlamos o comportamento do httpClient (mockDio), simulando o retorno da API.
Assim, não dependemos de API real (internet), nem faz chamadas reais, deixando o teste mais rápido e confiável.
Se a dependência fosse criada internamente no repositório, não teria como substituir pelo mock.