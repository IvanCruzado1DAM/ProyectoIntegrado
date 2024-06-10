class PlayerModel {
  final int? idPlayer;
  final String name;
  final String position;
  final int? age;
  final String? image;
  final int? idTeam;
  final int dorsal;
  final String? nationality;
  final int? marketValue;
  final int? salary;
  final int? goals;
  final int? assists;
  final int? yc; // yellow cards
  final int? rc; // red cards
  final int? contract;
  final String? footballAspects;
  final String? diet;
  final String? transferStatus;
  final bool? isInjured;
  final bool? isSancionated;

  PlayerModel({
     this.idPlayer,
    required this.name,
    required this.position,
     this.age,
     this.image,
     this.idTeam,
     required this.dorsal,
     this.nationality,
     this.marketValue,
     this.salary,
     this.goals,
     this.assists,
     this.yc,
     this.rc,
     this.contract,
     this.footballAspects,
     this.diet,
     this.transferStatus,
     this.isInjured,
     this.isSancionated,
  });

  factory PlayerModel.fromJson(Map<String, dynamic> json) {
    return PlayerModel(
      idPlayer: json['id_player'],
      name: json['name'],
      position: json['position'],
      age: json['age'],
      image: json['image'],
      idTeam: json['id_team'],
      dorsal: json['dorsal'],
      nationality: json['nationality'],
      marketValue: json['market_value'],
      salary: json['salary'],
      goals: json['goals'],
      assists: json['assists'],
      yc: json['yc'],
      rc: json['rc'],
      contract: json['contract'],
      footballAspects: json['footballaspects'],
      diet: json['diet'],
      transferStatus: json['transfer_status'],
      isInjured: json['is_injured'],
      isSancionated: json['is_sancionated'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_player': idPlayer,
      'name': name,
      'position': position,
      'age': age,
      'image': image,
      'id_team': idTeam,
      'dorsal': dorsal,
      'nationality': nationality,
      'market_value': marketValue,
      'salary': salary,
      'goals': goals,
      'assists': assists,
      'yc': yc,
      'rc': rc,
      'contract': contract,
      'footballaspects': footballAspects,
      'diet': diet,
      'transfer_status': transferStatus,
      'is_injured': isInjured,
      'is_sancionated': isSancionated,
    };
  }
}
