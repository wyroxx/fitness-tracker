import 'package:fitness_tracker/features/exercises/data/muscle_groups_repository_impl.dart';
import 'package:fitness_tracker/features/exercises/presentation/widgets/muscle_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MuscleGroupsPage extends ConsumerWidget {
  const MuscleGroupsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupsAsync = ref.watch(muscleGroupsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercises'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.chevron_left_rounded, size: 32),
        ),
      ),
      body: groupsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            const Center(child: Text('Something went wrong...')),
        data: (groups) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsetsGeometry.symmetric(
                horizontal: 45,
                vertical: 16,
              ),
              child: Text(
                'Muscle groups',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  final firstIndex = index * 2;
                  final secondIndex = firstIndex + 1;
                  final hasSecondCard = secondIndex < groups.length;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MuscleCard(
                        title: groups[firstIndex].name,
                        id: groups[firstIndex].id,
                        size: 144,
                      ),
                      if (hasSecondCard) const SizedBox(width: 16),
                      if (hasSecondCard)
                        MuscleCard(
                          title: groups[secondIndex].name,
                          id: groups[secondIndex].id,
                          size: 144,
                        ),
                    ],
                  );
                },
                separatorBuilder: (_, _) => const SizedBox(height: 16),
                itemCount: (groups.length / 2).ceil(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
