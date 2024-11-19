import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class MacroIndicator extends StatelessWidget {
  final String title;
  final double percent;
  final String amount;
  final String totalAmount;

  const MacroIndicator({
    super.key,
    required this.title,
    required this.percent,
    required this.amount,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                title,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 8),
            LinearPercentIndicator(
              percent: percent,
              barRadius: const Radius.circular(12),
              backgroundColor: Colors.white,
              progressColor: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  Text(
                    '$amount ',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Text(
                    '($totalAmount)',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
