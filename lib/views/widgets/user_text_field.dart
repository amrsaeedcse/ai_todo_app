import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../helpers/theme/app_colors.dart';

class UserTextField extends StatelessWidget {
  const UserTextField({super.key, required this.name});
  final TextEditingController name;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: name,
      style: GoogleFonts.poppins(
        fontWeight: FontWeight.w600,
        color: AppColors.borderColor,
        fontSize: 15.sp,
      ),
      decoration: InputDecoration(
        hintText: "Name",
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
          return 'Name is required !';
        }
        if (value.length < 2) {
          return 'Name is too short !';
        }
        return null;
      },
    );
  }
}
