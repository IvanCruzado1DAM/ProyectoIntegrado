class RenovationofferModel {
  final int idRenovationOffer;
  final int idPlayerRenovation;
  final String status;
  final int year;

  RenovationofferModel({
    required this.idRenovationOffer,
    required this.idPlayerRenovation,
    required this.status,
    required this.year,
  });

  factory RenovationofferModel.fromJson(Map<String, dynamic> json) {
    return RenovationofferModel(
      idRenovationOffer: json['idRenovationOffer'],
      idPlayerRenovation: json['idPlayerRenovation'],
      status: json['status'],
      year: json['year'],
    );
  }
}
