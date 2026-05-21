import 'package:fitness_tracker/features/trainings/data/models/workout_set.dart';

class WorkoutSession {
  final String exerciseTitle;
  final List<WorkoutSet> sets;

  const WorkoutSession({required this.exerciseTitle, required this.sets});

  factory WorkoutSession.fromJson(Map<String, dynamic> json) {
    final sets = json['sets'] as List<dynamic>? ?? [];
    final workoutType = json['workout_type'] as Map<String, dynamic>;
    return WorkoutSession(
      exerciseTitle: workoutType['name'] as String,
      sets: sets
          .map((json) => WorkoutSet.fromJson(json as Map<String, dynamic>))
          .toList(),
    );
  }
}
