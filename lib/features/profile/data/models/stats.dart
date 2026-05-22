class UserStats {
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
    totalWorkouts: json['total_workouts'] as int,
    suggestion: json['ai_insight'] as String,
    lastTrainingDate: json['last_training_at'] as String,
    trainingsThisWeek: json['trainings_this_week'] as int,
    totalExerciseSessions: json['total_exercise_sessions'] as int,
  );
}
