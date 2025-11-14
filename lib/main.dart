import 'package:flutter/material.dart';

void main() {
  runApp(const SOSNetApp());
}

class SOSNetApp extends StatelessWidget {
  const SOSNetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SOSNet',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('SOSNet'),
        ),
        body: const Center(
          child: Text(
            'Benvenuto in SOSNet!',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
