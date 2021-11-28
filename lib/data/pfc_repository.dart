import 'dart:io';

import 'package:calory_counter/domain/model/information.dart';
import 'package:calory_counter/domain/model/user.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:sqflite/sqflite.dart';


class PFCRepository{
  Information getDay() {
    return Information(0, 0, 0, 0);
  }

}

class MockPFCRepository extends PFCRepository{
  Information mockDay;

  MockPFCRepository(this.mockDay);
}

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null)
      return _database!;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database!;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = documentsDirectory.path + "CaloriesCounter.db";
    var createTableFile = File('lib/data/scripts/create_table.sql');
    return await openDatabase(path, version: 1, onOpen: (db) {
    }, onCreate: (Database db, int version) async {
      await db.execute(createTableFile.readAsStringSync());
    });
  }

  saveUser(User user) async {
    final db = await database;
    var res = await db.update("User", user.toJson());
    return res;
  }
  getUser() async {
    final db = await database;
    var res = await db.query("User");
    return res.isNotEmpty ? User.fromJson(res.first) : Null ;
  }
}
