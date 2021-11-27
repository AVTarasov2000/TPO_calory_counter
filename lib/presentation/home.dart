
import 'package:calory_counter/domain/model/circular_data_pfc.dart';
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