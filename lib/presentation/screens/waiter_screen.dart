import 'package:flutter/material.dart';

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
          builder: (context) => TablesScreen(
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
                    Icons.receipt_long,
                    'Orders',
                    1,
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

// Pantallas de ejemplo para Tables y Orders
class TablesScreen extends StatelessWidget {
  final String token;
  final int userId;

  const TablesScreen({
    Key? key,
    required this.token,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tables'),
      ),
      body: const Center(
        child: Text(
          'Tables Screen',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class OrdersScreen extends StatelessWidget {
  final String token;
  final int userId;

  const OrdersScreen({
    Key? key,
    required this.token,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
      ),
      body: const Center(
        child: Text(
          'Orders Screen',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
