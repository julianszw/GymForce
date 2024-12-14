import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_force/config/providers/user_provider.dart';
import 'package:gym_force/presentation/widgets/yellow_button.dart';
import 'package:gym_force/utils/calculate_calories.dart';

class AiCaloriesScreen extends ConsumerStatefulWidget {
  const AiCaloriesScreen({super.key});

  @override
  ConsumerState<AiCaloriesScreen> createState() => _AiCaloriesScreenState();
}

class _AiCaloriesScreenState extends ConsumerState<AiCaloriesScreen> {
  bool _isLoading = false;
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _fatPercentageController =
      TextEditingController();

  String? activityLevel;
  String? goal;

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    _fatPercentageController.dispose();
    super.dispose();
  }

  void _validateInputs() {
    String weight = _weightController.text;
    String height = _heightController.text;
    String fatPercentage = _fatPercentageController.text;

    if (weight.isEmpty ||
        height.isEmpty ||
        fatPercentage.isEmpty ||
        activityLevel == null ||
        goal == null) {
      _showError('Todos los campos deben ser llenados');
      return;
    }

    double? weightValue = double.tryParse(weight);
    if (weightValue == null || weightValue < 25 || weightValue > 250) {
      _showError('El peso debe estar entre 25 kg y 250 kg');
      return;
    }

    double? heightValue = double.tryParse(height);
    if (heightValue == null || heightValue <= 50 || heightValue > 250) {
      _showError('La altura debe ser un valor entre 50 cm y 250 cm');
      return;
    }

    double? fatPercentageValue = double.tryParse(fatPercentage);
    if (fatPercentageValue == null ||
        fatPercentageValue < 0 ||
        fatPercentageValue > 100) {
      _showError('El porcentaje de grasa debe estar entre 0% y 100%');
      return;
    }

    _calculateCalories();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _calculateCalories() async {
    setState(() {
      _isLoading = true;
    });
    double weight = double.parse(_weightController.text);
    double height = double.parse(_heightController.text);
    String activity = activityLevel ?? '';
    String userGoal = goal ?? '';
    final user = ref.watch(userProvider);

    int tdee = calculateCalories(
        weight: weight,
        height: height,
        activityLevel: activity,
        birthdate: user.birthdate!,
        gender: user.gender!,
        goal: userGoal);

    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      context.push('/set-diary-calories',
          extra: {'initialCalories': tdee.toString()});
      setState(() {
        _isLoading = false;
      });
      await Future.delayed(const Duration(seconds: 2));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: _isLoading
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  context.pop();
                },
              ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 20, right: 40, left: 40),
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        'Te pediremos algunos datos para calcular las calorías que necesitas',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Theme.of(context).colorScheme.primary),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 80),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Peso (kg)'),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextField(
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(6),
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d{0,3}(\.\d{0,2})?$')),
                                  ],
                                  style: const TextStyle(color: Colors.black),
                                  controller: _weightController,
                                  decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 8),
                                      border: OutlineInputBorder(),
                                      hintText: 'Peso (kg)'),
                                  keyboardType: TextInputType.number,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 40),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Altura (cm)'),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextField(
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(6),
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d{0,3}(\.\d{0,2})?$')),
                                  ],
                                  style: const TextStyle(color: Colors.black),
                                  controller: _heightController,
                                  decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 8),
                                      border: OutlineInputBorder(),
                                      hintText: 'Altura (cm)'),
                                  keyboardType: TextInputType.number,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Porcentaje de grasa corporal (%)'),
                          const SizedBox(
                            height: 10,
                          ),
                          TextField(
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(5),
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d{0,2}(\.\d{0,2})?$')),
                            ],
                            style: const TextStyle(color: Colors.black),
                            controller: _fatPercentageController,
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 8),
                                border: OutlineInputBorder(),
                                hintText: 'Porcentaje (%)'),
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Nivel de Actividad Semanal',
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          DropdownButtonFormField<String>(
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black),
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10.0),
                                filled: true,
                                fillColor: Colors.white,
                                errorStyle: const TextStyle(color: Colors.red),
                                border: OutlineInputBorder(
                                    borderSide: const BorderSide(width: 0),
                                    borderRadius: BorderRadius.circular(5))),
                            dropdownColor: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            value: activityLevel,
                            hint: const Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Nivel de actividad física',
                                  style: TextStyle(color: Colors.grey)),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'Sedentario',
                                child: Text('Sedentario'),
                              ),
                              DropdownMenuItem(
                                value: 'Ligero',
                                child: Text('Ligero (1-2 días por semana)'),
                              ),
                              DropdownMenuItem(
                                value: 'Moderado',
                                child: Text('Moderado (3-5 días por semana)'),
                              ),
                              DropdownMenuItem(
                                value: 'Intenso',
                                child: Text('Intenso (6-7 días por semana)'),
                              ),
                              DropdownMenuItem(
                                value: 'Muy intenso',
                                child: Text('Muy intenso (ejercicio diario)'),
                              ),
                            ],
                            onChanged: (String? newValue) {
                              setState(() {
                                activityLevel = newValue;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Objetivo físico',
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          DropdownButtonFormField<String>(
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black),
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10.0),
                                filled: true,
                                fillColor: Colors.white,
                                errorStyle: const TextStyle(color: Colors.red),
                                border: OutlineInputBorder(
                                    borderSide: const BorderSide(width: 0),
                                    borderRadius: BorderRadius.circular(5))),
                            dropdownColor: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            value: goal,
                            hint: const Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Objetivo físico',
                                  style: TextStyle(color: Colors.grey)),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'Pérdida de peso',
                                child: Text('Pérdida de peso'),
                              ),
                              DropdownMenuItem(
                                value: 'Mantenimiento',
                                child: Text('Mantenimiento'),
                              ),
                              DropdownMenuItem(
                                value: 'Ganancia muscular',
                                child: Text('Ganancia muscular'),
                              ),
                            ],
                            onChanged: (String? newValue) {
                              setState(() {
                                goal = newValue;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 150,
                      ),
                      YellowButton(
                        onPressed: _validateInputs,
                        text: 'Calcular',
                        width: 320,
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
