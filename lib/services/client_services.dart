import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_application_bardamm/models/user.dart';
import 'package:flutter_application_bardamm/models/drink.dart';
import 'package:flutter_application_bardamm/models/event.dart';
import 'package:flutter_application_bardamm/models/reservetable.dart';
import 'dart:typed_data';
import 'dart:io';
import 'package:intl/intl.dart';

class ClientResponse {
  UserData? userData;
  String? error;

  ClientResponse({this.userData, this.error});
}

class ClientResult {
  final UserData? userData;
  final String? error;

  ClientResult({this.userData, this.error});
}

class ClientService {
  static const String baseUrl =
      'https://proyectointegrado.onrender.com/apiclient';

  Future<List<Drink>> fetchAllDrinks(String token) async {
    final url = Uri.parse('$baseUrl/listdrinks');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token', 
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Drink> drinks = body
          .map((dynamic item) => Drink(
                iddrink: item['iddrink'],
                drinkname: item['drinkname'],
                drinkdescription: item['drinkdescription'],
                drinkcategory: item['drinkcategory'],
                drinkprice: item['drinkprice'],
                drinkimage: item['drinkimage'] != null
                    ? base64Decode(item['drinkimage'])
                    : Uint8List(0),
              ))
          .toList();
      return drinks;
    } else {
      throw Exception('Failed to load drinks: ${response.statusCode}');
    }
  }

  Future<List<Event>> fetchAllEvents(String token) async {
    final url = Uri.parse('$baseUrl/listevents');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token', 
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Event> events = body
          .map((dynamic item) => Event(
                idevent: item['idevent'],
                eventname: item['eventname'],
                eventdescription: item['eventdescription'],
                eventenddate: DateTime.parse(item['eventenddate']),
                eventimage: item['eventimage'] != null
                    ? base64Decode(item['eventimage'])
                    : Uint8List(0),
              ))
          .toList();
      return events;
    } else {
      throw Exception('Failed to load events: ${response.statusCode}');
    }
  }

  Future<List<Reservetable>> fetchAllReserves(String token) async {
    final url = Uri.parse('$baseUrl/listreserves');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token', 
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Reservetable> reserves = body
          .map((dynamic item) => Reservetable(
                idTable: item['idtable'],
                numTable: item['numtable'],
                idClient: item['idclient'],
                reservationHour: DateTime.parse(item['reservationhour']),
                occupy: item['occupy'],
                wantToPay: item['wanttopay'],
              ))
          .toList();
      return reserves;
    } else {
      throw Exception('Failed to load events: ${response.statusCode}');
    }
  }

  Future<void> submitCv(
      String token, File cvFile, int userId, bool accept, String username) async {
    try {
      final Uri url = Uri.parse('$baseUrl/uploadCv');

      final request = http.MultipartRequest('POST', url)
        ..headers['Authorization'] = 'Bearer $token'
        ..fields['idusercv'] = userId.toString()
        ..fields['username'] = username
        ..fields['accept'] = accept.toString()
        ..files.add(await http.MultipartFile.fromPath('cvfile', cvFile.path));

      final response = await request.send();

      if (response.statusCode == 200) {
        print('CV uploaded successfully');
      } else {
        print('Error uploading CV: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<String> reserveTable({
    required String token,
    required int numTable,
    required int idClient,
    required DateTime reservationHour,
  }) async {
    final url = Uri.parse('$baseUrl/reserveTable');
    String formattedDate = _formatDateTime(reservationHour);

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token', 
        },
        body: {
          'numtable': numTable.toString(),
          'idclient': idClient.toString(),
          'reservationHour': formattedDate,
        },
      );
  
      if (response.statusCode == 200) {
        return 'Table reserved successfully';
      } else if (response.statusCode == 404) {
        return 'Table not found';
      } else {
        return '${response.body}';
      }
    } catch (e) {
      return 'Failed to reserve table: $e';
    }
  }

  String _formatDateTime(DateTime dateTime) {
  // Formato sin milisegundos
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
  return dateFormat.format(dateTime);
}
}
