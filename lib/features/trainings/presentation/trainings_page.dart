import 'package:fitness_tracker/core/ui/add_button.dart';
import 'package:fitness_tracker/features/trainings/data/trainings_repository_impl.dart';
import 'package:fitness_tracker/features/trainings/presentation/widgets/training_card.dart';
import 'package:fitness_tracker/features/workout_editor/presentation/workout_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TrainingsPage extends ConsumerWidget {
  const TrainingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trainingsAsync = ref.watch(trainingsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('My Trainings')),
      body: trainingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            const Center(child: Text('Something went wrong...')),
        data: (trainings) => Padding(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 20,
          ),
          child: ListView.separated(
            itemBuilder: (context, index) =>
                TrainingCard(training: trainings[index]),
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemCount: trainings.length,
          ),
        ),
      ),
      floatingActionButton: AddButton(
        size: 60,
        onPressed: () => showModal(context),
      ),
    );
  }
}
