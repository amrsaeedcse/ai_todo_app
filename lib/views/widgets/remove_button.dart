import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/bloc/todo_control/todo_control_cubit.dart';
import 'package:todo_app/helpers/theme/app_colors.dart';
import 'package:todo_app/helpers/widgets/custom_text.dart';
import 'package:todo_app/views/widgets/add_task_text_field.dart';

class RemoveButton extends StatelessWidget {
  const RemoveButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoControlCubit, TodoControlState>(
      builder: (context, state) {
        if (state is TodoControlAddedSuccess) {
          bool theresSelected = state.data.any((element) => element.selected);
          return SafeArea(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theresSelected
                    ? Colors.red
                    : Colors.red.withOpacity(.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(5),
                  side: BorderSide.none,
                ),
              ),
              onPressed: theresSelected
                  ? () {
                      context.read<TodoControlCubit>().removeFromList();
                    }
                  : () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    text: "Delete",
                    fontWeight: FontWeight.w700,
                    size: 17,
                    color: AppColors.primaryBackGround,
                  ),
                  SizedBox(width: 3),
                  Icon(Icons.delete, color: AppColors.primaryBackGround),
                ],
              ),
            ),
          );
        } else {
          return SizedBox();
        }
      },
    );
  }
}
