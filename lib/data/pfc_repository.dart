import 'package:calory_counter/domain/model/dish.dart';
import 'package:calory_counter/presentation/util.dart';
import 'package:intl/intl.dart';
import "package:path/path.dart" show dirname, join;
import 'dart:io' show Directory, File, Platform;

import 'package:calory_counter/domain/model/information.dart';
import 'package:calory_counter/domain/model/user.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';


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
    return join(documentsDirectory.path, "CaloriesCounterTest7.db");
  }

  initDB() async {

    var db = sqlite3.open(await getPath());
    db.execute(
        "CREATE TABLE IF NOT EXISTS Dish "
            "("
            "    id            INTEGER PRIMARY KEY,"
            "    name          TEXT,"
            "    proteins      INT,"
            "    fat           INT,"
            "    carbohydrates INT,"
            "    calories      INT,"
            "    watter        INT"
            ")");
    db.execute(
        "CREATE TABLE IF NOT EXISTS Information "
            "("
            "    id       INTEGER PRIMARY KEY,"
            "    datetime DATETIME,"
            "    amount   INT,"
            "    dish_id  INT REFERENCES Dish(id) "
            ")");
    db.execute(
        "CREATE TABLE IF NOT EXISTS MyUser "
            "("
            "    id     INTEGER PRIMARY KEY,"
            "    height INT,"
            "    weight INT,"
            "    age    INT,"
            "    mode   INT"
            ")"
    );
    db.execute(
        "INSERT INTO MyUser ( id, height, weight, age, mode )"
            " VALUES ( 0, 170, 60, 25, 2 )");
    db.execute(
        "INSERT INTO Dish (name,proteins,fat,carbohydrates,calories,watter) "
            "VALUES "
            "('картошка', 10, 10, 10, 10, 10),"
            "('котлета', 10, 10, 10, 10, 10),"
            "('макарошки', 10, 10, 10, 10, 10),"
            "('пюрешка', 10, 10, 10, 10, 10)");
    return db;

  }

  saveUser(User user) async {
    final db = await database;
    db.execute("UPDATE MyUser "
        "SET  "
        "height =  ${user.height}, "
        "weight = ${user.weight}, "
        "age = ${user.age}, "
        "mode = ${user.mode} "
        "WHERE id =  ${user.id};");
    // var res = await db.update("MyUser", user.toJson());
    // return res;
  }

  saveMeal(List<Dish> meal, DateTime dateTime) async{
    final db = await database;
    var datetime = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
    for (var dish in meal) {
      db.execute(
        "INSERT INTO Information (datetime, amount, dish_id)"
          " VALUES ('${datetime}', ${dish.amount}, ${dish.id})");
    }
  }

  getUser() async {
    final db = await database;
    // var res = await db.select("MyUser", where: "id = ?", whereArgs: [0]);
    var res = db.select("select * FROM MyUser where id = 0");
    return res.isNotEmpty ? User.fromJson(res.first) : User(0,0,0,0,0);
  }

  Future<List> allDishes() async{
    final db = await database;
    var res = db.select("select * from Dish");
    return res.map((val){return {"display": val["name"],"value":val["id"]};}).toList();
  }


  Future<Information> getCaloriesBetween(DateTime dateTimeFrom, DateTime dateTimeTo) async {
    final db = await database;
    var res = await db.select(
        "SELECT sum( Dish.calories * Information.amount / 100)/(SELECT count(DISTINCT(DATE(datetime))) from Information ) as calories, "
            "sum( Dish.fat * Information.amount / 100)/(SELECT count(DISTINCT(DATE(datetime))) from Information ) as fat, "
            "sum( Dish.carbohydrates * Information.amount / 100)/(SELECT count(DISTINCT(DATE(datetime))) from Information ) as carbohydrates, "
            "sum( Dish.watter * Information.amount / 100)/(SELECT count(DISTINCT(DATE(datetime))) from Information ) as watter, "
            "sum( Dish.proteins * Information.amount / 100)/(SELECT count(DISTINCT(DATE(datetime))) from Information ) as proteins "
            "FROM Information "
            "JOIN Dish ON Information.dish_id = Dish.id "
            "WHERE Information.datetime > '${dateTimeFrom}' AND Information.datetime < '${dateTimeTo}' ");

    return res.map(
            (item){
          return Information(
              intOrDefault(item["calories"], 0),
              intOrDefault(item["carbohydrates"], 0),
              intOrDefault(item["fat"], 0),
              intOrDefault(item["proteins"], 0),
              intOrDefault(item["watter"], 0));
        }
    ).first;
  }

  Future<List> getCaloriesDaysStatistic(DateTime dateTimeFrom, DateTime dateTimeTo, Information rec) async {
    final db = await database;
    var res = await db.select(
        "SELECT DATE(Information.datetime), sum( Dish.calories * Information.amount / 100 ) as identifier "
                "FROM Information "
                "JOIN Dish ON Information.dish_id = Dish.id "
                "WHERE DATE(Information.datetime) > '${dateTimeFrom}' AND DATE(Information.datetime) < '${dateTimeTo}' "
                "GROUP BY DATE(Information.datetime) "
    );
    var bigger = 0;
    var less = 0;
    for (var i in res.toList()){
      intOrDefault(i['identifier'], 0) < rec.calories ? less++ : bigger++;
    }
    return [bigger.toDouble(), less.toDouble()];
  }

  deleteDB() {}

}
