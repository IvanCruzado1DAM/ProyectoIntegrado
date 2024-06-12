import 'package:flutter/material.dart';
import 'market_president_screen.dart';
import 'players_president_screen.dart';
import 'financialactions_president_screen.dart';
import 'package:football_zone/models/users.dart';

class PresidentScreen extends StatefulWidget {
  final UserData user;

  const PresidentScreen({Key? key, required this.user}) : super(key: key);

  @override
  _PresidentScreenState createState() => _PresidentScreenState();
}

class _PresidentScreenState extends State<PresidentScreen> {
  int _selectedIndex = 0;
  

  static List<Widget> _widgetOptions = <Widget>[
    MarketScreen(),
    PlayersScreen(),
    FinancialActionsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('President Screen')),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: 'Market',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Players',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance),
            label: 'Financial Actions',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}