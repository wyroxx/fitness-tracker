import 'package:intl/intl.dart';

String formatTrainingDate(String value) {
  final dateTime = DateTime.tryParse(value)?.toLocal();
  if (dateTime == null) {
    return value;
  }

  return DateFormat('MMM d, EEE').format(dateTime);
}
