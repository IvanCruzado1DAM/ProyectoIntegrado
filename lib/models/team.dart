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

  //getters and setters
  int? getidTeam() {
    return idTeam;
  }

  void setidTeam(int value) {
    idTeam = value;
  }

  String? getName() {
    return name;
  }

  void setName(String value) {
    name = value;
  }

  String? getCity() {
    return city;
  }

  void setCity(String value) {
    city = value;
  }

  String? getBadge() {
    return badge;
  }

  void setBadge(String value) {
    badge = value;
  }

  String? getStadium() {
    return stadium;
  }

  void setStadium(String value) {
    stadium = value;
  }

  int? getCapital() {
    return capital;
  }

  void setCapital(int value) {
    capital = value;
  }

  int? getOccupation() {
    return occupation;
  }

  void setOccupation(int value) {
    occupation = value;
  }

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
