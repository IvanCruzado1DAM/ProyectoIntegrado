import 'dart:typed_data';

class Cv {
  int idcv;
  int idusercv;
  Uint8List? cvdocument;
  bool accept;

  Cv({
    required this.idcv,
    required this.idusercv,
    this.cvdocument,
    required this.accept,
  });

  factory Cv.fromJson(Map<String, dynamic> json) {
    return Cv(
      idcv: json['idcv'] as int,
      idusercv: json['idusercv'] as int,
      cvdocument: json['cvdocument'] != null
          ? Uint8List.fromList((json['cvdocument'] as List<dynamic>).cast<int>())
          : null,
      accept: json['accept'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idcv': idcv,
      'idusercv': idusercv,
      'cvdocument': cvdocument,
      'accept': accept,
    };
  }
}
