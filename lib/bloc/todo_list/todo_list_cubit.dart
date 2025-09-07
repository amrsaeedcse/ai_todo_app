import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

import '../../models/todo_model.dart';

part 'todo_list_state.dart';

class TodoListCubit extends Cubit<TodoListState> {
  TodoListCubit() : super(TodoListEmpty());
  List<TodoModel> tempTodos = [];

  void addTodo(TodoModel todo, String email) async {
    await TodoModel.saveTodo(email: email, todo: todo);
    List<TodoModel> todos = await TodoModel.getUserTodo(email: email);

    emit(TodoListLoaded(todos));
  }

  void removeTodo(TodoModel todo, String email) async {
    await TodoModel.removeTodo(email: email, deletedTodo: todo.todoName);
    List<TodoModel> todos = await TodoModel.getUserTodo(email: email);

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

  void saveTempTodos(String email) async {
    if (tempTodos.isNotEmpty) {
      for (var todo in tempTodos) {
        await TodoModel.saveTodo(email: email, todo: todo);
      }
      tempTodos.clear();
      List<TodoModel> todos = await TodoModel.getUserTodo(email: email);
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
    List<TodoModel> todos = await TodoModel.getUserTodo(email: "amr@gmail.com");
    if (todos.isNotEmpty) {
      emit(TodoListLoaded(todos));
      return;
    }
    emit(TodoListEmpty());
  }

  void editTodo(String todoName, TodoModel newTodo) async {
    await TodoModel.editTodo(
      email: "amr@gmail.com",
      todoName: todoName,
      newTodo: newTodo,
    );
    getTodos();
  }
}
