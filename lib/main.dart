import 'package:ecommerece_shop/add_todopage.dart';
import 'package:ecommerece_shop/bloc/todo_bloc.dart';
import 'package:ecommerece_shop/todo_list.dart';
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
      create: (context) => TodoBloc(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(useMaterial3: true),
        initialRoute: '/',
        routes: {
          '/': (_) => const TodoList(),
          '/add-todo': (_) => const AddTodopage(),
        },
      ),
    ); // MaterialApp
  }
}
