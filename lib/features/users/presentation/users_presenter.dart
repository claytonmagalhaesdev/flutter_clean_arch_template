import 'package:flutter_clean_arch_template/core/command.dart';
import 'package:flutter_clean_arch_template/features/users/presentation/user_state.dart';

/// Contrato de presenter: emite um único stream de estado e um comando.
abstract class UsersPresenter {
  /// Stream único de estados (initial, loading, data, error)
  Stream<UsersState> get stateStream;

  /// Comando que dispara o carregamento de usuários
  Command0<void> get loadUsersCommand;
}
