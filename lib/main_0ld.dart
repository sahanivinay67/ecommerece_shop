import 'dart:ui';

import 'package:ecommerece_shop/logo_p.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/splash_bg_new.jpg'),
            fit: BoxFit.fitWidth,
          ),
        ),
        child: Center(child: VadaPavLogo(size: 200)),
      ),
    );
  }
}
