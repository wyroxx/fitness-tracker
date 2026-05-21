import 'package:fitness_tracker/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AskButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;

  const AskButton({super.key, required this.onPressed, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: isLoading ? null : onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFD9E4F2),
            borderRadius: BorderRadius.circular(15)
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.auto_awesome,
                size: 18,
                color: AppColors.primary,
              ),
              const SizedBox(width: 4),
              Text(
                isLoading ? 'Generating...' : 'Ask AI again',
                style: const TextStyle(color: AppColors.primary, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
