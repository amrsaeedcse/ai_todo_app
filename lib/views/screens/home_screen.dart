import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/bloc/todo_control/todo_control_cubit.dart';
import 'package:todo_app/helpers/theme/app_colors.dart';
import 'package:todo_app/helpers/widgets/custom_text.dart';
import 'package:todo_app/helpers/widgets/custom_app_bar.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/views/widgets/add_task_text_field.dart';
import 'package:todo_app/views/widgets/remove_button.dart';
import 'package:todo_app/views/widgets/todo_container.dart';
import 'package:todo_app/views/widgets/todos_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColors.primaryBackGround,
        appBar: CustomAppBar(
          actions: [Icon(Icons.settings, color: AppColors.buttonColor)],
          title: "My Tasks",
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              AddTaskTextField(),
              SizedBox(height: 20),
              Expanded(
                child: BlocConsumer<TodoControlCubit, TodoControlState>(
                  listener: (context, state) {
                    // TODO: implement listener
                  },
                  builder: (context, state) {
                    if (state is TodoControlEmpty) {
                      return Center(
                        child: CustomText(
                          text: "No todos",
                          fontWeight: FontWeight.w500,
                          size: 25,
                        ),
                      );
                    }
                    List<TodoModel> data =
                        (state as TodoControlAddedSuccess).data;
                    return TodosList(data: data);
                  },
                ),
              ),

              RemoveButton(),
            ],
          ),
        ),
      ),
    );
  }
}
