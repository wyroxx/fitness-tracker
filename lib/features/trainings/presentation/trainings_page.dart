import 'package:fitness_tracker/core/ui/add_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TrainingsPage extends StatelessWidget {
  const TrainingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Trainings')),
      floatingActionButton: AddButton(
        size: 60,
        onPressed: () async {
          await context.push('/exercises');
        },
      ),
    );
  }
}
