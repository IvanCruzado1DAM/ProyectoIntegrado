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
  PageController _pageController = PageController();

  late List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      MarketScreen(user: widget.user),
      PlayersScreen(user: widget.user),
      FinancialActionsScreen(user: widget.user),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('President Screen')),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: _widgetOptions,
      ),
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
        selectedItemColor: Colors.white,
        backgroundColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
