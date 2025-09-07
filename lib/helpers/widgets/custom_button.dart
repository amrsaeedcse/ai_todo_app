import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_app/helpers/widgets/custom_text.dart';

import '../theme/app_colors.dart';

class CustomButton extends StatelessWidget {
  CustomButton({
    super.key,
    required this.onTap,
    required this.label,
    this.height = 50,
    this.canceled = false,
  });

  final void Function() onTap;
  final String label;
  double height;
  bool canceled;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      curve: Curves.elasticOut,
      duration: Duration(milliseconds: 500),
      height: height,
      child: canceled
          ? ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.buttonColor.withOpacity(.3),
                shape: RoundedRectangleBorder(
                  side: BorderSide.none,
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              onPressed: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    text: label,
                    fontWeight: FontWeight.w600,
                    size: 18.sp,
                    color: AppColors.secondaryBackGround,
                  ),
                ],
              ),
            )
          : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonColor,
                    shape: RoundedRectangleBorder(
                      side: BorderSide.none,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  onPressed: onTap,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        text: label,
                        fontWeight: FontWeight.w600,
                        size: 18.sp,
                        color: AppColors.secondaryBackGround,
                      ),
                    ],
                  ),
                )
                .animate(onPlay: (controller) => controller.repeat())
                .shimmer(
                  duration: const Duration(milliseconds: 1000),
                  color: AppColors.secondaryBackGround,
                ),
    );
  }
}
