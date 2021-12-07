import 'package:calory_counter/data/pfc_repository.dart';
import 'package:calory_counter/domain/model/circular_data_pfc.dart';
import 'package:calory_counter/domain/model/dish.dart';
import 'package:calory_counter/domain/model/information.dart';
import 'package:calory_counter/domain/model/user.dart';
import 'package:calory_counter/presentation/util.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';

class StatisticService {

  static StatisticService? service;

  UserService userService = UserService.service;

  static getStatisticService(){
    service ??= StatisticService();
    return service;
  }

  Future<List> getDayStatistic(DateTime? dateTimeFrom, DateTime? dateTimeTo) async{
    Information inf = await userService.getUserLimit();
    if(dateTimeFrom != null && dateTimeTo != null) {
      return await DBProvider.db.getCaloriesDaysStatistic(dateTimeFrom, dateTimeTo, inf);
    }
    return [0.0,0.0];
  }

  Future<CircularDataPFC> getCalories(DateTime? dateTimeFrom, DateTime? dateTimeTo) async {

    if(dateTimeFrom != null && dateTimeTo != null) {
      Information res = await DBProvider.db.getCaloriesBetween(dateTimeFrom, dateTimeTo);
      return CircularDataPFC("calories", res.calories, Colors.amberAccent);
    }
    if(dateTimeFrom != null) {
      DateTime start = DateTime(dateTimeFrom.year, dateTimeFrom.month, dateTimeFrom.day, 0, 0, 0);
      DateTime end = DateTime(dateTimeFrom.year, dateTimeFrom.month, dateTimeFrom.day, 23, 59, 59);

      Information res = await DBProvider.db.getCaloriesBetween(start, end);
      return CircularDataPFC("calories", res.calories, Colors.amberAccent);
    }
    return CircularDataPFC("calories", 0, Colors.amberAccent);
  }

  Future<CircularDataPFC> getFat(DateTime? dateTimeFrom, DateTime? dateTimeTo) async {

    if(dateTimeFrom != null && dateTimeTo != null) {
      Information res = await DBProvider.db.getCaloriesBetween(dateTimeFrom, dateTimeTo);
      return CircularDataPFC("fat", res.fat, Colors.greenAccent);
    }
    if(dateTimeFrom != null) {
      DateTime start = DateTime(dateTimeFrom.year, dateTimeFrom.month, dateTimeFrom.day, 0, 0, 0);
      DateTime end = DateTime(dateTimeFrom.year, dateTimeFrom.month, dateTimeFrom.day, 23, 59, 59);

      Information res = await DBProvider.db.getCaloriesBetween(start, end);
      return CircularDataPFC("fat", res.fat, Colors.greenAccent);
    }
    return CircularDataPFC("fat", 0, Colors.greenAccent);
  }
  Future<CircularDataPFC> getCarbohydrates(DateTime? dateTimeFrom, DateTime? dateTimeTo) async {

    if(dateTimeFrom != null && dateTimeTo != null) {
      Information res = await DBProvider.db.getCaloriesBetween(dateTimeFrom, dateTimeTo);
      return CircularDataPFC("carbohydrates", res.carbohydrates, Colors.blueGrey);
    }
    if(dateTimeFrom != null) {
      DateTime start = DateTime(dateTimeFrom.year, dateTimeFrom.month, dateTimeFrom.day, 0, 0, 0);
      DateTime end = DateTime(dateTimeFrom.year, dateTimeFrom.month, dateTimeFrom.day, 23, 59, 59);

      Information res = await DBProvider.db.getCaloriesBetween(start, end);
      return CircularDataPFC("carbohydrates", res.carbohydrates, Colors.blueGrey);
    }
    return CircularDataPFC("carbohydrates", 0, Colors.blueGrey);
  }
  Future<CircularDataPFC> getProteins(DateTime? dateTimeFrom, DateTime? dateTimeTo) async {

    if(dateTimeFrom != null && dateTimeTo != null) {
      Information res = await DBProvider.db.getCaloriesBetween(dateTimeFrom, dateTimeTo);
      return CircularDataPFC("proteins", res.proteins, Colors.deepPurple);
    }
    if(dateTimeFrom != null) {
      DateTime start = DateTime(dateTimeFrom.year, dateTimeFrom.month, dateTimeFrom.day, 0, 0, 0);
      DateTime end = DateTime(dateTimeFrom.year, dateTimeFrom.month, dateTimeFrom.day, 23, 59, 59);

      Information res = await DBProvider.db.getCaloriesBetween(start, end);
      return CircularDataPFC("proteins", res.proteins, Colors.deepPurple);
    }
    return CircularDataPFC("proteins", 0, Colors.deepPurple);
  }
  Future<CircularDataPFC> getWatter(DateTime? dateTimeFrom, DateTime? dateTimeTo) async {

    if(dateTimeFrom != null && dateTimeTo != null) {
      Information res = await DBProvider.db.getCaloriesBetween(dateTimeFrom, dateTimeTo);
      return CircularDataPFC("water", res.watter, Colors.blue);
    }
    if(dateTimeFrom != null) {
      DateTime start = DateTime(dateTimeFrom.year, dateTimeFrom.month, dateTimeFrom.day, 0, 0, 0);
      DateTime end = DateTime(dateTimeFrom.year, dateTimeFrom.month, dateTimeFrom.day, 23, 59, 59);

      Information res = await DBProvider.db.getCaloriesBetween(start, end);
      return CircularDataPFC("water", res.watter, Colors.blue);
    }
    return CircularDataPFC("water", 0, Colors.blue);
  }
}

class FoodService {

  static FoodService? service;
  static List foodList = [];

  static getFoodService(){
    if (service == null){
      service = FoodService();
      DBProvider.db.allDishes().then((val){foodList = val;});
    }
    return service;
  }

  saveMeal(List<Dish> meal){
    DBProvider.db.saveMeal(meal, DateTime.now());
  }
  
}


class RecommendationService {

  Map mealRecommend = {
    1: 0.35,
    2: 0.8,
    3: 1.0
  };

  RecommendationService._();

  static RecommendationService service = RecommendationService._();

  RecommendationRepository repository = RecommendationRepository.repository;

  UserService userService = UserService.service;

  Future<String> getRecommendation (DateTime dateTime) async {
    List<Information> dishes = await repository.getDishes(dateTime);
    Information dayLimit = await userService.getUserLimit();
    Information mealRecommend = getMealRecommend(dayLimit, dishes, dateTime);
    List<String> recommendations = await getRecomendations(mealRecommend);
    return joinAll(recommendations);
  }

  Future<List<String>> getRecomendations(Information mealRecommend) async {
    List<String> result = [];
    if (
        mealRecommend.calories < 0 &&
        mealRecommend.fat < 0 &&
        mealRecommend.carbohydrates < 0 &&
        mealRecommend.proteins < 0 &&
        mealRecommend.watter < 0
    ){
      result.add("вам стоит прекратить питание на сегодня \n\n");
      return result;
    }

    if(mealRecommend.calories > 0){
      result.add("вам следует употреблять больше каллорий в пищу \n\n");
    } else if(mealRecommend.calories < 0){
      result.add("вам следует употреблять меньше каллорий в пищу \n\n");
    }

    if (mealRecommend.watter > 0){
      result.add("вам следует употреблять больше воды \n\n");
    } else if (mealRecommend.watter < 0){
      result.add("вам следует употреблять меньше воды \n\n");
    }

    if (mealRecommend.fat > 0){
      result.add("вам следует употреблять больше жиров, напримиер их много в" + await repository.getMostFats()+" \n\n");
    } else if (mealRecommend.fat < 0){
      result.add("вам следует употреблять меньше жиров \n\n");
    }

    if (mealRecommend.carbohydrates > 0){
      result.add("вам следует употреблять больше углеводов, например их много в" + await repository.getMostCarbohidrates()+" \n\n");
    } else if (mealRecommend.carbohydrates < 0){
      result.add("вам следует употреблять меньше углеводов \n\n");
    }

    if (mealRecommend.proteins > 0){
      result.add("вам следует употреблять больше протеинов, например их много в" + await repository.getMostProteins()+" \n\n");
    } else if (mealRecommend.proteins < 0){
      result.add("вам следует употреблять меньше протеинов \n\n");
    }
    return result;
  }

  Information getMealRecommend(Information dayLimit, List<Information> dishes, DateTime dateTime) {
    Information daySum = Information(0,0,0,0,0);
    for (Information i in dishes){
      daySum += i;
    }
    return getMealRec(dayLimit, dateTime.hour) - daySum;
  }

  Information getMealRec(Information information, int hour){
    if(hour < 12){
      return information * mealRecommend[1];
    }
    if(hour < 16){
      return information * mealRecommend[2];
    }
    if(hour < 20){
      return information * mealRecommend[3];
    }
    return information * 0;
  }

}


class RecommendationRepository{

  RecommendationRepository._();
  static final RecommendationRepository repository = RecommendationRepository._();

  DBProvider dbProvider = DBProvider.db;


  saveUser(User user) async {
    final db = await dbProvider.database;
  }

  Future<List<Information>> getDishes(DateTime dateTime) async {
    final db = await dbProvider.database;
    var start = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime(dateTime.year, dateTime.month, dateTime.day, 0, 0, 0));
    var end = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime(dateTime.year, dateTime.month, dateTime.day, 23, 59, 59));
    var res = await db.select(
        "SELECT Dish.*, Information.* "
            "FROM Information "
            "JOIN Dish ON Information.dish_id = Dish.id "
            "WHERE Information.datetime > '${start}' AND Information.datetime < '${end}' ");

    return res.map((item){
      double amountCoef = intOrDefault(item["amount"], 0) / 100;
      return Information(
          intOrDefault(item["calories"], 0) * amountCoef,
          intOrDefault(item["carbohydrates"], 0) * amountCoef,
          intOrDefault(item["fat"], 0) * amountCoef,
          intOrDefault(item["proteins"], 0) * amountCoef,
          intOrDefault(item["watter"], 0) * amountCoef);
    }).toList();
  }

  Future<String> getMostFats() async {
    final db = await dbProvider.database;
    var res = await db.select(
        "SELECT name "
            "FROM Dish "
            "Order By fat "
            "DESC "
            "LIMIT 1");
    return res.first["name"].toString();
  }

  Future<String> getMostCarbohidrates() async {
    final db = await dbProvider.database;
    var res = await db.select(
        "SELECT name "
            "FROM Dish "
            "Order By carbohydrates "
            "DESC "
            "LIMIT 1");
    return res.first["name"].toString();
  }

  Future<String> getMostProteins() async {
    final db = await dbProvider.database;
    var res = await db.select(
        "SELECT name "
            "FROM Dish "
            "Order By proteins "
            "DESC "
            "LIMIT 1");
    return res.first["name"].toString();
  }

}


class UserService {

  UserService._();

  DBProvider db = DBProvider.db;

  Map modes = {
    1:0.9,
    2:1,
    3:1.1
  };

  static UserService service = UserService._();

  Future<User> getUser() async{
    return await db.getUser();
  }

  save(User user){
    db.saveUser(user);
    return user;
  }

  Future<Information> getUserLimit() async {
    User user = await getUser();
    Information limit = Information(0,0,0,0,0);
    limit.calories = ((10 * user.weight + 6.25 * user.height / 100 + 5*user.age - 161)*modes[user.mode]).roundToDouble();
    limit.carbohydrates = (limit.calories * 0.5 / 4 * modes[user.mode]).roundToDouble();
    limit.proteins = (limit.calories * 0.3 / 4 * modes[user.mode]).roundToDouble();
    limit.fat = (limit.calories * 0.2 / 9 * modes[user.mode]).roundToDouble();
    limit.watter = 1000;
    return limit;
  }
}