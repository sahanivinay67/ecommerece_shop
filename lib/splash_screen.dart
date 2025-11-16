import 'dart:async';

import 'package:ecommerece_shop/logo_p.dart';
import 'package:ecommerece_shop/routes/app_routes.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Timer _timer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/splash_bg_new.jpg'),
            fit: BoxFit.fitHeight,
          ),
        ),
        child: Center(child: VadaPavLogo(size: 200)),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer(Duration(seconds: 3), () {
      Navigator.pushNamed(context, AppRoutes.initial);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
