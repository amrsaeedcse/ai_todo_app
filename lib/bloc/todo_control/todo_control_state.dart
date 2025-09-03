part of 'todo_control_cubit.dart';

@immutable
sealed class TodoControlState {}

// final class TodoControlError extends TodoControlState {
//   final String error;
//   final List<TodoModel> oldData;
//
//   TodoControlError(this.error, this.oldData);
// }

final class TodoControlEmpty extends TodoControlState {}

final class TodoControlAddedSuccess extends TodoControlState {
  final List<TodoModel> data;
  TodoControlAddedSuccess(this.data);
}
