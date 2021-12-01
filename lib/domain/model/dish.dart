import 'package:calory_counter/domain/model/information.dart';

class Dish{

  int id;
  String name;
  num amount;
  Information information = Information(0,0,0,0,0);

  Dish(this.id, this.name, this.amount);


}