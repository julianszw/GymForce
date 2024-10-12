import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        leading: BackButton(),
      ),
      body: Center(
        child: Text('Hello Login'),
      ),
    );
  }
}
