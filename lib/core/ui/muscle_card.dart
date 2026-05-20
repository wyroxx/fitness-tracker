import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MuscleCard extends StatelessWidget {
  final int id;
  final String title;
  final double size;
  
  const MuscleCard({
    super.key,
    required this.title,
    required this.size,
    required this.id
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async => await context.push('/exercises/$id', extra: title),
          borderRadius: BorderRadius.circular(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/${title.toLowerCase()}.png',
                width: size * 0.55,
                height: size * 0.55,
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}
