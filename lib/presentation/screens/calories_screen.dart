import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_force/config/providers/calories_plan_provider.dart';
import 'package:gym_force/config/providers/daily_calories_provider.dart';
import 'package:gym_force/presentation/widgets/calories/macro_indicator.dart';
import 'package:gym_force/presentation/widgets/navigation/drawer_nav_menu.dart';
import 'package:gym_force/presentation/widgets/yellow_button.dart';
import 'package:gym_force/utils/choose_dialog.dart';
import 'package:gym_force/utils/formatter.dart';
import 'package:percent_indicator/percent_indicator.dart';

class CaloriesScreen extends ConsumerStatefulWidget {
  const CaloriesScreen({super.key});

  @override
  ConsumerState<CaloriesScreen> createState() => _CaloriesScreenState();
}

class _CaloriesScreenState extends ConsumerState<CaloriesScreen> {
  final TextEditingController _proteinController = TextEditingController();
  final TextEditingController _carbsController = TextEditingController();
  final TextEditingController _fatsController = TextEditingController();
  String dailyCalories = '0';
  String dailyProteins = '0';
  String dailyCarbs = '0';
  String dailyFats = '0';

  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _proteinController.dispose();
    _carbsController.dispose();
    _fatsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final caloriesPlan = ref.watch(caloriePlanProvider);
    final dailyState = ref.watch(dailyCaloriesProvider);

    if (caloriesPlan.calories.isNotEmpty) {
      _proteinController.text = caloriesPlan.proteins;
      _carbsController.text = caloriesPlan.carbs;
      _fatsController.text = caloriesPlan.fats;
    }

    return Scaffold(
      appBar: AppBar(),
      drawer: const DrawerNavMenu(),
      body: Center(
        child: Column(
          children: [
            caloriesPlan.calories.isEmpty
                ? Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 20, top: 200),
                        width: 300,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 15),
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
                            onAcceptRight: () {
                              context.push('/ai-calories');
                            },
                            description:
                                '¿Sabes cuántas calorías querés consumir o preferis la asistencia de la IA?',
                            leftText: 'Ingreso Manual',
                            rightText: 'Ingreso con IA',
                          );
                        },
                        text: 'Crear Plan',
                      ),
                    ],
                  )
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 100),
                      child: Column(
                        children: [
                          Column(
                            children: [
                              EasyDateTimeLinePicker(
                                headerOptions: const HeaderOptions(
                                    headerType: HeaderType.none),
                                firstDate: DateTime(2024, 11, 1),
                                lastDate: DateTime(2030, 3, 18),
                                focusedDate: _selectedDate,
                                itemExtent: 64.0,
                                locale: const Locale('es'),
                                timelineOptions:
                                    const TimelineOptions(height: 90),
                                disableStrategy:
                                    const DisableStrategy.afterToday(),
                                onDateChange: (date) {
                                  setState(() {
                                    _selectedDate = date;
                                  });
                                },
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      context.push('/calendar');
                                    },
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text('Calendario'),
                                        SizedBox(width: 5),
                                        Icon(Icons.double_arrow, size: 16),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          CircularPercentIndicator(
                            radius: 100,
                            backgroundColor: Colors.grey,
                            percent: calculatePercentage(
                                dailyState['totalCalories'],
                                caloriesPlan.calories),
                            progressColor:
                                Theme.of(context).colorScheme.primary,
                            backgroundWidth: 1,
                            center: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  dailyState['totalCalories'],
                                  style: const TextStyle(fontSize: 40),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  'de ${caloriesPlan.calories} kcal',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 18,
                          ),
                          MacroIndicator(
                              title: 'Proteínas',
                              percent: calculatePercentage(
                                  dailyState['totalProteins'],
                                  _proteinController.text),
                              amount: '${dailyState['totalProteins']}g',
                              totalAmount: _proteinController.text),
                          const SizedBox(
                            height: 10,
                          ),
                          MacroIndicator(
                              title: 'Carbohidratos',
                              percent: calculatePercentage(
                                  dailyState['totalCarbs'],
                                  _carbsController.text),
                              amount: '${dailyState['totalCarbs']}g',
                              totalAmount: _carbsController.text),
                          const SizedBox(
                            height: 10,
                          ),
                          MacroIndicator(
                              title: 'Grasas',
                              percent: calculatePercentage(
                                  dailyState['totalFats'],
                                  _fatsController.text),
                              amount: '${dailyState['totalFats']}g',
                              totalAmount: _fatsController.text),
                          const SizedBox(
                            height: 50,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                YellowButton(
                                  onPressed: () {
                                    showChooseDialog(
                                      context: context,
                                      onAcceptLeft: () {
                                        context.push('/set-diary-calories',
                                            extra: {
                                              'initialCalories':
                                                  caloriesPlan.calories
                                            });
                                      },
                                      onAcceptRight: () {
                                        context.push('/ai-calories');
                                      },
                                      description:
                                          '¿Quieres editar el plan manualmente o generar uno nuevo con ayuda de la IA?',
                                      leftText: 'Edicón Manual',
                                      rightText: 'Generar con IA',
                                    );
                                  },
                                  text: 'Editar Plan',
                                  fontSize: 16,
                                ),
                                YellowButton(
                                  onPressed: () {
                                    context.push('/set-diary-calories',
                                        extra: {'addCalories': 'true'});
                                  },
                                  text: 'Ingresar Calorías',
                                  fontSize: 16,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
