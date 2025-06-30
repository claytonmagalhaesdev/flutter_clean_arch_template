import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_clean_arch_template/core/command.dart';
import 'package:flutter_clean_arch_template/core/common/types/result.dart';
import 'package:flutter_clean_arch_template/core/navigation/navigation_service.dart';
import 'package:flutter_clean_arch_template/features/auth/presentation/login_state.dart';

abstract class LoginPresenter {
  Stream<LoginState> get stateStream;
  Command0<void> get loginCommand;
  Command0<void> get logoutCommand;
  void dispose();
}

// presenter implementation using ChangeNotifier into same file
// this class will be changed to use other state management solutions
class LoginChangeNotifierPresenter extends ChangeNotifier
    implements LoginPresenter {

  @override
  Stream<LoginState> get stateStream => _stateController.stream;

  @override
  late final Command0<void> loginCommand;

  @override
  late final Command0<void> logoutCommand;
  
  final NavigationService navigationService;
  LoginState _state = const LoginInitial();
  final _stateController = StreamController<LoginState>.broadcast();

  LoginChangeNotifierPresenter(this.navigationService) {
    loginCommand = Command0<void>(_login);
    logoutCommand = Command0<void>(_logout);
    _emit(_state);
  }

  Future<Result<void>> _login() async {
    _emit(const LoginLoading());

    //simulate a network call
    await Future.delayed(const Duration(seconds: 3));

    _emit(const LoginSuccess());
    navigationService.navigateTo('/users');

    return Result.ok(null);
  }

  Future<Result<void>> _logout() async {
    _emit(const LoginInitial());
    navigationService.navigateTo('/login');
    return Result.ok(null);
  }

  void _emit(LoginState newState) {
    _state = newState;
    notifyListeners();
    _stateController.add(newState);
  }

  @override
  void dispose() {
    _stateController.close();
    super.dispose();
  }
}
