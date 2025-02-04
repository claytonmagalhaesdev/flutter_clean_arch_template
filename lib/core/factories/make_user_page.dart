import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_arch_template/core/common/network/http/dio/dio_http_client.dart';
import 'package:flutter_clean_arch_template/features/user/domain/usecases/get_users_use_case.dart';
import 'package:flutter_clean_arch_template/features/user/infra/user_repository_impl.dart';
import 'package:flutter_clean_arch_template/features/user/presentation/bloc/user_bloc.dart';
import 'package:flutter_clean_arch_template/features/user/presentation/user_page.dart';
import 'package:flutter_clean_arch_template/features/user/presentation/user_viewmodel.dart';

Widget makeUserPage() {
  final repo = makeUserRepo();
  final usecase = GetUsersUseCase(repo);
  final bloc = UserBloc(usecase);
  final viewModel = UserViewModel(bloc);
  return UserPage(viewModel: viewModel,);
}

makeUserRepo() {
  final dio = Dio();
  final dioClient = DioHttpClient(dio);
  final repo = UserRepositoryImpl(dio: dioClient);
  return repo;
}
