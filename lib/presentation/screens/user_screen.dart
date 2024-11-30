import 'package:flutter/material.dart';
import 'package:BarDamm/services/user_services.dart';
import 'menu_screen.dart';
import 'package:BarDamm/presentation/screens/events_screen.dart';
import 'package:BarDamm/presentation/screens/cv_screen.dart';
import 'package:BarDamm/presentation/screens/reserve_screen.dart';

class UserScreen extends StatefulWidget {
  final String token;
  final int idUser;
  final String username;

  const UserScreen({Key? key, required this.token, required this.idUser, required this.username}) : super(key: key);

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  void _onCardTapped(int index) {
    final UserService _userService = UserService();
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ReserveScreen(token: widget.token, idUser: widget.idUser, username:widget.username ),
        ),
      );
    }
    else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MenuScreen(token: widget.token, idUser: widget.idUser, username:widget.username ),
        ),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => EventsScreen(token: widget.token , idUser: widget.idUser, username:widget.username),
        ),
      );
    }else{
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CvScreen(token: widget.token, userId: widget.idUser, username:widget.username),
        ),
      );
    }
    
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: 4, 
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, 
            crossAxisSpacing: 16, 
            mainAxisSpacing: 16, 
            childAspectRatio: (MediaQuery.of(context).size.width / 1.95) /
                (screenHeight / 2.1), 
          ),
          itemBuilder: (context, index) {
            return _buildNavigationCard(
              index == 0
                  ? Icons.book_online
                  : index == 1
                      ? Icons.local_bar_rounded
                      : index == 2
                          ? Icons.event
                          : Icons.people_outline,
              index == 0
                  ? 'Reserve'
                  : index == 1
                      ? 'Menu'
                      : index == 2
                          ? 'Soon Events'
                          : 'Work For Us!',
              index,
            );
          },
        ),
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
        child: SizedBox(
          width: double.infinity,
          height: double
              .infinity, 
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
      ),
    );
  }
}

class UserReserveScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Reserves Screen'),
    );
  }
}

class UserMenuScreen extends StatelessWidget {
  final String token;
  final int idUser;
  final String username;
  const UserMenuScreen({Key? key, required this.token,  required this.idUser, required this.username }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MenuScreen(token: token, idUser: idUser, username: username,)),
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Menu Screen'),
      ),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class UserEventsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Soon Events Screen'),
    );
  }
}

class UserBecomeWaiterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Become Waiter Screen'),
    );
  }

  
}
