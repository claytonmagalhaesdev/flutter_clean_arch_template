// lib/features/user/presentation/user_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_clean_arch_template/features/users/presentation/users_presenter.dart';
import 'package:flutter_clean_arch_template/features/users/presentation/users_viewmodel.dart';

/// Tela que consome o [UserPresenter] e exibe a lista de usuários.
class UserPage extends StatefulWidget {
  final UsersPresenter presenter;

  const UserPage({
    super.key,
    required this.presenter,
  });

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  void initState() {
    super.initState();
    widget.presenter.loadUsers();
    widget.presenter.isBusyStream.listen((isBusy) {
      if (isBusy) {
        _showLoading();
      } else {
        _hideLoading();
      }
    });
  }

  void _showLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const SimpleDialog(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                Text('Carregando usuários…'),
                SizedBox(height: 16),
                CircularProgressIndicator(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _hideLoading() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Erro ao carregar usuários.'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => widget.presenter.loadUsers(isReload: true),
            child: const Text('RECARREGAR'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Usuários')),
      body: StreamBuilder<UsersViewModel>(
        stream: widget.presenter.usersStream,
        builder: (context, snapshot) {
          // Spinner inicial até o stream entrar no estado active
          if (snapshot.connectionState != ConnectionState.active) {
            return const Center(child: CircularProgressIndicator());
          }

          // Se ocorrer erro, mostra o layout de erro
          if (snapshot.hasError) {
            return _buildError();
          }

          final UsersViewModel vm = snapshot.data!;

          // Se não houver usuários
          if (vm.users.isEmpty) {
            return const Center(child: Text('Nenhum usuário encontrado.'));
          }

          // Exibe a lista
          return ListView.separated(
            itemCount: vm.users.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (_, index) {
              final user = vm.users[index];
              return ListTile(
                leading: user.avatarUrl != null
                    ? CircleAvatar(backgroundImage: NetworkImage(user.avatarUrl!))
                    : CircleAvatar(child: Text(user.displayName[0])),
                title: Text(user.displayName),
                subtitle: Text(user.emailMasked),
              );
            },
          );
        },
      ),
    );
  }
}
