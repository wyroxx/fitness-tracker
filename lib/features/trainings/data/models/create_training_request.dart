import 'package:fitness_tracker/features/trainings/data/models/workout_session.dart';

class CreateTrainingRequest {
  final String title;
  final List<WorkoutSession> sessions;

  const CreateTrainingRequest({required this.title, required this.sessions});

  Map<String, dynamic> toJson() => {
    'title': title,
    'sessions': sessions.map((session) => session.toJson()).toList(),
  };
}
