import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/getx/todo_control.dart';
import 'package:todo_app/helpers/widgets/custom_text.dart';

import '../../helpers/theme/app_colors.dart';

class TodoTitleTextField extends StatefulWidget {
  TodoTitleTextField({super.key, this.initTitle});
  final String? initTitle;

  @override
  State<TodoTitleTextField> createState() => _TodoTitleTextFieldState();
}

class _TodoTitleTextFieldState extends State<TodoTitleTextField> {
  late TextEditingController cont;
  TodoControl todoControl = Get.find<TodoControl>();
  @override
  void initState() {
    // TODO: implement initState
    cont = TextEditingController(text: widget.initTitle ?? "");
    todoControl.todoTitle.value = widget.initTitle ?? "";

    cont.addListener(() {
      todoControl.todoTitle.value = cont.text.trim();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: .2,

      color: AppColors.secondaryBackGround,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.0.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText(
              text: "Todo Title",
              fontWeight: FontWeight.w500,
              size: 15.sp,
              color: AppColors.onPrimaryText,
            ),
            SizedBox(height: 10.h),
            TextFormField(
              controller: cont,
              style: GoogleFonts.poppins(
                color: AppColors.primaryText,
                fontSize: 20.sp,
              ),
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.borderColor.withOpacity(.3),
                  ),
                ),
                errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.borderColor.withOpacity(.3),
                  ),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.borderColor.withOpacity(.3),
                  ),
                ),
                disabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.borderColor.withOpacity(.3),
                  ),
                ),
                contentPadding: EdgeInsetsGeometry.symmetric(horizontal: 5.w),
                hintText: "Add title",
                hintStyle: GoogleFonts.poppins(
                  color: AppColors.onPrimaryText,
                  fontSize: 20.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
