import 'package:flutter_clean_arch_template/core/command.dart';
import 'package:flutter_clean_arch_template/core/common/types/result.dart';
import 'package:flutter_clean_arch_template/features/user/presentation/bloc/user_bloc.dart';
import 'package:flutter_clean_arch_template/features/user/presentation/bloc/user_events.dart';
import 'package:flutter_clean_arch_template/features/user/presentation/bloc/user_state.dart';

class UserViewModel {
  final UserBloc userBloc;
  late final Command0<void> fetchUsersCommand;

  UserViewModel(this.userBloc) {
    fetchUsersCommand = Command0<void>(() async {
      userBloc.add(FetchUsers());
      return Result<void>.ok(null);
    });
  }

  // Expor estados
  Stream<UserState> get userStateStream => userBloc.stream;

  // Método para facilitar o uso na interface
  Future<void> fetchUsers() => fetchUsersCommand.execute();
}
