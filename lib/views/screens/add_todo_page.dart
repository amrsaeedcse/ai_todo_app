import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_app/bloc/todo_list/todo_list_cubit.dart';
import 'package:todo_app/getx/todo_control.dart';
import 'package:todo_app/helpers/theme/app_colors.dart';
import 'package:todo_app/helpers/widgets/custom_app_bar.dart';
import 'package:todo_app/helpers/widgets/custom_button.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/views/widgets/todo_disc_text_field.dart';
import 'package:todo_app/views/widgets/todo_time.dart';
import 'package:todo_app/views/widgets/todo_title_text_field.dart';
import 'package:get/get.dart';

import '../../notification.dart';

class AddTodoPage extends StatefulWidget {
  AddTodoPage({super.key, this.editableTodo, this.temp = false});
  bool temp;
  TodoModel? editableTodo;
  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage>
    with TickerProviderStateMixin {
  // إضافة TickerProviderStateMixin

  TextEditingController todoTitle = TextEditingController();
  TextEditingController todoDisc = TextEditingController();

  // إنشاء AnimationController بشكل صحيح
  late AnimationController animationController;

  TodoControl todoControl = Get.put(TodoControl());

  @override
  void initState() {
    super.initState();
    // تهيئة AnimationController مع duration ومع vsync
    animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    // بدء الانيميشن تلقائياً
    animationController.forward();
  }

  @override
  void dispose() {
    // dispose الـ AnimationController الأول
    animationController.dispose();
    Get.delete<TodoControl>();
    super.dispose();
  }

  Future back() async {
    // عكس الانيميشن بشكل صحيح
    await animationController.reverse();
    if (widget.temp) {
      print(widget.editableTodo!.todoName);
      context.read<TodoListCubit>().removeTempTodo(
        widget.editableTodo!.todoName,
      );
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    print("rebuilt");
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar(
          title: "Add Details",
          suffix: GestureDetector(
            onTap: back,
            child: Icon(Icons.arrow_back_ios_new),
          ),
        ),
        backgroundColor: AppColors.primaryBackGround,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0.w, vertical: 20.h),
          child: Column(
            children: [
              // استخدام AnimationController المُعرف بدلاً من onPlay
              TodoTitleTextField(initTitle: widget.editableTodo?.todoName)
                  .animate(controller: animationController)
                  .then(delay: Duration(milliseconds: 0))
                  .moveX(
                    begin: -100,
                    curve: Curves.elasticOut,
                    duration: Duration(milliseconds: 1000),
                  )
                  .fadeIn(duration: Duration(milliseconds: 1000)),

              SizedBox(height: 20.h),

              TodoDiscTextField(initDisc: widget.editableTodo?.disc)
                  .animate(controller: animationController)
                  .then(delay: Duration(milliseconds: 300))
                  .moveX(
                    begin: -100,
                    curve: Curves.elasticOut,
                    duration: Duration(milliseconds: 1000),
                  )
                  .fadeIn(duration: Duration(milliseconds: 1000)),

              SizedBox(height: 20.h),

              TodoTime(initTime: widget.editableTodo?.finishTime)
                  .animate(controller: animationController)
                  .then(delay: Duration(milliseconds: 600))
                  .moveX(
                    begin: -100,
                    curve: Curves.elasticOut,
                    duration: Duration(milliseconds: 1000),
                  )
                  .fadeIn(duration: Duration(milliseconds: 1000)),

              Spacer(),

              SafeArea(
                child: Obx(() {
                  print("here");
                  print("is it temp${widget.temp}");
                  bool showIt =
                      (todoControl.todoDateTime.value != null &&
                      todoControl.todoDisc.value.isNotEmpty &&
                      todoControl.todoTitle.value.isNotEmpty);

                  if (widget.editableTodo != null && widget.temp == false) {
                    print("hereddddd");
                    print("disc todo comtrol${todoControl.todoDisc.value}");
                    print(widget.editableTodo!.disc);
                    print("title todocotrol ${todoControl.todoTitle.value}");
                    print(widget.editableTodo!.todoName);
                    showIt =
                        (todoControl.todoDateTime.value?.difference(
                                  widget.editableTodo!.finishTime!,
                                ) !=
                                Duration.zero ||
                            todoControl.todoDisc.value !=
                                widget.editableTodo!.disc) ||
                        (todoControl.todoTitle.value !=
                            widget.editableTodo!.todoName);
                  }

                  if (widget.temp) {
                    print("ok its temp");
                    showIt =
                        (todoControl.todoDateTime.value != null &&
                        todoControl.todoDisc.value.isNotEmpty &&
                        todoControl.todoTitle.value.isNotEmpty);
                  }

                  print(showIt);
                  double height;
                  if (showIt) {
                    height = 100.h;
                  } else {
                    height = 40.h;
                  }

                  return CustomButton(
                        height: height,
                        canceled: !(showIt),
                        onTap: () async {
                          if (showIt) {
                            await back();
                            if (widget.editableTodo == null || widget.temp) {
                              context.read<TodoListCubit>().addTodo(
                                TodoModel(
                                  todoName: todoControl.todoTitle.value,
                                  finishTime: todoControl.todoDateTime.value!,
                                  finished: false,
                                  disc: todoControl.todoDisc.value,
                                ),
                              );
                              print(
                                todoControl.todoDateTime.value!
                                    .toIso8601String(),
                              );
                              try {
                                await scheduleTodoReminders(
                                  finishTime: todoControl.todoDateTime.value!,
                                  taskName: todoControl.todoTitle.value,
                                );
                                print("here eddddddddddddddddddded");
                              } catch (e) {
                                print(e.toString() + "احاااااااااااااااااا");
                              }
                            } else {
                              context.read<TodoListCubit>().editTodo(
                                widget.editableTodo!.todoName,
                                TodoModel(
                                  todoName: todoControl.todoTitle.value,
                                  finishTime: todoControl.todoDateTime.value!,
                                  finished: false,
                                  disc: todoControl.todoDisc.value,
                                ),
                              );
                            }
                          }
                        },
                        label: 'save',
                      )
                      .animate(controller: animationController)
                      .then(delay: Duration(milliseconds: 900))
                      .fadeIn(duration: Duration(milliseconds: 500))
                      .moveY(begin: 50, duration: Duration(milliseconds: 800));
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
