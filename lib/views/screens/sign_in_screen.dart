import 'dart:ui';

import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_app/helpers/theme/app_colors.dart';
import 'package:todo_app/helpers/widgets/custom_button.dart';
import 'package:todo_app/helpers/widgets/custom_snack_bar.dart';
import 'package:todo_app/helpers/widgets/custom_text.dart';
import 'package:todo_app/models/user_model.dart';
import 'package:todo_app/views/screens/home_screen.dart';
import 'package:todo_app/views/screens/sign_up_screen.dart';
import 'package:todo_app/views/widgets/email_text_field.dart';
import 'package:todo_app/views/widgets/pass_text_field.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();

  void signIn() async {
    UserModel.getAllUsers();

    if (_formKey.currentState!.validate()) {
      UserModel? user = await UserModel.checkIfUserHere(
        email: email.text.trim(),
        pass: pass.text.trim(),
      );
      if (user != null) {
        ShowSnackBar.showWarning(context, "Welcome again ${user.name}");
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return HomeScreen();
            },
            transitionDuration: Duration(milliseconds: 1500),
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
      } else {
        ShowSnackBar.showWarning(context, "userName or pass is wrong ");
      }
    }
  }

  PageController pageController = PageController();

  ValueNotifier<double> buttHeight = ValueNotifier(50);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackGround,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle_outline,
                color: AppColors.buttonColor,
                size: 60.sp,
              ),
              SizedBox(height: 10.h),
              SizedBox(
                height: 50.h,
                child: PageView(
                  controller: pageController,
                  children: [
                    Center(
                      child: CustomText(
                        text: "Welcome Back!",
                        fontWeight: FontWeight.w700,
                        size: 30.sp,
                      ),
                    ),
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomText(
                            text: "Sign Up",
                            fontWeight: FontWeight.w600,
                            size: 30.sp,
                          ),
                          SizedBox(width: 5.w),
                          ValueListenableBuilder(
                            valueListenable: buttHeight,
                            builder: (context, value, child) {
                              final t = ((value - 50) / 150).clamp(0, 1);

                              return Icon(
                                    Icons.arrow_circle_right,
                                    color: AppColors.buttonColor,
                                    size: 40.sp,
                                  )
                                  .animate(
                                    onPlay: (controller) => controller.repeat(),
                                  )
                                  .shake(
                                    hz: lerpDouble(0, 100, t.toDouble())!,
                                    duration: const Duration(seconds: 2),
                                    offset: Offset(
                                      lerpDouble(0, 6, t.toDouble())!,
                                      0,
                                    ),
                                  );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5.h),
              CustomText(
                text: "Log in to manage your to-do list",
                fontWeight: FontWeight.w500,
                size: 17.sp,
                color: AppColors.onPrimaryText,
              ),
              SizedBox(height: 40.h),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    EmailTextField(email: email),
                    SizedBox(height: 10.h),
                    PassTextField(pass: pass),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              GestureDetector(
                onVerticalDragUpdate: (details) {
                  if (buttHeight.value > 40 && buttHeight.value < 200) {
                    buttHeight.value += details.delta.dy;
                  }
                },
                onVerticalDragEnd: (d) {
                  if (buttHeight.value > 190) {
                    Navigator.of(context).pushReplacement(
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return SignUpScreen();
                        },
                        transitionDuration: Duration(milliseconds: 1500),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                              return SharedAxisTransition(
                                animation: animation,
                                secondaryAnimation: secondaryAnimation,
                                transitionType:
                                    SharedAxisTransitionType.horizontal,
                                child: child,
                              );
                            },
                      ),
                    );
                    return;
                  }
                  buttHeight.value = 50;
                  pageController.animateToPage(
                    0,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                },
                onVerticalDragStart: (details) {
                  pageController.animateToPage(
                    1,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                },
                child: ValueListenableBuilder(
                  valueListenable: buttHeight,
                  builder: (context, value, child) {
                    return CustomButton(
                      onTap: signIn,
                      label: "Login",
                      height: buttHeight.value,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
