import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class CountdownDao {

  static final _databaseName = 'DayStudy.db';
  static final _databaseVersion = 1;

  static final table = 'note';
  static final columnId = 'id';
  static final columnDate = 'date';
  static final columnCompleteDate = 'completeDate';
  static final columnNote = 'note';

  static Database? _database;
  Future<Database> get database async =>
      _database ??= await _initDatabase();

  CountdownDao._privateConstructor();
  static final CountdownDao instance = CountdownDao._privateConstructor();


  // Open db and create if it not exists
  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL create DB
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
           $columnId INTEGER PRIMARY KEY,            
           $columnDate TEXT NOT NULL,  
           $columnCompleteDate TEXT NOT NULL,
           $columnNote TEXT NOT NULL
          )
          ''');
  }


  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<List<Map<String, dynamic>>> queryAllRowsDesc() async {
    Database db = await instance.database;
    return await db.rawQuery('SELECT * FROM $table ORDER BY id DESC');
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

}