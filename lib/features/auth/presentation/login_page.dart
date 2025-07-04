import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_arch_template/core/config/l10n/app_translations.dart';
import 'package:flutter_clean_arch_template/core/config/l10n/localization_service.dart';

import 'package:flutter_clean_arch_template/features/auth/presentation/login_form_widget.dart';
import 'package:flutter_clean_arch_template/features/auth/presentation/login_presenter.dart';

class LoginPage extends StatefulWidget {
  final LoginPresenter presenter;
  final LocalizationService localizationService;
  const LoginPage(
      {super.key, required this.presenter, required this.localizationService});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      //Logo
                      FlutterLogo(
                        size: MediaQuery.sizeOf(context).width * .4,
                      ),
                      //welcome
                      Text(
                        key: Key('welcome_text'),
                        widget.localizationService
                            .getString(AppTranslations.welcome),
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      //form
                      SignInForm(
                        presenter: widget.presenter,
                        localizationService: widget.localizationService,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      //forgetPassword
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          widget.localizationService
                              .getString(AppTranslations.forgetPassword),
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
                            text: widget.localizationService
                                .getString(AppTranslations.dontHaveAccount),
                            children: <TextSpan>[
                              TextSpan(
                                text:
                                    ' ${widget.localizationService.getString(AppTranslations.createNewAccount)}',
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
