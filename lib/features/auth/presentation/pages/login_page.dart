import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_arch_template/core/config/l10n/app_translations.dart';
import 'package:flutter_clean_arch_template/core/config/l10n/localization_service.dart';
import 'package:flutter_clean_arch_template/core/di/service_locator.dart';

import 'package:flutter_clean_arch_template/features/auth/presentation/widgets/form_login_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final localizationService = ServiceLocator.get<LocalizationService>();

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
                    children: [
                      const Spacer(),
                      //Logo
                      FlutterLogo(
                        size: MediaQuery.sizeOf(context).width * .4,
                      ),
                      //welcome
                      Text(
                        localizationService.getString(AppTranslations.welcome),
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      //form
                      SignInForm(),
                      //forgetPassword
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          localizationService
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
                            text: localizationService
                                .getString(AppTranslations.dontHaveAccount),
                            children: <TextSpan>[
                              TextSpan(
                                text:
                                    ' ${localizationService.getString(AppTranslations.createNewAccount)}',
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
