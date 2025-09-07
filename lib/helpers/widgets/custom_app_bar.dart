import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'custom_text.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.actions,
    required this.title,
    this.suffix,
  });
  final List<Widget>? actions;
  final String title;

  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      shape: Border(
        bottom: BorderSide(color: AppColors.borderColor.withOpacity(.2)),
      ),
      backgroundColor: Colors.transparent,
      title: CustomText(text: title, fontWeight: FontWeight.w700, size: 30),
      leading: suffix,
      centerTitle: true,

      automaticallyImplyLeading: false,
      actions: actions,
      actionsPadding: EdgeInsets.only(right: 20),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(70);
}
