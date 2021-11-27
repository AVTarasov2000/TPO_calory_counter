import 'dart:ffi';

import 'package:calory_counter/domain/model/information.dart';

class Recommendation {

  Information lack;
  Information dayRecommend;

  Recommendation(this.lack, this.dayRecommend);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Recommendation &&
          runtimeType == other.runtimeType &&
          lack == other.lack &&
          dayRecommend == other.dayRecommend;

  @override
  int get hashCode => lack.hashCode ^ dayRecommend.hashCode;
}