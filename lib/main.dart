import 'package:ecommerece_shop/bloc/counter_bloc.dart';
import 'package:ecommerece_shop/cubit/counter_cubit.dart';
import 'package:ecommerece_shop/future_builder.dart';
import 'package:ecommerece_shop/inc_dec.dart';
import 'package:ecommerece_shop/isolate_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => CounterCubit()),
        BlocProvider(create: (context) => CounterBloc()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: IncDec(),
      ),
    );
  }
}
