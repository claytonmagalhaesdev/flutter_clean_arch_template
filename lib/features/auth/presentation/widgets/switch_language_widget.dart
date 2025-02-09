import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_arch_template/core/common/presentation/bloc/language_bloc.dart';
import 'package:flutter_clean_arch_template/core/common/presentation/bloc/language_state.dart';

class SwitchLanguageWidget extends StatefulWidget {
  const SwitchLanguageWidget({super.key});

  @override
  State<SwitchLanguageWidget> createState() => _SwitchLanguageWidgetState();
}

class _SwitchLanguageWidgetState extends State<SwitchLanguageWidget> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LanguageState>(
      stream: context.watch<LanguageBloc>().stream,
      builder: (context, snapshot) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
              onTap: () {
                context.read<LanguageBloc>().changeLanguage('en');
              },
              child: const Text('EN'),
            ),
            const SizedBox(width: 16),
            InkWell(
              onTap: () {
                context.read<LanguageBloc>().changeLanguage('pt');
              },
              child: const Text('BR'),
            ),
            const SizedBox(width: 16),
            InkWell(
              onTap: () {
                context.read<LanguageBloc>().changeLanguage('ja');
              },
              child: const Text('JA'),
            ),
          ],
        );
      },
    );
  }
}
