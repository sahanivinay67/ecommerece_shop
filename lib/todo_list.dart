import 'package:ecommerece_shop/bloc/todo_bloc.dart';
import 'package:ecommerece_shop/cubit/todo_cubit.dart';
import 'package:ecommerece_shop/model/todo_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todo List')),
      body: BlocBuilder<TodoBloc, List<TodoModel>>(
        builder: (context, todo) {
          return ListView.builder(
            itemCount: todo.length,
            itemBuilder: (context, index) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(todo[index].name),
                  Text(todo[index].createdat.toString()),
                  TextButton(
                    onPressed: () {
                      print((".....d..    ${todo.length}"));
                      context.read<TodoBloc>().add(
                        RemoveTodo(todo: todo[index]),
                      );
                    },
                    child: Icon(Icons.delete),
                  ),
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/add-todo');
        },
        child: const Icon(Icons.navigate_next),
      ),
    );
  }
}
