import 'package:flutter/material.dart';

class Reservetable {
  final int idTable;
  final int numTable;
  final int idClient;
  final DateTime reservationHour;
  final bool occupy;

  Reservetable({
    required this.idTable,
    required this.numTable,
    required this.idClient,
    required this.reservationHour,
    required this.occupy,
  });

  factory Reservetable.fromJson(Map<String, dynamic> json) {
    return Reservetable(
      idTable: json['idtable'],
      numTable: json['numtable'],
      idClient: json['idclient'],
      reservationHour: DateTime.parse(json['reservationhour']),
      occupy: json['occupy'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idtable': idTable,
      'numtable': numTable,
      'idclient': idClient,
      'reservationhour': reservationHour.toIso8601String(),
      'occupy': occupy,
    };
  }
}
