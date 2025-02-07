import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_arch_template/core/config/l10n/app_locale.dart';
import 'package:flutter_clean_arch_template/features/auth/presentation/widgets/form_login_widget.dart';
import 'package:flutter_clean_arch_template/features/auth/presentation/widgets/switch_language_widget.dart';
import 'package:flutter_localization/flutter_localization.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //localization.translate('en'); to change language on tap
  final FlutterLocalization localization = FlutterLocalization.instance;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    spacing: 16.0,
                    children: [
                      const Spacer(),
                      //Logo
                      FlutterLogo(
                        size: MediaQuery.sizeOf(context).width * .4,
                      ),
                      //welcome
                      Text(
                        AppLocale.welcome.getString(context),
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      //form
                      const SignInForm(),
                      //forgetPassword
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          AppLocale.forgetPassword.getString(context),
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blueAccent),
                        ),
                      ),
                      //create account
                      Center(
                        child: Text.rich(
                          TextSpan(
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(fontWeight: FontWeight.w600),
                            text: AppLocale.dontHaveAccount.getString(context),
                            children: <TextSpan>[
                              TextSpan(
                                text:
                                    ' ${AppLocale.createNewAccount.getString(context)}',
                                style:
                                    const TextStyle(color: Colors.blueAccent),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    // Navigate to Sign Up Screen
                                  },
                              )
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      //change language
                      SwitchLanguageWidget(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
