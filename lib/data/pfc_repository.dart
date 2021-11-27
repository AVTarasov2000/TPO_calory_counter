import 'package:calory_counter/domain/model/information.dart';

class PFCRepository{
  Information getDay() {
    return Information(0, 0, 0, 0);
  }

}

class MockPFCRepository extends PFCRepository{
  Information mockDay;

  MockPFCRepository(this.mockDay);
}