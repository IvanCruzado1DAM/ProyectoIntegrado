class Opinion {
  final int idOpinion; // Nullable porque puede ser generado automáticamente
  final int idUserOpinion;
  final int score;
  final String comment;

  // Constructor
  Opinion({
    required this.idOpinion,
    required this.idUserOpinion,
    required this.score,
    required this.comment,
  });

  // Método para convertir desde JSON a una instancia de Opinion
  factory Opinion.fromJson(Map<String, dynamic> json) {
    return Opinion(
      idOpinion: json['idopinion'],
      idUserOpinion: json['iduseropinion'],
      score: json['score'],
      comment: json['comment'],
    );
  }

  // Método para convertir una instancia de Opinion a JSON
  Map<String, dynamic> toJson() {
    return {
      'idopinion': idOpinion,
      'iduseropinion': idUserOpinion,
      'score': score,
      'comment': comment,
    };
  }
}
