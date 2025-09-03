import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/bloc/todo_control/todo_control_cubit.dart';

import '../../helpers/theme/app_colors.dart';
import '../../helpers/widgets/custom_text.dart';

class TasksAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TasksAppBar({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoControlCubit, TodoControlState>(
      builder: (context, state) {
        return AppBar(
          backgroundColor: Colors.transparent,
          title: CustomText(
            text:
                "My Tasks ${state is TodoControlAddedSuccess ? state.data.length : 0}",
            fontWeight: FontWeight.w700,
            size: 30,
          ),
          centerTitle: false,
          titleSpacing: 20,
          automaticallyImplyLeading: false,
          actions: [Icon(Icons.settings, color: AppColors.buttonColor)],
          actionsPadding: EdgeInsets.only(right: 20),
        );
      },
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(70);
}
