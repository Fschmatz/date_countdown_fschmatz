import 'package:flutter/material.dart';
import '../classes/countdown.dart';
import '../db/countdown_dao.dart';

class CountdownService {

  CountdownService._privateConstructor();
  static final CountdownService instance = CountdownService._privateConstructor();

  final dbCountDown = CountdownDao.instance;

  Future<List<Countdown>> queryAllRowsDesc() async {
    var resp = await dbCountDown.queryAllRowsDesc();

    return resp.isNotEmpty ? resp.map((map) => Countdown.fromMap(map)).toList() : [];
  }

  Future<List<Countdown>> queryAllRowsOrderByDateAsc() async {
    var resp = await dbCountDown.queryAllRowsOrderByDateAsc();

    return resp.isNotEmpty ? resp.map((map) => Countdown.fromMap(map)).toList() : [];
  }

  Future<void> delete(int id) async {
    await dbCountDown.delete(id);
  }

  Future<void> update(Countdown countdown) async {
    Map<String, dynamic> row = {
      CountdownDao.columnId: countdown.id,
      CountdownDao.columnDate: DateUtils.dateOnly(countdown.date!).toString(),
      CountdownDao.columnNote: countdown.note,
      CountdownDao.columnCreatedAt: DateUtils.dateOnly(countdown.createdAt!).toString()
    };

    await dbCountDown.update(row);
  }

  Future<void> insert(Countdown countdown) async {
    DateUtils.dateOnly(DateTime.now());

    Map<String, dynamic> row = {
      CountdownDao.columnDate: DateUtils.dateOnly(countdown.date!).toString(),
      CountdownDao.columnNote: countdown.note,
      CountdownDao.columnCreatedAt: DateUtils.dateOnly(DateTime.now()).toString(),
    };

    await dbCountDown.insert(row);
  }
}
