import 'package:fitness_tracker/features/profile/data/models/stats.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserStats', () {
    test('parses stats from json', () {
      final stats = UserStats.fromJson({
        'total_workouts': 12,
        'ai_insight': 'Add more rest between heavy sessions.',
        'last_training_at': '2026-05-25T10:00:00Z',
        'trainings_this_week': 3,
        'total_exercise_sessions': 24,
      });

      expect(stats.totalWorkouts, 12);
      expect(stats.suggestion, 'Add more rest between heavy sessions.');
      expect(stats.lastTrainingDate, '2026-05-25T10:00:00Z');
      expect(stats.trainingsThisWeek, 3);
      expect(stats.totalExerciseSessions, 24);
    });

    test('uses fallbacks for nullable stats response fields', () {
      final stats = UserStats.fromJson({
        'total_workouts': null,
        'ai_insight': null,
        'last_training_at': null,
        'trainings_this_week': null,
        'total_exercise_sessions': null,
      });

      expect(stats.totalWorkouts, 0);
      expect(stats.suggestion, UserStats.emptySuggestion);
      expect(stats.lastTrainingDate, UserStats.emptyLastTrainingDate);
      expect(stats.trainingsThisWeek, 0);
      expect(stats.totalExerciseSessions, 0);
    });
  });
}
