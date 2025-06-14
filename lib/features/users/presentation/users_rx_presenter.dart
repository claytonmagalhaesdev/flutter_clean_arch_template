import 'package:flutter_clean_arch_template/features/users/presentation/user_model.dart';
import 'package:flutter_clean_arch_template/features/users/presentation/users_presenter.dart';
import 'package:flutter_clean_arch_template/features/users/presentation/users_viewmodel.dart';
import 'package:rxdart/rxdart.dart';

final class UsersRxPresenter implements UsersPresenter {
  final Future<List<UserModel>> Function() usersLoader;
  final usersSubject = BehaviorSubject<UsersViewModel>();
  final isBusySubject = BehaviorSubject<bool>();

  UsersRxPresenter({required this.usersLoader});

  @override
  Stream<UsersViewModel> get usersStream => usersSubject.stream;

  @override
  Stream<bool> get isBusyStream => isBusySubject.stream;

  @override
  Future<void> loadUsers({bool isReload = false}) async {
    try {
      if (isReload) isBusySubject.add(true);
      final event = await usersLoader();
      usersSubject.add(UsersViewModel.fromUsers(event));
    } catch (error) {
      usersSubject.addError(error);
    } finally {
      if (isReload) isBusySubject.add(false);
    }
  }
}
