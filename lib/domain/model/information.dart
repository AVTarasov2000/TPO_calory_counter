import 'dart:ffi';

class Information {
  double proteins = 0;
  double fat = 0;
  double carbohydrates = 0;
  double calories = 0;

  Information (this.calories, this.carbohydrates, this.fat, this.proteins);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Information &&
          runtimeType == other.runtimeType &&
          proteins == other.proteins &&
          fat == other.fat &&
          carbohydrates == other.carbohydrates &&
          calories == other.calories;

  @override
  int get hashCode =>
      proteins.hashCode ^
      fat.hashCode ^
      carbohydrates.hashCode ^
      calories.hashCode;
}