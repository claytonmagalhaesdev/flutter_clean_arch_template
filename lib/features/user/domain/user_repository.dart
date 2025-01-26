import 'package:flutter_clean_arch_template/core/common/types/result.dart';
import 'package:flutter_clean_arch_template/features/user/domain/user_entity.dart';

abstract class UserRepository {
  Future<Result<List<UserEntity>>> getUsers();
  // Other potential methods:
  // Future<Result<UserEntity>> getUserById(String id);
  // Future<Result<void>> createUser(UserEntity user);
  // Future<Result<void>> updateUser(UserEntity user);
}
