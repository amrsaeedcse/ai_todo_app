import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/views/widgets/todo_container.dart';

class TodosList extends StatelessWidget {
  TodosList({super.key, required this.data});
  final List<TodoModel> data;

  // final GlobalKey<AnimatedListState> listKey = GlobalKey();

  // void addToList(int index, TodoModel model) {
  //   data.add(model);
  //   listKey.currentState!.insertItem(index);
  // }
  //
  // void removeFromList(int index, TodoModel model) {
  //   data.removeAt(index);
  //   listKey.currentState!.removeItem(index, (context, animation) {
  //     return buildAnim(model, animation);
  //   });
  // }

  // Widget buildAnim(TodoModel model, Animation<double> anim) {
  //   return SizeTransition(
  //     sizeFactor: anim,
  //     child: TodoContainer(todoModel: model),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) {
        return SizedBox(height: 5);
      },
      itemBuilder: (context, index) {
        return TodoContainer(todoModel: data[index]);
      },
      itemCount: data.length,
    );
  }
}
