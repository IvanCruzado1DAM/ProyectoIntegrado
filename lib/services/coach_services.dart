import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:football_zone/models/player.dart';
import 'package:football_zone/models/game.dart';

class CoachService {
  static const String baseUrl = 'https://proyectointegradoapi.onrender.com/apiCoach';
  
  Future<List<PlayerModel>> getPlayersByTeam(int teamId, String token) async {
    final String apiUrl = '$baseUrl/getPlayersbyTeam?id=$teamId';

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $token', 
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<PlayerModel> players = body
          .map((dynamic item) => PlayerModel(
                idPlayer: item['id_player'],  
                name: item['name'],
                position: item['position'],
                dorsal: item['dorsal'],
              ))
          .toList();
      return players;
    } else {
      throw Exception('Failed to load players');
    }
  }



  Future<List<GameModel>> getGamesbyTeam(int teamId, String token) async {
    final String apiUrl = '$baseUrl/getGamesbyTeam?id=$teamId';

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $token', // Incluir el token en los encabezados
      }, 
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<GameModel> games = body
          .map((dynamic item) => GameModel(
                idGame: item['id_game'] ?? 0,
                idLocalTeam: item['idLocalTeam'] ?? 0,
                idVisitantTeam: item['idVisitantTeam'] ?? 0,
                numberGame: item['numberGame'] ?? 0,
                date: item['date'] != null ? DateTime.parse(item['date']) : DateTime.now(),
                tickets: item['tickets'] ?? 0,
                score: item['score'] ?? 'Por jugar',
              ))
          .toList();
      return games;
    } else {
      throw Exception('Failed to load games');
    }
  }

  Future<void> setValorationGame(int idmatchvm, int idplayervm, int defensiverating, int tacticalrating, int offensiverating,int finalscore, String token) async {
    final String apiUrl = '$baseUrl/setValorationGame?idmatchvm=$idmatchvm&idplayervm=$idplayervm&defensiverating=$defensiverating&tacticalrating=$tacticalrating&offensiverating=$offensiverating&finalscore=$finalscore';

    final Map<String, dynamic> data = {
    'idmatchvm': idmatchvm,
    'idplayervm': idplayervm,
    'defensiverating': defensiverating,
    'tacticalrating': tacticalrating,
    'offensiverating': offensiverating,
    'finalscore': finalscore,
  };

  final Uri uri = Uri.parse(apiUrl);
  
  try {
    final response = await http.post(
      uri,
      body: data,
    );

    if (response.statusCode == 200) {
      print('Valoration game set successfully');
    } else {
      print('Failed to set valoration game. Error: ${response.statusCode}');
    }
  } catch (e) {
    print('Error sending request: $e');
  }
  
  }
}