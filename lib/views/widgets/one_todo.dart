import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_app/bloc/todo_list/todo_list_cubit.dart';
import 'package:todo_app/helpers/theme/app_colors.dart';
import 'package:todo_app/helpers/widgets/custom_text.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/views/screens/add_todo_page.dart';

class OneTodo extends StatefulWidget {
  OneTodo({super.key, required this.todoModel, this.temp = false});
  final TodoModel todoModel;
  bool temp;

  @override
  State<OneTodo> createState() => _OneTodoState();
}

class _OneTodoState extends State<OneTodo> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> sizeAnim;

  @override
  void initState() {
    // TODO: implement initState
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    sizeAnim = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.bounceOut),
    );
    animationController.forward();

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    animationController.dispose();
    super.dispose();
  }

  bool stopClick = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("is it temo in click ${widget.temp}");
        print("this is the diteable now");
        print(widget.todoModel.todoName);
        print(widget.todoModel.finishTime);
        print(widget.todoModel.disc);
        //TODO
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                AddTodoPage(editableTodo: widget.todoModel, temp: widget.temp),
          ),
        );
      },
      child: OpenContainer(
        key: ValueKey("key"), // 👈 مهم جداً
        transitionDuration: const Duration(milliseconds: 1000),
        transitionType: ContainerTransitionType.fade,
        closedElevation: 10,
        closedShape: const RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.all(Radius.circular(10)),
          side: BorderSide.none,
        ),
        closedBuilder: (context, action) {
          return GestureDetector(
            onTap: action,
            child: SizeTransition(
              sizeFactor: sizeAnim,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.secondaryBackGround,
                  borderRadius: BorderRadius.circular(10.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(5, 5),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.0.w,
                    vertical: 6.h,
                  ),
                  child: Row(
                    children: [
                      Transform.scale(
                        scale: 1.2,
                        child: AnimatedSwitcher(
                          duration: Duration(milliseconds: 500),
                          child: !widget.temp
                              ? Checkbox(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadiusGeometry.circular(
                                      4.r,
                                    ),
                                    side: BorderSide(
                                      color: AppColors.borderColor.withOpacity(
                                        .1,
                                      ),
                                    ),
                                  ),
                                  side: BorderSide(
                                    color: AppColors.borderColor.withOpacity(1),
                                  ),
                                  value: widget.todoModel.finished,
                                  onChanged: (value) {
                                    // widget.todoModel.finished !=
                                    //     widget.todoModel.finished;

                                    if (widget.todoModel.finished) {
                                      context.read<TodoListCubit>().editTodo(
                                        widget.todoModel.todoName,
                                        TodoModel(
                                          todoName: widget.todoModel.todoName,
                                          finishTime:
                                              widget.todoModel.finishTime,
                                          finished: false,
                                          disc: widget.todoModel.disc,
                                        ),
                                      );
                                    } else {
                                      context.read<TodoListCubit>().editTodo(
                                        widget.todoModel.todoName,
                                        TodoModel(
                                          todoName: widget.todoModel.todoName,
                                          finishTime:
                                              widget.todoModel.finishTime,
                                          finished: true,
                                          disc: widget.todoModel.disc,
                                        ),
                                      );
                                    }
                                  },
                                )
                              : Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.0.w,
                                  ),
                                  child: Icon(Icons.close, color: Colors.red),
                                ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      SizedBox(
                        width: 240.w,
                        child: CustomText(
                          text: widget.todoModel.todoName,
                          fontWeight: FontWeight.w700,
                          size: 20.sp,
                          oneLine: true,
                          isLined: widget.todoModel.finished,
                        ),
                      ),
                      Spacer(),
                      Material(
                        shape: CircleBorder(),
                        color: Colors.transparent,
                        child: InkWell(
                          customBorder: CircleBorder(),
                          onTap: () async {
                            if (stopClick == false) {
                              stopClick = true;
                              if (!widget.temp) {
                                await animationController.reverse();
                                context.read<TodoListCubit>().removeTodo(
                                  widget.todoModel,
                                );
                              } else {
                                await animationController.reverse();
                                context.read<TodoListCubit>().removeTempTodo(
                                  widget.todoModel.todoName,
                                );
                              }
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.all(8.0.r),
                            child: Icon(Icons.delete, color: Colors.red),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        openBuilder: (context, action) {
          return AddTodoPage(editableTodo: widget.todoModel, temp: widget.temp);
        },
      ),
    );
  }
}
