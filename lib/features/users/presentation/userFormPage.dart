import 'package:flutter/material.dart';

class Userformpage extends StatefulWidget {
  const Userformpage({super.key});

  @override
  State<Userformpage> createState() => _UserformpageState();
}

class _UserformpageState extends State<Userformpage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: const InputDecoration(labelText: 'Nome'),
        ),
        TextField(
          decoration: const InputDecoration(labelText: 'Email'),
        ),
        ElevatedButton(
          onPressed: () {},
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}
