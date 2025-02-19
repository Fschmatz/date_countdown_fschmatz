import 'package:intl/intl.dart';

class Countdown{
  int? id;
  DateTime? date;
  String? note;
  DateTime? createdAt;

  Countdown({this.id, this.date, this.note, this.createdAt});

  factory Countdown.fromMap(Map<String, dynamic> map) {
    return Countdown(
      id: map['id'],
      date: DateTime.parse(map['date']),
      note: map['note'],
      createdAt: DateTime.parse(map['createdAt'])
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date?.toIso8601String(),
      'note': note,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  String getDateFormatted() {
    return DateFormat('dd/MM/yyyy').format(date!);
  }

  String getCreatedAtFormatted() {
    return DateFormat('dd/MM/yyyy').format(createdAt!);
  }
}