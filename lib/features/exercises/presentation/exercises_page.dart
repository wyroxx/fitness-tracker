import 'package:fitness_tracker/core/ui/exercise_card.dart';
import 'package:fitness_tracker/features/exercises/data/exercises_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ExercisesPage extends ConsumerWidget {
  final int muscleGroupId;
  final String title;

  const ExercisesPage({
    super.key,
    required this.muscleGroupId,
    required this.title,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exercisesAsync = ref.watch(exercisesProvider(muscleGroupId));
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.chevron_left_rounded, size: 32),
        ),
      ),
      body: exercisesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            const Center(child: Text('Something went wrong')),
        data: (exercises) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView.separated(
            itemBuilder: (context, index) => ExerciseCard(
              title: exercises[index].name,
              description: exercises[index].description,
            ),
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemCount: exercises.length,
          ),
        ),
      ),
    );
  }
}
