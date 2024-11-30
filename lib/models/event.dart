import 'dart:typed_data';

class Event {
  int idevent;
  String eventname;
  String eventdescription;
  DateTime eventenddate;
  Uint8List eventimage;

  Event({
    required this.idevent,
    required this.eventname,
    required this.eventdescription,
    required this.eventenddate,
    required this.eventimage,
  });
  

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      idevent: json['idevent'],
      eventname: json['eventname'],
      eventdescription: json['eventdescription'],
      eventenddate: DateTime.parse(json['eventenddate']),
      eventimage: Uint8List.fromList(List<int>.from(json['eventimage'])),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idevent': idevent,
      'eventname': eventname,
      'eventdescription': eventdescription,
      'eventenddate': eventenddate.toIso8601String(),
      'eventimage': eventimage,
    };
  }
}
