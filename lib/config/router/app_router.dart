import 'package:flutter/src/widgets/framework.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_force/config/providers/user_provider.dart';
import 'package:gym_force/domain/user_state_domain.dart';
import 'package:gym_force/presentation/screens/login_screen.dart';
import 'package:gym_force/presentation/screens/splash_screen.dart';
import 'package:gym_force/presentation/widgets/auth_guarrd.dart';
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
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    ShellRoute(
      // Este builder devuelve el BottomNav con el child proporcionado
      builder: (context, state, child) => BottomNav(child: child),
      routes: [
        GoRoute(
          path: '/', // Ruta Home
          builder: (context, state) => AuthGuard(
            fallbackRoute: '/login',
            child: HomeScreen(),
          ),
        ),
        GoRoute(
          path: '/workouts', // Ruta Workouts
          builder: (context, state) => const WorkoutsScreen(),
        ),
        GoRoute(
          path: '/qr', // Ruta QR
          builder: (context, state) => const QrCustomerScren(),
        ),
        GoRoute(
          path: '/calories', // Ruta Calories
          builder: (context, state) => const CaloriesScreen(),
        ),
        GoRoute(
          path: '/profile', // Ruta Profile
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/headquarter', // Ruta del Drawer para Sedes
      builder: (context, state) => const HeadquarterScreen(),
    ),
    GoRoute(
      path: '/calendar', // Ruta del Drawer para el calendario
      builder: (context, state) => const CalendarScreen(),
    ),
    GoRoute(
      path: '/membership', // Ruta del Drawer para Membresías
      builder: (context, state) => const MembershipScreen(),
    ),
  ],
);
