import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int number = 0;
  int heavyTaskValue = 0;
  bool isProcessing = false;

  int heavyTask(int to) {
    int val = 0;
    for (var i = 0; i < to; i++) {
      val += i;
      debugPrint(val.toString());
    }
    return val;
    // sendPort.send(val);
  }

  // int isolateHeavyTask(SendPort sendPort) {
  //   int val = 0;
  //   for (var i = 0; i < 1000000000; i++) {
  //     val += i;
  //     debugPrint(val.toString());
  //   }
  //   sendPort.send(val);
  //   // return 0;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              number.toString(),
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  number++;
                });
              },
              child: const Text("Increment"),
            ),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  isProcessing = true;
                });
                // ReceivePort receivePort = ReceivePort();
                // await Isolate.spawn(heavyTask, receivePort);
                // heavyTaskValue = await compute(heavyTask, 1000000000);
                heavyTaskValue = await Isolate.run(() => heavyTask(1000000000));
                setState(() {
                  isProcessing = false;
                });
              },
              child: const Text("Heavy Task"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isProcessing = true;
                });
                // ReceivePort receivePort = ReceivePort();
                // Isolate.sp
                // heavyTaskValue = heavyTask();
                // setState(() {
                //   isProcessing = false;
                // });
              },
              child: const Text("Heavy Task"),
            ),
            if (isProcessing) const CircularProgressIndicator(),
            if (!isProcessing)
              Text(
                heavyTaskValue.toString(),
              )
          ],
        ),
      ),
    );
  }
}
