import 'package:fitness_tracker/app/theme/app_colors.dart';
import 'package:fitness_tracker/features/trainings/data/models/workout_session.dart';
import 'package:fitness_tracker/features/trainings/data/models/workout_set.dart';
import 'package:flutter/material.dart';

class WorkoutSessionSummaryCard extends StatelessWidget {
  final WorkoutSession session;

  const WorkoutSessionSummaryCard({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE1E1E1), width: 1.6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${session.exerciseTitle} x${session.sets.length}',
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          for (int i = 0; i < session.sets.length; i++)
            Padding(
              padding: EdgeInsets.only(top: i == 0 ? 0 : 4),
              child: Text(
                'Set ${i + 1}: ${_formatSet(session.sets[i])}',
                style: const TextStyle(
                  color: AppColors.hint,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _formatSet(WorkoutSet set) {
    final parts = <String>[];

    if (set.weight != null) {
      parts.add('${set.weight}kg');
    }
    if (set.reps != null) {
      parts.add('${set.reps}');
    }
    if (set.distanceMeters != null) {
      parts.add('${set.distanceMeters}m');
    }
    if (set.durationSeconds != null) {
      parts.add(_formatDuration(set.durationSeconds!));
    }

    return parts.isEmpty ? 'No metrics' : parts.join(' x ');
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;

    if (minutes == 0) {
      return '${remainingSeconds}s';
    }

    return '${minutes}m ${remainingSeconds}s';
  }
}
