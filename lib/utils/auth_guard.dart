// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:gym_force/config/providers/user_provider.dart';

// class AuthGuard extends ConsumerWidget {
//   final String fallbackRoute;
//   final Widget child;

//   const AuthGuard({
//     super.key,
//     required this.fallbackRoute,
//     required this.child,
//   });

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final userState = ref.watch(userProvider);

//     if (!userState.isLoggedIn) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         GoRouter.of(context).go(fallbackRoute);
//       });
//       return Container();
//     }

//     return child;
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_force/config/providers/user_provider.dart';

class AuthGuard extends ConsumerWidget {
  final String fallbackRoute;
  final Widget child;

  const AuthGuard({
    super.key,
    required this.fallbackRoute,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userProvider);

    // En lugar de isLoggedIn, verificamos si el uid no está vacío
    if (userState.uid.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        GoRouter.of(context).go(fallbackRoute);
      });
      return Container();
    }

    return child;
  }
}
