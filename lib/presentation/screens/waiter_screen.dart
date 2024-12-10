import 'package:flutter/material.dart';
import 'orderr_screen.dart';
import 'wanttopay_screen.dart';
import 'table_screen.dart';

class WaiterScreen extends StatelessWidget {
  final String token;
  final int userId;
  final String username;

  const WaiterScreen({
    Key? key,
    required this.token,
    required this.userId,
    required this.username,
  }) : super(key: key);

  void _onCardTapped(BuildContext context, int index) {
    if (index == 0) {
      // Navegar a la pantalla de Tables
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TableScreen(
            token: token,
            userId: userId,
          ),
        ),
      );
    } else if (index == 1) {
      // Navegar a la pantalla de Orders
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WantsToPayScreen(
            token: token,
            userId: userId,
          ),
        ),
      );
    }
    else if (index == 2) {
      // Navegar a la pantalla de Orders
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OrdersScreen(
            token: token,
            userId: userId,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Waiter Screen'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: SizedBox.expand(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: _buildNavigationCard(
                    context,
                    Icons.table_bar,
                    'Tables',
                    0,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: SizedBox.expand(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: _buildNavigationCard(
                    context,
                    Icons.payment,
                    'Wants to Pay',
                    1,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: SizedBox.expand(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: _buildNavigationCard(
                    context,
                    Icons.receipt_long,
                    'Orders',
                    2,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationCard(
      BuildContext context, IconData icon, String label, int index) {
    return GestureDetector(
      onTap: () => _onCardTapped(context, index),
      child: Card(
        elevation: 5,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: Colors.blue.shade700,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 60,
              color: Colors.white,
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}





