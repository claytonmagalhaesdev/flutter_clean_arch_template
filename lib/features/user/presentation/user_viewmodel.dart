import 'package:flutter_clean_arch_template/features/user/presentation/bloc/user_bloc.dart';
import 'package:flutter_clean_arch_template/features/user/presentation/bloc/user_events.dart';
import 'package:flutter_clean_arch_template/features/user/presentation/bloc/user_state.dart';

class UserViewModel {
  final UserBloc userBloc;

  UserViewModel(this.userBloc);

  // Expor estados
  Stream<UserState> get userStateStream => userBloc.stream;

  // Expor ações como comandos
  void fetchUsers() {
    userBloc.add(FetchUsers());
  }
}
