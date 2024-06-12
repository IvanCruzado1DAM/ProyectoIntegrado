import 'package:flutter/material.dart';
import 'package:football_zone/models/users.dart';
class FinancialActionsScreen extends StatelessWidget {
   final UserData user;

  const FinancialActionsScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: const Text('Financial Actions Screen')),
    );
  }
}
