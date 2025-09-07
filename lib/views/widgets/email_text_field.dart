import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/helpers/theme/app_colors.dart';

class EmailTextField extends StatelessWidget {
  const EmailTextField({super.key, required this.email});
  final TextEditingController email;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: email,
      style: GoogleFonts.poppins(
        fontWeight: FontWeight.w600,
        color: AppColors.borderColor,
        fontSize: 15.sp,
      ),
      decoration: InputDecoration(
        hintText: "Email",
        hintStyle: GoogleFonts.poppins(
          color: AppColors.borderColor,
          fontWeight: FontWeight.w500,
          fontSize: 17.sp,
        ),
        prefixIcon: SizedBox(
          child: Center(
            child: Icon(
              Icons.email_outlined,
              color: AppColors.onPrimaryText,
              size: 25.sp,
            ),
          ),
        ),
        prefixIconConstraints: BoxConstraints.loose(Size.fromWidth(50.w)),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(width: 1.2, color: AppColors.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(width: 1.2, color: AppColors.borderColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(width: 1.2, color: AppColors.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(width: 1.2, color: AppColors.borderColor),
        ),
        filled: true,
        fillColor: AppColors.secondaryBackGround,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter your email !';
        }
        if (!RegExp(
          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
        ).hasMatch(value.trim())) {
          return 'Please enter a valid email address !';
        }
        return null; // va
      },
    );
  }
}
