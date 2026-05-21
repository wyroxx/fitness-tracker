import 'package:fitness_tracker/core/utils/date_formatter.dart';
import 'package:fitness_tracker/features/trainings/data/models/workout_session.dart';

class Training {
  final String title;
  final String date;
  final List<WorkoutSession> sessions;

  const Training({
    required this.title,
    required this.date,
    required this.sessions,
  });

  factory Training.fromJson(Map<String, dynamic> json) {
    final sessions = json['sessions'] as List<dynamic>? ?? [];
    return Training(
      title: json['title'] as String,
      date: formatTrainingDate(json['created_at'] as String),
      sessions: sessions
          .map((json) => WorkoutSession.fromJson(json as Map<String, dynamic>))
          .toList(),
    );
  }
}
