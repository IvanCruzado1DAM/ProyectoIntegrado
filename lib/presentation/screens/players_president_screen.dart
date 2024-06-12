import 'package:flutter/material.dart';
import 'package:football_zone/models/users.dart';
import 'package:football_zone/services/president_services.dart'; // Importar el servicio
import 'package:football_zone/models/player.dart'; // Importar el modelo de jugador

class PlayersScreen extends StatefulWidget {
  final UserData user;

  const PlayersScreen({Key? key, required this.user}) : super(key: key);

  @override
  _PlayersScreenState createState() => _PlayersScreenState();
}

class _PlayersScreenState extends State<PlayersScreen> {
  late Future<List<PlayerModel>> _playersFuture;

  @override
  void initState() {
    super.initState();
    _loadPlayers();
  }

  Future<void> _loadPlayers() async {
    final presidentService = PresidentService();
    // Llamar al método getPlayersByTeam del servicio con la ID del equipo del usuario
    _playersFuture = presidentService.getPlayersByTeam(widget.user.idTeamUser!, widget.user.token!);
  }

  BoxDecoration _getPlayerBoxDecoration(String position) {
    Color backgroundColor;
    String imagePath;
    
    switch (position) {
      case 'Portero':
        backgroundColor = Colors.blue.withOpacity(0.6);
        imagePath = 'assets/images/portero.png';
        break;
      case 'Defensa':
        backgroundColor = Colors.green.withOpacity(0.6);
        imagePath = 'assets/images/defensa.png';
        break;
      case 'Centrocampista':
        backgroundColor = Colors.yellow.withOpacity(0.6);
        imagePath = 'assets/images/centrocampista.png';
        break;
      case 'Delantero':
        backgroundColor = Colors.red.withOpacity(0.6);
        imagePath = 'assets/images/delantero.png';
        break;
      default:
        backgroundColor = Colors.grey.withOpacity(0.6);
        imagePath = 'assets/images/default.png';
        break;
    }
    
    return BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: backgroundColor, width: 2), // Mismo color que el fondo
    );
  }

  Future<void> _setTransferible(int idPresident, int idPlayer, String token) async {
    final presidentService = PresidentService();
    try {
      await presidentService.setTransferible(idPresident, idPlayer, token);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('This player is now Transferable!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to make player transferable: $e')),
      );
    }
  }

  void _showTransferStatusDialog(BuildContext context, PlayerModel player) {
    if (player.transferStatus == "Transferible") {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Player Status'),
            content: Text('This player is already transferable'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Transfer Player'),
            content: Text('Do you want to make this player transferable?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await _setTransferible(widget.user.idUser!, player.idPlayer!, widget.user.token!);
                },
                child: Text('Accept'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PlayerModel>>(
      future: _playersFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          // Mostrar la lista de jugadores
          final players = snapshot.data!;
          return ListView.builder(
            itemCount: players.length,
            itemBuilder: (context, index) {
              final player = players[index];
              return GestureDetector(
                onTap: () {
                  _showTransferStatusDialog(context, player);
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  padding: EdgeInsets.all(8),
                  decoration: _getPlayerBoxDecoration(player.position),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('assets/images/${player.position.toLowerCase()}.png'),
                    ),
                    title: Text(
                      player.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 4), 
                        Text(
                          "Position: ${player.position}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4), 
                        Text(
                          "Dorsal: ${player.dorsal}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
