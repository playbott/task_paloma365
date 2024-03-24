import 'dart:io';

import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart' as sqlite;
import 'package:path/path.dart' as path;

class LocalDb {
  static final LocalDb _instance = LocalDb._internal();
  static sqlite.Database? _database;
  static late String _dbPath;

  LocalDb._internal();

  factory LocalDb() {
    return _instance;
  }

  static Future<void> init() async {
    const dbFileName = 'task_paloma365.sqlite3';
    final databasePath = await sqlite.getDatabasesPath();
    _dbPath = path.join(databasePath, dbFileName);
    final exists = await sqlite.databaseExists(_dbPath);

    if (!exists) {
      ByteData data = await rootBundle.load('res/$dbFileName');
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(_dbPath).writeAsBytes(bytes);
    }
  }

  static Future<sqlite.Database> open() async {
    _database ??= await sqlite.openDatabase(_dbPath);

    return _database!;
  }

  static Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
