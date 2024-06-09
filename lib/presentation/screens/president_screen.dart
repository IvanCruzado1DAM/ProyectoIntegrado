import 'package:flutter/material.dart';

class PresidentScreen extends StatelessWidget {
  const PresidentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('President Screen')),
      body: Center(child: const Text('President Screen')),
    );
  }
}
