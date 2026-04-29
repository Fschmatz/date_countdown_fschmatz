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
    await dbCountDown.update(countdown.toMap());
    await loadCountdowns();
  }

  Future<void> insert(Countdown countdown) async {
    Countdown countdownToInsert = countdown.copyWith(
      createdAt: countdown.createdAt ?? DateUtils.dateOnly(DateTime.now()),
    );

    await dbCountDown.insert(countdownToInsert.toMap());
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
