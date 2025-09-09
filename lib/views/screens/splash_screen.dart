import 'dart:math' as math;

import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todo_app/helpers/theme/app_colors.dart';
import 'package:todo_app/views/screens/sign_in_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double width = 0;
  @override
  void initState() {
    // TODO: implement initState
    init();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Future.delayed(Duration(milliseconds: 1300), () {
        setState(() {
          width = MediaQuery.sizeOf(context).width - 100;
        });
      });
      await Future.delayed(Duration(milliseconds: 300));
      setState(() {
        width = 40.w;
      });
    });
    super.initState();
  }

  void init() async {
    await Future.delayed(Duration(milliseconds: 4000));
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return SignInScreen();
        },
        transitionDuration: Duration(milliseconds: 1500),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeThroughTransition(
            secondaryAnimation: secondaryAnimation,
            animation: animation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.buttonColor,
      body: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 1000),
            curve: Curves.easeInOut,
            height: MediaQuery.sizeOf(context).height,
            width: width,
            decoration: BoxDecoration(
              color: AppColors.secondaryBackGround,
              border: Border.symmetric(
                horizontal: BorderSide(
                  color: AppColors.borderColor,
                  width: 1.2,
                ),
              ),
            ),
          ).animate().rotate(
            delay: Duration(milliseconds: 1300),
            duration: Duration(milliseconds: 1000),
            curve: Curves.easeInOut,
            begin: 0,
            end: math.pi / 4,
          ),
          Center(
            child: SvgPicture.asset("assets/images/logo/Yz0Ld101.svg"),
          ).animate().fadeIn(
            delay: Duration(milliseconds: 2000),
            duration: Duration(milliseconds: 500),
          ),
        ],
      ),
    );
  }
}
