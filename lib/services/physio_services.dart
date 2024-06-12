import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:football_zone/models/player.dart';

class PhysioService {
  static const String baseUrl = 'http://192.168.56.1:8090/apiPhysio';
  
  Future<List<PlayerModel>> getPlayersInjured(int teamId, String token) async {
    final String apiUrl = '$baseUrl/getPlayersInjured?id=$teamId';
    print(apiUrl);
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

 Future<void> setMedicalPart(int idPhysioMP, int idTeamMP, int idPlayer, String description, String recoverymethod, String token) async {
  final url = Uri.parse('$baseUrl/setMedicalPart');
  final response = await http.post(
    url,
    headers: {
      'Authorization': 'Bearer $token',
    },
    body: {
      'idPhysioMP': idPhysioMP.toString(),
      'idTeamMP': idTeamMP.toString(), // Corregir el nombre del parámetro idTeam
      'idPlayer': idPlayer.toString(),
      'description': description,
      'recoverymethod': recoverymethod, // Agregar el parámetro recoverymethod
    },
  );

  if (response.statusCode == 200) {
    print('MedicalPart set successfully');
  } else {
    throw Exception('Failed to set medical part: ${response.body}');
  }
}

}