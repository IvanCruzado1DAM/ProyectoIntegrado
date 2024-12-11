import 'package:flutter/material.dart';
import 'orderr_screen.dart';
import 'wanttopay_screen.dart';
import 'table_screen.dart';
import 'package:BarDamm/services/waiter_services.dart'; // Importación del servicio de Waiter

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

  void _onCardTapped(BuildContext context, int index) async {
    if (index == 0) {
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
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WantsToPayScreen(
            token: token,
            userId: userId,
          ),
        ),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OrdersScreen(
            token: token,
            userId: userId,
          ),
        ),
      );
    } else if (index == 3) {
      // Acción para "Set Pool Free"
      final confirm = await _showConfirmationDialog(context);
      if (confirm == true) {
        // Llama al método setPoolFree del servicio
        WaiterService ws = WaiterService();

        try {
          // Llamamos al método setpoolfree con el token
          String message = await ws.setpoolfree(token);

          // Si la respuesta es exitosa, mostramos un mensaje de agradecimiento
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Pool is free succesfully',
                style: TextStyle(fontSize: 16),
              ),
              duration: Duration(seconds: 3),
            ),
          );
        } catch (e) {
          // En caso de error, mostramos un mensaje de error en la parte inferior
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Error: $e',
                style: TextStyle(fontSize: 16),
              ),
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    }
  }

  Future<bool> _showConfirmationDialog(BuildContext context) async {
    return (await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirmation'),
              content:
                  const Text('Do you want to mark the pool table as free?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false); // Cancelar
                  },
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true); // Confirmar
                  },
                  child: const Text('Yes'),
                ),
              ],
            );
          },
        )) ??
        false; // Devuelve false si el usuario cierra el cuadro de diálogo.
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: SizedBox.expand(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: _buildNavigationCardWithImage(
                    context,
                    'assets/images/billar.png',
                    'Set Pool Free',
                    3,
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

  Widget _buildNavigationCardWithImage(
      BuildContext context, String imagePath, String label, int index) {
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
            Image.asset(
              imagePath,
              height: 60,
              fit: BoxFit.contain,
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
