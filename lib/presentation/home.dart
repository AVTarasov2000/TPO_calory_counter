
import 'package:calory_counter/data/pfc_repository.dart';
import 'package:calory_counter/domain/model/circular_data_pfc.dart';
import 'package:calory_counter/domain/model/dish.dart';
import 'package:calory_counter/domain/model/user.dart';
import 'package:flutter/material.dart';

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
    DBProvider.db.saveMeal(meal);
  }
  
}


class RecommendationService {

  static RecommendationService? service;
  static RecommendationService getRecommendationService() {
    service ??= RecommendationService();
    return service!;
  }

  getRecommendation(DateTime dateTime){
    return "рекоммендация";
  }
}


class UserService {
  static UserService? service;
  static UserService getUserService() {
    service ??= UserService();
    return service!;
  }

  Future<User> getUser() async{
    return await DBProvider.db.getUser();
  }

  save(User user){
    DBProvider.db.saveUser(user);
    return user;
  }
}
