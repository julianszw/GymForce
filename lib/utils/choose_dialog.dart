import 'package:flutter/material.dart';
import 'package:gym_force/presentation/widgets/yellow_button.dart';

Future<void> showChooseDialog({
  required BuildContext context,
  required VoidCallback onAcceptLeft,
  required VoidCallback onAcceptRight,
  required String description,
  required String leftText,
  required String rightText,
}) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Text(
          description,
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              YellowButton(
                onPressed: () {
                  onAcceptLeft();
                  Navigator.of(context).pop();
                },
                text: leftText,
                width: 120,
                fontSize: 12,
              ),
              YellowButton(
                onPressed: () {
                  onAcceptRight();
                  Navigator.of(context).pop();
                },
                text: rightText,
                width: 120,
                fontSize: 12,
              )
            ],
          )
        ],
      );
    },
  );
}
