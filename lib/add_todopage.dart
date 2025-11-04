import 'package:ecommerece_shop/bloc/todo_bloc.dart';
import 'package:ecommerece_shop/cubit/todo_cubit.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddTodopage extends StatefulWidget {
  const AddTodopage({super.key});

  @override
  State<AddTodopage> createState() => _AddTodopageState();
}

class _AddTodopageState extends State<AddTodopage> {
  final todolistController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //  final todoCubit=BlocProvider.of<TodoCubit>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Add Todo')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: todolistController,
              decoration: InputDecoration(label: Text('Title')),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                
                context.read<TodoBloc>().add(
                  AddTodo(title: todolistController.text.trim()),
                );
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
