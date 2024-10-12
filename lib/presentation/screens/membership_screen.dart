import 'package:flutter/material.dart';

class MembershipScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Membership'),
        leading: BackButton(),
      ),
      body: Center(
        child: Text('Hello Membership'),
      ),
    );
  }
}
