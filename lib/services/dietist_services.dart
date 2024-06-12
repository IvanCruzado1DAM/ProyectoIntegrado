import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:football_zone/models/player.dart';

class DietistService {
  static const String baseUrl = 'http://192.168.56.1:8090/apiDietist';
  
  Future<List<PlayerModel>> getPlayersByTeam(int teamId, String token) async {
    final String apiUrl = '$baseUrl/getPlayersbyTeam?id=$teamId';

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $token', // Incluir el token en los encabezados
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

  Future<void> setDiet(int idDietist, int idPlayer, String diet, String token) async {
    final url = Uri.parse('$baseUrl/setDiet');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
      body: {
        'idDietist': idDietist.toString(),
        'idPlayer': idPlayer.toString(),
        'diet': diet,
      },
    );

    if (response.statusCode == 200) {
      print('Diet set successfully');
    } else {
      throw Exception('Failed to set diet: ${response.body}');
    }
  }
}