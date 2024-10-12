import 'package:flutter/material.dart';

class QrCustomerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QrCostumer'),
        leading: BackButton(),
      ),
      body: Center(
        child: Text('Hello QrCostumer'),
      ),
    );
  }
}
