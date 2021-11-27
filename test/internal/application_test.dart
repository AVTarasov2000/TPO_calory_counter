import 'package:calory_counter/data/pfc_repository.dart';
import 'package:calory_counter/domain/enums/meal.dart';
import 'package:calory_counter/domain/enums/mode.dart';
import 'package:calory_counter/domain/model/information.dart';
import 'package:calory_counter/domain/model/recommendation.dart';
import 'package:calory_counter/internal/aplication.dart';
import 'package:calory_counter/internal/pfc_counter.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {

  CaloriesDeficitCounter caloriesDeficitCounter = CaloriesDeficitCounter();
  double proteins = 2000;
  double fat = 250;
  double carbohydrates = 44;
  double calories = 150;
  Information mockDayRecommend = Information(proteins, fat, carbohydrates, calories);
  PFCRepository pfcRepository = MockPFCRepository(mockDayRecommend);
  PFCCalculator pfcCalculator = PFCCalculator(pfcRepository);



  setUp(() {

  });

  testWidgets('до 12 часов/до первого и до второго приема пищи', (WidgetTester tester) async {

    Information dayInformation = Information(0, 0, 0, 0);
    Information lack = Information(0, 0, 0, 0);
    Information dayRecommend = Information(2000, 250, 44, 150);
    Recommendation recommendation = Recommendation(lack, dayRecommend);
    DateTime timeOfDay = DateTime.parse("2020-10-10 11:18:04Z");
    expect(caloriesDeficitCounter.recommend(dayInformation, timeOfDay), recommendation);
  });

  testWidgets('с 12 до 16 часов/после первого и до второго приема пищи', (WidgetTester tester) async {

    Information dayInformation = Information(500, 62.5, 11, 37.5);
    Information lack = Information(200, 25, 4.4, 15);
    Information dayRecommend = Information(1300, 162.5, 28.6, 97.5);
    Recommendation recommendation = Recommendation(lack, dayRecommend);
    DateTime timeOfDay = DateTime.parse("2020-10-10 14:18:04Z");
    expect(caloriesDeficitCounter.recommend(dayInformation, timeOfDay), recommendation);
  });

  testWidgets('с 16 до 20 часов/после второго и до второго приема пищи', (WidgetTester tester) async {

    Information dayInformation = Information(1400, 175, 31, 105);
    Information lack = Information(200, 25, 4.4, 15);
    Information dayRecommend = Information(400, 50, 8.6, 30);
    Recommendation recommendation = Recommendation(lack, dayRecommend);
    DateTime timeOfDay = DateTime.parse("2020-10-10 18:18:04Z");
    expect(caloriesDeficitCounter.recommend(dayInformation, timeOfDay), recommendation);
  });

  testWidgets('после 20 часов/после третьего и до второго приема пищи', (WidgetTester tester) async {

    Information dayInformation = Information(1800, 225, 39.6, 135);
    Information lack = Information(200, 25, 4.4, 15);
    Information dayRecommend = Information(0, 0, 0, 0);
    Recommendation recommendation = Recommendation(lack, dayRecommend);
    DateTime timeOfDay = DateTime.parse("2020-10-10 21:18:04Z");
    expect(caloriesDeficitCounter.recommend(dayInformation, timeOfDay), recommendation);
  });

  testWidgets('рассчет бжу на день', (WidgetTester tester) async {
    double loss = 0.9;
    double increase = 1.1;
    expect(pfcCalculator.day(Mode.LOSS), Information(proteins*loss, fat*loss, carbohydrates*loss, calories*loss));
    expect(pfcCalculator.day(Mode.KEEP), mockDayRecommend);
    expect(pfcCalculator.day(Mode.INCREASING), Information(proteins*increase, fat*increase, carbohydrates*increase, calories*increase));
  });

  testWidgets('бжу на день на завтрак обед ужин', (WidgetTester tester) async {
    double breakfast = 0.35;
    double lunch = 0.45;
    double dinner = 0.2;
    expect(pfcCalculator.meal(Meal.BREAKFAST, mockDayRecommend), Information(proteins*breakfast, fat*breakfast, carbohydrates*breakfast, calories*breakfast));
    expect(pfcCalculator.meal(Meal.LUNCH, mockDayRecommend), Information(proteins*lunch, fat*lunch, carbohydrates*lunch, calories*lunch));
    expect(pfcCalculator.meal(Meal.DINNER, mockDayRecommend), Information(proteins*dinner, fat*dinner, carbohydrates*dinner, calories*dinner));
  });


}
