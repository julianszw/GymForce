import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_force/config/providers/user_provider.dart';
import 'package:gym_force/presentation/screens/ai_calories_screen.dart';
import 'package:gym_force/presentation/screens/ai_workout_screen.dart';
import 'package:gym_force/presentation/screens/auth/auth_screen.dart';
import 'package:gym_force/presentation/screens/auth/register_selfie_screen.dart';
import 'package:gym_force/presentation/screens/auth/register_dni_screen.dart';
import 'package:gym_force/presentation/screens/create_ai_workout_screen.dart';
import 'package:gym_force/presentation/screens/create_manually_workout_screen.dart';
import 'package:gym_force/presentation/screens/edit_workout_screen.dart';
import 'package:gym_force/presentation/screens/employee/help_screen.dart';
import 'package:gym_force/presentation/screens/employee/qr_employee_screen.dart';
import 'package:gym_force/presentation/screens/auth/login_screen.dart';
import 'package:gym_force/presentation/screens/auth/register_basic_data.dart';
import 'package:gym_force/presentation/screens/auth/register_extra_data_screen.dart';
import 'package:gym_force/presentation/screens/set_diary_calories_screen.dart';
import 'package:gym_force/presentation/screens/splash_screen.dart';
import 'package:gym_force/presentation/screens/train_workout_screen.dart';
import 'package:gym_force/presentation/widgets/navigation/employee_bottom_nav.dart';
import 'package:gym_force/utils/auth_guard.dart';
import 'package:gym_force/presentation/widgets/navigation/bottom_nav.dart';
import 'package:gym_force/presentation/screens/calendar_screen.dart';
import 'package:gym_force/presentation/screens/calories_screen.dart';
import 'package:gym_force/presentation/screens/headquarter_screen.dart';
import 'package:gym_force/presentation/screens/home_screen.dart';
import 'package:gym_force/presentation/screens/membership_screen.dart';
import 'package:gym_force/presentation/screens/profile_screen.dart';
import 'package:gym_force/presentation/screens/qr_customer_scren.dart';
import 'package:gym_force/presentation/screens/workouts_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/auth',
      builder: (context, state) => const AuthScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterBasicDataScreen(),
    ),
    GoRoute(
      path: '/register_extra_data',
      builder: (context, state) => const RegisterExtraDataScreen(),
    ),
    GoRoute(
      path: '/register_dni',
      builder: (context, state) => const RegisterDniScreen(),
    ),
    GoRoute(
      path: '/register_selfie',
      builder: (context, state) => const RegisterSelfieScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) {
        return Consumer(
          builder: (context, ref, child) {
            final user = ref.watch(userProvider);
            return user.role == 'employee'
                ? EmployeeBottomNav(child: child!)
                : BottomNav(child: child!);
          },
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const AuthGuard(
            fallbackRoute: '/login',
            child: HomeScreen(),
          ),
        ),
        GoRoute(
          path: '/workouts',
          builder: (context, state) => const WorkoutsScreen(),
        ),
        GoRoute(
          path: '/qr',
          builder: (context, state) => const QrCustomerScren(),
        ),
        GoRoute(
          path: '/calories',
          builder: (context, state) => const CaloriesScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(path: '/help', builder: (context, state) => const HelpScreen()),
        GoRoute(
            path: '/qr-employee',
            builder: (context, state) => const QrEmployeeScreen())
      ],
    ),
    GoRoute(
      path: '/headquarter',
      builder: (context, state) => const HeadquarterScreen(),
    ),
    GoRoute(
      path: '/calendar',
      builder: (context, state) => const CalendarScreen(),
    ),
    GoRoute(
      path: '/membership',
      builder: (context, state) => const MembershipScreen(),
    ),
    GoRoute(
        path: '/create-manually-workout',
        builder: (context, state) => const CreateManuallyWorkoutScreen()),
    GoRoute(
        path: '/create-ai-workout',
        builder: (context, state) => const CreateAiWorkoutScreen()),
    GoRoute(
      path: '/edit-workout/:id',
      builder: (context, state) {
        final workoutId = state.pathParameters['id']!;
        return EditWorkoutScreen(workoutId: workoutId);
      },
    ),
    GoRoute(
      path: '/train-workout/:id',
      builder: (context, state) {
        final workoutId = state.pathParameters['id']!;
        return TrainWorkoutScreen(workoutId: workoutId);
      },
    ),
    GoRoute(
        path: '/ai-workout',
        builder: (context, state) => const AIWorkoutScreen()),
    GoRoute(
        path: '/set-diary-calories',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final initialCalories = extra?['initialCalories'];

          return SetDiaryCaloriesScreen(
            initialCalories: initialCalories,
          );
        }),
    GoRoute(
        path: '/ai-calories',
        builder: (context, state) => const AiCaloriesScreen())
  ],
);
