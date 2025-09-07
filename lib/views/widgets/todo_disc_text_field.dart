import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../getx/todo_control.dart';
import '../../helpers/theme/app_colors.dart';
import '../../helpers/widgets/custom_text.dart';

class TodoDiscTextField extends StatefulWidget {
  const TodoDiscTextField({super.key, this.initDisc});
  final String? initDisc;

  @override
  State<TodoDiscTextField> createState() => _TodoDiscTextFieldState();
}

class _TodoDiscTextFieldState extends State<TodoDiscTextField> {
  late TextEditingController controller;
  TodoControl todoControl = Get.find<TodoControl>();
  @override
  void initState() {
    // TODO: implement initState
    controller = TextEditingController(text: widget.initDisc);
    todoControl.todoDisc.value = widget.initDisc ?? "";
    controller.addListener(() {
      todoControl.todoDisc.value = controller.text.trim();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.secondaryBackGround,
      elevation: .2,

      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.0.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText(
              text: "Description",
              fontWeight: FontWeight.w500,
              size: 15.sp,
              color: AppColors.onPrimaryText,
            ),
            SizedBox(height: 10.h),
            SizedBox(
              height: 100.h,
              child: TextFormField(
                controller: controller,
                style: GoogleFonts.poppins(
                  color: AppColors.primaryText,
                  fontSize: 20.sp,
                ),
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,

                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      color: AppColors.borderColor.withOpacity(.3),
                      width: 1.2,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      color: AppColors.borderColor.withOpacity(.3),
                      width: 1.2,
                    ),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      color: AppColors.borderColor.withOpacity(.3),
                      width: 1.2,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      color: AppColors.borderColor.withOpacity(.3),
                      width: 1.2,
                    ),
                  ),

                  contentPadding: EdgeInsetsGeometry.symmetric(
                    horizontal: 10.w,
                    vertical: 10.h,
                  ),
                  hintText: "Add a description...",
                  hintStyle: GoogleFonts.poppins(
                    color: AppColors.onPrimaryText,
                    fontSize: 15.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
