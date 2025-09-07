import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

import '../../models/todo_model.dart';

part 'todo_list_state.dart';

class TodoListCubit extends Cubit<TodoListState> {
  TodoListCubit() : super(TodoListEmpty());
  List<TodoModel> tempTodos = [];

  void addTodo(TodoModel todo) async {
    await TodoModel.saveTodo(todo: todo);
    List<TodoModel> todos = await TodoModel.getUserTodo();

    emit(TodoListLoaded(todos));
  }

  void removeTodo(TodoModel todo) async {
    await TodoModel.removeTodo(deletedTodo: todo.todoName);
    List<TodoModel> todos = await TodoModel.getUserTodo();

    if (todos.isNotEmpty) {
      emit(TodoListLoaded(todos));
      return;
    }
    emit(TodoListEmpty());
  }

  void addTempTodo(TodoModel model) {
    tempTodos.add(model);
    refresh();
  }

  void removeTempTodo(String name) {
    tempTodos.removeWhere((element) => element.todoName == name);
    refresh();
  }

  void saveTempTodos() async {
    if (tempTodos.isNotEmpty) {
      for (var todo in tempTodos) {
        await TodoModel.saveTodo(todo: todo);
      }
      tempTodos.clear();
      List<TodoModel> todos = await TodoModel.getUserTodo();
      emit(TodoListLoaded(todos));
    }
  }

  void refresh() {
    print("refres");
    if (state is TodoListLoaded) {
      emit(TodoListLoaded((state as TodoListLoaded).todos));
    } else {
      emit(TodoListEmpty());
    }
  }

  void getTodos() async {
    print("meyjod");
    List<TodoModel> todos = await TodoModel.getUserTodo();
    if (todos.isNotEmpty) {
      emit(TodoListLoaded(todos));
      return;
    }
    emit(TodoListEmpty());
  }

  void editTodo(String todoName, TodoModel newTodo) async {
    await TodoModel.editTodo(todoName: todoName, newTodo: newTodo);
    getTodos();
  }
}
