import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IsolateTest extends StatefulWidget {
  const IsolateTest({super.key});

  @override
  State<IsolateTest> createState() => _IsolateTestState();
}

class _IsolateTestState extends State<IsolateTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Lottie.asset(
                'assets/lottie/bfruits.json',
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
              ElevatedButton(
                onPressed: () async {
                  var result = await withoutIsolate();
                  debugPrint("resukt $result");
                },
                child: Text("Task1"),
              ),
              ElevatedButton(
                onPressed: () async {
                  final recieveport = ReceivePort();

                  final jsonvalue = {
                    'name': 'Vinay',
                    'port': recieveport.sendPort,
                  };
                  await Isolate.spawn(withIsolate, jsonvalue);
                  recieveport.listen((data) {
                    double total = data['total'];
                    String name = data['name'];
                    debugPrint("$name $total");
                  });
                },
                child: Text("Task2"),
              ),
              ElevatedButton(
                onPressed: () async {
                  final data = await compute(withcoumpoute, "");
                  debugPrint("resukt $data");
                },
                child: Text("Task2withCoumoute"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<double> withoutIsolate() async {
    double total = 0.0;
    for (int i = 0; i < 1000000000; i++) {
      total += i;
    }
    return total;
  }
}

withIsolate(Map<String, dynamic> data) async {
  final sendPort = data['port'];

  double total = 0.0;
  for (int i = 0; i < 1000000000; i++) {
    total += i;
  }
  sendPort.send({'name': data['name'], 'total': total});
}

Future<double> withcoumpoute(String name) async {
  double total = 0.0;
  for (int i = 0; i < 1000000000; i++) {
    total += i;
  }
  return total;
}
