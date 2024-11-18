import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_force/presentation/widgets/navigation/drawer_nav_menu.dart';
import 'package:gym_force/presentation/widgets/yellow_button.dart';
import 'package:gym_force/utils/auth_guard.dart';
import 'package:gym_force/utils/choose_dialog.dart';
import 'package:gym_force/utils/common_dialog.dart';

class CaloriesScreen extends StatelessWidget {
  const CaloriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: const DrawerNavMenu(),
      body: Center(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 20, top: 200),
              width: 300,
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(12)),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                child: Text(
                  'Para empezar a registrar tus calorías, crea un plan',
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            YellowButton(
                onPressed: () {
                  showChooseDialog(
                      context: context,
                      onAcceptLeft: () {
                        context.push('/set-diary-calories');
                      },
                      onAcceptRight: () {},
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
