import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_force/config/providers/user_provider.dart';

class AuthGuard extends ConsumerWidget {
  final String fallbackRoute;
  final Widget child;

  const AuthGuard({
    Key? key,
    required this.fallbackRoute,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userProvider);

    if (userState.isLoggedIn == null) {
      // Podrías mostrar un indicador de progreso mientras se verifica
      return const Center(child: CircularProgressIndicator());
    }

    if (!userState.isLoggedIn) {
      // Redirige si no está autenticado
      WidgetsBinding.instance.addPostFrameCallback((_) {
        GoRouter.of(context).go(fallbackRoute);
      });
      return Container(); // No muestra nada mientras redirige
    }

    return child; // Muestra el contenido protegido
  }
}
