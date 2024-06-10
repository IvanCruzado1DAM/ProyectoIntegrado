import 'package:flutter/material.dart';
import 'package:football_zone/services/dietist_services.dart';
import 'package:football_zone/models/player.dart';
import 'package:football_zone/models/users.dart';

class DietistScreen extends StatefulWidget {
  final UserData user;

  const DietistScreen({Key? key, required this.user}) : super(key: key);

  @override
  _DietistScreenState createState() => _DietistScreenState();
}

class _DietistScreenState extends State<DietistScreen> {
  final DietistService _dietistService = DietistService();
  late Future<List<PlayerModel>> _playersFuture;

  @override
  void initState() {
    super.initState();
    print("Token: ${widget.user.token}, Team ID: ${widget.user.idTeamUser}");
    _playersFuture = _fetchPlayers();
  }

  Future<List<PlayerModel>> _fetchPlayers() async {
    final List<PlayerModel> players = await _dietistService.getPlayersByTeam(widget.user.idTeamUser!, widget.user.token!);
    return players;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dietist Screen')),
      body: Center(
        child: FutureBuilder<List<PlayerModel>>(
          future: _playersFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final List<PlayerModel> players = snapshot.data!;
              return ListView.builder(
                itemCount: players.length,
                itemBuilder: (context, index) {
                  final PlayerModel player = players[index];
                  return GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          String dietText = '';
                          return AlertDialog(
                            title: Text('Establecer Dieta'),
                            content: TextField(
                              onChanged: (value) {
                                dietText = value;
                              },
                              decoration: InputDecoration(hintText: 'Introduce la dieta'),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // Cerrar el AlertDialog
                                },
                                child: Text('Cancelar'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  _setDiet(player.idPlayer, dietText);
                                  print('Player ID:'+player.idPlayer.toString());
                                  Navigator.of(context).pop(); // Cerrar el AlertDialog
                                },
                                child: Text('Establecer Dieta'),
                              ),
                            ],
                          );
                        },
                      );
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
                            SizedBox(height: 4), // Espacio entre el título y la posición
                            Text(
                              "Position: ${player.position}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4), // Espacio entre la posición y el dorsal
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
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue,
        child: Container(
          height: 50,
          alignment: Alignment.center,
          child: const Text(
            'DIET',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  void _setDiet(int? playerId, String dietText) async {
    try {
      await _dietistService.setDiet(widget.user.idUser!, playerId!, dietText, widget.user.token!);
        print('UserID: ${widget.user.idUser}');
    print('PlayerID: $playerId');
    print('Diet Text: $dietText');
    print('Token: ${widget.user.token}');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Dieta establecida correctamente'),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error al establecer la dieta: $e'),
      ));
    }
  }
}
