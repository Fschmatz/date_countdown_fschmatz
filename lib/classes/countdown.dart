import 'package:jiffy/jiffy.dart';

import '../db/countdown_dao.dart';

class Countdown {
  int? id;
  DateTime? date;
  String? note;
  DateTime? createdAt;

  Countdown({
    this.id,
    this.date,
    this.note,
    this.createdAt,
  });

  factory Countdown.fromMap(Map<String, dynamic> map) {
    return Countdown(
      id: map[CountdownDao.columnId] as int?,
      date: DateTime.parse(map[CountdownDao.columnDate] as String),
      note: map[CountdownDao.columnNote] as String?,
      createdAt: DateTime.parse(map[CountdownDao.columnCreatedAt] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) CountdownDao.columnId: id,
      CountdownDao.columnDate: date?.toIso8601String(),
      CountdownDao.columnNote: note,
      CountdownDao.columnCreatedAt: createdAt?.toIso8601String(),
    };
  }

  Countdown copyWith({
    int? id,
    DateTime? date,
    String? note,
    DateTime? createdAt,
  }) {
    return Countdown(
      id: id ?? this.id,
      date: date ?? this.date,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  String getDateFormatted() {
    return Jiffy.parseFromDateTime(date!).format(pattern: 'dd/MM/yyyy');
  }

  String getCreatedAtFormatted() {
    return Jiffy.parseFromDateTime(createdAt!).format(pattern: 'dd/MM/yyyy');
  }
}