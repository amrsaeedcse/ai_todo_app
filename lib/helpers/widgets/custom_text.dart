import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/helpers/theme/app_colors.dart';

class CustomText extends StatelessWidget {
  CustomText({
    super.key,
    required this.text,
    required this.fontWeight,
    required this.size,
    this.color,
    this.isLined = false,
    this.oneLine = true,
  });
  final String text;
  final FontWeight fontWeight;
  final double size;
  Color? color;
  bool isLined;
  bool oneLine;

  @override
  Widget build(BuildContext context) {
    return Text(
      softWrap: oneLine ? false : true,
      overflow: oneLine == true ? TextOverflow.ellipsis : null,
      maxLines: oneLine == true ? 1 : null,
      text,
      style: GoogleFonts.poppins(
        decoration: isLined ? TextDecoration.lineThrough : null,
        color: !isLined
            ? color ?? (AppColors.primaryText)
            : color == null
            ? (AppColors.primaryText).withOpacity(.5)
            : color!.withOpacity(.5),
        fontSize: size,
        fontWeight: fontWeight,
      ),
    );
  }
}
