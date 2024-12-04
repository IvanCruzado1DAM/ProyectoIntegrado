import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:BarDamm/models/user.dart';
import 'package:BarDamm/models/drink.dart';
import 'package:BarDamm/models/event.dart';
import 'package:BarDamm/models/reservetable.dart';
import 'package:BarDamm/models/opinion.dart';
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
              ))
          .toList();
      return reserves;
    } else {
      throw Exception('Failed to load reserves: ${response.statusCode}');
    }
  }


  Future<List<Reservetable>> fetchAllReservesbyClient(String token, int idClient) async {
    final url = Uri.parse('$baseUrl/listreserves/$idClient');
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
              ))
          .toList();
      return reserves;
    } else {
      throw Exception('Failed to load reserves: ${response.statusCode}');
    }
  }


  Future<List<Opinion>> fetchAllOpinions(String token) async {
  final url = Uri.parse('$baseUrl/listopinions');
  final response = await http.get(
    url,
    headers: {
      'Authorization': 'Bearer $token',
       'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    // Si la respuesta es exitosa, procesa el cuerpo
    List<dynamic> body = jsonDecode(response.body);
    List<Opinion> opinions = body
        .map((dynamic item) => Opinion(
              idOpinion: item['idopinion'],
              idUserOpinion: item['iduseropinion'],
              score: item['score'],
              comment: item['comment'],
            ))
        .toList();
    return opinions;
  } else {
    throw Exception('Failed to load opinions: ${response.statusCode}');
  }
}


  Future<void> submitCv(String token, File cvFile, int userId, bool accept,
      String username) async {
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

  Future<void> saveOpinion(
      {required int iduseropinion,
      required int score,
      required String comment,
      required String token}) async {
    const String url = '$baseUrl/saveOpinion';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {
          'iduseropinion': iduseropinion.toString(),
          'score': score.toString(),
          'comment': comment,
        },
      );

      if (response.statusCode == 200) {
        print('Opinion saved successfully: ${response.body}');
      } else if (response.statusCode == 404) {
        print('Error: ${response.body}');
      } else {
        print('Unexpected response: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  Future<void> editOpinion(
      {required int idUserOpinion,
      required int score,
      required String comment,
      required String token}) async {
    const String url = '$baseUrl/updateOpinion';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {
          'iduseropinion': idUserOpinion.toString(),
          'score': score.toString(),
          'comment': comment,
        },
      );

      if (response.statusCode == 200) {
        print('Opinion updated successfully: ${response.body}');
      } else {
        print(
            'Failed to update opinion: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

Future<void> addOrderr({
  required String drinks,
  required int numtable,
  required double total,
  required String token, // Si el endpoint necesita autenticación
}) async {
  final url = Uri.parse('$baseUrl/addOrderr'); // Cambia a tu URL base
  final headers = {
    'Authorization': 'Bearer $token', // Si se necesita autenticación
  };

  // Parámetros que se envían en la solicitud
  final body = {
    'drinks': drinks,
    'numtable': numtable.toString(),
    'total': total.toString(),
  };

  try {
    final response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      print('Order saved successfully: ${response.body}');
    } else {
      print('Failed to save order. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to save order: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
    throw Exception('An error occurred while saving the order.');
  }
}

}
