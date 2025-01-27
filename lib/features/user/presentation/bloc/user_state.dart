// Estados do BLoC
import 'package:equatable/equatable.dart';
import 'package:flutter_clean_arch_template/features/user/domain/user_entity.dart';

abstract class UserState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final List<UserEntity> users;

  UserLoaded(this.users);

  @override
  List<Object?> get props => [users];
}

class UserError extends UserState {
  final String message;

  UserError(this.message);

  @override
  List<Object?> get props => [message];
}
