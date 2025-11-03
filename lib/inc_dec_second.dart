import 'package:ecommerece_shop/bloc/counter_bloc.dart';
// import 'package:ecommerece_shop/cubit/counter_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IncDec2 extends StatelessWidget {
  const IncDec2({super.key});

  @override
  Widget build(BuildContext context) {
    final countecbloc = BlocProvider.of<CounterBloc>(context);
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                countecbloc.add(CounterDecreament());
              },
              icon: Icon(Icons.remove),
            ),

            IconButton(
              onPressed: () {
                countecbloc.add(CounterIncrement());
              },
              icon: Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
