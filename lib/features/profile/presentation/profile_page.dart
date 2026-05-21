import 'package:fitness_tracker/app/theme/app_colors.dart';
import 'package:fitness_tracker/app/theme/app_text_styles.dart';
import 'package:fitness_tracker/features/auth/presentation/auth_controller.dart';
import 'package:fitness_tracker/features/profile/data/profile_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileDataAsync = ref.watch(profileDataProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: profileDataAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error:(error, stackTrace) => const Center(
          child: Text('Something went wrong...'),
        ),
        data: (profileData) => Center(
          child: Column(
            children: [
              const Spacer(),
              SvgPicture.asset(
                'assets/avatar.svg',
                height: 160,
                width: 160,
              ),
              const SizedBox(height: 12),
              Text(profileData.user.name, style: AppTextStyles.sectionTitle),
              const Text(
                'Total workouts',
                style: TextStyle(
                  fontSize: 20,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                profileData.stats.totalWorkouts.toString(),
                style: const TextStyle(
                  fontSize: 24,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              const Text(
                'AI assistant insight',
                style: AppTextStyles.sectionTitle,
              ),
              Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryDark],
                  ),
                ),
                child: Text(
                  profileData.stats.suggestion,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: TextButton(
                  onPressed: () async {
                    await ref.read(authControllerProvider.notifier).logout();
                    if (context.mounted) {
                      context.go('/login');
                    }
                  },
                  child: const Text(
                    'Log out',
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
