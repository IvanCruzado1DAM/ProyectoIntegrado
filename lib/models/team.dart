// file: lib/models/team.dart
class TeamModel {
  int idTeam;
  String name;
  String? city;
  String? badge;
  String? stadium;
  int capital;
  int occupation;

  TeamModel({
    required this.idTeam,
    required this.name,
    this.city,
    this.badge,
    this.stadium,
    required this.capital,
    required this.occupation,
  });

  factory TeamModel.fromJson(Map<String, dynamic> json) {
    return TeamModel(
      idTeam: json['id_team'],
      name: json['name'],
      city: json['city'],
      badge: json['badge'],
      stadium: json['stadium'],
      capital: json['capital'],
      occupation: json['occupation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_team': idTeam,
      'name': name,
      'city': city,
      'badge': badge,
      'stadium': stadium,
      'capital': capital,
      'occupation': occupation,
    };
  }
}
