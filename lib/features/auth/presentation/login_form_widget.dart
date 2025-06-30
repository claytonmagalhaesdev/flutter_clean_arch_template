import 'package:flutter/material.dart';
import 'package:flutter_clean_arch_template/core/config/l10n/app_translations.dart';
import 'package:flutter_clean_arch_template/core/config/l10n/localization_service.dart';
import 'package:flutter_clean_arch_template/core/di/service_locator.dart';
import 'package:flutter_clean_arch_template/features/auth/presentation/login_presenter.dart';
import 'package:flutter_clean_arch_template/features/auth/presentation/login_state.dart';

class SignInForm extends StatefulWidget {
  final LoginPresenter presenter;

  const SignInForm({super.key, required this.presenter});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final localizationService = ServiceLocator.get<LocalizationService>();
  final _formKey = GlobalKey<FormState>();

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            onSaved: (value) {},
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText:
                  localizationService.getString(AppTranslations.emailAddress),
            ),
          ),

          // Password Field
          TextFormField(
            obscureText: _obscureText,
            onSaved: (value) {},
            decoration: InputDecoration(
              hintText: localizationService.getString(AppTranslations.password),
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                child: _obscureText
                    ? const Icon(Icons.visibility_off, color: Color(0xFF868686))
                    : const Icon(Icons.visibility, color: Color(0xFF868686)),
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          StreamBuilder<LoginState>(
            stream: widget.presenter.stateStream,
            builder: (context, snapshot) {
              final state = snapshot.data ?? const LoginInitial();

              if (state is LoginLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              return SizedBox(
                width: MediaQuery.sizeOf(context).width,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      widget.presenter.loginCommand.execute();
                    }
                  },
                  child: Text(
                    localizationService.getString(AppTranslations.signIn),
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
