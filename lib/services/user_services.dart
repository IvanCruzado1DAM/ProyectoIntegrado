// file: lib/services/user_services.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:football_zone/models/users.dart';
import 'package:football_zone/models/team.dart';

class LoginResponse {
  UserData? userData;
  String? error;

  LoginResponse({this.userData, this.error});
}

class LoginResult {
  final UserData? userData;
  final String? error;

  LoginResult({this.userData, this.error});
}


class UserService {
  static const String baseUrl = 'https://proyectointegradoapi.onrender.com/api';

  Future<LoginResult> login(String username, String password) async {
  final url = Uri.parse('$baseUrl/login?username=$username&password=$password');
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
  );

  print('username: $username');
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final userData = UserData.fromJson(data);
    return LoginResult(userData: userData);
  } else {
    return LoginResult(error: 'Credenciales incorrectas');
  }
}



  Future<List<TeamModel>> getTeams() async {
    final response = await http.get(Uri.parse('$baseUrl/getTeams'));

    if (response.statusCode == 200) {
      List<dynamic> responseData = json.decode(response.body);
      List<TeamModel> teams = responseData.map((data) => TeamModel.fromJson(data)).toList();
      return teams;
    } else {
      throw Exception('No se pudieron cargar los equipos: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> register(String username, String password, int idTeam, String name) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'username': username,
          'password': password,
          'id_team_user': idTeam.toString(), // Convertir idTeam a String para que sea compatible con x-www-form-urlencoded
          'name': name,
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body)['error'];
        return {'error': error != null ? error : 'Fallo en el registro'};
      }
    } catch (e) {
      return {'error': e.toString()};
    }
  }
}
