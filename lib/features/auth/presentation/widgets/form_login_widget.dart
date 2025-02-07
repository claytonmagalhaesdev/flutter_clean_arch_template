import 'package:flutter/material.dart';
import 'package:flutter_clean_arch_template/core/config/l10n/app_locale.dart';
import 'package:flutter_localization/flutter_localization.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        spacing: 16.0,
        children: [
          TextFormField(
            onSaved: (value) {},
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: AppLocale.emailAddress.getString(context),
            ),
          ),

          // Password Field
          TextFormField(
            obscureText: _obscureText,
            onSaved: (value) {},
            decoration: InputDecoration(
              hintText: AppLocale.password.getString(context),
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

          // Sign In Button
          SizedBox(
            width: MediaQuery.sizeOf(context).width,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  //go to home page
                }
              },
              child: Text(
                AppLocale.signIn.getString(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
