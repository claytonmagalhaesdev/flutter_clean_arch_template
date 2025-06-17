// lib/features/users/presentation/users_change_notifier_presenter.dart

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_clean_arch_template/core/command.dart';
import 'package:flutter_clean_arch_template/core/common/types/result.dart';
import 'package:flutter_clean_arch_template/features/users/domain/usecases/get_users_use_case.dart';
import 'package:flutter_clean_arch_template/features/users/presentation/user_model.dart';
import 'package:flutter_clean_arch_template/features/users/presentation/users_state.dart';
import 'package:flutter_clean_arch_template/features/users/presentation/users_presenter.dart';
import 'package:flutter_clean_arch_template/features/users/presentation/users_viewmodel.dart';

/// Presenter que usa ChangeNotifier e expõe um Stream<UsersState> para a UI.
class UsersChangeNotifierPresenter extends ChangeNotifier implements UsersPresenter {
  final GetUsersUseCase _useCase;

  // Estado interno atual
  UsersState _state = const UsersInitial();

  // Controller para stream que a UI consome
  final _stateController = StreamController<UsersState>.broadcast();

  @override
  late final Command0<void> loadUsersCommand;

  UsersChangeNotifierPresenter(this._useCase) {
    loadUsersCommand = Command0<void>(_executeLoad);
    // Emite o estado inicial assim que construído
    _emit(_state);
  }

  Future<Result<void>> _executeLoad() async {
    _emit(const UsersLoading());

    final result = await _useCase.execute();
    if (result.isError) {
      final msg = result.errorMessage!;
      _emit(UsersError(msg));
      return Result.error(Exception(msg));
    }

    final vm = UsersViewModel.fromModels(
      result.value!.map(UserModel.fromEntity).toList(),
    );
    _emit(UsersData(vm));
    return const Result.ok(null);
  }

  /// Notifica listeners e adiciona ao stream
  void _emit(UsersState newState) {
    _state = newState;
    notifyListeners();
    _stateController.add(newState);
  }

  /// Para StreamBuilder na UI
  @override
  Stream<UsersState> get stateStream => _stateController.stream;

  /// Fecha o controller ao descartar
  @override
  void dispose() {
    _stateController.close();
    super.dispose();
  }
}
