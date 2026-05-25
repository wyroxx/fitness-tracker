import 'package:fitness_tracker/app/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class AppErrorState extends StatelessWidget {
  const AppErrorState({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/error_state.png',
            width: screenWidth * 0.8,
            height: screenWidth * 0.8,
          ),
          const SizedBox(height: 16),
          Text(title, style: AppTextStyles.appBarTitle),
        ],
      ),
    );
  }
}
