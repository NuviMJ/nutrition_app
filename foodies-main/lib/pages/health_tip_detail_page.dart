import 'package:flutter/material.dart';
import 'health_tips_page.dart'; // Import the model

class HealthTipDetailPage extends StatelessWidget {
  final HealthTip tip;

  const HealthTipDetailPage({super.key, required this.tip});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tip.title),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          tip.description,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
