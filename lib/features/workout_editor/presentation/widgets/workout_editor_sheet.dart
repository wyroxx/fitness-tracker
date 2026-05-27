import 'package:fitness_tracker/app/theme/app_colors.dart';
import 'package:fitness_tracker/app/theme/app_text_styles.dart';
import 'package:fitness_tracker/core/ui/primary_button.dart';
import 'package:fitness_tracker/core/ui/snack_bar.dart';
import 'package:fitness_tracker/features/profile/data/profile_repository_impl.dart';
import 'package:fitness_tracker/features/trainings/data/models/create_training_request.dart';
import 'package:fitness_tracker/features/trainings/data/models/workout_session.dart';
import 'package:fitness_tracker/features/trainings/data/trainings_repository_impl.dart';
import 'package:fitness_tracker/features/workout_editor/presentation/widgets/workout_session_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class WorkoutEditorSheet extends ConsumerStatefulWidget {
  const WorkoutEditorSheet({super.key});

  @override
  ConsumerState<WorkoutEditorSheet> createState() => _WorkoutEditorSheetState();
}

class _WorkoutEditorSheetState extends ConsumerState<WorkoutEditorSheet> {
  final _titleController = TextEditingController();
  final List<WorkoutSession> _sessions = [];

  bool _isSaving = false;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _addExercise() async {
    final session = await context.push<WorkoutSession>('/exercises');

    if (session == null || !mounted) {
      return;
    }

    setState(() {
      _sessions.add(session);
    });
  }

  Future<void> _save() async {
    if (_sessions.isEmpty || _isSaving) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final title = _titleController.text.trim();
    final request = CreateTrainingRequest(
      title: title.isEmpty ? 'New workout' : title,
      sessions: List.unmodifiable(_sessions),
    );

    try {
      await ref.read(trainingsRepositoryProvider).createTraining(request);
      ref.invalidate(profileDataProvider);
      if (mounted) {
        showAppToast(
          context,
          message: 'Training added',
          type: AppToastType.success,
        );
      }
    } catch (_) {
      if (mounted) {
        showAppToast(
          context,
          message: 'Could not save workout',
          type: AppToastType.error,
        );
      }
      return;
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }

    ref.invalidate(trainingsProvider);

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final canSave = _sessions.isNotEmpty && !_isSaving;

    return SizedBox(
      width: double.infinity,
      height: 500,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6, bottom: 8),
            height: 3,
            width: 33,
            decoration: BoxDecoration(
              color: const Color(0xFFD9D9D9),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const Text(
            'New workout',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: SizedBox(
              height: 44,
              child: TextField(
                controller: _titleController,
                style: const TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  hintText: 'Enter title',
                  hintStyle: const TextStyle(
                    color: AppColors.hint,
                    fontSize: 18,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: Color(0xFFE1E1E1),
                      width: 1.6,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 1.6,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: _sessions.isEmpty
                ? Center(
                    child: Text(
                      'No exercises added',
                      style: AppTextStyles.bodyMuted.copyWith(
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    itemCount: _sessions.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) =>
                        WorkoutSessionSummaryCard(session: _sessions[index]),
                  ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: _isSaving ? null : _addExercise,
                child: const Text(
                  'Add exercise',
                  style: TextStyle(fontSize: 15),
                ),
              ),
              const SizedBox(width: 50),
              PrimaryButton(
                text: _isSaving ? 'Saving' : 'Save',
                width: 72,
                height: 38,
                isEnabled: canSave,
                onPressed: _save,
              ),
            ],
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
