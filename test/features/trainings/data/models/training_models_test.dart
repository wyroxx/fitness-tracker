import 'package:fitness_tracker/features/trainings/data/models/create_training_request.dart';
import 'package:fitness_tracker/features/trainings/data/models/training.dart';
import 'package:fitness_tracker/features/trainings/data/models/workout_session.dart';
import 'package:fitness_tracker/features/trainings/data/models/workout_set.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('training models', () {
    test('serializes create training request without id or date', () {
      const request = CreateTrainingRequest(
        title: 'Pull day',
        sessions: [
          WorkoutSession(
            exerciseTitle: 'Pull ups',
            workoutTypeId: 7,
            sets: [
              WorkoutSet(
                reps: 12,
                weight: null,
                distanceMeters: null,
                durationSeconds: null,
              ),
            ],
          ),
        ],
      );

      expect(request.toJson(), {
        'title': 'Pull day',
        'sessions': [
          {
            'workout_type_id': 7,
            'sets': [
              {
                'reps': 12,
                'weight_kg': null,
                'distance_meters': null,
                'duration_seconds': null,
              },
            ],
          },
        ],
      });
    });

    test('parses training with sessions from json', () {
      final training = Training.fromJson({
        'id': 42,
        'title': 'Pull day',
        'created_at': '2026-05-25T10:00:00Z',
        'sessions': [
          {
            'workout_type_id': 7,
            'workout_type': {'name': 'Pull ups'},
            'sets': [
              {
                'reps': 12,
                'weight_kg': null,
                'distance_meters': null,
                'duration_seconds': null,
              },
            ],
          },
        ],
      });

      expect(training.id, 42);
      expect(training.title, 'Pull day');
      expect(training.sessions, hasLength(1));
      expect(training.sessions.single.exerciseTitle, 'Pull ups');
      expect(training.sessions.single.sets.single.reps, 12);
    });

    test('uses empty sessions when sessions key is missing', () {
      final training = Training.fromJson({
        'id': 1,
        'title': 'Empty workout',
        'created_at': '2026-05-25T10:00:00Z',
      });

      expect(training.sessions, isEmpty);
    });
  });
}
