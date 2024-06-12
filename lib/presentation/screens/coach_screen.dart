import 'package:flutter/material.dart';
import 'package:football_zone/models/users.dart';
import 'package:football_zone/models/game.dart'; 
import 'package:football_zone/models/player.dart'; 
import 'package:football_zone/services/coach_services.dart';

class CoachScreen extends StatelessWidget {
  final UserData user;

  const CoachScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Coach Screen'),
        ),
        body: TabBarView(
          children: [
            TrainingPage(),
            //GamesPage(teamId: user.idTeamUser!, token: user.token!),
            PlayersPage(teamId: user.idTeamUser!, token: user.token!),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.blue,
          child: TabBar(
            tabs: [
              Tab(text: 'Training'),
              Tab(text: 'Games'),
              Tab(text: 'Players'),
            ],
            indicatorColor: Colors.white, // Opcional: cambia el color del indicador de pestañas
          ),
        ),
      ),
    );
  }
}

class TrainingPage extends StatelessWidget {
  const TrainingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Training Page'));
  }
}

/*class GamesPage extends StatefulWidget {
  final int teamId;
  final String token;

  const GamesPage({Key? key, required this.teamId, required this.token}) : super(key: key);

  @override
  _GamesPageState createState() => _GamesPageState();
}

class _GamesPageState extends State<GamesPage> {
  late Future<List<GameModel>> _gamesFuture;
  int? _selectedGameId; 
   final CoachService _coachService = CoachService();
   @override
    void initState() {
    super.initState();
    //_selectedGameId = widget.selectedGameId; 
    _gamesFuture = _fetchGames(); 
  }

  Future<List<GameModel>> _fetchGames() async {
    final List<GameModel> games = await _coachService.getGamesbyTeam(widget.teamId, widget.token);
    return games;
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<GameModel>>(
      future: _gamesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData && snapshot.data!.isEmpty) {
          return Center(child: Text('No games available'));
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final game = snapshot.data![index];
              return Card(
                color: Colors.blue[50],
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: ListTile(
                  title: Text(
                    'Game ${game.idGame}',
                    textAlign: TextAlign.center,
                  ),
                  subtitle: Column(
                    children: [
                      Text(
                        'Date: ${game.date}',
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Score: ${game.score}',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      _selectedGameId = game.idGame; // Guardar el ID del juego seleccionado
                    });
                    if (!game.score.toString().contains('Por jugar')) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlayersByGamePage(
                            teamId: widget.teamId,
                            token: widget.token,
                            selectedGameId: _selectedGameId, // Pasar _selectedGameId a PlayersByGamePage
                          ),
                        ),
                      );
                    } else {
                      // Lógica para manejar el tap en el juego sin score
                    }
                  },
                ),
              );
            },
          );
        }
      },
    );
  }
}


class PlayersByGamePage extends StatefulWidget {
  final int teamId;
  final String token;
  final int? selectedGameId; // Agregar _selectedGameId
  const PlayersByGamePage({Key? key, required this.teamId, required this.token, this.selectedGameId}) : super(key: key);


  @override
  _PlayersByGamePageState createState() => _PlayersByGamePageState();
}

class _PlayersByGamePageState extends State<PlayersByGamePage> {
  late Future<List<PlayerModel>> _playersFuture;
  final CoachService _coachService = CoachService();
  

  @override
  void initState() {
    super.initState();
    _playersFuture = _fetchPlayers();
  }

  Future<List<PlayerModel>> _fetchPlayers() async {
    final List<PlayerModel> players =
        await _coachService.getPlayersByTeam(widget.teamId, widget.token);
    return players;
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
        } else if (snapshot.hasData && snapshot.data!.isEmpty) {
          return Center(child: Text('No players available'));
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text('Players for Team ${widget.teamId}'),
            ),
            body: ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final player = snapshot.data![index];
                return GestureDetector(
                  onTap: () {
                    // Lógica para manejar el tap en el jugador
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.withOpacity(0.6), width: 2),
                    ),
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
            ),
          );
        }
      },
    );
  }
}
*/

class PlayersPage extends StatefulWidget {
  final int teamId;
  final String token;
  final int? selectedGameId; // Agregar selectedGameId

  const PlayersPage({Key? key, required this.teamId, required this.token, this.selectedGameId}) : super(key: key);

  @override
  _PlayersPageState createState() => _PlayersPageState();
}



class _PlayersPageState extends State<PlayersPage> {
  late Future<List<PlayerModel>> _playersFuture;
  final CoachService _coachService = CoachService();
  int? _selectedGameId; 

  @override
  void initState() {
    super.initState();
    _selectedGameId = widget.selectedGameId;
    _playersFuture = _fetchPlayers();
  }

  Future<List<PlayerModel>> _fetchPlayers() async {
    final List<PlayerModel> players = await _coachService.getPlayersByTeam(widget.teamId, widget.token);
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
    return FutureBuilder<List<PlayerModel>>(
      future: _playersFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData && snapshot.data!.isEmpty) {
          return Center(child: Text('No players available'));
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length + 1, // +1 para el título "List of Players"
            itemBuilder: (context, index) {
              if (index == 0) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      'List of Players',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                );
              }
              final playerIndex = index - 1; // Restar 1 para ajustar el índice de los jugadores
              final player = snapshot.data![playerIndex];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlayerRatingPage(
                          gameId: _selectedGameId!, // Pasar el ID del juego seleccionado
                          playerId: player.idPlayer!,
                          token: widget.token,
                        ),
                      ),
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
    );
  }
}
  class PlayerRatingPage extends StatefulWidget {
  final int gameId;
  final int playerId;
  final String token;

  const PlayerRatingPage({Key? key, required this.gameId, required this.playerId, required this.token}) : super(key: key);

  @override
  _PlayerRatingPageState createState() => _PlayerRatingPageState();
}

class _PlayerRatingPageState extends State<PlayerRatingPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _defensiveController;
  late TextEditingController _tacticalController;
  late TextEditingController _offensiveController;
  final CoachService _coachService = CoachService();
  @override
  void initState() {
    super.initState();
    _defensiveController = TextEditingController();
    _tacticalController = TextEditingController();
    _offensiveController = TextEditingController();
  }

  @override
  void dispose() {
    _defensiveController.dispose();
    _tacticalController.dispose();
    _offensiveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Player Rating'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _defensiveController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Defensive Rating (1-5)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a value';
                  }
                  final rating = int.tryParse(value);
                  if (rating == null || rating < 1 || rating > 5) {
                    return 'Please enter a number between 1 and 5';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _tacticalController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Tactical Rating (1-5)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a value';
                  }
                  final rating = int.tryParse(value);
                  if (rating == null || rating < 1 || rating > 5) {
                    return 'Please enter a number between 1 and 5';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _offensiveController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Offensive Rating (1-5)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a value';
                  }
                  final rating = int.tryParse(value);
                  if (rating == null || rating < 1 || rating > 5) {
                    return 'Please enter a number between 1 and 5';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final defensiveRating = int.parse(_defensiveController.text);
                    final tacticalRating = int.parse(_tacticalController.text);
                    final offensiveRating = int.parse(_offensiveController.text);
                    final averageRating = ((defensiveRating + tacticalRating + offensiveRating) / 3).toInt();

                    _coachService.setValorationGame(
                      widget.gameId!,
                      widget.playerId,
                       defensiveRating,
                      tacticalRating,
                     offensiveRating,
                      averageRating,
                      widget.token,
                    );
                  }
                },
                child: Text('Set Valoration'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  
}

