import 'package:fitness_tracker/app/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/presentation/auth_controller.dart';
import '../features/auth/presentation/login_page.dart';
import '../features/auth/presentation/register_page.dart';
import '../features/exercises/presentation/exercises_page.dart';
import '../features/exercises/presentation/muscle_groups_page.dart';
import '../features/profile/presentation/profile_page.dart';
import '../features/trainings/presentation/trainings_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  final authStatus = ref.watch(authControllerProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/login',

    redirect: (context, state) {
      final location = state.matchedLocation;

      if (authStatus == AuthStatus.loading) {
        return null;
      }

      if (authStatus == AuthStatus.unauthenticated &&
          location != '/login' &&
          location != '/register') {
        return '/login';
      }

      if (authStatus == AuthStatus.authenticated &&
          (location == '/login' || location == '/register')) {
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
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainPage(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: 'trainings',
                path: '/trainings',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: TrainingsPage()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: 'profile',
                path: '/profile',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: ProfilePage()),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        name: 'exercises',
        path: '/exercises',
        builder: (context, state) => const MuscleGroupsPage(),
      ),
      GoRoute(
        name: 'exercisesList',
        path: '/exercises/:muscleGroupId',
        builder: (context, state) {
          final muscleGroupId = int.tryParse(
            state.pathParameters['muscleGroupId'] ?? '',
          );
          final title = state.extra is String
              ? state.extra as String
              : 'Exercises';
          if (muscleGroupId == null) {
            return const MuscleGroupsPage();
          }
          return ExercisesPage(muscleGroupId: muscleGroupId, title: title);
        },
      ),
    ],
  );
});
