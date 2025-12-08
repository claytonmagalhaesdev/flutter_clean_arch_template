// lib/features/users/presentation/users_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_clean_arch_template/features/users/presentation/user_model.dart';
import 'package:flutter_clean_arch_template/features/users/presentation/users_state.dart';
import 'users_presenter.dart';

class UsersPage extends StatefulWidget {
  final UsersPresenter presenter;

  const UsersPage({super.key, required this.presenter});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  @override
  void initState() {
    super.initState();
    widget.presenter.loadUsersCommand.execute();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Usuários')),
      body: StreamBuilder<UsersState>(
        stream: widget.presenter.stateStream,
        builder: (context, snapshot) {
          final state = snapshot.data ?? const UsersInitial();

          if (state is UsersInitial || state is UsersLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is UsersError) {
            return _buildError(state.message);
          }
          // state is UsersData
          final vm = (state as UsersData).viewModel;
          if (!vm.hasAny) {
            return const Center(child: Text('Nenhum usuário encontrado.'));
          }
          return ListView(
            children: [
              if (vm.admins.isNotEmpty) ...[
                _buildSectionTitle('Administradores'),
                ...vm.admins.map(_buildTile),
                const Divider(),
              ],
              if (vm.regulars.isNotEmpty) ...[
                _buildSectionTitle('Regulares'),
                ...vm.regulars.map(_buildTile),
                const Divider(),
              ],
              if (vm.guests.isNotEmpty) ...[
                _buildSectionTitle('Convidados'),
                ...vm.guests.map(_buildTile),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildError(String msg) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(msg),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => widget.presenter.loadUsersCommand.execute(),
            child: const Text('Recarregar'),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) => Padding(
        padding: const EdgeInsets.all(8),
        child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      );

  Widget _buildTile(UserModel user) => ListTile(
        leading: user.avatarUrl != null
            ? CircleAvatar(backgroundImage: NetworkImage(user.avatarUrl!))
            : const CircleAvatar(child: Icon(Icons.person)),
        title: Text(user.displayName),
        subtitle: Text(user.emailMasked),
      );
}
