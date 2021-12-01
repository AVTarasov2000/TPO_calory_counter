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

  static getStatisticService(){
    service ??= StatisticService();
    return service;
  }

  CircularDataPFC calories = CircularDataPFC("calories", 9, Colors.amberAccent);
  CircularDataPFC fat = CircularDataPFC("fat", 9, Colors.greenAccent);
  CircularDataPFC carbohydrates = CircularDataPFC("carbohydrates", 9, Colors.blueGrey);
  CircularDataPFC proteins = CircularDataPFC("proteins", 9, Colors.deepPurple);
  CircularDataPFC water = CircularDataPFC("water", 9, Colors.blue);

  getCalories(DateTime dateTime) {
    return CircularDataPFC("calories", dateTime.day.toDouble(), Colors.amberAccent);
    // return calories;
  }

  getFat(DateTime dateTime) {
    return fat;
  }

  getCarbohydrates(DateTime dateTime) {
    return carbohydrates;
  }

  getProteins(DateTime dateTime) {
    return proteins;
  }

  getWater(DateTime dateTime) {
    return water;
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
      result.add("вам стоит прекратить питание на сегодня \n");
      return result;
    }

    if(mealRecommend.calories > 0){
      result.add("вам следует употреблять больше каллорий в пищу \n");
    } else if(mealRecommend.calories < 0){
      result.add("вам следует употреблять меньше каллорий в пищу \n");
    }

    if (mealRecommend.watter > 0){
      result.add("вам следует употреблять больше воды \n");
    } else if (mealRecommend.watter < 0){
      result.add("вам следует употреблять меньше воды \n");
    }

    if (mealRecommend.fat > 0){
      result.add("вам следует употреблять больше жиров, напримиер их много в" + await repository.getMostFats()+" \n");
    } else if (mealRecommend.fat < 0){
      result.add("вам следует употреблять меньше жиров \n");
    }

    if (mealRecommend.carbohydrates > 0){
      result.add("вам следует употреблять больше углеводов, например их много в" + await repository.getMostCarbohidrates()+" \n");
    } else if (mealRecommend.carbohydrates < 0){
      result.add("вам следует употреблять меньше углеводов \n");
    }

    if (mealRecommend.proteins > 0){
      result.add("вам следует употреблять больше протеинов, например их много в" + await repository.getMostProteins()+" \n");
    } else if (mealRecommend.proteins < 0){
      result.add("вам следует употреблять меньше протеинов \n");
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
    var res = await db.rawQuery(
        "SELECT d.id, d.amount, d.name, d.proteins, d.fat, d.carbohydrates, d.calories, d.watter"
        "FROM Information i"
            "JOIN Dish d ON i.dish_id = d.id"
            "WHERE i.datetime > '${start}' AND i.datetime < ${end} ");

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
    var res = await db.rawQuery(
        "SELECT name "
            "FROM Dish "
            "Order By fat "
            "LIMIT 1");
    return res.first["name"].toString();
  }

  Future<String> getMostCarbohidrates() async {
    final db = await dbProvider.database;
    var res = await db.rawQuery(
        "SELECT name "
            "FROM Dish "
            "Order By carbohydrates "
            "LIMIT 1");
    return res.first["name"].toString();
  }

  Future<String> getMostProteins() async {
    final db = await dbProvider.database;
    var res = await db.rawQuery(
        "SELECT name "
            "FROM Dish "
            "Order By proteins "
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