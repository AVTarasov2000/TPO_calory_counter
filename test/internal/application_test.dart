import 'dart:io';

import 'package:calory_counter/data/pfc_repository.dart';
import 'package:calory_counter/domain/model/information.dart';
import 'package:calory_counter/domain/model/user.dart';
import 'package:calory_counter/presentation/home.dart';
import 'package:flutter_test/flutter_test.dart';


class DBProviderMock extends DBProvider {

  getUser() async {
    print("DBProviderMock");
    return User(0, 50, 170, 20, 2);
  }
}

class DBProviderTest extends DBProvider {

  @override
  Future<String> getPath() async {
    return "test/internal/testDB.db";
  }
}

void main() {
  RecommendationService recommendationService = RecommendationService.service;
  UserService userService = UserService.service;
  RecommendationRepository recommendationRepository = RecommendationRepository
      .repository;

  setUp(() {
    userService.db = DBProviderMock();
    recommendationRepository.dbProvider = DBProviderTest();
  });

  testWidgets('персональный лимит', (WidgetTester tester) async {
    Information asis = await userService.getUserLimit();
    expect(asis.calories, 1642);
    expect(asis.fat, 36);
    expect(asis.proteins, 123);
    expect(asis.carbohydrates, 205);
    expect(asis.watter, 1000);
  });

  testWidgets('рекоммендации по часам', (WidgetTester tester) async {
    Information information = Information(100, 100, 100, 100, 100);
    expect(await recommendationService.getMealRec(information, 11),
        Information(35, 35, 35, 35, 35));
    expect(await recommendationService.getMealRec(information, 14),
        Information(80, 80, 80, 80, 80));
    expect(await recommendationService.getMealRec(information, 18),
        Information(100, 100, 100, 100, 100));
    expect(await recommendationService.getMealRec(information, 21),
        Information(0, 0, 0, 0, 0));
  });
  testWidgets('вектор рекоммендации', (WidgetTester tester) async {
    Information information = Information(100, 100, 100, 100, 100);
    List<Information> dishes = [Information(80, 80, 80, 80, 80)];
    expect(await recommendationService.getMealRecommend(
        information, dishes, DateTime(2021, 11, 8, 11, 35, 11)),
        Information(-45, -45, -45, -45, -45,));
    expect(await recommendationService.getMealRecommend(
        information, dishes, DateTime(2021, 11, 8, 14, 35, 11)),
        Information(0, 0, 0, 0, 0));
    expect(await recommendationService.getMealRecommend(
        information, dishes, DateTime(2021, 11, 8, 18, 35, 11)),
        Information(20, 20, 20, 20, 20));
    expect(await recommendationService.getMealRecommend(
        information, dishes, DateTime(2021, 11, 8, 21, 35, 11)),
        Information(-80, -80, -80, -80, -80,));
  });


  group('тест бд', ()
  {

    test('список блюд по дате', () async {
      final db = await recommendationRepository.dbProvider.database;
      db.rawInsert(
          "INSERT INTO Dish (id,name,proteins,fat,carbohydrates,calories,watter) "
              "VALUES "
              "(7,'картошка', 7, 7, 7, 7, 7),"
              "(8,'котлета', 8, 8, 8, 8, 8),"
              "(9,'макарошки', 9, 9, 9, 9, 9),"
              "(10,'пюрешка', 10, 10, 10, 10, 10)");
      db.rawInsert(
          "INSERT INTO Information (datetime, amount, dish_id)"
              " VALUES ('2021-11-08 11:35:11', 200, 10)");

      expect(await recommendationRepository.getDishes(DateTime(2021, 11, 8)),
          [Information(20, 20, 20, 20, 20)]);
    });

    test('рекомендация блюда', () async {
      final db = await recommendationRepository.dbProvider.database;
      db.rawInsert(
          "INSERT INTO Dish (id,name,calories,proteins,fat,carbohydrates,watter) "
              "VALUES "
              "(7,'картошка', 7, 1, 2, 3, 7),"
              "(8,'котлета', 8, 3, 1, 2, 8),"
              "(9,'макарошки', 9, 2, 3, 1, 9)");
      expect(recommendationRepository.getMostProteins(), "котлета");
      expect(recommendationRepository.getMostFats(), "макарошки");
      expect(recommendationRepository.getMostCarbohidrates(), "картошка");
    });
  });
}