import 'package:fitness_tracker/features/trainings/data/models/create_training_request.dart';
import 'package:fitness_tracker/features/trainings/data/models/training.dart';

abstract interface class TrainingsRepository {
  Future<List<Training>> getTrainings();
  Future<void> createTraining(CreateTrainingRequest request);
  Future<void> deleteTraining(int id);
}
