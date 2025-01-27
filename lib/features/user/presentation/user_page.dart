import 'package:flutter/material.dart';
import 'package:flutter_clean_arch_template/features/user/presentation/bloc/user_state.dart';
import 'package:flutter_clean_arch_template/features/user/presentation/user_viewmodel.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key, required this.viewModel});

  final UserViewModel viewModel;

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Usuários')),
      body: StreamBuilder<UserState>(
        stream: widget.viewModel.userStateStream,
        builder: (context, snapshot) {
          final state = snapshot.data;

          if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserLoaded) {
            return ListView.builder(
              itemCount: state.users.length,
              itemBuilder: (context, index) {
                final user = state.users[index];
                return ListTile(
                  title: Text(user.name),
                  subtitle: Text(user.email),
                );
              },
            );
          } else if (state is UserError) {
            return Center(child: Text(state.message));
          }

          return const Center(child: Text('Nenhum dado disponível'));
        },
      ),
    );
  }
}
