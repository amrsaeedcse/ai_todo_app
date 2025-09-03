import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/bloc/todo_control/todo_control_cubit.dart';
import 'package:todo_app/helpers/theme/app_colors.dart';
import 'package:todo_app/models/todo_model.dart';

class AddTaskTextField extends StatelessWidget {
  AddTaskTextField({super.key});
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: TextField(
            controller: textEditingController,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.secondaryBackGround,
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7),
                borderSide: BorderSide(
                  color: AppColors.onPrimaryText,
                  width: 1.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7),
                borderSide: BorderSide(
                  color: AppColors.onPrimaryText,
                  width: 1.0,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7),
                borderSide: BorderSide(
                  color: AppColors.onPrimaryText,
                  width: 1.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7),
                borderSide: BorderSide(
                  color: AppColors.onPrimaryText,
                  width: 1.0,
                ),
              ),
              hintText: "Add a new task ... ",
              hintStyle: GoogleFonts.adamina(
                fontWeight: FontWeight.w500,
                color: AppColors.onPrimaryText,
                fontSize: 12,
              ),
            ),
          ),
        ),
        SizedBox(width: 10),
        GestureDetector(
          onTap: () {
            if (textEditingController.text.trim().isNotEmpty) {
              context.read<TodoControlCubit>().addToList(
                TodoModel(
                  todoName: textEditingController.text.trim(),
                  selected: false,
                ),
              );
              textEditingController.clear();
            } else {
              Fluttertoast.showToast(
                msg: "Pls add todo first",

                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0,
              );
            }
          },
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: AppColors.buttonColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.add, color: AppColors.primaryBackGround),
          ),
        ),
      ],
    );
  }
}
