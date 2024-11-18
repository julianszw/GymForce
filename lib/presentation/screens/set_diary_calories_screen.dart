import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gym_force/presentation/widgets/navigation/drawer_nav_menu.dart';
import 'package:percent_indicator/percent_indicator.dart';

class SetDiaryCaloriesScreen extends StatefulWidget {
  const SetDiaryCaloriesScreen({super.key});

  @override
  State<SetDiaryCaloriesScreen> createState() => _SetDiaryCaloriesScreenState();
}

class _SetDiaryCaloriesScreenState extends State<SetDiaryCaloriesScreen> {
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _proteinsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _caloriesController.addListener(_updateWidth);
  }

  @override
  void dispose() {
    _caloriesController.removeListener(_updateWidth);
    _caloriesController.dispose();
    _proteinsController.dispose();

    super.dispose();
  }

  void _updateWidth() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: Container(
        margin: const EdgeInsets.only(top: 100),
        child: Column(
          children: [
            CircularPercentIndicator(
              radius: 100,
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
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text('Proteínas'),
                const SizedBox(width: 10),
                Flexible(
                  child: SizedBox(
                    width: 100,
                    child: TextField(
                      controller: _proteinsController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter
                            .digitsOnly, // Solo permite dígitos
                        LengthLimitingTextInputFormatter(
                            3), // Limita a 3 caracteres
                      ],
                      onChanged: (value) {
                        if (!value.endsWith('g')) {
                          setState(() {
                            // Si el texto no tiene 'g' al final, lo agregamos.
                            _proteinsController.text = '$value' + 'g';
                            _proteinsController.selection =
                                TextSelection.collapsed(
                                    offset: _proteinsController.text.length);
                          });
                        }
                      },
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
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
    );
  }
}
