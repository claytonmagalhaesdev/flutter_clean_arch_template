import 'package:flutter_clean_arch_template/features/user/presentation/bloc/user_state.dart';
import 'package:flutter_clean_arch_template/features/user/presentation/commands/fetch_users_command.dart';

class UserViewModel {
  final FetchUsersCommand fetchUsersCommand; // Usando o comando

  UserViewModel(this.fetchUsersCommand);

  // Expor estados
  Stream<UserState> get userStateStream => fetchUsersCommand.userBloc.stream;

  // Expor ações como comandos
  void fetchUsers() {
    fetchUsersCommand.execute();
  }
}
