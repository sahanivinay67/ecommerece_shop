import 'package:ecommerece_shop/model/todo_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodoCubit extends Cubit<List<TodoModel>> {
  TodoCubit() : super([]);
  void addToDO({required String title}) {
    final todo = TodoModel(name: title, createdat: DateTime.now());
    emit([...state, todo]);
  }
}
