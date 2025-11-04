import 'package:ecommerece_shop/bloc/auth_bloc.dart';
import 'package:ecommerece_shop/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(useMaterial3: true),
        home: LoginScreen(),
      ),
    ); // MaterialApp
  }
}
