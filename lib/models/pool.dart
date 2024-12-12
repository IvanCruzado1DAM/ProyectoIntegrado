class Pool {
  int idpool;
  int numturn;

  Pool({required this.idpool, required this.numturn});

  Map<String, dynamic> toMap() {
    return {
      'idpool': idpool,
      'numturn': numturn,
    };
  }

  factory Pool.fromMap(Map<String, dynamic> map) {
    return Pool(
      idpool: map['idpool'],
      numturn: map['numturn'],
    );
  }
}
