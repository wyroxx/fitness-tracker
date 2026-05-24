import 'package:fitness_tracker/features/workout_editor/presentation/workout_editor.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ExerciseCard extends StatelessWidget {
  final String title;
  final int id;
  final String description;

  const ExerciseCard({
    super.key,
    required this.title,
    required this.description,
    required this.id,
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
          onTap: () async {
            final session = await showSetsDialog(context, title, id);
            if (session == null || !context.mounted) {
              return;
            }
            context.pop(session);
          },
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
