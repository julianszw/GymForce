import 'package:go_router/go_router.dart';
import 'package:gym_force/config/navigation/bottom_nav.dart';
import 'package:gym_force/presentation/screens/calories_screen.dart';
import 'package:gym_force/presentation/screens/home_screen.dart';
import 'package:gym_force/presentation/screens/profile_screen.dart';
import 'package:gym_force/presentation/screens/qr_customer_scren.dart';
import 'package:gym_force/presentation/screens/workouts_screen.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    ShellRoute(
      // Este builder devuelve el BottomNav con el child proporcionado
      builder: (context, state, child) => BottomNav(child: child),
      routes: [
        GoRoute(
          path: '/', // Ruta Home
          builder: (context, state) => const HomeScreen(),
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
  ],
);
