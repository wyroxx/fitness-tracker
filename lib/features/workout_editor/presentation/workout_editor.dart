import 'package:fitness_tracker/app/theme/app_colors.dart';
import 'package:fitness_tracker/features/workout_editor/presentation/widgets/workout_editor_sheet.dart';
import 'package:flutter/material.dart';

export 'widgets/sets_dialog.dart' show showSetsDialog;

Future<void> showModal(BuildContext context) async {
  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.surface,
    barrierColor: Colors.black.withValues(alpha: 0.33),
    useRootNavigator: true,
    builder: (context) => const WorkoutEditorSheet(),
  );
}
