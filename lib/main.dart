import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_app/bloc/todo_list/todo_list_cubit.dart';
import 'package:todo_app/bloc/voice_control/voice_control_cubit.dart';
import 'package:todo_app/views/screens/add_todo_page.dart';
import 'package:todo_app/views/screens/home_screen.dart';
import 'package:todo_app/views/screens/sign_in_screen.dart';
import 'package:todo_app/views/widgets/mice.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => TodoListCubit()),
            BlocProvider(create: (context) => VoiceControlCubit()),
          ],
          child: MaterialApp(debugShowCheckedModeBanner: false, home: child),
        );
      },
      child: SignInScreen(),
    ); // ch
  }
}
