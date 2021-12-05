import 'package:calory_counter/domain/model/dish.dart';
import 'package:intl/intl.dart';
import "package:path/path.dart" show dirname, join;
import 'dart:io' show Directory, File, Platform;

import 'package:calory_counter/domain/model/information.dart';
import 'package:calory_counter/domain/model/user.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:sqflite/sqflite.dart';


class PFCRepository{
  Information getDay() {
    return Information(0, 0, 0, 0, 0);
  }

}

class MockPFCRepository extends PFCRepository{
  Information mockDay;

  MockPFCRepository(this.mockDay);
}

class DBProvider {
  DBProvider();
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

  Future<String> getPath() async{
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    return join(documentsDirectory.path, "CaloriesCounterTest5.db");
  }

  initDB() async {

    return await openDatabase(await getPath(), version: 1,
        onOpen: (db) {},
        onCreate: (Database db, int version) async {
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
              "    id       INTEGER PRIMARY KEY,"
              "    datetime DATETIME,"
              "    amount INT,"
              "    dish_id  INT REFERENCES Dish(id) "
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
          "INSERT INTO MyUser ( id, height, weight, age, mode )"
              " VALUES ( 0, 170, 60, 25, 2 )");
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

  saveMeal(List<Dish> meal, DateTime dateTime) async{
    final db = await database;
    var datetime = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
    for (var dish in meal) {
      await db.rawInsert(
        "INSERT INTO Information (datetime, amount, dish_id)"
          " VALUES ('${datetime}', ${dish.amount}, ${dish.id})");
    }
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
