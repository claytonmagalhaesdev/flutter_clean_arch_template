import 'package:flutter/material.dart';
import 'package:flutter_clean_arch_template/core/di/dependency_injector.dart';
import 'package:flutter_clean_arch_template/features/user/presentation/user_page.dart';

class App extends StatelessWidget {
  final DependencyInjector di;

  const App(this.di, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Template',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: di.get<UserPage>(),
    );
  }
}
