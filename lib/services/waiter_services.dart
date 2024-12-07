import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:BarDamm/models/user.dart';
import 'package:BarDamm/models/orderr.dart';
import 'dart:typed_data';
import 'dart:io';
import 'package:intl/intl.dart';

class WaiterResponse {
  UserData? userData;
  String? error;

  WaiterResponse({this.userData, this.error});
}

class WaiterResult {
  final UserData? userData;
  final String? error;

  WaiterResult({this.userData, this.error});
}

class WaiterService {
  static const String baseUrl =
      'https://proyectointegrado.onrender.com/apiwaiter';

  Future<List<Orderr>> fetchAllDrinks(String token) async {
    final url = Uri.parse('$baseUrl/listorders');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Orderr> drinks = body
          .map((dynamic item) => Orderr(
                idorder: item['idorder'],
                numtable: item['numtable'],
                drinks: item['drinks'],
                total: item['total'],
                paid: item['paid'],
              ))
          .toList();
      return drinks;
    } else {
      throw Exception('Failed to load drinks: ${response.statusCode}');
    }
  }
}
