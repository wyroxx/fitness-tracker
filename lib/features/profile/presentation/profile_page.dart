import 'package:fitness_tracker/app/theme/app_colors.dart';
import 'package:fitness_tracker/app/theme/app_text_styles.dart';
import 'package:fitness_tracker/core/ui/adaptive_dialog.dart';
import 'package:fitness_tracker/core/ui/app_error_state.dart';
import 'package:fitness_tracker/core/ui/snack_bar.dart';
import 'package:fitness_tracker/features/auth/presentation/auth_controller.dart';
import 'package:fitness_tracker/features/profile/data/profile_repository_impl.dart';
import 'package:fitness_tracker/features/profile/presentation/widgets/ask_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  String? _suggestion;
  bool _isGeneratingSuggestion = false;

  Future<void> _generateSuggestion() async {
    setState(() {
      _isGeneratingSuggestion = true;
    });

    try {
      final suggestion = await ref
          .read(profileRepositoryProvider)
          .getSuggestion();
      if (!mounted) {
        return;
      }
      setState(() {
        _suggestion = suggestion;
        _isGeneratingSuggestion = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _isGeneratingSuggestion = false;
          showAppToast(
            context,
            message: 'Failed to generate suggestion',
            type: AppToastType.error,
          );
        });
      }
    }
  }

  Future<void> _logout() async {
    final confirmed = await showAdaptiveConfirmationDialog(
      context,
      title: 'Log out?',
      message: 'You will need to sign in again to continue tracking workouts.',
      confirmText: 'Log out',
      isDestructive: true,
    );

    if (!confirmed || !mounted) {
      return;
    }

    await ref.read(authControllerProvider.notifier).logout();

    if (mounted) {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileDataAsync = ref.watch(profileDataProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: profileDataAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => AppErrorState(
          title: 'Error loading profile',
          onRetry: () => ref.invalidate(profileDataProvider),
        ),
        data: (profileData) {
          final suggestion = _suggestion ?? profileData.stats.suggestion;
          return Center(
            child: Column(
              children: [
                const Spacer(),
                SvgPicture.asset(
                  'assets/images/avatar.svg',
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
                  padding: const EdgeInsets.all(12),
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
                    suggestion,
                    textAlign: TextAlign.start,
                    maxLines: 6,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                ),
                AskButton(
                  isLoading: _isGeneratingSuggestion,
                  onPressed: _generateSuggestion,
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: TextButton(
                    onPressed: _logout,
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
          );
        },
      ),
    );
  }
}
