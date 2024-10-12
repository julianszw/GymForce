import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HeadquarterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Headquarters'),
        leading: BackButton(
          onPressed: () {
            context.pop();  // Volver a la pantalla anterior
          },
        ),
      ),
      body: Center(
        child: Text('Hello Headquarters'),
      ),
    );
  }
}
