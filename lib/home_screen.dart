import 'package:ecommerece_shop/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = context.watch<AuthBloc>().state as AuthLoginSuccess;
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          children: [
            Text(data.uid),

            ElevatedButton(
              onPressed: () {
                context.read<AuthBloc>().add(AuthLogoutEvent());
              },
              child: Icon(Icons.logout),
            ),
          ],
        ),
      ),
    );
  }
}
