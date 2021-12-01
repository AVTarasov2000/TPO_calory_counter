import 'package:calory_counter/data/pfc_repository.dart';
import 'package:calory_counter/domain/enums/meal.dart';
import 'package:calory_counter/domain/enums/mode.dart';
import 'package:calory_counter/domain/model/information.dart';

class PFCCalculator{
  PFCRepository repository;

  PFCCalculator(this.repository);

  Information day(Mode loss) {
    return repository.getDay();
  }

  Information meal(Meal breakfast, Information mockDayRecommend) {
    return Information(0, 0, 0, 0, 0);
  }
}