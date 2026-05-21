import 'package:fitness_tracker/features/exercises/data/models/muscle_group.dart';

abstract interface class MuscleGroupsRepository {
  Future<List<MuscleGroup>> getMuscleGroups();
}
