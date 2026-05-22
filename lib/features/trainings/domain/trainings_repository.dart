import 'package:fitness_tracker/features/trainings/data/models/training.dart';

abstract interface class TrainingsRepository {
  Future<List<Training>> getTrainings();
  Future<void> createTraining(Training training);
}
