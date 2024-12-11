class Pool {
  int idpool;
  int numturn;

  // Constructor
  Pool({required this.idpool, required this.numturn});

  // Método para convertir el objeto en un mapa (Map)
  Map<String, dynamic> toMap() {
    return {
      'idpool': idpool,
      'numturn': numturn,
    };
  }

  // Método para crear un objeto Pool a partir de un mapa (Map)
  factory Pool.fromMap(Map<String, dynamic> map) {
    return Pool(
      idpool: map['idpool'],
      numturn: map['numturn'],
    );
  }
}
