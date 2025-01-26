import 'package:flutter_clean_arch_template/core/commom/types/result.dart';
import 'package:flutter_clean_arch_template/features/user/domain/user_entity.dart';
import 'package:flutter_clean_arch_template/features/user/domain/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  
  @override
  Future<Result<List<UserEntity>>> getUsers() async {
    // Simulate a network request
    await Future.delayed(Duration(seconds: 1));
    return Result.ok([
      UserEntity(id: '1', name: 'John Doe', email: '  [email protected]'),
      UserEntity(id: '2', name: 'Jane Doe', email: '  [email protected]'),
    ]);
  }
}
