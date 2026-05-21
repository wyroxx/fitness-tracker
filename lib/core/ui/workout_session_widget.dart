import 'package:fitness_tracker/app/theme/app_colors.dart';
import 'package:fitness_tracker/app/theme/app_text_styles.dart';
import 'package:fitness_tracker/features/trainings/data/models/workout_session.dart';
import 'package:fitness_tracker/features/trainings/data/models/workout_set.dart';
import 'package:flutter/material.dart';

class WorkoutSessionWidget extends StatelessWidget {
  final WorkoutSession session;
  final int index;
  final bool isExpanded;
  final VoidCallback onPressed;

  const WorkoutSessionWidget({
    super.key,
    required this.session,
    required this.index,
    required this.onPressed,
    required this.isExpanded,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$index. ${session.exerciseTitle} x${session.sets.length}',
                style: AppTextStyles.bodyMuted.copyWith(
                  fontWeight: FontWeight.normal,
                ),
              ),
              AnimatedRotation(
                turns: isExpanded ? 0.25 : 0,
                duration: const Duration(milliseconds: 250),
                child: const Icon(
                  Icons.chevron_right,
                  color: AppColors.textSecondary,
                  size: 24,
                ),
              ),
            ],
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          alignment: Alignment.topLeft,
          child: isExpanded
              ? Padding(
                  padding: const EdgeInsets.only(left: 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (int i = 0; i < session.sets.length; i++)
                        Text(
                          'Set ${i + 1}: ${_formatSet(session.sets[i])}',
                          style: AppTextStyles.bodyMuted.copyWith(
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                    ],
                  ),
                )
              : const SizedBox(
                width: double.infinity,
                height: 0,
              ),
        ),
      ],
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

    if (parts.isEmpty) {
      return 'No metrics';
    }

    return parts.join(' x ');
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
