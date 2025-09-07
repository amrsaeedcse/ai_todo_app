import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../helpers/theme/app_colors.dart';

class PassTextField extends StatefulWidget {
  const PassTextField({super.key, required this.pass});

  final TextEditingController pass;

  @override
  State<PassTextField> createState() => _PassTextFieldState();
}

class _PassTextFieldState extends State<PassTextField> {
  bool showIt = false;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.pass,
      style: GoogleFonts.poppins(
        color: AppColors.borderColor,
        fontWeight: FontWeight.w600,
        fontSize: 15.sp,
      ),
      obscureText: showIt,
      decoration: InputDecoration(
        hintText: "Password",
        prefixIcon: SizedBox(
          child: Center(
            child: Icon(
              Icons.lock,
              color: AppColors.onPrimaryText,
              size: 25.sp,
            ),
          ),
        ),
        hintStyle: GoogleFonts.poppins(
          color: AppColors.borderColor,
          fontWeight: FontWeight.w500,
          fontSize: 17.sp,
        ),
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              showIt = !showIt;
            });
          },
          child: showIt
              ? Icon(Icons.remove_red_eye, color: AppColors.buttonColor)
              : Icon(Icons.remove_red_eye_outlined),
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
          return 'Please enter your password !';
        }
        if (value.trim().length < 6) {
          return 'Password must be at least 6 characters long !';
        }
        if (!RegExp(
          r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d).{6,}$',
        ).hasMatch(value.trim())) {
          return 'Password must contain upper, lower case letters and a number !';
        }
        return null; // valid
      },
    );
  }
}
