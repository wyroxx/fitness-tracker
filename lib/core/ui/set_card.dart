import 'package:fitness_tracker/app/theme/app_colors.dart';
import 'package:fitness_tracker/app/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SetCard extends StatelessWidget {
  final int index;
  final TextEditingController weightController;
  final TextEditingController repsController;

  const SetCard({
    super.key,
    required this.index,
    required this.weightController,
    required this.repsController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(9, 10, 8, 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Set $index', style: AppTextStyles.body.copyWith(fontSize: 14)),
          _SetInput(
            controller: weightController,
            label: 'Weight',
            suffix: 'kg',
            width: 34,
          ),
          _SetInput(controller: repsController, label: 'Reps', width: 28),
        ],
      ),
    );
  }
}

class _SetInput extends StatelessWidget {
  final String label;
  final String? suffix;
  final double width;
  final TextEditingController controller;

  const _SetInput({
    required this.label,
    required this.width,
    this.suffix,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: AppTextStyles.body.copyWith(
            fontWeight: FontWeight.normal,
            fontSize: 13,
          ),
        ),
        Flexible(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: width),
            child: SizedBox(
              height: 22,
              child: TextField(
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: AppTextStyles.body.copyWith(fontSize: 13),
                decoration: const InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ),
        ),
        if (suffix != null)
          Text(suffix!, style: AppTextStyles.body.copyWith(fontSize: 13)),
      ],
    );
  }
}
