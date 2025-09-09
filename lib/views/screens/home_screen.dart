import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_app/bloc/search_anim/search_anim_cubit.dart';
import 'package:todo_app/bloc/todo_list/todo_list_cubit.dart';
import 'package:todo_app/helpers/theme/app_colors.dart';
import 'package:todo_app/helpers/widgets/custom_app_bar.dart';
import 'package:todo_app/views/screens/add_todo_page.dart';
import 'package:todo_app/views/widgets/mice.dart';
import 'package:todo_app/views/widgets/search_icon.dart';
import 'package:todo_app/views/widgets/todos_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    context.read<TodoListCubit>().getTodos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.primaryBackGround,
          appBar: CustomAppBar(
            title: "My Todos",
            actions: [
              // GestureDetector(
              //   onTap: () {
              //     final cubit = context.read<SearchAnimCubit>();
              //     if (cubit.state is SearchAnimOpen) {
              //       cubit.makeItClose();
              //     } else {
              //       cubit.makeItOpen();
              //     }
              //   },
              //   child: Icon(
              //     Icons.search_outlined,
              //     color: AppColors.primaryText,
              //     size: 40.sp,
              //   ),
              // ),
            ],
          ),
          body: Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.0.w,
                  vertical: 15.h,
                ),
                child: Column(children: [Expanded(child: TodosList())]),
              ),
              Positioned(
                right: 20.w,
                bottom: 30.h,
                child: Material(
                  color: AppColors.buttonColor,
                  shape: CircleBorder(),
                  child: InkWell(
                    customBorder: CircleBorder(),
                    onTap: () {
                      //temp now
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                                return AddTodoPage();
                              },
                          transitionDuration: Duration(milliseconds: 1500),
                          reverseTransitionDuration: Duration(
                            milliseconds: 1500,
                          ),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                                return FadeThroughTransition(
                                  secondaryAnimation: secondaryAnimation,
                                  animation: animation,
                                  child: child,
                                );
                              },
                        ),
                      );
                    },
                    child: Container(
                      height: 60.h,
                      width: 60.w,
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      child: Center(
                        child: Icon(
                          Icons.add,
                          color: AppColors.secondaryBackGround,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0.w,
                bottom: 30.h,
                child: Center(child: Mice()),
              ),
            ],
          ),
        ),
        SearchIcon(),
      ],
    );
  }
}
