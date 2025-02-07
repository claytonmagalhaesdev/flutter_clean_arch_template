import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

class SwitchLanguageWidget extends StatefulWidget {
  const SwitchLanguageWidget({super.key});

  @override
  State<SwitchLanguageWidget> createState() => _SwitchLanguageWidgetState();
}

class _SwitchLanguageWidgetState extends State<SwitchLanguageWidget> {
  @override
  Widget build(BuildContext context) {
    final FlutterLocalization localization = FlutterLocalization.instance;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () {
            localization.translate('en');
            setState(() {});
          },
          child: const Text('EN'),
        ),
        const SizedBox(width: 16),
        GestureDetector(
          onTap: () {
            localization.translate('pt');
            setState(() {});
          },
          child: const Text('BR'),
        ),
        const SizedBox(width: 16),
        GestureDetector(
          onTap: () {
            localization.translate('ja');
            setState(() {});
          },
          child: const Text('JA'),
        ),
      ],
    );
  }
}
