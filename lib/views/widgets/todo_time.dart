import 'package:animations/animations.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:todo_app/helpers/widgets/custom_text.dart';

import '../../getx/todo_control.dart';
import '../../helpers/theme/app_colors.dart';

class TodoTime extends StatefulWidget {
  TodoTime({super.key, this.initTime});
  DateTime? initTime;

  @override
  State<TodoTime> createState() => _TodoTimeState();
}

class _TodoTimeState extends State<TodoTime> {
  DateTime? selectedDateTime;

  TodoControl todoControl = Get.find<TodoControl>();

  @override
  void initState() {
    // TODO: implement initState
    todoControl.todoDateTime.value = widget.initTime;
    if (widget.initTime != null) {
      selectedDateTime = widget.initTime;
    }
    super.initState();
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) async {
    if (args.value is DateTime) {
      DateTime pickedDate = args.value;

      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        final DateTime fullDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        setState(() {
          selectedDateTime = fullDateTime;
          todoControl.todoDateTime.value = selectedDateTime;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: .2,
      color: AppColors.secondaryBackGround,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.0.h),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today,
              color: AppColors.onPrimaryText,
              size: 25.sp,
            ),
            SizedBox(width: 10.w),
            CustomText(
              text: "DeadLine",
              fontWeight: FontWeight.w600,
              size: 15.sp,
            ),
            Spacer(),

            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Material(
                  color: AppColors.secondaryBackGround,
                  shape: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide.none,
                  ),
                  child: InkWell(
                    onTap: () async {
                      // final pickedTime = await showTimePicker(
                      //   context: context,
                      //   initialTime: TimeOfDay.now(),
                      //   builder: (context, child) {
                      //     return Theme(
                      //       data: Theme.of(context).copyWith(
                      //         timePickerTheme: TimePickerThemeData(
                      //           backgroundColor: Colors.black,
                      //           hourMinuteTextColor: Colors.white,
                      //           dialHandColor: Colors.red,
                      //         ),
                      //         colorScheme: ColorScheme.light(
                      //           primary: Colors.red,
                      //           onSurface: Colors.white,
                      //         ),
                      //       ),
                      //       child: child!,
                      //     );
                      //   },
                      // );
                      showModalBottomSheet(
                        backgroundColor: AppColors.secondaryBackGround,
                        context: context,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                        ),
                        builder: (context) => Container(
                          padding: EdgeInsetsGeometry.all(20.r),
                          height: 400,
                          child: SfDateRangePicker(
                            selectionTextStyle: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                            ),
                            rangeTextStyle: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                            ),

                            selectionShape:
                                DateRangePickerSelectionShape.circle,
                            todayHighlightColor: AppColors.borderColor,
                            selectionColor: AppColors.buttonColor,
                            headerStyle: DateRangePickerHeaderStyle(
                              backgroundColor: AppColors.buttonColor,
                              textStyle: GoogleFonts.poppins(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            rangeSelectionColor: AppColors.secondaryBackGround,
                            backgroundColor: AppColors.secondaryBackGround,
                            endRangeSelectionColor:
                                AppColors.secondaryBackGround,
                            selectionMode: DateRangePickerSelectionMode.single,
                            onSelectionChanged: _onSelectionChanged,
                          ),
                        ),
                      );
                    },
                    // highlightColor: Colors.red,
                    customBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide.none,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          width: 1.2,
                          color: AppColors.borderColor.withOpacity(.7),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsetsGeometry.all(8.r),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomText(
                              text: selectedDateTime == null
                                  ? "mm/dd/yyyy"
                                  : "${selectedDateTime?.day}/${selectedDateTime?.month}/${selectedDateTime?.year}",
                              fontWeight: FontWeight.w500,
                              size: 15.sp,
                            ),
                            SizedBox(width: 15.w),
                            Icon(
                              Icons.calendar_today,
                              color: AppColors.onPrimaryText,
                              size: 20.sp,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 5.h),
                selectedDateTime != null
                    ? Material(
                        color: AppColors.secondaryBackGround,
                        shape: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          borderSide: BorderSide.none,
                        ),
                        child: InkWell(
                          // highlightColor: Colors.red,
                          customBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide.none,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(
                                width: 1.2,
                                color: AppColors.borderColor.withOpacity(.7),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsetsGeometry.all(8.r),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomText(
                                    text: selectedDateTime == null
                                        ? "hh:mm"
                                        : "${selectedDateTime?.hour}:${selectedDateTime?.minute}",
                                    fontWeight: FontWeight.w500,
                                    size: 15.sp,
                                  ),
                                  SizedBox(width: 15.w),
                                  Icon(
                                    Icons.timer,
                                    color: AppColors.onPrimaryText,
                                    size: 20.sp,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    : SizedBox(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
