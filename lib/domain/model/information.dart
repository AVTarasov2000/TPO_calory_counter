import 'dart:ffi';

class Information {
  double proteins = 0;
  double fat = 0;
  double carbohydrates = 0;
  double calories = 0;
  double watter = 0;

  Information (this.calories, this.carbohydrates, this.fat, this.proteins, this.watter);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Information &&
          runtimeType == other.runtimeType &&
          proteins == other.proteins &&
          fat == other.fat &&
          carbohydrates == other.carbohydrates &&
          calories == other.calories &&
          watter == other.watter;

  Information operator +(Information other) =>
      Information(
          calories + other.calories,
          carbohydrates + other.carbohydrates,
          fat + other.fat,
          proteins + other.proteins,
          watter + other.watter
      );

  Information operator -(Information other) =>
      Information(
          calories - other.calories,
          carbohydrates - other.carbohydrates,
          fat - other.fat,
          proteins - other.proteins,
          watter - other.watter
      );


  Information operator *(double other) =>
      Information(
        (calories * other).roundToDouble(),
        (carbohydrates * other).roundToDouble(),
        (fat * other).roundToDouble(),
        (proteins * other).roundToDouble(),
        (watter * other).roundToDouble()
      );

  @override
  int get hashCode =>
      proteins.hashCode ^
      fat.hashCode ^
      carbohydrates.hashCode ^
      calories.hashCode;

  @override
  String toString() {
    return 'Information{proteins: $proteins, fat: $fat, carbohydrates: $carbohydrates, calories: $calories, watter: $watter}';
  }
}