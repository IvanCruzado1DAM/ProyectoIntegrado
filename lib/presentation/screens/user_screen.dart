import 'package:flutter/material.dart';
import 'package:BarDamm/services/user_services.dart';
import 'menu_screen.dart';
import 'package:BarDamm/presentation/screens/events_screen.dart';
import 'package:BarDamm/presentation/screens/cv_screen.dart';
import 'package:BarDamm/presentation/screens/reserve_screen.dart';
import 'package:BarDamm/presentation/screens/opinion_screen.dart'; // Nueva pantalla para "Give Us Your Opinion"

class UserScreen extends StatefulWidget {
  final String token;
  final int idUser;
  final String username;

  const UserScreen(
      {Key? key,
      required this.token,
      required this.idUser,
      required this.username})
      : super(key: key);

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  void _onCardTapped(int index) {
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ReserveScreen(
              token: widget.token,
              idUser: widget.idUser,
              username: widget.username),
        ),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MenuScreen(
              token: widget.token,
              idUser: widget.idUser,
              username: widget.username),
        ),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => EventsScreen(
              token: widget.token,
              idUser: widget.idUser,
              username: widget.username),
        ),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CvScreen(
              token: widget.token,
              userId: widget.idUser,
              username: widget.username),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OpinionScreen(
              token: widget.token,
              idUser: widget.idUser,
              username: widget.username),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Screen'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Expanded(
                  child: _buildNavigationCard(Icons.book_online, 'Reserve', 0),
                ),
                Expanded(
                  child:
                      _buildNavigationCard(Icons.local_bar_rounded, 'Menu', 1),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Expanded(
                  child: _buildNavigationCard(Icons.event, 'Soon Events', 2),
                ),
                Expanded(
                  child: _buildNavigationCard(
                      Icons.people_outline, 'Work For Us!', 3),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _onCardTapped(4),
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      color: Color.fromARGB(255, 21, 135, 228),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.feedback, // Icono para opiniones
                            size: 40,
                            color: Colors.white,
                          ),
                          const SizedBox(
                              height: 10), // Espacio entre el icono y el texto
                          Text(
                            'Give Us Your Opinion',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationCard(IconData icon, String label, int index) {
    return GestureDetector(
      onTap: () => _onCardTapped(index),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Colors.blue.shade700,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: Colors.white,
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}