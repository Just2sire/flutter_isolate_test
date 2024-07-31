import 'dart:isolate';

import 'package:flutter/material.dart';

class FactorialScreen extends StatefulWidget {
  const FactorialScreen({super.key});

  @override
  State<FactorialScreen> createState() => _FactorialScreenState();
}

class _FactorialScreenState extends State<FactorialScreen> {
  int _result = 0;

  Future<void> _calculateFactorial(int number) async {
    final response = ReceivePort();
    await Isolate.spawn(_factorial, response.sendPort);

    final sendPort = await response.first as SendPort;
    final answer = ReceivePort();
    sendPort.send([number, answer.sendPort]);
    final res = await answer.first as int;

    setState(() {
      _result = res;
    });
  }

  static void _factorial(SendPort sendPort) async {
    final port = ReceivePort();
    sendPort.send(port.sendPort);

    await for (final message in port) {
      final data = message[0] as int;
      final replyTo = message[1] as SendPort;
      replyTo.send(_calculateFactorialSync(data));
    }
  }

  static int _calculateFactorialSync(int n) {
    return n <= 1 ? 1 : n * _calculateFactorialSync(n - 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Résultat du factoriel: $_result'),
          ElevatedButton(
            onPressed: () => _calculateFactorial(5),
            child: const Text('Calculer le factoriel de 5',),
          ),
        ],
      ),
    );
  }
}