import 'package:fitness_tracker/app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class MainPage extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainPage({super.key, required this.navigationShell});

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      backgroundColor: AppColors.background,
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.14),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BottomNavigationBar(
            currentIndex: navigationShell.currentIndex,
            onTap: _onTap,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: [
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/list.svg',
                  width: 30,
                  height: 30,
                ),
                activeIcon: SvgPicture.asset(
                  'assets/list.svg',
                  width: 30,
                  height: 30,
                  colorFilter: const ColorFilter.mode(
                    AppColors.primary,
                    BlendMode.srcIn,
                  ),
                ),
                label: 'Trainings',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.person_rounded, size: 32),
                activeIcon: Icon(
                  Icons.person_rounded,
                  size: 32,
                  color: AppColors.primary,
                ),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
