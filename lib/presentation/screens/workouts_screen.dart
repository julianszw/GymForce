import 'package:flutter/material.dart';

class WorkoutsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workouts'),
        leading: BackButton(),
      ),
      body: Center(
        child: Text('Hello Workouts'),
      ),
    );
  }
}
