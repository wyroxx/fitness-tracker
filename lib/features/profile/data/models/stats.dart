class UserStats {
  static const emptySuggestion = 'No insight yet. Add workouts to get one.';
  static const emptyLastTrainingDate = 'No trainings yet';

  final int totalWorkouts;
  final String suggestion;
  final String lastTrainingDate;
  final int trainingsThisWeek;
  final int totalExerciseSessions;

  const UserStats({
    required this.totalWorkouts,
    required this.suggestion,
    required this.lastTrainingDate,
    required this.trainingsThisWeek,
    required this.totalExerciseSessions,
  });

  factory UserStats.fromJson(Map<String, dynamic> json) => UserStats(
    totalWorkouts: json['total_workouts'] as int? ?? 0,
    suggestion: _readString(json['ai_insight'], emptySuggestion),
    lastTrainingDate: _readString(
      json['last_training_at'],
      emptyLastTrainingDate,
    ),
    trainingsThisWeek: json['trainings_this_week'] as int? ?? 0,
    totalExerciseSessions: json['total_exercise_sessions'] as int? ?? 0,
  );
}

String _readString(Object? value, String fallback) {
  if (value is String && value.trim().isNotEmpty) {
    return value;
  }

  return fallback;
}
