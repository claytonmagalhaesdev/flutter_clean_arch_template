# Organização de Tema (Dark/Light)

## Visão Geral

O projeto utiliza um padrão **desacoplado** e alinhado com boas práticas para definir e gerenciar os temas do aplicativo.
Todas as cores, tipografia e estilos ficam centralizados, facilitando manutenção, expansão e testes.

---

## Estrutura Recomendada

- [`lib/core/config/themes/app_colors.dart`](https://github.com/claytonmagalhaesdev/flutter_clean_arch_template/blob/main/lib/core/config/themes/app_colors.dart)
  Define paletas de cores (light/dark).
- [`lib/core/config/themes/app_typography.dart`](https://github.com/claytonmagalhaesdev/flutter_clean_arch_template/blob/main/lib/core/config/themes/app_typography.dart)
  Define tipografia.
- [`lib/core/config/themes/app_theme.dart`](https://github.com/claytonmagalhaesdev/flutter_clean_arch_template/blob/main/lib/core/config/themes/app_typography.dart)
  Mapeia tudo para ThemeData do Flutter.
- `[lib/app.dart]`(https://github.com/claytonmagalhaesdev/flutter_clean_arch_template/blob/main/lib/app.dart)\
  Inicialização e gerenciamento dinâmico do tema.

---

## Exemplo de Implementação

### 1. Definição de Cores

Use uma `abstract final class` para impedir instância e garantir imutabilidade.

```dart
// lib/core/config/themes/app_colors.dart
abstract final class AppColors {
  const AppColors._(); // construtor privado, evita instâncias acidentais

  static const lightBackground = Color(0xFFF6F6F6);
  static const darkBackground = Color(0xFF18191A);
  // ... demais cores
}
```

---

### 2. Tipografia

Sempre use `const` para performance.

```dart
// lib/core/config/themes/app_typography.dart
abstract final class AppTypography {
  const AppTypography._();

  static const TextStyle displayLarge = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 32,
    fontWeight: FontWeight.bold,
  );
  // ... demais estilos
}
```

---

### 3. ThemeData Centralizado

Definidos temas em uma única classe separada.

```dart
// lib/core/config/themes/app_theme.dart
final class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightBackground,
    textTheme: const TextTheme(
      displayLarge: AppTypography.displayLarge,
      // ...
    ),
    // ... demais temas de widget
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBackground,
    // ... repete a estrutura acima para dark
  );
}
```

---

### 4. Extensões para ThemeData

Caso seja necessário fazer customizações, uma boa prática que não está no projeto é o uso de "extensions".
Permite acessar cores customizadas de acordo com o tema ativo, de forma desacoplada.

Exemplo:

```dart
extension CustomTheme on ThemeData {
  Color get cardBorder => brightness == Brightness.dark
    ? AppColors.darkBackground
    : AppColors.lightBackground;
}
```

Exemplo de uso:

```dart
Container(
  decoration: BoxDecoration(
    border: Border.all(
      color: Theme.of(context).cardBorder,
    ),
  ),
)
```
---

Por fim, para usar essas classes no aplicativo, deve-se usar dentro do MaterialApp, widget root, da forma como está no projeto

```dart
return MaterialApp(
      //outras propriedades
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
    );
```
