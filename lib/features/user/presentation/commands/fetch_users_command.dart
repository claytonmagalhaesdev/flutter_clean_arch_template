import 'package:flutter_clean_arch_template/features/user/presentation/bloc/user_bloc.dart';
import 'package:flutter_clean_arch_template/features/user/presentation/bloc/user_events.dart';

class FetchUsersCommand {
  final UserBloc userBloc;

  FetchUsersCommand(this.userBloc);

  void execute() {
    userBloc.add(FetchUsers());
  }
}
