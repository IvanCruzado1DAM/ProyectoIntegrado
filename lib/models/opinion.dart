class Opinion {
  final int idOpinion; 
  final int idUserOpinion;
  final int score;
  final String comment;

  Opinion({
    required this.idOpinion,
    required this.idUserOpinion,
    required this.score,
    required this.comment,
  });

  factory Opinion.fromJson(Map<String, dynamic> json) {
    return Opinion(
      idOpinion: json['idopinion'],
      idUserOpinion: json['iduseropinion'],
      score: json['score'],
      comment: json['comment'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idopinion': idOpinion,
      'iduseropinion': idUserOpinion,
      'score': score,
      'comment': comment,
    };
  }
}
