part of 'todo_list_cubit.dart';

@immutable
sealed class TodoListState {}

final class TodoListEmpty extends TodoListState {}

final class TodoListInitial extends TodoListState {}

final class TodoListLoaded extends TodoListState {
  List<TodoModel> todos;

  TodoListLoaded(this.todos);
}
