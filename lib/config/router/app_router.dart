import 'package:go_router/go_router.dart';
import 'package:gym_force/presentation/screens/calendar_screen.dart';
import 'package:gym_force/presentation/screens/calories_screen.dart';
import 'package:gym_force/presentation/screens/headquarter_screen.dart';
import 'package:gym_force/presentation/screens/home_screen.dart';
import 'package:gym_force/presentation/screens/login_screen.dart';
import 'package:gym_force/presentation/screens/membership_screen.dart';
import 'package:gym_force/presentation/screens/profile_screen.dart';
import 'package:gym_force/presentation/screens/qr_customer_screen.dart';
import 'package:gym_force/presentation/screens/register_screen.dart';
import 'package:gym_force/presentation/screens/workouts_screen.dart';



final appRouter = GoRouter(
  initialLocation: "/home",
  routes: [
  GoRoute(
    name: "/home",
    path: "/home",
    builder: (context, state) => HomeScreen(),
  ),
    GoRoute(
      path: '/calendar',
      builder: (context, state) => CalendarScreen(),
    ),
    GoRoute(
      path: '/calories',
      builder: (context, state) => CaloriesScreen(),
    ),
    GoRoute(
      path: '/membership',
      builder: (context, state) => MembershipScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => ProfileScreen(),
    ),
    GoRoute(
      path: '/qr_customer',
      builder: (context, state) => QrCustomerScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => RegisterScreen(),
    ),
    GoRoute(
      path: '/workouts',
      builder: (context, state) => WorkoutsScreen(),
    ),
        GoRoute(
      path: '/headquarters',
      builder: (context, state) => HeadquarterScreen(),
    ),

]);