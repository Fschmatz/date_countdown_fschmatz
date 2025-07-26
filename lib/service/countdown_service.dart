import 'package:date_countdown_fschmatz/service/store_service.dart';
import 'package:flutter/material.dart';

import '../classes/countdown.dart';
import '../db/countdown_dao.dart';

class CountdownService extends StoreService {
  final dbCountDown = CountdownDao.instance;

  Future<List<Countdown>> queryAllRowsDesc() async {
    var resp = await dbCountDown.queryAllOrderByDateAsc();

    return resp.isNotEmpty ? resp.map((map) => Countdown.fromMap(map)).toList() : [];
  }

  Future<List<Map<String, dynamic>>> queryAllRowsDescForBackup() async {
    return await dbCountDown.queryAllOrderByDateAsc();
  }

  Future<List<Countdown>> queryAllRowsOrderByDateAsc() async {
    var resp = await dbCountDown.queryAllRowsOrderByDateAsc();

    return resp.isNotEmpty ? resp.map((map) => Countdown.fromMap(map)).toList() : [];
  }

  Future<void> delete(int id) async {
    await dbCountDown.delete(id);
    await loadCountdowns();
  }

  Future<void> update(Countdown countdown) async {
    Map<String, dynamic> row = {
      CountdownDao.columnId: countdown.id,
      CountdownDao.columnDate: DateUtils.dateOnly(countdown.date!).toString(),
      CountdownDao.columnNote: countdown.note,
      CountdownDao.columnCreatedAt: DateUtils.dateOnly(countdown.createdAt!).toString()
    };

    await dbCountDown.update(row);
    await loadCountdowns();
  }

  Future<void> insert(Countdown countdown) async {
    DateUtils.dateOnly(DateTime.now());

    Map<String, dynamic> row = {
      CountdownDao.columnDate: DateUtils.dateOnly(countdown.date!).toString(),
      CountdownDao.columnNote: countdown.note,
      CountdownDao.columnCreatedAt: DateUtils.dateOnly(DateTime.now()).toString(),
    };

    await dbCountDown.insert(row);
    await loadCountdowns();
  }

  Future<void> deleteAll() async {
    await dbCountDown.deleteAll();
  }

  Future<void> insertAllFromRestoreBackup(List<dynamic> jsonData) async {
    List<Map<String, dynamic>> listToInsert = jsonData.map((item) {
      return Countdown.fromMap(item).toMap();
    }).toList();

    await dbCountDown.insertBatchForBackup(listToInsert);
    await loadCountdowns();
  }
}
