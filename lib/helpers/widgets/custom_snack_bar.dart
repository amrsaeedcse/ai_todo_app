import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_app/helpers/widgets/custom_text.dart';

import '../theme/app_colors.dart';

class ShowSnackBar {
  static showWarning(BuildContext c, String message) {
    ScaffoldMessenger.of(c).showSnackBar(
      snackBarAnimationStyle: AnimationStyle(
        curve: Curves.elasticOut,
        duration: Duration(milliseconds: 1000),
      ),
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.grey,
        content: Center(
          child: CustomText(
            text: message,
            fontWeight: FontWeight.w600,
            size: 18.sp,
            color: AppColors.secondaryBackGround,
          ),
        ),
      ),
    );
  }
}
