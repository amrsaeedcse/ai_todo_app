import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:todo_app/bloc/search_anim/search_anim_cubit.dart';
import 'package:todo_app/bloc/todo_list/todo_list_cubit.dart';
import 'package:todo_app/bloc/voice_control/voice_control_cubit.dart';
import 'package:todo_app/models/user_model.dart';
import 'package:todo_app/notification.dart';
import 'package:todo_app/views/screens/add_todo_page.dart';
import 'package:todo_app/views/screens/home_screen.dart';
import 'package:todo_app/views/screens/sign_in_screen.dart';
import 'package:todo_app/views/screens/splash_screen.dart';
import 'package:todo_app/views/widgets/mice.dart';
import 'package:todo_app/views/widgets/test.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ✅ ضروري
  await initNotifications();
  await createNotificationChannel();

  UserModel.lastUser = UserModel(
    name: "amr",
    email: "amr@gmail.com",
    pass: "1234Am@",
  );
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
            BlocProvider(create: (context) => SearchAnimCubit()),
          ],
          child: MaterialApp(debugShowCheckedModeBanner: false, home: child),
        );
      },
      child: SplashScreen(),
    ); // ch
  }
}
