import 'package:sqflite/sqflite.dart';

import 'database_helper.dart';

class CountdownDao {
  static const table = DatabaseHelper.tableCountdown;
  static const columnId = DatabaseHelper.columnId;
  static const columnDate = DatabaseHelper.columnDate;
  static const columnNote = DatabaseHelper.columnNote;
  static const columnCreatedAt = DatabaseHelper.columnCreatedAt;

  Future<Database> get database async => await DatabaseHelper.instance.database;

  CountdownDao._privateConstructor();

  static final CountdownDao instance = CountdownDao._privateConstructor();

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<List<Map<String, dynamic>>> queryAllOrderByDateAsc() async {
    Database db = await instance.database;
    return await db.rawQuery('SELECT * FROM $table ORDER BY $columnDate ASC');
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> queryAllRowsOrderByDateDesc() async {
    Database db = await instance.database;
    return await db.rawQuery('SELECT * FROM $table ORDER BY $columnDate DESC');
  }

  Future<List<Map<String, dynamic>>> queryAllRowsOrderByDateAsc() async {
    Database db = await instance.database;
    return await db.rawQuery('SELECT * FROM $table ORDER BY $columnDate ');
  }

  Future<int> deleteAll() async {
    Database db = await instance.database;
    return await db.delete(table);
  }

  Future<void> insertBatchForBackup(List<Map<String, dynamic>> list) async {
    Database db = await instance.database;

    await db.transaction((txn) async {
      final batch = txn.batch();

      for (final data in list) {
        batch.insert(table, data);
      }

      await batch.commit(noResult: true);
    });
  }
}
