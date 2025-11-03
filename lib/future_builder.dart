import 'package:flutter/material.dart';

class Futurebuilder extends StatefulWidget {
  const Futurebuilder({super.key});

  @override
  State<Futurebuilder> createState() => _FuturebuilderState();
}

class _FuturebuilderState extends State<Futurebuilder> {
  late Future<int> _getValueFuture;

  @override
  void initState() {
    super.initState();
    _getValueFuture = getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            FutureBuilder<int>(
              future: _getValueFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "An error occurred: ${snapshot.error}",
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  );
                }
                if (snapshot.hasData) {
                  return Center(
                    child: Column(
                      children: [
                        Text(
                          snapshot.data.toString(),
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _getValueFuture = getData();
          });
        },
      ),
    );
  }
}

Future<int> getData() async {
  try {
    await Future.delayed(Duration(seconds: 3));
    return 7;
  } catch (e) {
    print("An error occurred: $e");
    rethrow;
  }
}

