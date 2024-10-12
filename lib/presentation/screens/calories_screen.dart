import 'package:flutter/material.dart';

class CaloriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calories'),
        leading: BackButton(),
      ),
      body: Center(
        child: Text('Hello Calories'),
      ),
    );
  }
}
