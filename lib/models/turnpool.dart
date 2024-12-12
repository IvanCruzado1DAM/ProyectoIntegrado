class Turnpool {
  int idturnpool;
  int iduserpool;

  Turnpool({required this.idturnpool, required this.iduserpool});

  Map<String, dynamic> toMap() {
    return {
      'idturnpool': idturnpool,
      'iduserpool': iduserpool,
    };
  }

  factory Turnpool.fromMap(Map<String, dynamic> map) {
    return Turnpool(
      idturnpool: map['idturnpool'],
      iduserpool: map['iduserpool'],
    );
  }
}
