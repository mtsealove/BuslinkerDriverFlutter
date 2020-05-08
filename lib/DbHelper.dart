import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


final String TableName = 'alert';

class DBHelper {

  DBHelper._();
  static final DBHelper _db = DBHelper._();
  factory DBHelper() => _db;

  static Database _database;

  Future<Database> get database async {
    if(_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'alert.db');

    return await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
          CREATE TABLE $TableName(
            id INTEGER PRIMARY KEY,
            message TEXT,
            read bool default false
          )
        ''');
        },
        onUpgrade: (db, oldVersion, newVersion){}
    );
  }

  //Create
  createData(String msg) async {
    final db = await database;
    var res = await db.rawInsert('INSERT INTO $TableName(message) VALUES(?)', [msg]);
    return res;
  }


  //Read All
  Future<List<String>> getAll() async {
    final db = await database;
    var res = await db.rawQuery('SELECT * FROM $TableName');
    List<String> list = res.isNotEmpty ? res.map((c) => c['message'] ).toList() : [];

    return list;
  }


  //Delete All
  deleteAll() async {
    final db = await database;
    db.rawDelete('DELETE FROM $TableName');
  }

}