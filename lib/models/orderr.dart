class Orderr {
  int idorder;
  int numtable;
  String drinks;
  double total;
  bool paid;

  Orderr({
    required this.idorder,
    required this.numtable,
    required this.drinks,
    required this.total,
    required this.paid,
  });

  // Método para crear una instancia de Orderr desde un JSON
  factory Orderr.fromJson(Map<String, dynamic> json) {
    return Orderr(
      idorder: json['idorder'] as int,
      numtable: json['numtable'] as int,
      drinks: json['drinks'] as String,
      total: (json['total'] as num).toDouble(),
      paid: json['paid'] as bool,
    );
  }

  // Método para convertir una instancia de Orderr a JSON
  Map<String, dynamic> toJson() {
    return {
      'idorder': idorder,
      'numtable': numtable,
      'drinks': drinks,
      'total': total,
      'paid': paid,
    };
  }
}
