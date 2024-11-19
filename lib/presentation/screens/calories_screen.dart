import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_force/config/providers/calories_plan_provider.dart';
import 'package:gym_force/presentation/widgets/navigation/drawer_nav_menu.dart';
import 'package:gym_force/presentation/widgets/yellow_button.dart';
import 'package:gym_force/utils/choose_dialog.dart';

class CaloriesScreen extends ConsumerWidget {
  const CaloriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final caloriesPlan = ref.watch(caloriesPlanProvider);

    return Scaffold(
      appBar: AppBar(),
      drawer: const DrawerNavMenu(),
      body: Center(
        child: Column(
          children: [
            caloriesPlan.calories.isEmpty
                ? Container(
                    margin: const EdgeInsets.only(bottom: 20, top: 200),
                    width: 300,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(12)),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                      child: Text(
                        'Para empezar a registrar tus calorías, crea un plan',
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : Container(),
            YellowButton(
                onPressed: () {
                  showChooseDialog(
                      context: context,
                      onAcceptLeft: () {
                        context.push('/set-diary-calories');
                      },
                      onAcceptRight: () {
                        context.push('/ai-calories');
                      },
                      description:
                          '¿Sabes cuántas calorías querés consumir o preferis la asistencia de la IA?',
                      leftText: 'Ingreso Manual',
                      rightText: 'Ingreso con IA');
                },
                text: 'Crear Plan')
          ],
        ),
      ),
    );
  }
}
