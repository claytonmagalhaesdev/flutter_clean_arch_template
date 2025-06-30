import 'package:flutter/material.dart';
import 'package:flutter_clean_arch_template/core/di/service_locator.dart';
import 'package:flutter_clean_arch_template/features/auth/presentation/login_presenter.dart';
import 'package:flutter_clean_arch_template/features/users/presentation/users_page.dart';
import 'package:flutter_clean_arch_template/features/auth/presentation/login_page.dart';
import 'package:flutter_clean_arch_template/features/users/presentation/users_presenter.dart';

typedef PageFactory = Widget Function([Object? arguments]);

Map<String, PageFactory> buildPageFactories() => {
      '/users': ([arguments]) =>
          UsersPage(presenter: ServiceLocator.get<UsersPresenter>()),
      '/login': ([arguments]) =>
          LoginPage(presenter: ServiceLocator.get<LoginPresenter>()),

      //other routes can be added here
    };
