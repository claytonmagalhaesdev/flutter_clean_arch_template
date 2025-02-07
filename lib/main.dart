import 'package:flutter/material.dart';
import 'package:flutter_clean_arch_template/app.dart';
import 'package:flutter_localization/flutter_localization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterLocalization.instance.ensureInitialized();

  runApp(App());
}
