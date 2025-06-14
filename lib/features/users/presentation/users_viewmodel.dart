import 'package:flutter_clean_arch_template/features/users/presentation/user_model.dart';

/// Só campos imutáveis para a UI consumir
final class UsersViewModel {
  final List<UserModel> users;

  const UsersViewModel({this.users = const []});

  /// Mapeia diretamente da entidade de domínio
  factory UsersViewModel.fromUsers(List<UserModel> users) {
    return UsersViewModel(users: users);
  }
}
