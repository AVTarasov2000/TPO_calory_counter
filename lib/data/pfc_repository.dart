import 'package:calory_counter/data/scripts/create_table.dart';
import "package:path/path.dart" show dirname, join;
import 'dart:io' show Directory, File, Platform;

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
    String path =join(documentsDirectory.path, "CaloriesCounterTest2.db");
    return await openDatabase(path, version: 1, onOpen: (db) {
    }, onCreate: (Database db, int version) async {
      await db.execute(
          "CREATE TABLE Dish "
          "("
          "    id            INTEGER PRIMARY KEY,"
          "    name          TEXT,"
          "    proteins      INT,"
          "    fat           INT,"
          "    carbohydrates INT,"
          "    calories      INT,"
          "    watter        INT"
          ")");
      await db.execute(
          "CREATE TABLE Information "
          "("
          "    id            INTEGER PRIMARY KEY,"
          "    date          DATE,"
          "    time          TIME,"
          "    proteins      INT,"
          "    fat           INT,"
          "    carbohydrates INT,"
          "    calories      INT,"
          "    watter        INT"
          ")");
      await db.execute(
          "CREATE TABLE MyUser "
          "("
          "    id     INTEGER PRIMARY KEY,"
          "    height INT,"
          "    weight INT,"
          "    age    INT,"
          "    mode   INT"
          ")"
      );
      await db.rawInsert(
          "INSERT INTO MyUser ( id, height, weight, age,mode )"
              " VALUES ( 0, 0, 0, 0, 0 )");
      // await db.insert("MyUser", {"id":0, "height":0, "weight":0, "age":0, "mode":0 });
      await db.rawInsert(
          "INSERT INTO Dish (name,proteins,fat,carbohydrates,calories,watter) "
          "VALUES "
              "('картошка', 10, 10, 10, 10, 10),"
              "('котлета', 10, 10, 10, 10, 10),"
              "('макарошки', 10, 10, 10, 10, 10),"
              "('пюрешка', 10, 10, 10, 10, 10)");
    });
  }

  saveUser(User user) async {
    final db = await database;
    var res = await db.update("MyUser", user.toJson());
    return res;
  }
  getUser() async {
    final db = await database;
    var res = await db.query("MyUser", where: "id = ?", whereArgs: [0]);
    return res.isNotEmpty ? User.fromJson(res.first) : User(0,0,0,0,0);
  }

  Future<List> allDishes() async{
    final db = await database;
    var res = await db.query("Dish");
    return res.map((val){return {"display": val["name"],"value":val["id"]};}).toList();
  }
}
