import 'package:flutter/material.dart';

class SecondScreen extends StatelessWidget {
  final String? payload;

  const SecondScreen({
    Key? key,
    required this.payload,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(payload ?? ''),
            const Text('kirim payload atau argument'),
          ],
        ),
      ),
    );
  }
}
