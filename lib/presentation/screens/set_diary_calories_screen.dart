import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_force/config/providers/calories_plan_provider.dart';
import 'package:gym_force/config/providers/user_provider.dart';
import 'package:gym_force/domain/calories_plan_domain.dart';
import 'package:gym_force/presentation/widgets/calories/macros_input.dart';
import 'package:gym_force/presentation/widgets/yellow_button.dart';
import 'package:gym_force/services/calories_services.dart';
import 'package:percent_indicator/percent_indicator.dart';

class SetDiaryCaloriesScreen extends ConsumerStatefulWidget {
  final String? initialCalories;

  const SetDiaryCaloriesScreen({super.key, this.initialCalories});

  @override
  ConsumerState<SetDiaryCaloriesScreen> createState() =>
      _SetDiaryCaloriesScreenState();
}

class _SetDiaryCaloriesScreenState
    extends ConsumerState<SetDiaryCaloriesScreen> {
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

    if (widget.initialCalories != null) {
      _caloriesController.text = widget.initialCalories!;
      _onCaloriesChanged();
    }
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

    isUpdating = true;

    final calories = int.tryParse(_caloriesController.text) ?? 0;
    final proteins = calories * 0.3 ~/ 4;
    final carbs = calories * 0.4 ~/ 4;
    final fats = calories * 0.3 ~/ 9;

    _updateMacros(proteins, carbs, fats);

    isUpdating = false;
  }

  void _onMacrosChanged() {
    if (isUpdating) return;

    isUpdating = true;

    final proteins =
        int.tryParse(_proteinsController.text.replaceAll('g', '')) ?? 0;
    final carbs = int.tryParse(_carbsController.text.replaceAll('g', '')) ?? 0;
    final fats = int.tryParse(_fatsController.text.replaceAll('g', '')) ?? 0;
    final calories = (proteins * 4) + (carbs * 4) + (fats * 9);

    if (_caloriesController.text != calories.toString()) {
      _caloriesController.text = calories.toString();
    }

    isUpdating = false;
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
    if (_proteinsController.text.isEmpty ||
        _carbsController.text.isEmpty ||
        _fatsController.text.isEmpty ||
        _caloriesController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Por favor, ingrese todos los valores de calorías y macronutrientes.'),
        ),
      );
      return;
    }
    try {
      setState(() {
        isLoading = true;
      });
      final userId = ref.watch(userProvider).uid;

      final caloriesPlan = CaloriesPlan(
          userId: userId,
          date: DateTime.now(),
          calories: _caloriesController.text,
          proteins: _proteinsController.text,
          carbs: _carbsController.text,
          fats: _fatsController.text);

      await CaloriesServices().createCaloriesPlan(caloriesPlan);
      ref.watch(caloriesPlanProvider.notifier).setCaloriesPlan(caloriesPlan);
      if (mounted) {
        context.go('/calories');
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
                    MacronutrientInput(
                        label: 'Proteínas', controller: _proteinsController),
                    MacronutrientInput(
                        label: "Carbohidratos", controller: _carbsController),
                    MacronutrientInput(
                        label: 'Grasas', controller: _fatsController),
                    const SizedBox(
                      height: 120,
                    ),
                    YellowButton(
                        width: 320,
                        onPressed: () {
                          _saveCaloriesPlan();
                        },
                        text: 'Crear Plan')
                  ],
                ),
              ),
            ),
    );
  }
}
