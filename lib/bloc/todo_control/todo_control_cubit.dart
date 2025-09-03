import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:todo_app/models/todo_model.dart';

part 'todo_control_state.dart';

class TodoControlCubit extends Cubit<TodoControlState> {
  TodoControlCubit() : super(TodoControlEmpty());

  void addToList(TodoModel model) {
    if (state is TodoControlAddedSuccess) {
      final currState = state as TodoControlAddedSuccess;
      final updatedList = List<TodoModel>.from(currState.data)..add(model);
      emit(TodoControlAddedSuccess(updatedList));
    } else {
      emit(TodoControlAddedSuccess([model]));
    }
  }

  void removeFromList() {
    if (state is TodoControlAddedSuccess) {
      final currState = state as TodoControlAddedSuccess;
      final updatedList = List<TodoModel>.from(currState.data)
        ..removeWhere((element) => element.selected);
      if (updatedList.isEmpty) {
        emit(TodoControlEmpty());
        return;
      }
      emit(TodoControlAddedSuccess(updatedList));
    }
  }

  void selectIt(TodoModel model) {
    print("hello");
    if (state is TodoControlAddedSuccess) {
      final currState = state as TodoControlAddedSuccess;
      // TodoModel selectedItem = (currState.data).firstWhere(
      //   (element) => model == element,
      // );
      // selectedItem.selected != selectedItem.selected;
      model.selected = !model.selected;

      for (var b in currState.data) {
        print(b.selected);
      }
      emit(TodoControlAddedSuccess(currState.data));
    }
  }
}
