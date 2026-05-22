import 'package:fitness_tracker/features/workout_editor/presentation/workout_editor.dart';
import 'package:flutter/material.dart';

class ExerciseCard extends StatelessWidget {
  final String title;
  final String description;

  const ExerciseCard({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => showSetsDialog(context, title),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(fontSize: 15, color: Colors.black45),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
