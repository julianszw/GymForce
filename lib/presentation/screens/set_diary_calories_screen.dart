import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_force/presentation/widgets/yellow_button.dart';
import 'package:gym_force/services/calories_services.dart';
import 'package:percent_indicator/percent_indicator.dart';

class SetDiaryCaloriesScreen extends StatefulWidget {
  const SetDiaryCaloriesScreen({super.key});

  @override
  State<SetDiaryCaloriesScreen> createState() => _SetDiaryCaloriesScreenState();
}

class _SetDiaryCaloriesScreenState extends State<SetDiaryCaloriesScreen> {
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _proteinsController = TextEditingController();
  final TextEditingController _carbsController = TextEditingController();
  final TextEditingController _fatsController = TextEditingController();
  bool isUpdating = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _caloriesController.addListener(_updateWidth);
    _caloriesController.addListener(_onCaloriesChanged);
    _proteinsController.addListener(_onMacrosChanged);
    _carbsController.addListener(_onMacrosChanged);
    _fatsController.addListener(_onMacrosChanged);
  }

  @override
  void dispose() {
    _caloriesController.removeListener(_onCaloriesChanged);
    _proteinsController.removeListener(_onMacrosChanged);
    _carbsController.removeListener(_onMacrosChanged);
    _fatsController.removeListener(_onMacrosChanged);
    _caloriesController.dispose();
    _proteinsController.dispose();
    _carbsController.dispose();
    _fatsController.dispose();
    super.dispose();
  }

  void _onCaloriesChanged() {
    if (isUpdating) return;

    isUpdating = true; // Bloquea nuevas ejecuciones

    final calories = int.tryParse(_caloriesController.text) ?? 0;
    final proteins = calories * 0.3 ~/ 4;
    final carbs = calories * 0.4 ~/ 4;
    final fats = calories * 0.3 ~/ 9;

    _updateMacros(proteins, carbs, fats);

    isUpdating = false; // Desbloquea al final de la actualización
  }

  void _onMacrosChanged() {
    if (isUpdating) return;

    isUpdating = true; // Bloquea nuevas ejecuciones

    final proteins =
        int.tryParse(_proteinsController.text.replaceAll('g', '')) ?? 0;
    final carbs = int.tryParse(_carbsController.text.replaceAll('g', '')) ?? 0;
    final fats = int.tryParse(_fatsController.text.replaceAll('g', '')) ?? 0;
    final calories = (proteins * 4) + (carbs * 4) + (fats * 9);

    if (_caloriesController.text != calories.toString()) {
      _caloriesController.text = calories.toString();
    }

    isUpdating = false; // Desbloquea al final de la actualización
  }

  void _updateMacros(int proteins, int carbs, int fats) {
    _proteinsController.text = '$proteins';
    _carbsController.text = '$carbs';
    _fatsController.text = '$fats';
  }

  void _updateWidth() {
    setState(() {});
  }

  Future<void> _saveCaloriesPlan() async {
    try {
      setState(() {
        isLoading = true;
      });
      final calories = _caloriesController.text;
      final proteins = _proteinsController.text;
      final carbs = _carbsController.text;
      final fats = _fatsController.text;

      await CaloriesServices().createCaloriesPlan(
        calories: calories,
        proteins: proteins,
        carbs: carbs,
        fats: fats,
      );
      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Plan de calorías guardado exitosamente'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        await Future.delayed(const Duration(milliseconds: 200));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar el plan de calorías: $e'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      setState(() {
        isLoading = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: isLoading
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  context.pop();
                },
              ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.only(top: 20),
                child: Column(
                  children: [
                    Text(
                      'Ajusta las calorías y los macronutrients',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: Theme.of(context).colorScheme.primary),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                    CircularPercentIndicator(
                      radius: 110,
                      backgroundColor: Colors.grey,
                      backgroundWidth: 1,
                      center: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: _caloriesController.text.isEmpty ? 50 : 100,
                            child: TextField(
                              controller: _caloriesController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 40),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(4),
                              ],
                              decoration: const InputDecoration(
                                filled: false,
                                border: InputBorder.none,
                                hintText: '0',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          const Text(
                            'kcal',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 50),
                    Padding(
                      padding: const EdgeInsets.only(left: 40),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const SizedBox(
                                width: 160,
                                child: Text(
                                  'Proteínas',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Flexible(
                                child: SizedBox(
                                  width: 100,
                                  child: TextField(
                                    controller: _proteinsController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(3),
                                    ],
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontSize: 18),
                                    decoration: const InputDecoration(
                                      filled: false,
                                      border: InputBorder.none,
                                      hintText: '0g',
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                width: 160,
                                child: Text(
                                  'Carbohidratos',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Flexible(
                                child: SizedBox(
                                  width: 100,
                                  child: TextField(
                                    controller: _carbsController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(3),
                                    ],
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                    decoration: const InputDecoration(
                                      filled: false,
                                      border: InputBorder.none,
                                      hintText: '0g',
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                width: 160,
                                child: Text(
                                  'Grasas',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Flexible(
                                child: SizedBox(
                                  width: 100,
                                  child: TextField(
                                    controller: _fatsController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(3),
                                    ],
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                    decoration: const InputDecoration(
                                      filled: false,
                                      border: InputBorder.none,
                                      hintText: '0g',
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 120,
                    ),
                    YellowButton(
                        onPressed: () {
                          _saveCaloriesPlan();
                        },
                        text: 'Finalizar')
                  ],
                ),
              ),
            ),
    );
  }
}
