import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/presentation/auth_controller.dart';
import '../features/auth/presentation/login_page.dart';
import '../features/auth/presentation/register_page.dart';
import '../features/exercises/presentation/exercises_page.dart';
import '../features/exercises/presentation/muscle_groups_page.dart';
import '../features/profile/presentation/profile_page.dart';
import '../features/trainings/presentation/trainings_page.dart';
import '../features/workout_editor/presentation/add_training_page.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authControllerProvider);

  return GoRouter(
    initialLocation: '/login',

    redirect: (context, state) {
      final isLoggedIn = authState.isAuthenticated;
      final isLoading = authState.isLoading;
      final location = state.matchedLocation;

      if (isLoading) {
        return null;
      }

      if (!isLoggedIn && location != '/login' && location != '/register') {
        return '/login';
      }

      if (isLoggedIn && (location == '/login' || location == '/register')) {
        return '/trainings';
      }

      return null;
    },

    routes: <RouteBase>[
      GoRoute(
        name: 'login',
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        name: 'register',
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      ShellRoute(
        routes: [
          GoRoute(
            name: 'trainings',
            path: '/trainings',
            builder: (context, state) => const TrainingsPage(),
          ),
          GoRoute(
            name: 'profile',
            path: '/profile',
            builder: (context, state) => const ProfilePage(),
          ),
        ],
      ),
      GoRoute(
        name: 'execises',
        path: '/exercises',
        builder: (context, state) => const MuscleGroupsPage(),
      ),
      GoRoute(
        name: 'execisesList',
        path: '/exercises/:muscleGroupId',
        builder: (context, state) {
          final muscleGroupId = state.pathParameters['muscleGroupId'];
          if (muscleGroupId == null) {
            return const MuscleGroupsPage();
          }
          return ExercisesPage(muscleGroupId: int.parse(muscleGroupId));
        },
      ),
      GoRoute(
        name: 'addTraining',
        path: '/workout/new',
        builder: (context, state) => const AddTrainingPage(),
      ),
    ],
  );
});
