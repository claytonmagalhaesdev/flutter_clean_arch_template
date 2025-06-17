// lib/features/users/presentation/users_rx_presenter.dart

import 'package:flutter_clean_arch_template/core/common/types/failures.dart';
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
  final Future<List<UserModel>> Function() _loader;
  final _ctrl = BehaviorSubject<UsersState>.seeded(const UsersInitial());

  @override
  late final Command0<void> loadUsersCommand;

  UsersRxPresenter({required Future<List<UserModel>> Function() usersLoader})
      : _loader = usersLoader {
    loadUsersCommand = Command0<void>(() async {
      _ctrl.add(const UsersLoading());

      try {
        final models = await _loader();
        final vm = UsersViewModel.fromModels(models);
        _ctrl.add(UsersData(vm));
        return const Result.ok(null);
      } on Failure catch (failure) {
        // mensagens ja formatadas em dioInterceptor
        _ctrl.add(UsersError(failure.message));
        return Result.error(failure);
      } catch (error) {
        // qualquer outro erro inesperado (JSON, timeout, etc)
        final fallback = UnknownFailure(error.toString());
        _ctrl.add(UsersError(fallback.message));
        return Result.error(fallback);
      }
    });
  }

  @override
  Stream<UsersState> get stateStream => _ctrl.stream;

  /// Fecha o Subject ao desmontar
  void dispose() => _ctrl.close();
}
