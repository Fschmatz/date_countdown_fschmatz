import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _databaseName = "DateCountdown.db";
  static const _databaseVersion = 2;

  // Countdown
  static const tableCountdown = 'note';
  static const columnId = 'id';
  static const columnDate = 'date';
  static const columnNote = 'note';
  static const columnCreatedAt = 'createdAt';

  // App Parameters
  static const tableAppParameters = 'app_parameters';
  static const columnParamKey = 'key';
  static const columnParamValue = 'value';
 
  static Database? _database;

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onCreate(Database db, int version) async {
    // Countdown
    await db.execute('''
          CREATE TABLE $tableCountdown (
           $columnId INTEGER PRIMARY KEY,            
           $columnDate TEXT NOT NULL,           
           $columnNote TEXT NOT NULL,
           $columnCreatedAt TEXT NOT NULL
          )
          ''');

    // App Parameters
    await db.execute('''
          CREATE TABLE $tableAppParameters (
            $columnParamKey TEXT PRIMARY KEY,
            $columnParamValue TEXT
          )
          ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
          CREATE TABLE $tableAppParameters (
            $columnParamKey TEXT PRIMARY KEY,
            $columnParamValue TEXT
          )
          ''');
    }
  }
}
