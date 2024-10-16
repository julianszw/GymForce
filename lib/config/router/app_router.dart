import 'package:go_router/go_router.dart';
import 'package:gym_force/presentation/screens/login_screen.dart';
import 'package:gym_force/presentation/screens/splash_screen.dart';
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
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) => BottomNav(child: child),
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
  ],
);
