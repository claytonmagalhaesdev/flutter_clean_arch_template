import 'package:flutter_clean_arch_template/features/users/presentation/users_viewmodel.dart';

abstract class UsersPresenter {
  /// Stream de ViewModels já mapeados
  Stream<UsersViewModel> get usersStream;

  /// Para mostrar/hide loading
  Stream<bool> get isBusyStream;

  /// Dispara a carga (pode ter pagination, filtros…)
  Future<void> loadUsers({bool isReload});
}
