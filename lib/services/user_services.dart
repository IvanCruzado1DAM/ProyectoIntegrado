import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:football_zone/models/users.dart';
import 'package:football_zone/models/team.dart';
class LoginResponse {
  UserData? userData;
  String? error;

  LoginResponse({this.userData, this.error});
}

class UserService {
  static const String baseUrl = 'http://localhost:8090/api';

  Future<LoginResponse> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        body: {
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final UserData userData = UserData.fromJson(responseData);
        return LoginResponse(userData: userData);
      } else {
        final Map<String, dynamic> errorData = json.decode(response.body);
        final String errorMessage = errorData['message'] ?? 'Unknown error';
        return LoginResponse(error: errorMessage);
      }
    } catch (e) {
      return LoginResponse(error: 'Connection error: $e');
    }
  }

  Future<List<TeamModel>> getTeams() async {
  final response = await http.get(Uri.parse('$baseUrl/getTeams'));

  if (response.statusCode == 200) {
    List<dynamic> responseData = json.decode(response.body);
    List<TeamModel> teams = responseData.map((data) => TeamModel.fromJson(data)).toList();
    return teams;
  } else {
    throw Exception('Failed to load teams: ${response.statusCode}');
  }
}


 Future<Map<String, dynamic>> register(String username, String password, int idTeam, String name) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      body: {
        'username': username,
        'password': password,
        'id_team': idTeam, 
        'name': name,
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final error = jsonDecode(response.body)['error'];
      return {'error': error != null ? error : 'Failed to register'};
    }
  } catch (e) {
    return {'error': e.toString()};
  }
}




}
