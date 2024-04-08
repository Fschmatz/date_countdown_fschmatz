class Countdown{
  int? id;
  String? date;
  String? completeDate;
  String? note;

  Countdown({this.id, this.date, this.note, this.completeDate});

  factory Countdown.fromMap(Map<String, dynamic> map) {
    return Countdown(
      id: map['id'],
      date: map['date'],
      completeDate : map['completeDate'],
      note: map['note'],
    );
  }
}