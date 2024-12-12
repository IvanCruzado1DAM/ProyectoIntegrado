import 'package:BarDamm/models/reservetable.dart';
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

  Future<List<Orderr>> fetchAllOrders(String token) async {
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
                idreservetable: item['idreservetable'],
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

  Future<List<Reservetable>> fetchAllTables(String token) async {
    final url = Uri.parse('$baseUrl/listtables');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Reservetable> tables = body
          .map((dynamic item) => Reservetable(
                idTable: item['idtable'],
                numTable: item['numtable'],
                idClient: item['idclient'],
                reservationHour: DateTime.parse(item['reservationhour']),
                occupy: item['occupy'],
                wanttopay: item['wanttopay'],
              ))
          .toList();
      return tables;
    } else {
      throw Exception('Failed to load tables: ${response.statusCode}');
    }
  }

  Future<String> payOrder(int idOrder, String token) async {
    final url = Uri.parse('$baseUrl/payOrderr?idorder=$idOrder');

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token', 
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return 'Order paid successfully'; 
      } else {
        throw Exception(
            'Failed to pay order. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error paying order: $e');
    }
  }

  Future<String> confirmAssist(int idreservetable, String token) async {
    final url = Uri.parse('$baseUrl/confirmAssist?idreservetable=$idreservetable');

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token', 
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return 'Confirm assist successfully'; 
      } else {
        throw Exception(
            'Failed to confirm assist. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error paying order: $e');
    }
  }

  Future<String> settablefree(int idreservetable, String token) async {
    final url = Uri.parse('$baseUrl/settablefree?idreservetable=$idreservetable');

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token', 
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return 'Mark table as free successfully'; 
      } else {
        throw Exception(
            'Failed to confirm assist. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error paying order: $e');
    }
  }

  Future<String> setpoolfree(String token) async {
    final url = Uri.parse('$baseUrl/setpoolfree');
    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return 'Mark pool as free successfully';
      } else {
        throw Exception(
            'Failed to mark pool as free. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
