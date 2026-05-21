import 'package:fitness_tracker/app/theme/app_colors.dart';
import 'package:fitness_tracker/app/theme/app_text_styles.dart';
import 'package:fitness_tracker/core/ui/workout_session_widget.dart';
import 'package:fitness_tracker/features/trainings/data/models/training.dart';
import 'package:flutter/material.dart';

class TrainingCard extends StatefulWidget {
  final Training training;

  const TrainingCard({super.key, required this.training});

  @override
  State<TrainingCard> createState() => _TrainingCardState();
}

class _TrainingCardState extends State<TrainingCard> {
  final Set<int> _expandedIndexes = {};

  void _expand(int index) {
    setState(() {
      if (_expandedIndexes.contains(index)) {
        _expandedIndexes.remove(index);
      } else {
        _expandedIndexes.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.training.title,
                  style: AppTextStyles.sectionTitle,
                ),
                Text(
                  widget.training.date,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary
                  ),
                )
              ],
            ),
            ...List.generate(
              widget.training.sessions.length,
              (index) => WorkoutSessionWidget(
                session: widget.training.sessions[index],
                index: index + 1,
                isExpanded: _expandedIndexes.contains(index),
                onPressed: () => _expand(index),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
