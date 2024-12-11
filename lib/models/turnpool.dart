class Turnpool {
  int idturnpool;
  int iduserpool;

  // Constructor
  Turnpool({required this.idturnpool, required this.iduserpool});

  // Método para convertir el objeto en un mapa (Map)
  Map<String, dynamic> toMap() {
    return {
      'idturnpool': idturnpool,
      'iduserpool': iduserpool,
    };
  }

  // Método para crear un objeto Turnpool a partir de un mapa (Map)
  factory Turnpool.fromMap(Map<String, dynamic> map) {
    return Turnpool(
      idturnpool: map['idturnpool'],
      iduserpool: map['iduserpool'],
    );
  }
}
