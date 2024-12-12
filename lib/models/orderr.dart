class Orderr {
  int idorder;
  int numtable;
  int idreservetable;
  String drinks;
  double total;
  bool paid;

  Orderr({
    required this.idorder,
    required this.numtable,
    required this.idreservetable,
    required this.drinks,
    required this.total,
    required this.paid,
  });

  factory Orderr.fromJson(Map<String, dynamic> json) {
    return Orderr(
      idorder: json['idorder'] as int,
      numtable: json['numtable'] as int,
      idreservetable: json['idreservetable'] as int,
      drinks: json['drinks'] as String,
      total: (json['total'] as num).toDouble(),
      paid: json['paid'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idorder': idorder,
      'numtable': numtable,
      'idreservetable': idreservetable,
      'drinks': drinks,
      'total': total,
      'paid': paid,
    };
  }
}
