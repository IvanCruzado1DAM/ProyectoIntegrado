
class GameModel {
  final int idGame;
  final int idLocalTeam;
  final int idVisitantTeam;
  final int numberGame;
  final DateTime date;
  final int tickets;
  final String score;

  GameModel({
    required this.idGame,
    required this.idLocalTeam,
    required this.idVisitantTeam,
    required this.numberGame,
    required this.date,
    required this.tickets,
    required this.score,
  });

  factory GameModel.fromJson(Map<String, dynamic> json) {
    return GameModel(
      idGame: json['id_game'] ?? 0,
      idLocalTeam: json['idLocalTeam'] ?? 0,
      idVisitantTeam: json['idVisitantTeam'] ?? 0,
      numberGame: json['numberGame'] ?? 0,
      date: json['date'] ?? DateTime.now(),
      tickets: json['tickets'] ?? 0,
      score: json['score'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_game': idGame,
      'idLocalTeam': idLocalTeam,
      'idVisitantTeam': idVisitantTeam,
      'numberGame': numberGame,
      'date': date,
      'tickets': tickets,
      'score': score,
    };
  }
}