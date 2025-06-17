// lib/features/users/presentation/users_rx_presenter.dart

import 'package:flutter_clean_arch_template/features/users/domain/usecases/get_users_use_case.dart';
import 'package:flutter_clean_arch_template/features/users/presentation/user_model.dart';
import 'package:flutter_clean_arch_template/features/users/presentation/user_state.dart';
import 'package:flutter_clean_arch_template/features/users/presentation/users_presenter.dart';
import 'package:flutter_clean_arch_template/features/users/presentation/users_viewmodel.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_clean_arch_template/core/command.dart';
import 'package:flutter_clean_arch_template/core/common/types/result.dart';

/* Implementação com RxDart, respeitando SRP:
   só orquestra fluxo e emite estados selados
   não faz lógica de UI (essa fica no UsersViewModel) */

class UsersRxPresenter implements UsersPresenter {
  final GetUsersUseCase _useCase;
  final BehaviorSubject<UsersState> _ctrl =
      BehaviorSubject<UsersState>.seeded(const UsersInitial());

  @override
  late final Command0<void> loadUsersCommand;

  UsersRxPresenter(this._useCase) {
    loadUsersCommand = Command0<void>(() async {
      _ctrl.add(const UsersLoading());

      final result = await _useCase.execute();
      if (result.isError) {
        final msg = result.errorMessage!; // já é String
        _ctrl.add(UsersError(msg));
        return Result.error(Exception(msg));
      }

      final vm = UsersViewModel.fromModels(
        result.value!.map(UserModel.fromEntity).toList(),
      );
      _ctrl.add(UsersData(vm));
      return const Result.ok(null);
    });
  }

  @override
  Stream<UsersState> get stateStream => _ctrl.stream;
  void dispose() => _ctrl.close();
}
