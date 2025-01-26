import 'package:flutter_clean_arch_template/core/commom/types/result.dart';
import 'package:flutter_clean_arch_template/features/user/domain/user_entity.dart';
import 'package:flutter_clean_arch_template/features/user/domain/user_repository.dart';

class GetUsersUseCase {
  final UserRepository _userRepository;

  GetUsersUseCase(this._userRepository);

  Future<Result<List<UserEntity>>> execute() {
    return _userRepository.getUsers();
  }
}
