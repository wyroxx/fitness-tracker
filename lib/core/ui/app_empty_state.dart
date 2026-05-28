import 'package:fitness_tracker/app/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class AppEmptyState extends StatelessWidget {
  const AppEmptyState({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/empty_state.png',
            height: screenWidth * 0.8,
            width: screenWidth * 0.8,
            colorBlendMode: BlendMode.src,
          ),
          const SizedBox(height: 8),
          Text(title, style: AppTextStyles.appBarTitle),
        ],
      ),
    );
  }
}
