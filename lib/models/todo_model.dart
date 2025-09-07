import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/models/user_model.dart';

class TodoModel {
  final String todoName;
  final DateTime? finishTime;
  final bool finished;
  final String disc;

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      todoName: json['todoName'] ?? '',
      finishTime: json["finishTime"] != null && json["finishTime"].isNotEmpty
          ? DateTime.parse(json["finishTime"])
          : null, // أو DateTime.now() لو تحب
      finished: json['finished'] ?? false,
      disc: json["disc"] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'todoName': todoName,
      'finishTime': finishTime?.toIso8601String(),
      'finished': finished,
      'disc': disc,
    };
  }

  TodoModel({
    required this.todoName,
    required this.finishTime,
    required this.finished,
    required this.disc,
  });

  static Future<void> saveTodo({required TodoModel todo}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final todos =
        sharedPreferences.getStringList("${UserModel.lastUser!.email}_todos") ??
        [];
    todos.add(jsonEncode(todo.toJson()));
    sharedPreferences.setStringList(
      "${UserModel.lastUser!.email}_todos",
      todos,
    );
  }

  static Future<List<TodoModel>> getUserTodo() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List<String> jsonTodos =
        sharedPreferences.getStringList("${UserModel.lastUser!.email}_todos") ??
        [];
    List<TodoModel> todos = jsonTodos.map((e) {
      return TodoModel.fromJson(jsonDecode(e));
    }).toList();
    return todos;
  }

  static Future editTodo({
    required String todoName,
    required TodoModel newTodo,
  }) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List<String> jsonTodos = sharedPreferences.getStringList(
      "${UserModel.lastUser!.email}_todos",
    )!;
    List<TodoModel> todos = jsonTodos.map((e) {
      return TodoModel.fromJson(jsonDecode(e));
    }).toList();
    int index = todos.indexWhere((element) => element.todoName == todoName);
    if (index != -1) {
      todos[index] = newTodo;
    }

    List<String> savedTodo = todos.map((e) => jsonEncode(e.toJson())).toList();
    sharedPreferences.setStringList(
      "${UserModel.lastUser!.email}_todos",
      savedTodo,
    );
  }

  static Future removeTodo({required String deletedTodo}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List<String> jsonTodos = sharedPreferences.getStringList(
      "${UserModel.lastUser!.email}_todos",
    )!;
    List<TodoModel> todos = jsonTodos.map((e) {
      return TodoModel.fromJson(jsonDecode(e));
    }).toList();
    todos.removeWhere((element) => element.todoName == deletedTodo);
    List<String> savedTodo = todos.map((e) {
      return jsonEncode(e.toJson());
    }).toList();
    sharedPreferences.setStringList(
      "${UserModel.lastUser!.email}_todos",
      savedTodo,
    );
  }
}
