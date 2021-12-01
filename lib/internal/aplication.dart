
import 'package:calory_counter/domain/model/information.dart';
import 'package:calory_counter/domain/model/recommendation.dart';


class CaloriesDeficitCounter {

  CaloriesDeficitCounter();


  Recommendation recommend(Information dayInformation, DateTime timeOfDay){
    return Recommendation(Information(0,0,0,0,0), Information(0,0,0,0,0));
  }
}