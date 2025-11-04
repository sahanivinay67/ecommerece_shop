part of 'todo_bloc.dart';

class TodoEvents {}

class AddTodo extends TodoEvents {
  final String title;
  AddTodo({required this.title});
}


class RemoveTodo extends TodoEvents {
  final TodoModel todo;
  RemoveTodo({required this.todo});
}
