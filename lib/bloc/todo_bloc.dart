import 'package:ecommerece_shop/model/todo_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'todo_events.dart';

class TodoBloc extends Bloc<TodoEvents, List<TodoModel>> {
  TodoBloc() : super([]) {
    on<AddTodo>((event, emit) {
      final todo = TodoModel(name: event.title, createdat: DateTime.now());
      emit([...state, todo]);
    });

    on<RemoveTodo>((event, emit) {
      final updatedList = List<TodoModel>.from(state);
      updatedList.remove(event.todo);
      emit(updatedList);
    });
  }
}
