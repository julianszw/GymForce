import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_force/config/providers/user_provider.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userProvider);

    Future.delayed(const Duration(seconds: 3), () {
      if (userState.isLoggedIn) {
        if (context.mounted) {
          GoRouter.of(context).go('/');
        }
      } else {
        if (context.mounted) {
          GoRouter.of(context).go('/auth');
        }
      }
    });

    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
