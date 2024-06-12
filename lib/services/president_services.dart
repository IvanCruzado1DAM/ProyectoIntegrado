import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:football_zone/models/player.dart';

class PresidentService {
  static const String baseUrl = 'https://proyectointegradoapi.onrender.com/apiPresident';
  
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
                transferStatus: item['transfer_status'] ?? ''
              ))
          .toList();
      return players;
    } else {
      throw Exception('Failed to load players');
    }
  }

  Future<void> setTransferible(int idPresident, int idPlayer, String token) async {
    final url = Uri.parse('$baseUrl/setTransferible');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
      body: {
        'idPresident': idPresident.toString(),
        'idPlayer': idPlayer.toString(),
      },
    );

    if (response.statusCode == 200) {
      print('Diet set successfully');
    } else {
      throw Exception('Failed to set diet: ${response.body}');
    }
  }
}