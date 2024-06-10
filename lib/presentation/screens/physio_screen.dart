import 'package:flutter/material.dart';
import 'package:football_zone/models/player.dart';
import 'package:football_zone/services/physio_services.dart';
import 'package:football_zone/models/users.dart';

class PhysioScreen extends StatefulWidget {
  final UserData user;

  const PhysioScreen({Key? key, required this.user}) : super(key: key);

  @override
  _PhysioScreenState createState() => _PhysioScreenState();
}

class _PhysioScreenState extends State<PhysioScreen> {
  final PhysioService _physioService = PhysioService();
  late Future<List<PlayerModel>> _playersFuture;

  @override
  void initState() {
    super.initState();
    _playersFuture = _fetchPlayersInjured();
  }

  Future<List<PlayerModel>> _fetchPlayersInjured() async {
    try {
      final List<PlayerModel> injuredPlayers =
          await _physioService.getPlayersInjured(widget.user.idTeamUser!, widget.user.token!);
      return injuredPlayers;
    } catch (e) {
      print('Error fetching injured players: $e');
      throw e;
    }
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
      appBar: AppBar(title: const Text('Physio Screen')),
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
              if (players.isEmpty) {
                return Center(
                  child: Text(
                    'NO INJURED PLAYERS!',
                    style: TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                );
              }
              return ListView.builder(
                itemCount: players.length + 1, // +1 para agregar el texto "Injured Players" encima del primer jugador
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: EdgeInsets.only(top: 8, bottom: 4),
                      child: Center(
                        child: Text(
                          'Injured Players',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    );
                  }
                  final PlayerModel player = players[index - 1];
                  return GestureDetector(
                    onTap: () {
                      _openMedicalPartFormScreen(player.idPlayer!);
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
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue,
        child: Container(
          height: 50,
          alignment: Alignment.center,
          child: const Text(
            'MEDICAL PART',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ),
    );
  }

  void _openMedicalPartFormScreen(int playerId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MedicalPartFormScreen(playerId: playerId, user: widget.user),
      ),
    );
  }
}

class MedicalPartFormScreen extends StatefulWidget {
  final int playerId;
  final UserData user; // Agrega UserData como un parámetro

  const MedicalPartFormScreen({Key? key, required this.playerId, required this.user}) : super(key: key);

  @override
  _MedicalPartFormScreenState createState() => _MedicalPartFormScreenState();
}

class _MedicalPartFormScreenState extends State<MedicalPartFormScreen> {
  late TextEditingController _descriptionController;
  late TextEditingController _recoveryMethodController;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController();
    _recoveryMethodController = TextEditingController();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _recoveryMethodController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Medical Part Form')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _recoveryMethodController,
              decoration: InputDecoration(
                labelText: 'Recovery Method',
              ),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                _saveMedicalPart();
              },
              child: Text('Save Medical Part'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveMedicalPart() {
    final description = _descriptionController.text;
    final recoveryMethod = _recoveryMethodController.text;
    final PhysioService _physioService = PhysioService();
    
    // Llamar al método setDiet de physio_services
    _physioService.setMedicalPart(widget.user.idUser!, widget.user.idTeamUser!,widget.playerId, description, recoveryMethod, widget.user.token!)
        .then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Medical part saved successfully'),
        ),
      );
      Navigator.pop(context); // Regresar a la pantalla anterior
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save medical part: $error'),
        ),
      );
    });
  }
}