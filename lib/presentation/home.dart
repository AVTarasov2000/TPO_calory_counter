
import 'package:calory_counter/data/pfc_repository.dart';
import 'package:calory_counter/domain/model/circular_data_pfc.dart';
import 'package:calory_counter/domain/model/user.dart';
import 'package:flutter/material.dart';

class StatisticService {

  static StatisticService? service = null;

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

  static FoodService? service = null;

  static getFoodService(){
    service ??= FoodService();
    return service;
  }

  getFood() {
    return [
      {
        "display": "Running",
        "value": "Running1",
      },
      {
        "display": "Running",
        "value": "Running",
      },
      {
        "display": "Climbing",
        "value": "Climbing",
      },
      {
        "display": "Walking",
        "value": "Walking",
      },
      {
        "display": "Swimming",
        "value": "Swimming",
      },
      {
        "display": "Soccer Practice",
        "value": "Soccer Practice",
      },
      {
        "display": "Baseball Practice",
        "value": "Baseball Practice",
      },
      {
        "display": "Football Practice",
        "value": "Football Practice",
      },
    ];
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
    var userValue = await DBProvider.db.getUser();
    return userValue;
  }

  save(User user){
    DBProvider.db.saveUser(user);
    return user;
  }
}
