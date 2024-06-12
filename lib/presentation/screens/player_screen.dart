import 'package:flutter/material.dart';
import 'package:football_zone/models/users.dart';
import 'package:football_zone/models/player.dart';
import 'package:football_zone/services/player_services.dart';

class PlayerScreen extends StatefulWidget {
  final UserData user;

  const PlayerScreen({Key? key, required this.user}) : super(key: key);

  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  int _selectedIndex = 0;

  late List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      Center(child: Text('Training Exercises')),
      ProfilePage(playerId: widget.user.idUser!, token: widget.user.token!),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Player Screen')),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Training exercises',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}

class ProfilePage extends StatefulWidget {
  final int playerId;
  final String token;

  const ProfilePage({Key? key, required this.playerId, required this.token}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<PlayerModel> futurePlayer;
  final PlayerService playerService = PlayerService();

  @override
  void initState() {
    super.initState();
    futurePlayer = playerService.fetchPlayerInfo(widget.playerId, widget.token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  body: SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FutureBuilder<PlayerModel>(
          future: futurePlayer,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final player = snapshot.data!;
              Color backgroundColor;
              String imagePath;
              switch (player.position) {
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
              return Container(
                padding: EdgeInsets.all(16.0),
                margin: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Column(
                        children: [
                          CircleAvatar(
                            backgroundImage: AssetImage(imagePath),
                            backgroundColor: backgroundColor,
                            radius: 50,
                          ),
                          SizedBox(height: 10),
                          Text(
                            player.name,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    _buildInfoRow('Position', player.position),
                    _buildInfoRow('Dorsal', player.dorsal.toString()),
                    _buildInfoRow('Age', player.age?.toString() ?? 'N/A'),
                    _buildInfoRow('Nationality', player.nationality ?? 'N/A'),
                    _buildInfoRow(player.position == 'Portero' ? 'Goals Conceded' : 'Goals', player.goals?.toString() ?? 'N/A'),
                    _buildInfoRow(player.position == 'Portero' ? 'Unbeaten Matches' : 'Assists', player.assists?.toString() ?? 'N/A'),
                    _buildInfoRow('Yellow Cards', player.yc?.toString() ?? 'N/A'),
                    _buildInfoRow('Red Cards', player.rc?.toString() ?? 'N/A'),
                    _buildInfoRow('Contract', player.contract?.toString() ?? 'N/A'),
                    _buildInfoRow('Football Aspects', player.footballAspects ?? 'N/A'),
                    _buildInfoRow('Diet', player.diet ?? 'No diet'),
                  ],
                ),
              );
            } else {
              return Center(child: Text('No player data found'));
            }
          },
        ),
        SizedBox(height: 20),
        Center(
          child: ElevatedButton(
            onPressed: () {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Enter the year for renovation:'),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Year',
                  ),
                  onChanged: (value) {
                    // Puedes validar el valor del año aquí si es necesario
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Aquí puedes obtener el valor del año ingresado y realizar la validación
                // Por ejemplo, puedes verificar si el año ingresado es mayor o igual al año de contrato del jugador
                // Si la validación pasa, puedes realizar la acción de renovación
                // Si no pasa, puedes mostrar un mensaje de error o simplemente no hacer nada
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  },
  child: Text('Request Renovation'),
  style: ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
  ),
            
          ),
        ),
        SizedBox(height: 20),
      ],
    ),
  ),
);

  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: <Widget>[
          Text(
            '$label: ',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
