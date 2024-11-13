import 'package:flutter/material.dart';
import 'package:gym_force/presentation/widgets/yellow_button.dart';

Future<void> showCommonDialog(
    {required BuildContext context,
    required VoidCallback onAccept,
    required String title,
    required String description,
    required String acceptText,
    double buttonWidth = 80,
    double buttonTextSize = 14}) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: title != '' ? Text(title) : null,
        content: Text(description),
        actions: <Widget>[
          YellowButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            text: 'Cancelar',
            width: buttonWidth,
            fontSize: buttonTextSize,
          ),
          YellowButton(
            onPressed: () {
              Navigator.of(context).pop();
              onAccept();
            },
            text: acceptText,
            width: buttonWidth,
            fontSize: buttonTextSize,
          ),
        ],
      );
    },
  );
}
