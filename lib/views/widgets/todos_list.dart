import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/views/widgets/one_todo.dart';
import 'package:todo_app/views/widgets/todo_container.dart';

import '../../bloc/todo_list/todo_list_cubit.dart';

class TodosList extends StatefulWidget {
  TodosList({super.key});

  @override
  State<TodosList> createState() => _TodosListState();
}

class _TodosListState extends State<TodosList> {
  TextEditingController controller = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    controller.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: controller,
          decoration: InputDecoration(suffixIcon: Icon(Icons.search)),
        ),
        Expanded(
          child: BlocBuilder<TodoListCubit, TodoListState>(
            builder: (context, state) {
              List<TodoModel> tempList = context
                  .read<TodoListCubit>()
                  .tempTodos;
              List<TodoModel> searchedTemp = tempList
                  .where(
                    (element) => element.todoName.toLowerCase().contains(
                      controller.text.trim(),
                    ),
                  )
                  .toList();
              print("lenths is ${tempList.length}");
              if (state is TodoListEmpty) {
                if (tempList.isNotEmpty) {
                  return ListView.separated(
                    itemBuilder: (context, index) {
                      return OneTodo(todoModel: searchedTemp[index], temp: true)
                          .animate(onPlay: (controller) => controller.repeat())
                          .shimmer(
                            duration: Duration(milliseconds: 1000),
                            color: Colors.red,
                          );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 10.h);
                    },
                    itemCount: searchedTemp.length,
                  );
                }
                return Center(child: Text("empty"));
              }

              final List<TodoModel> todos = (state as TodoListLoaded).todos;
              List<TodoModel> searchedTodos = todos
                  .where(
                    (element) => element.todoName.toLowerCase().contains(
                      controller.text.trim(),
                    ),
                  )
                  .toList();
              return ListView.separated(
                itemBuilder: (context, index) {
                  if (index < searchedTodos.length) {
                    return OneTodo(todoModel: searchedTodos[index]);
                  } else {
                    return OneTodo(
                          temp: true,
                          todoModel: searchedTemp[index - searchedTodos.length],
                        )
                        .animate(onPlay: (controller) => controller.repeat())
                        .shimmer(
                          duration: Duration(milliseconds: 300),
                          color: Colors.red,
                        );
                  }
                },
                separatorBuilder: (context, index) {
                  return SizedBox(height: 10.h);
                },
                itemCount: searchedTodos.length + searchedTemp.length,
              );
            },
          ),
        ),
      ],
    );
  }
}
