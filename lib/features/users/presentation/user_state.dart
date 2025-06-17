// lib/features/users/presentation/users_state.dart

import 'package:flutter_clean_arch_template/features/users/presentation/users_viewmodel.dart';

/// Estados selados para a UI tratar de maneira exaustiva.
abstract class UsersState {
  const UsersState();
}

class UsersInitial extends UsersState {
  const UsersInitial();
}

class UsersLoading extends UsersState {
  const UsersLoading();
}

class UsersData extends UsersState {
  final UsersViewModel viewModel;
  const UsersData(this.viewModel);
}

class UsersError extends UsersState {
  final String message;
  const UsersError(this.message);
}
