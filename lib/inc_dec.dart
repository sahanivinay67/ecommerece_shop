import 'package:ecommerece_shop/bloc/counter_bloc.dart';
import 'package:ecommerece_shop/cubit/counter_cubit.dart';
import 'package:ecommerece_shop/inc_dec_second.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IncDec extends StatelessWidget {
  IncDec({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocBuilder<CounterBloc, int>(
              builder: (context, state) {
                return Text(state.toString());
              },
            ),
            IconButton(
              onPressed: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (context) => IncDec2()));
              },
              icon: Icon(Icons.navigate_next),
            ),
          ],
        ),
      ),
    );
  }
}
