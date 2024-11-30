import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_application_bardamm/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';


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
  static const String baseUrl = 'https://proyectointegrado.onrender.com/api';

  Future<LoginResult> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/login?username=$username&password=$password');
    
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return LoginResult(
          userData: UserData(
            token: data['token'],
            role: data['role'],
            idUser: data['iduser'], 
            username: data['username'],
          ),
        );
      } else {
        print(url);
        return LoginResult(error: 'Login failed: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(url);
      print('Error: $e');
      return LoginResult(error: 'Hubo un error al intentar conectar con el servidor');
    }
  }


  Future<Map<String, dynamic>> register(String username, String password, String name, String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'username': username,
          'password': password,
          'name': name,
          'email': email,
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
