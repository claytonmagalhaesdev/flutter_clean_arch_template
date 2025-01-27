// BLoC (ViewModel)
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_arch_template/core/common/types/result.dart';
import 'package:flutter_clean_arch_template/features/user/domain/usecases/get_users_use_case.dart';
import 'package:flutter_clean_arch_template/features/user/presentation/bloc/user_events.dart';
import 'package:flutter_clean_arch_template/features/user/presentation/bloc/user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUsersUseCase getUsersUsecase;

  UserBloc(this.getUsersUsecase) : super(UserInitial()) {
    on<FetchUsers>((event, emit) async {
      emit(UserLoading());
      final Result result = await getUsersUsecase.execute();

      if (result.isSuccess) {
        emit(UserLoaded(result.value!));
      } else {
        emit(UserError(result.errorMessage ?? "Erro desconhecido"));
      }
    });
  }
}
