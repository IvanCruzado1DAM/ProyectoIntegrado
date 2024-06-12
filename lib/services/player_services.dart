import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:football_zone/models/player.dart';
import 'package:football_zone/models/renovationoffer.dart';

class PlayerService{
  static const String baseUrl = 'http://192.168.56.1:8090/apiPlayer';
  Future<PlayerModel> fetchPlayerInfo(int id, String token) async {
    final String apiUrl = '$baseUrl/getInfoPlayer?id=$id';
    final response = await http.get(
      Uri.parse(apiUrl),
       headers: {
        'Authorization': 'Bearer $token', 
      },
    );

    if (response.statusCode == 200) {
      return PlayerModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load player info');
    }
  }

  Future<RenovationofferModel> addRenovationoffer(int idplayerrenovation, int year, String token) async {
    final String apiUrl = '$baseUrl/sendRenovationoffer';
    final response = await http.post(
      Uri.parse(apiUrl),
      body: jsonEncode({
        'idplayerrenovation': idplayerrenovation,
        'year': year,
      }),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', 
      },
    );

    if (response.statusCode == 200) {
      return RenovationofferModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to add renovation offer: ${response.statusCode}');
    }
  }
}