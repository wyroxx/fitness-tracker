import 'package:fitness_tracker/core/utils/date_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('returns original value when date cannot be parsed', () {
    expect(formatTrainingDate('not-a-date'), 'not-a-date');
  });
}
