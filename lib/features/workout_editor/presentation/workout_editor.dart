import 'package:fitness_tracker/app/theme/app_colors.dart';
import 'package:fitness_tracker/app/theme/app_text_styles.dart';
import 'package:fitness_tracker/core/ui/primary_button.dart';
import 'package:fitness_tracker/core/ui/set_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Future<void> showModal(BuildContext context) async {
  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.surface,
    barrierColor: Colors.black.withValues(alpha: 0.33),
    useRootNavigator: true,
    builder: (context) {
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
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () => context.push('/exercises'),
                  child: const Text(
                    'Add exercise',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                const SizedBox(width: 50),
                PrimaryButton(
                  text: 'Save',
                  width: 72,
                  height: 38,
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      );
    },
  );
}

Future<void> showSetsDialog(BuildContext context, String title) async {
  await showDialog<void>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.33),
    builder: (context) => _SetsDialog(title: title),
  );
}

class _SetsDialog extends StatefulWidget {
  final String title;

  const _SetsDialog({required this.title});

  @override
  State<_SetsDialog> createState() => _SetsDialogState();
}

class _SetsDialogState extends State<_SetsDialog> {
  static const int _minSets = 2;
  static const int _maxSets = 6;

  int _setCount = _minSets;

  void _addSet() {
    if (_setCount >= _maxSets) {
      return;
    }

    setState(() {
      _setCount++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final canAddSet = _setCount < _maxSets;

    return Dialog(
      backgroundColor: AppColors.surface,
      insetPadding: const EdgeInsets.symmetric(horizontal: 48),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.title, style: AppTextStyles.sectionTitle),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, color: AppColors.primary),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Column(children: _buildSetRows()),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: canAddSet ? _addSet : null,
                  child: Text(
                    'Add set',
                    style: TextStyle(
                      fontSize: 15,
                      color: canAddSet ? AppColors.primary : Colors.black38,
                    ),
                  ),
                ),
                const SizedBox(width: 50),
                PrimaryButton(
                  text: 'Save',
                  width: 72,
                  height: 38,
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSetRows() {
    final rows = <Widget>[];

    for (int firstIndex = 1; firstIndex <= _setCount; firstIndex += 2) {
      final secondIndex = firstIndex + 1;

      rows.add(
        Padding(
          padding: EdgeInsets.only(bottom: secondIndex < _setCount ? 10 : 0),
          child: Row(
            children: [
              Expanded(
                child: SetCard(key: ValueKey(firstIndex), index: firstIndex),
              ),
              if (secondIndex <= _setCount) ...[
                const SizedBox(width: 10),
                Expanded(
                  child: SetCard(
                    key: ValueKey(secondIndex),
                    index: secondIndex,
                  ),
                ),
              ] else const Spacer(),
            ],
          ),
        ),
      );
    }

    return rows;
  }
}
