import 'package:fitness_tracker/app/theme/app_colors.dart';
import 'package:fitness_tracker/app/theme/app_text_styles.dart';
import 'package:fitness_tracker/core/ui/adaptive_dialog.dart';
import 'package:fitness_tracker/core/ui/snack_bar.dart';
import 'package:fitness_tracker/features/profile/data/profile_repository_impl.dart';
import 'package:fitness_tracker/features/trainings/data/models/training.dart';
import 'package:fitness_tracker/features/trainings/data/trainings_repository_impl.dart';
import 'package:fitness_tracker/features/trainings/presentation/widgets/workout_session_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TrainingCard extends ConsumerStatefulWidget {
  final Training training;

  const TrainingCard({super.key, required this.training});

  @override
  ConsumerState<TrainingCard> createState() => _TrainingCardState();
}

class _TrainingCardState extends ConsumerState<TrainingCard> {
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
    final id = widget.training.id;
    return Slidable(
      key: ValueKey(id),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.25,
        children: [
          CustomSlidableAction(
            onPressed: (_) async {
              final confirmed = await showAdaptiveConfirmationDialog(
                context,
                title: 'Delete training?',
                message: 'This workout will be permanently deleted.',
                confirmText: 'Delete',
                isDestructive: true,
              );

              if (!confirmed || !context.mounted) {
                return;
              }

              try {
                await ref.read(trainingsRepositoryProvider).deleteTraining(id);
                ref.invalidate(trainingsProvider);
                ref.invalidate(profileDataProvider);
                if (context.mounted) {
                  showAppToast(
                    context,
                    message: 'Training was deleted',
                    type: AppToastType.success,
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  showAppToast(
                    context,
                    message: 'Could not delete training',
                    type: AppToastType.error,
                  );
                }
              }
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            borderRadius: BorderRadius.circular(16),
            child: const Icon(
              CupertinoIcons.delete,
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
      child: Container(
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
                      color: AppColors.textSecondary,
                    ),
                  ),
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
      ),
    );
  }
}
