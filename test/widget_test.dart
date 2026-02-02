

import 'package:faida_pos/utils/transaction_utils/week_dates.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  test('get the day today', () {
    final result = WeekDates().getWeekDates(DateTime.now());
    assert(result.isNotEmpty, DateTime.monday);
  });
}
