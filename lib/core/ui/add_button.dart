import 'package:fitness_tracker/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AddButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double size;

  const AddButton({super.key, required this.onPressed, required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size / 2),
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.primaryMuted],
            stops: [0.25, 1.0],
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(size / 2),
            onTap: onPressed,
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: size / 1.7,
              weight: 2,
            ),
          ),
        ),
      ),
    );
  }
}
