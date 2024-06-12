import 'package:flutter/material.dart';
import 'package:football_zone/models/users.dart';
class MarketScreen extends StatelessWidget {
  final UserData user;

  const MarketScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: const Text('Market Screen')),
    );
  }
}
