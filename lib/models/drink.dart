import 'dart:typed_data';
import 'dart:convert';

class Drink {
  final int iddrink;
  final String drinkname;
  final String drinkdescription;
  final String drinkcategory;
  final double drinkprice;
  final Uint8List drinkimage;

  Drink({
    required this.iddrink,
    required this.drinkname,
    required this.drinkdescription,
    required this.drinkcategory,
    required this.drinkprice,
    required this.drinkimage,
  });

  factory Drink.fromJson(Map<String, dynamic> json) {
    return Drink(
      iddrink: json['iddrink'],
      drinkname: json['drinkname'],
      drinkdescription: json['drinkdescription'],
      drinkcategory: json['drinkcategory'],
      drinkprice: json['drinkprice'],
      drinkimage: json['drinkimage'] != null
          ? base64Decode(json['drinkimage'])
          : Uint8List(0), 
    );
  }
}
