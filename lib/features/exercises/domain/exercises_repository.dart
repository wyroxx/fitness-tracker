import 'package:fitness_tracker/features/exercises/data/models/exercise.dart';

abstract interface class ExercisesRepository {
  Future<List<Exercise>> getExercises(int muscleGroupId);
}
