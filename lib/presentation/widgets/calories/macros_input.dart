import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MacronutrientInput extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool enabled;

  const MacronutrientInput(
      {super.key,
      required this.label,
      required this.controller,
      this.enabled = true});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 40),
      child: Row(
        children: [
          SizedBox(
            width: 160,
            child: Text(
              label,
              style: const TextStyle(fontSize: 18),
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: SizedBox(
              width: 100,
              child: TextField(
                enabled: enabled,
                controller: controller,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(3),
                ],
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.primary,
                ),
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
    );
  }
}
