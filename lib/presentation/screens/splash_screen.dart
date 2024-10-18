import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_force/config/providers/user_provider.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Obtenemos el estado del usuario
    final userState = ref.watch(userProvider);

    // Usamos addPostFrameCallback para ejecutar la navegación luego de renderizar
    Future.delayed(const Duration(seconds: 3), () {
      if (userState.isLoggedIn) {
        // Redirige a Home si está autenticado después del retraso
        GoRouter.of(context).go('/');
      } else {
        // Redirige a Login si no está autenticado después del retraso
        GoRouter.of(context).go('/auth');
      }
    });

    // Muestra una pantalla de carga mientras decide a dónde redirigir
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
